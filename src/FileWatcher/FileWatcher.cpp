#include <stdio.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

#include <string>
#include <vector>
#include <set>

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
    printf("Error stat'ing EyeTV directory!\n");
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
    printf("EyeTV directory changed!\n");
    last_time=statbuf.st_ctimespec.tv_sec;
    return true;
  }

  return false;
}

std::string ShellEscape(const std::string &str)
{
  std::string ret="";
  for (size_t i=0;i<str.size(); ++i)
    ret = ret + "\\" + str[i];
  return ret;
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
        printf("Error stat'ing .eyetv directory!\n");
        _error=true; // mark for removal from list
        return false;
      }
#ifdef DEBUG
      printf("Checking size of file %s, size %ld, iteration %d of %d\n",_fname.c_str(), statbuf.st_size,_same_size_count,_max_count);
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
      printf("File %s is complete!\n",_fname.c_str());
      _is_complete=true;

      std::string f=std::string("/Applications/ETVComskip/MarkCommercials.sh ") + ShellEscape(_fname);
      if (background)
        f+=" &";
      printf("Calling %s\n",f.c_str());
      system(f.c_str());
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
    printf("Error stat'ing file %s\n",fname.c_str());
    return false;
  }
  if (!(statbuf.st_mode & S_IFDIR)) 
  {
    printf("New directory entry %s is not a directory\n",fname.c_str());
    return false;
  }

  // is does it match the watched_dir_extension?
  std::string::size_type pos=fname.find(watched_dir_extension);
  if (pos==std::string::npos || pos != fname.size()-watched_dir_extension.size())
  {
    printf("New directory entry %s is not an %s directory\n",fname.c_str(),watched_dir_extension.c_str());
    return false;
  }


  printf("Got new directory entry: %s\n",fname.c_str());

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
        if (ProcessNewEntry(fname, watched_dir_extension, watched_file_extension))
          system("/usr/bin/osascript /Applications/ETVComskip/EyeTVReaper.scpt &"); // got new file, so run reaper
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
  FILE *f=popen("/usr/bin/osascript /Applications/ETVComskip/FindEyeTVArchive.scpt","r");
  if (!f) {
    printf("Failed to find EyeTV Archive directory\n");
    return "";
  }
  char buf[1024];
  fgets(buf,1024,f);
  
  if (buf[strlen(buf)-1]=='\n')
    buf[strlen(buf)-1]=0;
  printf("Got EyeTV directory %s\n",buf);
  fclose(f);
  return buf;
}


int main(int argc, char **argv)
{
  char *watched_dir_extension=".eyetv";
  char *watched_file_extension=".mpg";

  std::string etvdir=FindEyeTVArchive();
  if (etvdir.size()==0)
    return 0;

  bool do_all=false;
  for (int i=0; i< argc; ++i)
  {
    if (strncmp(argv[i],"all",3)==0) {
      do_all=true;
      break;
    }
  }

  if (do_all)
  {
    printf("Got args: \n");

    printf("Processing all files in directory.  Press enter after you quit EyeTV:");
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
  return 0;
}
