FasdUAS 1.101.10   ��   ��    k             l     ��  ��    D > Run the python MarkCommercials script for the given recording     � 	 	 |   R u n   t h e   p y t h o n   M a r k C o m m e r c i a l s   s c r i p t   f o r   t h e   g i v e n   r e c o r d i n g   
  
 l     ��  ��    8 2 this must be run with the RecordingStarted script     �   d   t h i s   m u s t   b e   r u n   w i t h   t h e   R e c o r d i n g S t a r t e d   s c r i p t      l     ��  ��    h b it will check if there were multiple PIDs for the recording and runs MarkCommercials for each pid     �   �   i t   w i l l   c h e c k   i f   t h e r e   w e r e   m u l t i p l e   P I D s   f o r   t h e   r e c o r d i n g   a n d   r u n s   M a r k C o m m e r c i a l s   f o r   e a c h   p i d      l     ��  ��    G A requires updated MarkCommercials which allows specifying the pid     �   �   r e q u i r e s   u p d a t e d   M a r k C o m m e r c i a l s   w h i c h   a l l o w s   s p e c i f y i n g   t h e   p i d      l     ��  ��    #  by Ben Blake, September 2009     �   :   b y   B e n   B l a k e ,   S e p t e m b e r   2 0 0 9      l     ��������  ��  ��       !   l     �� " #��   " � � modified for latest ComSkip, which cannot be run until after recording is finished; waits for Turbo.264 HD and EyeTV to stop running as well    # � $ $   m o d i f i e d   f o r   l a t e s t   C o m S k i p ,   w h i c h   c a n n o t   b e   r u n   u n t i l   a f t e r   r e c o r d i n g   i s   f i n i s h e d ;   w a i t s   f o r   T u r b o . 2 6 4   H D   a n d   E y e T V   t o   s t o p   r u n n i n g   a s   w e l l !  % & % l     �� ' (��   ' + % Steven T. Smith <s.t.smith@ieee.org>    ( � ) ) J   S t e v e n   T .   S m i t h   < s . t . s m i t h @ i e e e . o r g > &  * + * l     ��������  ��  ��   +  , - , p       . . ������ 0 logmsg LogMsg��   -  / 0 / l     ��������  ��  ��   0  1 2 1 i      3 4 3 I      �� 5���� 0 recordingdone RecordingDone 5  6�� 6 o      ���� 0 recordingid recordingID��  ��   4 k     � 7 7  8 9 8 l     ��������  ��  ��   9  : ; : r      < = < m      > > � ? ? 
 E y e T V = o      ���� 0 eyetvprocess EyeTVProcess ;  @ A @ r     B C B m     D D � E E ( E l g a t o   H . 2 6 4   D e c o d e r C o      ����  0 decoderprocess DecoderProcess A  F G F r     H I H m    	���� < I o      ���� 0 	delaytime 	DelayTime G  J K J l    L M N L r     O P O ]     Q R Q m    ����  R m    ���� < P o      ���� 0 	maxdelays 	MaxDelays M * $ twelve hours == MaxDelays*DelayTime    N � S S H   t w e l v e   h o u r s   = =   M a x D e l a y s * D e l a y T i m e K  T U T l   ��������  ��  ��   U  V W V l   �� X Y��   X T N delay until transcodeing for iPad/iPhone or both  slows down or stops running    Y � Z Z �   d e l a y   u n t i l   t r a n s c o d e i n g   f o r   i P a d / i P h o n e   o r   b o t h     s l o w s   d o w n   o r   s t o p s   r u n n i n g W  [ \ [ r     ] ^ ] m    ��
�� boovtrue ^ o      ���� 0 decoderunflag   \  _ ` _ U    i a b a k    d c c  d e d l   " f g h f I   "�� i��
�� .sysodelanull��� ��� nmbr i o    ���� 0 	delaytime 	DelayTime��   g 7 1 delay at least once to give it a chance to start    h � j j b   d e l a y   a t   l e a s t   o n c e   t o   g i v e   i t   a   c h a n c e   t o   s t a r t e  k l k l  # #�� m n��   m V P Elgato uses both Turbo.264 and EyeTV for transcoding, so check both in sequence    n � o o �   E l g a t o   u s e s   b o t h   T u r b o . 2 6 4   a n d   E y e T V   f o r   t r a n s c o d i n g ,   s o   c h e c k   b o t h   i n   s e q u e n c e l  p�� p Z   # d q r�� s q o   # $���� 0 decoderunflag   r k   ' E t t  u v u r   ' / w x w I   ' -�� y���� 0 cpupercentage CPUPercentage y  z�� z o   ( )����  0 decoderprocess DecoderProcess��  ��   x o      ���� 0 
pcpudecode   v  {�� { Z   0 E | }���� | G   0 ; ~  ~ =  0 3 � � � o   0 1���� 0 
pcpudecode   � m   1 2 � � � � �    A   6 9 � � � o   6 7���� 0 
pcpudecode   � m   7 8 � � @        } l  > A � � � � r   > A � � � m   > ?��
�� boovfals � o      ���� 0 decoderunflag   �   2% based on observation    � � � � 0   2 %   b a s e d   o n   o b s e r v a t i o n��  ��  ��  ��   s k   H d � �  � � � r   H P � � � I   H N�� ����� 0 cpupercentage CPUPercentage �  ��� � o   I J���� 0 eyetvprocess EyeTVProcess��  ��   � o      ���� 0 	pcpueyetv   �  ��� � Z   Q d � ����� � G   Q \ � � � =  Q T � � � o   Q R���� 0 	pcpueyetv   � m   R S � � � � �   � A   W Z � � � o   W X���� 0 	pcpueyetv   � m   X Y � � @>       � l  _ ` � � � � l  _ ` � � � �  S   _ ` � 6 0 break out of delay loop if EyeTVProcess is idle    � � � � `   b r e a k   o u t   o f   d e l a y   l o o p   i f   E y e T V P r o c e s s   i s   i d l e �   30% based on observation    � � � � 2   3 0 %   b a s e d   o n   o b s e r v a t i o n��  ��  ��  ��   b o    ���� 0 	maxdelays 	MaxDelays `  � � � l  j j��������  ��  ��   �  � � � I  j o�� ���
�� .sysodelanull��� ��� nmbr � m   j k���� 
��   �  � � � l  p p�� � ���   � _ Y comskip81 uses ffmpeg and does not support live tv; take this from RecordingStarted.scpt    � � � � �   c o m s k i p 8 1   u s e s   f f m p e g   a n d   d o e s   n o t   s u p p o r t   l i v e   t v ;   t a k e   t h i s   f r o m   R e c o r d i n g S t a r t e d . s c p t �  � � � r   p w � � � b   p u � � � b   p s � � � m   p q � � � � �
 e x p o r t   D I S P L A Y = : 0 . 0 ;   / u s r / b i n / n i c e   - n   5   ' / L i b r a r y / A p p l i c a t i o n   S u p p o r t / E T V C o m s k i p / M a r k C o m m e r c i a l s . a p p / C o n t e n t s / M a c O S / M a r k C o m m e r c i a l s '   � o   q r���� 0 recordingid recordingID � m   s t � � � � �    & >   / d e v / n u l l   & � o      ���� 0 cmd   �  � � � l  x x�� � ���   �   display dialog cmd    � � � � &   d i s p l a y   d i a l o g   c m d �  � � � l  x x�� � ���   � - ' set cmd to "env > /tmp/etv_test.log &"    � � � � N   s e t   c m d   t o   " e n v   >   / t m p / e t v _ t e s t . l o g   & " �  � � � I  x }�� ���
�� .sysoexecTEXT���     TEXT � o   x y���� 0 cmd  ��   �  � � � l  ~ ~��������  ��  ��   �  � � � r   ~ � � � � m   ~  � � � � �   � o      ���� 0 logmsg LogMsg �  � � � I   � ��� ����� &0 checkmultiplepids CheckMultiplePIDs �  ��� � o   � ����� 0 recordingid recordingID��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 7 1disable this if you do not want a logfile written    � � � � b d i s a b l e   t h i s   i f   y o u   d o   n o t   w a n t   a   l o g f i l e   w r i t t e n �  ��� � Z   � � � ����� � ?   � � � � � l  � � ����� � I  � ��� ���
�� .corecnte****       **** � o   � ����� 0 logmsg LogMsg��  ��  ��   � m   � �����   � I   � ��� ����� 0 write_to_file   �  � � � b   � � � � � b   � � � � � l  � � ����� � b   � � � � � b   � � � � � n   � � � � � 1   � ���
�� 
shdt � l  � � ����� � I  � �������
�� .misccurdldt    ��� null��  ��  ��  ��   � m   � � � � � � �    � n   � � � � � 1   � ���
�� 
tstr � l  � � ����� � I  � �������
�� .misccurdldt    ��� null��  ��  ��  ��  ��  ��   � o   � ����� 0 logmsg LogMsg � l  � � ����� � I  � ��� ���
�� .sysontocTEXT       shor � m   � ����� ��  ��  ��   �  � � � b   � � � � � l  � � ����� � I  � �� 
� .earsffdralis        afdr  m   � � �  l o g s �~�}
�~ 
rtyp m   � ��|
�| 
TEXT�}  ��  ��   � m   � � � " E y e T V   s c r i p t s . l o g � �{ m   � ��z
�z boovtrue�{  ��  ��  ��  ��   2 	 l     �y�x�w�y  �x  �w  	 

 l     �v�v    y testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script    � �   t e s t i n g   c o d e :   t h i s   w i l l   n o t   b e   c a l l e d   w h e n   t r i g g e r e d   f r o m   E y e T V ,   b u t   o n l y   w h e n   t h e   s c r i p t   i s   r u n   a s   a   s t a n d - a l o n e   s c r i p t  i     I     �u�t�s
�u .aevtoappnull  �   � ****�t  �s   O      k      l   �r�r   3 - set rec to unique ID of item 1 of recordings    � Z   s e t   r e c   t o   u n i q u e   I D   o f   i t e m   1   o f   r e c o r d i n g s  r     m    �q�q �L� o      �p�p 0 rec     l   �o�n�m�o  �n  �m    !�l! n   "#" I   	 �k$�j�k 0 recordingdone RecordingDone$ %�i% o   	 
�h�h 0 rec  �i  �j  #  f    	�l   m     &&�                                                                                  EyTV  alis    @  	Server HD                  �g�H+     �	EyeTV.app                                                       Ya�*��        ����  	                Applications    �gJ      �*�       �  !Server HD:Applications: EyeTV.app    	 E y e T V . a p p   	 S e r v e r   H D  Applications/EyeTV.app  / ��   '(' l     �g�f�e�g  �f  �e  ( )*) l     �d+,�d  + 8 2 compute the percentage CPU used by DecoderProcess   , �-- d   c o m p u t e   t h e   p e r c e n t a g e   C P U   u s e d   b y   D e c o d e r P r o c e s s* ./. i    010 I      �c2�b�c 0 cpupercentage CPUPercentage2 3�a3 o      �`�`  0 decoderprocess DecoderProcess�a  �b  1 k     544 565 r     787 I    	�_9�^
�_ .sysoexecTEXT���     TEXT9 l    :�]�\: b     ;<; b     =>= m     ?? �@@ $ p s   - a x w w c   |   g r e p   '> o    �[�[  0 decoderprocess DecoderProcess< m    AA �BB 0 '   |   g r e p   - v   g r e p   | |   t r u e�]  �\  �^  8 o      �Z�Z 0 	processps 	ProcessPS6 C�YC Z    5DE�XFD >   GHG o    �W�W 0 	processps 	ProcessPSH m    II �JJ  E k    0KK LML r    NON n    PQP 4    �VR
�V 
cworR m    �U�U Q o    �T�T 0 	processps 	ProcessPSO o      �S�S 0 	processid 	ProcessIDM STS r    $UVU I   "�RW�Q
�R .sysoexecTEXT���     TEXTW l   X�P�OX b    YZY b    [\[ m    ]] �^^ 6 p s   - x w w c o   p i d , p p i d , % c p u   - p  \ o    �N�N 0 	processid 	ProcessIDZ m    __ �``    |   t a i l   - 1�P  �O  �Q  V o      �M�M 0 	processps 	ProcessPST aba r   % +cdc n   % )efe 4   & )�Lg
�L 
cworg m   ' (�K�K f o   % &�J�J 0 	processps 	ProcessPSd o      �I�I 0 
processcpu 
ProcessCPUb h�Hh L   , 0ii c   , /jkj o   , -�G�G 0 
processcpu 
ProcessCPUk m   - .�F
�F 
nmbr�H  �X  F L   3 5ll m   3 4mm �nn  �Y  / opo l     �E�D�C�E  �D  �C  p qrq i    sts I      �Bu�A�B &0 checkmultiplepids CheckMultiplePIDsu v�@v o      �?�? 0 recordingid recordingID�@  �A  t k    ww xyx l     �>z{�>  z 8 2check if there are multiple Video PIDs in the file   { �|| d c h e c k   i f   t h e r e   a r e   m u l t i p l e   V i d e o   P I D s   i n   t h e   f i l ey }~} l     �=�<�;�=  �<  �;  ~ �: O    ��� k    �� ��� r    ��� n   ��� I    �9��8�9 0 read_from_file  � ��7� b    ��� b    ��� b    ��� b    ��� l   ��6�5� I   �4��
�4 .earsffdralis        afdr� m    �� ���  l o g s� �3��2
�3 
rtyp� m    �1
�1 
TEXT�2  �6  �5  � m    �� ���  E T V C o m s k i p� m    �� ���  :� o    �0�0 0 recordingid recordingID� m    �� ���  _ c o m s k i p . l o g�7  �8  �  f    � o      �/�/ 0 
input_text  � ��.� Z    ���-�,� ?    $��� l   "��+�*� I   "�)��(
�) .corecnte****       ****� l   ��'�&� c    ��� o    �%�% 0 
input_text  � m    �$
�$ 
TEXT�'  �&  �(  �+  �*  � m   " #�#�#  � k   ' ��� ��� r   ' ,��� n   ' *��� 2   ( *�"
�" 
cpar� o   ' (�!�! 0 
input_text  � o      � �  0 logdata  � ��� r   - ;��� c   - 9��� l  - 7���� n   - 7��� 4   . 7��
� 
cobj� l  / 6���� \   / 6��� l  / 4���� I  / 4���
� .corecnte****       ****� o   / 0�� 0 logdata  �  �  �  � m   4 5�� �  �  � o   - .�� 0 logdata  �  �  � m   7 8�
� 
TEXT� o      �� 0 logdata_lastrow  � ��� l  < <����  �  �  � ��� Z   < ������ =   < K��� c   < I��� l  < G���
� n   < G��� 7  = G�	��
�	 
cobj� m   A C�� � m   D F�� � o   < =�� 0 logdata_lastrow  �  �
  � m   G H�
� 
TEXT� m   I J�� ��� & V i d e o   P I D   n o t   f o u n d� k   N ��� ��� l  N N����  � A ;multiple Video PIDs, rerun MarkCommercials until successful   � ��� v m u l t i p l e   V i d e o   P I D s ,   r e r u n   M a r k C o m m e r c i a l s   u n t i l   s u c c e s s f u l� ��� l  N N����  �  �  � ��� r   N S��� c   N Q��� o   N O� �  0 recordingid recordingID� m   O P��
�� 
long� o      ���� &0 recrdingidinteger recrdingIDInteger� ��� r   T ]��� 5   T [�����
�� 
cRec� o   V W���� &0 recrdingidinteger recrdingIDInteger
�� kfrmID  � o      ���� 0 rec  � ��� r   ^ {��� b   ^ w��� b   ^ q��� b   ^ m��� b   ^ g��� b   ^ c��� m   ^ a�� ��� h R e c o r d i n g D o n e   f o u n d   m u l t i p l e   P I D s   f o r   r e c o r d i n g   I D :  � o   a b���� 0 recordingid recordingID� m   c f�� ���  ,   C h a n n e l  � l  g l������ n   g l��� 1   h l��
�� 
Chnm� o   g h���� 0 rec  ��  ��  � m   m p�� ���    -  � l  q v������ n   q v��� 1   r v��
�� 
Titl� o   q r���� 0 rec  ��  ��  � o      ���� 0 logmsg LogMsg� ��� l  | |��������  ��  ��  � ��� r   | �   c   | � l  | ����� n   | � 7  } ���
�� 
cobj m   � ����� , l  � �	����	 \   � �

 l  � ����� I  � �����
�� .corecnte****       **** o   � ����� 0 logdata_lastrow  ��  ��  ��   m   � ����� ��  ��   o   | }���� 0 logdata_lastrow  ��  ��   m   � ���
�� 
TEXT o      ���� 0 pids PIDs�  r   � � n  � � 1   � ���
�� 
txdl 1   � ���
�� 
ascr o      ���� 
0 delims    r   � � m   � � �  ,   n      1   � ���
�� 
txdl 1   � ���
�� 
ascr  r   � � J   � �����   o      ���� 0 pid_list PID_List  !  r   � �"#" n   � �$%$ 2   � ���
�� 
cwor% o   � ����� 0 pids PIDs# o      ���� 0 pid_list PID_List! &'& r   � �()( o   � ����� 
0 delims  ) n     *+* 1   � ���
�� 
txdl+ 1   � ���
�� 
ascr' ,-, l  � ���������  ��  ��  - ./. X   � �0��10 k   � �22 343 n  � �565 I   � ���7���� 0 launchcomskip launchComSkip7 898 o   � ����� 0 recordingid recordingID9 :��: o   � ����� 0 pid  ��  ��  6  f   � �4 ;��; V   � �<=< I  � ���>��
�� .sysodelanull��� ��� nmbr> m   � ����� ��  = l  � �?����? n  � �@A@ I   � ��������� 0 mcisrunning mcIsRunning��  ��  A  f   � ���  ��  ��  �� 0 pid  1 o   � ����� 0 pid_list PID_List/ B��B l  � ���������  ��  ��  ��  �  �  �  �-  �,  �.  � m     CC�                                                                                  EyTV  alis    @  	Server HD                  �g�H+     �	EyeTV.app                                                       Ya�*��        ����  	                Applications    �gJ      �*�       �  !Server HD:Applications: EyeTV.app    	 E y e T V . a p p   	 S e r v e r   H D  Applications/EyeTV.app  / ��  �:  r DED l     ��������  ��  ��  E FGF i    HIH I      ��J���� 0 read_from_file  J K��K o      ���� 0 target_file  ��  ��  I k      LL MNM l     ��OP��  O + %return the contents of the given file   P �QQ J r e t u r n   t h e   c o n t e n t s   o f   t h e   g i v e n   f i l eN RSR r     TUT l    V����V I    ��W��
�� .rdwropenshor       fileW l    X����X o     ���� 0 target_file  ��  ��  ��  ��  ��  U o      ���� 0 fileref fileRefS YZY r    [\[ l   ]����] I   ��^_
�� .rdwrread****        ****^ o    	���� 0 fileref fileRef_ ��`a
�� 
rdfr` l  
 b����b I  
 ��c��
�� .rdwrgeofcomp       ****c o   
 ���� 0 fileref fileRef��  ��  ��  a ��d��
�� 
as  d m    ��
�� 
utf8��  ��  ��  \ o      ���� 0 txt  Z efe I   ��g��
�� .rdwrclosnull���     ****g o    ���� 0 fileref fileRef��  f h��h L     ii o    ���� 0 txt  ��  G jkj l     ��������  ��  ��  k lml i    non I      ��p���� 0 write_to_file  p qrq o      ���� 0 	this_data  r sts o      ���� 0 target_file  t u��u o      ���� 0 append_data  ��  ��  o k     Yvv wxw l     ��yz��  y = 7from http://www.apple.com/applescript/sbrt/sbrt-09.html   z �{{ n f r o m   h t t p : / / w w w . a p p l e . c o m / a p p l e s c r i p t / s b r t / s b r t - 0 9 . h t m lx |��| Q     Y}~} k    :�� ��� r    ��� c    ��� l   ������ o    ���� 0 target_file  ��  ��  � m    ��
�� 
TEXT� l     ������ o      ���� 0 target_file  ��  ��  � ��� r   	 ��� I  	 ����
�� .rdwropenshor       file� 4   	 ���
�� 
file� o    ���� 0 target_file  � �����
�� 
perm� m    �
� boovtrue��  � l     ��~�}� o      �|�| 0 open_target_file  �~  �}  � ��� Z   '���{�z� =   ��� o    �y�y 0 append_data  � m    �x
�x boovfals� I   #�w��
�w .rdwrseofnull���     ****� l   ��v�u� o    �t�t 0 open_target_file  �v  �u  � �s��r
�s 
set2� m    �q�q  �r  �{  �z  � ��� I  ( 1�p��
�p .rdwrwritnull���     ****� o   ( )�o�o 0 	this_data  � �n��
�n 
refn� l  * +��m�l� o   * +�k�k 0 open_target_file  �m  �l  � �j��i
�j 
wrat� m   , -�h
�h rdwreof �i  � ��� I  2 7�g��f
�g .rdwrclosnull���     ****� l  2 3��e�d� o   2 3�c�c 0 open_target_file  �e  �d  �f  � ��b� L   8 :�� m   8 9�a
�a boovtrue�b  ~ R      �`�_�^
�` .ascrerr ****      � ****�_  �^   k   B Y�� ��� Q   B V���]� I  E M�\��[
�\ .rdwrclosnull���     ****� 4   E I�Z�
�Z 
file� o   G H�Y�Y 0 target_file  �[  � R      �X�W�V
�X .ascrerr ****      � ****�W  �V  �]  � ��U� L   W Y�� m   W X�T
�T boovfals�U  ��  m ��� l     �S�R�Q�S  �R  �Q  � ��� i    ��� I      �P��O�P 0 launchcomskip launchComSkip� ��� o      �N�N 0 recid recID� ��M� o      �L�L 0 pid  �M  �O  � k     !�� ��� Z     ���K�� =     ��� o     �J�J 0 pid  � m    �� ���  � r    ��� b    ��� b    	��� m    �� ���& e x p o r t   D I S P L A Y = : 0 . 0 ;   / u s r / b i n / n i c e   - n   5   ' / L i b r a r y / A p p l i c a t i o n   S u p p o r t / E T V C o m s k i p / M a r k C o m m e r c i a l s . a p p / C o n t e n t s / M a c O S / M a r k C o m m e r c i a l s '   - - f o r c e   - - l o g  � o    �I�I 0 recid recID� m   	 
�� ���    & >   / d e v / n u l l   &� o      �H�H 0 cmd  �K  � r    ��� b    ��� b    ��� b    ��� b    ��� m    �� ���& e x p o r t   D I S P L A Y = : 0 . 0 ;   / u s r / b i n / n i c e   - n   5   ' / L i b r a r y / A p p l i c a t i o n   S u p p o r t / E T V C o m s k i p / M a r k C o m m e r c i a l s . a p p / C o n t e n t s / M a c O S / M a r k C o m m e r c i a l s '   - - f o r c e   - - l o g  � o    �G�G 0 recid recID� m    �� ���    - - p i d =� o    �F�F 0 pid  � m    �� ���    & >   / d e v / n u l l   &� o      �E�E 0 cmd  � ��� l   �D�C�B�D  �C  �B  � ��A� I   !�@��?
�@ .sysoexecTEXT���     TEXT� o    �>�> 0 cmd  �?  �A  � ��� l     �=�<�;�=  �<  �;  � ��� i    ��� I      �:�9�8�: 0 mcisrunning mcIsRunning�9  �8  � k     �� ��� r     ��� I    �7��6
�7 .sysoexecTEXT���     TEXT� m     �� ��� � p s   - x w w   |   a w k   - F /   ' N F   > 2 '   |   a w k   - F /   ' { p r i n t   $ N F } '   |   a w k   - F   ' - '   ' { p r i n t   $ 1 } '  �6  � o      �5�5 0 processpaths processPaths� ��4� L    �� l   ��3�2� E    ��� o    	�1�1 0 processpaths processPaths� m   	 
�� ���  M a r k C o m m e r c i a l s�3  �2  �4  � ��0� l     �/�.�-�/  �.  �-  �0       
�,����� �,  � �+�*�)�(�'�&�%�$�+ 0 recordingdone RecordingDone
�* .aevtoappnull  �   � ****�) 0 cpupercentage CPUPercentage�( &0 checkmultiplepids CheckMultiplePIDs�' 0 read_from_file  �& 0 write_to_file  �% 0 launchcomskip launchComSkip�$ 0 mcisrunning mcIsRunning� �# 4�"�!� �# 0 recordingdone RecordingDone�" ��   �� 0 recordingid recordingID�!   	���������� 0 recordingid recordingID� 0 eyetvprocess EyeTVProcess�  0 decoderprocess DecoderProcess� 0 	delaytime 	DelayTime� 0 	maxdelays 	MaxDelays� 0 decoderunflag  � 0 
pcpudecode  � 0 	pcpueyetv  � 0 cmd    > D���� � �� � �� � �� �����
�	 ��������� <� 
� .sysodelanull��� ��� nmbr� 0 cpupercentage CPUPercentage
� 
bool� 

� .sysoexecTEXT���     TEXT� 0 logmsg LogMsg� &0 checkmultiplepids CheckMultiplePIDs
� .corecnte****       ****
�
 .misccurdldt    ��� null
�	 
shdt
� 
tstr� 
� .sysontocTEXT       shor
� 
rtyp
� 
TEXT
� .earsffdralis        afdr� 0 write_to_file  �  ��E�O�E�O�E�O�� E�OeE�O R�kh�j O� #*�k+ E�O�� 
 ���& fE�Y hY *�k+ E�O�� 
 ���& Y h[OY��O�j O�%�%E�O�j O�E` O*�k+ O_ j j ?**j a ,a %*j a ,%_ %a j %a a a l a %em+ Y h� �� ����
� .aevtoappnull  �   � ****�   ��     &�������� �L��� 0 rec  �� 0 recordingdone RecordingDone�� � �E�O)�k+ U� ��1����	
���� 0 cpupercentage CPUPercentage�� ����   ����  0 decoderprocess DecoderProcess��  	 ����������  0 decoderprocess DecoderProcess�� 0 	processps 	ProcessPS�� 0 	processid 	ProcessID�� 0 
processcpu 
ProcessCPU
 	?A��I��]_��m
�� .sysoexecTEXT���     TEXT
�� 
cwor
�� 
nmbr�� 6�%�%j E�O�� #��k/E�O�%�%j E�O��m/E�O��&Y �� ��t�������� &0 checkmultiplepids CheckMultiplePIDs�� ����   ���� 0 recordingid recordingID��   
���������������������� 0 recordingid recordingID�� 0 
input_text  �� 0 logdata  �� 0 logdata_lastrow  �� &0 recrdingidinteger recrdingIDInteger�� 0 rec  �� 0 pids PIDs�� 
0 delims  �� 0 pid_list PID_List�� 0 pid   !C������������������������������������������������������
�� 
rtyp
�� 
TEXT
�� .earsffdralis        afdr�� 0 read_from_file  
�� .corecnte****       ****
�� 
cpar
�� 
cobj�� 
�� 
long
�� 
cRec
�� kfrmID  
�� 
Chnm
�� 
Titl�� 0 logmsg LogMsg�� ,
�� 
ascr
�� 
txdl
�� 
cwor
�� 
kocl�� 0 launchcomskip launchComSkip�� 0 mcisrunning mcIsRunning�� 
�� .sysodelanull��� ��� nmbr��� �)���l �%�%�%�%k+ E�O��&j 	j ڡ�-E�O��j 	k/�&E�O�[�\[Zk\Z�2�&�  ���&E�O*�a 0E�Oa �%a %�a ,%a %�a ,%E` O�[�\[Za \Z�j 	l2�&E�O_ a ,E�Oa _ a ,FOjvE�O�a -E�O�_ a ,FO 4�[a �l 	kh 	)��l+ O h)j+ a j  [OY��[OY��OPY hY hU  ��I�������� 0 read_from_file  �� ����   ���� 0 target_file  ��   �������� 0 target_file  �� 0 fileref fileRef�� 0 txt   ����������������
�� .rdwropenshor       file
�� 
rdfr
�� .rdwrgeofcomp       ****
�� 
as  
�� 
utf8�� 
�� .rdwrread****        ****
�� .rdwrclosnull���     ****�� !�j  E�O��j ��� E�O�j O� ��o�������� 0 write_to_file  �� ����   �������� 0 	this_data  �� 0 target_file  �� 0 append_data  ��   ���������� 0 	this_data  �� 0 target_file  �� 0 append_data  �� 0 open_target_file   ����������������������������
�� 
TEXT
�� 
file
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� 
wrat
�� rdwreof �� 
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****��  ��  �� Z <��&E�O*�/�el E�O�f  ��jl Y hO����� 
O�j OeW X   *�/j W X  hOf ����������� 0 launchcomskip launchComSkip�� ����   ������ 0 recid recID�� 0 pid  ��   �������� 0 recid recID�� 0 pid  �� 0 cmd   ��������
�� .sysoexecTEXT���     TEXT�� "��  �%�%E�Y �%�%�%�%E�O�j  ����������� 0 mcisrunning mcIsRunning��  ��   ���� 0 processpaths processPaths ����
�� .sysoexecTEXT���     TEXT�� �j E�O��ascr  ��ޭ