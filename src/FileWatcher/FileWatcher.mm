#include <stdio.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

#include <string>
#include <vector>
#include <set>

#import <Cocoa/Cocoa.h>

//#define COMMANDLINE

// sets how long to sleep between polling directory (in seconds)
#define SLEEP_LEN 15

// how many minutes to wait between checks for completion of .mpg file
#define WAIT_MINUTES 1

// how long to wait for appearance of .mpg file in a new directory
#define WAIT_FOR_MPG_MINUTES 5

//#define DEBUG



bool HasDirChanged(const char *path)
{
  static bool firsttime=true;
  static time_t last_time;

  struct stat statbuf;

  if (stat(path,&statbuf)!=0)
  {
      NSLog(@"Error stat'ing EyeTV directory!\n");
      return false;
  }

  if (firsttime)
  {
    last_time=statbuf.st_ctimespec.tv_sec;
    firsttime=false;
    return false;
  }

  if (last_time != statbuf.st_ctimespec.tv_sec)
  {
      NSLog(@"EyeTV directory changed!\n");
      last_time=statbuf.st_ctimespec.tv_sec;
      return true;
  }

  return false;
}

class PendingFile
{
  public:
    PendingFile(const std::string &fname,unsigned int max_count) :
      _fname(fname),_last_size(0),_same_size_count(0),_max_count(max_count),
      _is_complete(false),_error(false) {}

    bool CheckSize()
    {
      struct stat statbuf;
      if (stat(_fname.c_str(),&statbuf)!=0)
      {
         NSLog(@"Error stat'ing .eyetv directory!\n");
        _error=true; // mark for removal from list
        return false;
      }
#ifdef DEBUG
       NSLog(@"Checking size of file %s, size %ld, iteration %d of %d\n",_fname.c_str(), statbuf.st_size,_same_size_count,_max_count);
#endif

      if (statbuf.st_size != _last_size)
      {
        _last_size=statbuf.st_size;
        _same_size_count=0;
      }
      else
      {
        _same_size_count++;
      }

      if (_same_size_count >= _max_count)
      {
        FileComplete();
      }
      return true;
    }

    void FileComplete(bool background=true)
    {
        //const char cmd[]="/Applications/ETVComskip/MarkCommercials.sh";
        std::string cmd=[[NSFileManager defaultManager]fileSystemRepresentationWithPath:[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"MarkCommercials.sh"]];

#ifdef DEBUG
        NSLog(@"File %s is complete!\n",_fname.c_str());
#endif
        _is_complete=true;
#ifdef DEBUG
        NSLog(@"Calling %s %s%s\n",cmd.c_str(),_fname.c_str(),background?" &":"");
#endif
        //this handles realcmd being used as the first arg too, but requires at least one cmdline param
        do{
            pid_t pid=fork();
            if(pid==0){
                //NSLog(@"Running %s\n",cmd.c_str());
                execl(cmd.c_str(),cmd.c_str(),_fname.c_str(),NULL);
                exit(-1);
            }
            if(pid<0){
                //FIXME error
                NSLog(@"Error starting process\n");
            }else{
                //NSLog(@"Started %s %s\n",cmd.c_str(),_fname.c_str());
                if(!background)
                    waitpid(pid,NULL,0);
            }
            waitpid(-1,NULL,WNOHANG);/*cleanup those that weren't waited. they eat brains.*/\
        }while(0);
    }

    bool IsComplete() const { return _is_complete; }
    bool HadError() const { return _error; }
    
  private:
    std::string _fname;
    off_t _last_size;
    unsigned int _same_size_count;
    unsigned int _max_count;
    bool _is_complete;
    bool _error;
};

std::vector<PendingFile> PendingFiles;
bool CheckForCompletedFiles(bool force=false)
{
  bool invalidated=false;
  do 
  {
    invalidated=false;
    for (std::vector<PendingFile>::iterator i=PendingFiles.begin(); i!=PendingFiles.end(); ++i)
    {
      if (force)
        i->FileComplete(false);
      else
        i->CheckSize();
      if (i->IsComplete() || i->HadError()) 
      {
        invalidated=true;
        PendingFiles.erase(i);
        break;
      }
    }
  } while (invalidated);
  return true;
}


bool ProcessNewEntry(const std::string &fname, const std::string &watched_dir_extension="", const std::string &watched_file_extension="") 
{
  // is it a directory?
  struct stat statbuf;
  if (stat(fname.c_str(),&statbuf)!=0)
  {
     NSLog(@"Error stat'ing file %s\n",fname.c_str());
    return false;
  }
  if (!(statbuf.st_mode & S_IFDIR)) 
  {
     NSLog(@"New directory entry %s is not a directory\n",fname.c_str());
    return false;
  }

  // is does it match the watched_dir_extension?
  std::string::size_type pos=fname.find(watched_dir_extension);
  if (pos==std::string::npos || pos != fname.size()-watched_dir_extension.size())
  {
     NSLog(@"New directory entry %s is not an %s directory\n",fname.c_str(),watched_dir_extension.c_str());
    return false;
  }


  NSLog(@"Got new directory entry: %s\n",fname.c_str());

  //add new entry to PendingFiles
  bool gotfile=false;
  unsigned int count=0;
  do 
  {
    DIR *dirp = opendir(fname.c_str());
    struct dirent *dp;
    while ((dp = readdir(dirp)) != NULL) 
    {
      std::string name(dp->d_name);
      if (name.find(watched_file_extension)!=std::string::npos)
      {
        std::string wfname=fname + std::string("/") + name;
        PendingFiles.push_back(PendingFile(wfname,60*WAIT_MINUTES/SLEEP_LEN));
        gotfile=true;
      }
    }
    closedir(dirp);
    if (!gotfile)
      sleep(WAIT_MINUTES);
    count++;
  } while (!gotfile && count < WAIT_FOR_MPG_MINUTES);

  return gotfile;
}

@interface ScriptRunner : NSObject
{
    NSAppleScript *script;
}
-(id)initWithPath:(NSString*)path;
-(void)dealloc;
-(void)runScript;
@end

@implementation ScriptRunner
-(id)initWithPath:(NSString*)path{
    if((self=[super init])==nil)
        return nil;
    NSDictionary *err=nil;
    script=nil;
    NSAppleScript *tscript=[[NSAppleScript alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
    if(tscript==nil || [tscript source]==nil){
        if(tscript){
            [tscript release];
            NSLog(@"Script %@ load error: %@\n",path,[err objectForKey:NSAppleScriptErrorMessage]);//err is a dictionary, autoreleased
        }else{
            NSLog(@"Script %@ doesn't have source code\n",path);
        }
        [self release];
        return nil;
    }
    NSMutableString *ssource=[[tscript source]mutableCopy];
    [tscript autorelease];
    NSString *oldhome=@"/Applications/ETVComskip";
    //NSLog(@"Replacing %@ with %@\n",oldhome,[[NSBundle mainBundle]builtInPlugInsPath]);
    if([[NSBundle mainBundle]builtInPlugInsPath]==nil)
        return nil;//FIXME
    [ssource replaceOccurrencesOfString:oldhome withString:[[NSBundle mainBundle]builtInPlugInsPath] options:NSLiteralSearch range:NSMakeRange(0,[ssource length])];
    script=[[NSAppleScript alloc]initWithSource:ssource];
    if(script==nil){
        NSLog(@"Script wouldn't load\n");
        [self release];
        return nil;
    }
    return self;
}
-(void)dealloc{
    [script release];
    [super dealloc];
}
-(void)runScript{
    NSAutoreleasePool *pool=[NSAutoreleasePool new];
    NSDictionary *err=nil;
    
    [script executeAndReturnError:&err];
    if(err)
        NSLog(@"Script execute error: %@\n",[err objectForKey:NSAppleScriptErrorMessage]);
    
    [self release];//release this object, so the caller need not worry about it. threaded or unthreaded, this vaporizes when done
    [pool release];
}
@end

void runScript(NSString *scriptpath,BOOL background){
    ScriptRunner *s=[[ScriptRunner alloc]initWithPath:scriptpath];
    if(s==nil){
        NSLog(@"Script %@ wouldn't load properly\n",scriptpath);
        return;
    }
    //re documentation for NSAppleScript, this may be required.
    [s performSelectorOnMainThread:@selector(runScript) withObject:nil waitUntilDone:!background];
}

void ProcessDir(const char *path, char *watched_dir_extension=0, char *watched_file_extension=0) 
{
  static bool firsttime=true;
  static std::set<std::string> files;
  std::set<std::string> tmpfiles;

  // add new enrtries
  //len = strlen(name);
  DIR *dirp = opendir(path);
  struct dirent *dp;
  while ((dp = readdir(dirp)) != NULL) 
  {
    tmpfiles.insert(dp->d_name);
    if (!firsttime)
    {
      std::string fname(dp->d_name);
      if (files.find(fname) == files.end())
      {
        fname=std::string(path) + fname;
          if (ProcessNewEntry(fname, watched_dir_extension, watched_file_extension)){
              runScript([[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"EyeTVReaper.scpt"],true);
          }
      }
    }
  }
  closedir(dirp);

  // this will have the effect of removing deleted entries
  files=tmpfiles;
  firsttime=false;
}


void ProcessEntireDir(const char *path, char *watched_dir_extension=0, char *watched_file_extension=0) 
{
  static std::set<std::string> files;
  std::set<std::string> tmpfiles;

  // add new enrtries
  //len = strlen(name);
  DIR *dirp = opendir(path);
  struct dirent *dp;
  while ((dp = readdir(dirp)) != NULL) 
  {
    tmpfiles.insert(dp->d_name);
    std::string fname(dp->d_name);
    fname=std::string(path) + fname;
    ProcessNewEntry(fname, watched_dir_extension, watched_file_extension);
  }
  closedir(dirp);
}

std::string FindEyeTVArchive()
{
    std::string ret="";
    NSAutoreleasePool *pool=[NSAutoreleasePool new];
    NSData *dat=[NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.elgato.eyetv.plist"]];//autoreleased
    if(dat==nil)
        return ret;
    NSDictionary *plist=[NSPropertyListSerialization propertyListFromData:dat
                                                         mutabilityOption:NSPropertyListImmutable
                                                                   format:NULL
                                                         errorDescription:NULL];//autoreleased
    NSString *path=[plist objectForKey:@"archive path"];
    NSURL *url=[NSURL URLWithString:path];//autoreleased
    ret=[[NSFileManager defaultManager]fileSystemRepresentationWithPath:[[url path]stringByAppendingString:@"/"]];
    [pool release];
    return ret;
}
int main(int argc, const char *argv[])
{
#ifndef COMMANDLINE
    return NSApplicationMain(argc, argv);
}


int FW_main(int argc, char **argv)
{
#endif
    NSAutoreleasePool *mainpool=[NSAutoreleasePool new];
  char *watched_dir_extension=".eyetv";
  char *watched_file_extension=".mpg";

  std::string etvdir=FindEyeTVArchive();
  if (etvdir.size()==0)
    return 0;
    
#ifdef DEBUG  
  NSLog(@"EyeTV is based out of %s\n",etvdir.c_str());
#endif
    
  bool do_all=false;
  for (int i=0; i< argc; ++i)
  {
    if (strcmp(argv[i],"all")==0) {
      do_all=true;
      break;
    }
  }

  if (do_all)
  {
     NSLog(@"Got args: \n");

     NSLog(@"Processing all files in directory.  Press enter after you quit EyeTV:");
    getchar();
    ProcessEntireDir(etvdir.c_str(),watched_dir_extension,watched_file_extension);
    CheckForCompletedFiles(true);
    return 0;
  }


  ProcessDir(etvdir.c_str()); // get current file set list
  while (1)
  {
    if (HasDirChanged(etvdir.c_str()))
      ProcessDir(etvdir.c_str(),watched_dir_extension,watched_file_extension);
    sleep(SLEEP_LEN);
    CheckForCompletedFiles();
  }
    [mainpool release];
  return 0;
}

@interface FileWatcherApp : NSObject
{
    NSThread *mythread;
}
-(id)init;
-(void)dealloc;
-(void)begin;
-(void)fwmainThread:(id)unused;
@end
@implementation FileWatcherApp
-(id)init{
    if((self=[super init])==nil)
        return nil;
    return self;
}
-(void)dealloc{
    // no way to terminate the tread unless 10.5 FIXME?
    [super dealloc];
}
-(void)awakeFromNib
{
    [self begin];
}
-(void)begin{
    [NSThread detachNewThreadSelector:@selector(fwmainThread:) toTarget:self withObject:nil];
}
-(void)fwmainThread:(id)unused{
    unused=nil;//warning
    char *cmd="FileWatcher";
    mythread=[NSThread currentThread];
#ifndef COMMANDLINE
    FW_main(1, &cmd);
#endif
}
@end
    
