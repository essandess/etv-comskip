FasdUAS 1.101.10   ��   ��    k             l     ��  ��    � � EyeTV ExportDone script to use ComSkip to mark commercials in exports to iTunes and ~/Movies, and save exported file inode numbers as the text file filename.exported_inodes.txt for synchronization with MarkCommercials.py     � 	 	�   E y e T V   E x p o r t D o n e   s c r i p t   t o   u s e   C o m S k i p   t o   m a r k   c o m m e r c i a l s   i n   e x p o r t s   t o   i T u n e s   a n d   ~ / M o v i e s ,   a n d   s a v e   e x p o r t e d   f i l e   i n o d e   n u m b e r s   a s   t h e   t e x t   f i l e   f i l e n a m e . e x p o r t e d _ i n o d e s . t x t   f o r   s y n c h r o n i z a t i o n   w i t h   M a r k C o m m e r c i a l s . p y   
  
 l     ��������  ��  ��        l     ��  ��    Z T Copyright � 2012�2013 Steven T. Smith <steve dot t dot smith at gmail dot com>, GPL     �   �   C o p y r i g h t   �   2 0 1 2  2 0 1 3   S t e v e n   T .   S m i t h   < s t e v e   d o t   t   d o t   s m i t h   a t   g m a i l   d o t   c o m > ,   G P L      l     ��������  ��  ��        l     ��  ��    N H    This program is free software: you can redistribute it and/or modify     �   �         T h i s   p r o g r a m   i s   f r e e   s o f t w a r e :   y o u   c a n   r e d i s t r i b u t e   i t   a n d / o r   m o d i f y      l     ��  ��    N H    it under the terms of the GNU General Public License as published by     �   �         i t   u n d e r   t h e   t e r m s   o f   t h e   G N U   G e n e r a l   P u b l i c   L i c e n s e   a s   p u b l i s h e d   b y      l     ��   ��    K E    the Free Software Foundation, either version 3 of the License, or      � ! ! �         t h e   F r e e   S o f t w a r e   F o u n d a t i o n ,   e i t h e r   v e r s i o n   3   o f   t h e   L i c e n s e ,   o r   " # " l     �� $ %��   $ - '    (at your option) any later version.    % � & & N         ( a t   y o u r   o p t i o n )   a n y   l a t e r   v e r s i o n . #  ' ( ' l     ��������  ��  ��   (  ) * ) l     �� + ,��   + I C    This program is distributed in the hope that it will be useful,    , � - - �         T h i s   p r o g r a m   i s   d i s t r i b u t e d   i n   t h e   h o p e   t h a t   i t   w i l l   b e   u s e f u l , *  . / . l     �� 0 1��   0 H B    but WITHOUT ANY WARRANTY; without even the implied warranty of    1 � 2 2 �         b u t   W I T H O U T   A N Y   W A R R A N T Y ;   w i t h o u t   e v e n   t h e   i m p l i e d   w a r r a n t y   o f /  3 4 3 l     �� 5 6��   5 G A    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the    6 � 7 7 �         M E R C H A N T A B I L I T Y   o r   F I T N E S S   F O R   A   P A R T I C U L A R   P U R P O S E .     S e e   t h e 4  8 9 8 l     �� : ;��   : 6 0    GNU General Public License for more details.    ; � < < `         G N U   G e n e r a l   P u b l i c   L i c e n s e   f o r   m o r e   d e t a i l s . 9  = > = l     ��������  ��  ��   >  ? @ ? l     �� A B��   A K E    You should have received a copy of the GNU General Public License    B � C C �         Y o u   s h o u l d   h a v e   r e c e i v e d   a   c o p y   o f   t h e   G N U   G e n e r a l   P u b l i c   L i c e n s e @  D E D l     �� F G��   F O I    along with this program.  If not, see <http://www.gnu.org/licenses/>.    G � H H �         a l o n g   w i t h   t h i s   p r o g r a m .     I f   n o t ,   s e e   < h t t p : / / w w w . g n u . o r g / l i c e n s e s / > . E  I J I l     ��������  ��  ��   J  K L K l     �� M N��   M Z T 2012-10-19 1.0rc1: Initial release as part of 1.0rc1 at ETVComskip Google code page    N � O O �   2 0 1 2 - 1 0 - 1 9   1 . 0 r c 1 :   I n i t i a l   r e l e a s e   a s   p a r t   o f   1 . 0 r c 1   a t   E T V C o m s k i p   G o o g l e   c o d e   p a g e L  P Q P l     �� R S��   R � � 2013-01-29 1.0rc2: Handle exports to ~/Movies; Fix issues with multiple exports: extend iTunes delay, modify IsFileOpen to ignore Spotlight indexing, and use creation date    S � T TX   2 0 1 3 - 0 1 - 2 9   1 . 0 r c 2 :   H a n d l e   e x p o r t s   t o   ~ / M o v i e s ;   F i x   i s s u e s   w i t h   m u l t i p l e   e x p o r t s :   e x t e n d   i T u n e s   d e l a y ,   m o d i f y   I s F i l e O p e n   t o   i g n o r e   S p o t l i g h t   i n d e x i n g ,   a n d   u s e   c r e a t i o n   d a t e Q  U V U l     ��������  ��  ��   V  W X W i      Y Z Y I      �� [���� 0 
exportdone 
ExportDone [  \�� \ o      ���� 0 recordingid recordingID��  ��   Z k    � ] ]  ^ _ ^ l     ��������  ��  ��   _  ` a ` r      b c b c      d e d o     ���� 0 recordingid recordingID e m    ��
�� 
long c o      ���� 0 myid   a  f g f r    	 h i h m     j j � k k . / o p t / l o c a l / b i n / m p 4 c h a p s i o      ���� 0 mp4chaps   g  l m l r   
  n o n m   
  p p � q q  . c h a p t e r s . t x t o o      ���� 0 mp4chaps_suffix   m  r s r r     t u t m     v v � w w ( . e x p o r t e d _ i n o d e s . t x t u o      ���� 0 export_suffix   s  x y x r     z { z m     | | � } }  . e d l { o      ���� 0 
edl_suffix   y  ~  ~ r     � � � m     � � � � �  . p l � o      ���� 0 perl_suffix     � � � l   ��������  ��  ��   �  � � � n   D � � � I    D�� ����� 0 write_to_file   �  � � � b    4 � � � b    2 � � � b    0 � � � b    . � � � l   , ����� � b    , � � � b    $ � � � n    " � � � 1     "��
�� 
shdt � l     ����� � I    ������
�� .misccurdldt    ��� null��  ��  ��  ��   � m   " # � � � � �    � n   $ + � � � 1   ) +��
�� 
tstr � l  $ ) ����� � I  $ )������
�� .misccurdldt    ��� null��  ��  ��  ��  ��  ��   � m   , - � � � � �    � m   . / � � � � � 0 E x p o r t   D o n e   r u n   f o r   I D :   � o   0 1���� 0 recordingid recordingID � o   2 3��
�� 
ret  �  � � � b   4 ? � � � l  4 ; ����� � I  4 ;�� � �
�� .earsffdralis        afdr � m   4 5 � � � � �  l o g s � �� ���
�� 
rtyp � m   6 7��
�� 
utxt��  ��  ��   � m   ; > � � � � � " E y e T V   s c r i p t s . l o g �  ��� � m   ? @��
�� boovtrue��  ��   �  f     �  � � � l  E E��������  ��  ��   �  � � � l  E E�� � ���   � ' ! try block example for debugging:    � � � � B   t r y   b l o c k   e x a m p l e   f o r   d e b u g g i n g : �  � � � l  E E�� � ���   � 
  try    � � � �    t r y �  � � � l  E E�� � ���   � %  	set mymp4 to (item 1 of mytv)    � � � � >   	 s e t   m y m p 4   t o   ( i t e m   1   o f   m y t v ) �  � � � l  E E�� � ���   � %  on error errText number errNum    � � � � >   o n   e r r o r   e r r T e x t   n u m b e r   e r r N u m �  � � � l  E E�� � ���   � I C 	set exported_error_file to eyetv_path & eyetv_root & ".error.txt"    � � � � �   	 s e t   e x p o r t e d _ e r r o r _ f i l e   t o   e y e t v _ p a t h   &   e y e t v _ r o o t   &   " . e r r o r . t x t " �  � � � l  E E�� � ���   � � | 	my write_to_file("ExportDone error 1: " & errText & "; error number " & errNum & "." & return, exported_error_file, false)    � � � � �   	 m y   w r i t e _ t o _ f i l e ( " E x p o r t D o n e   e r r o r   1 :   "   &   e r r T e x t   &   " ;   e r r o r   n u m b e r   "   &   e r r N u m   &   " . "   &   r e t u r n ,   e x p o r t e d _ e r r o r _ f i l e ,   f a l s e ) �  � � � l  E E�� � ���   �   end try    � � � �    e n d   t r y �  � � � l  E E��������  ��  ��   �  � � � O   E p � � � k   K o � �  � � � r   K [ � � � e   K Y � � l  K Y ����� � n   K Y � � � 1   T X��
�� 
Titl � 5   K T�� ���
�� 
cRec � o   O P���� 0 myid  
�� kfrmID  ��  ��   � o      ���� 0 myshortname   �  ��� � r   \ o � � � e   \ m � � c   \ m � � � l  \ i ����� � n   \ i � � � 1   e i��
�� 
pURL � 5   \ e�� ���
�� 
cRec � o   ` a���� 0 myid  
�� kfrmID  ��  ��   � m   i l��
�� 
alis � o      ���� 0 eyetvr_file  ��   � m   E H � ��                                                                                  EyTV  alis    @  	Server HD                  �k�H+  �.	EyeTV.app                                                      o�F͔z�        ����  	                Applications    ��*      ͔��    �.  !Server HD:Applications: EyeTV.app    	 E y e T V . a p p   	 S e r v e r   H D  Applications/EyeTV.app  / ��   �  � � � l  q q��������  ��  ��   �  � � � l  q q�� � ���   � > 8 Get EyeTV's root file names and paths for the recording    � � � � p   G e t   E y e T V ' s   r o o t   f i l e   n a m e s   a n d   p a t h s   f o r   t h e   r e c o r d i n g �  � � � O  q � � � � r   w � � � � c   w ~   n   w | m   x |��
�� 
ctnr o   w x���� 0 eyetvr_file   m   | }��
�� 
utxt � o      ���� 0 
eyetv_path   � m   q t�                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��   �  l  � �����   ? 9 fix AppleScript's strange trailing colon issue for paths    �		 r   f i x   A p p l e S c r i p t ' s   s t r a n g e   t r a i l i n g   c o l o n   i s s u e   f o r   p a t h s 

 Z  � ����� >  � � n   � � 4   � ���
�� 
cha  m   � ������� o   � ����� 0 
eyetv_path   m   � � �  : r   � � b   � � o   � ����� 0 
eyetv_path   m   � � �  : o      ���� 0 
eyetv_path  ��  ��    O  � � r   � �  n   � �!"! 1   � ���
�� 
pnam" o   � ����� 0 eyetvr_file    o      ���� 0 
eyetv_file   m   � �##�                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��   $%$ r   � �&'& l  � �(����( n   � �)*) I   � ���+��� 0 rootname RootName+ ,�~, o   � ��}�} 0 
eyetv_file  �~  �  *  f   � ���  ��  ' o      �|�| 0 
eyetv_root  % -.- r   � �/0/ b   � �121 b   � �343 o   � ��{�{ 0 
eyetv_path  4 o   � ��z�z 0 
eyetv_root  2 o   � ��y�y 0 
edl_suffix  0 o      �x�x 0 edl_file  . 565 r   � �787 n   � �9:9 1   � ��w
�w 
psxp: o   � ��v�v 0 edl_file  8 o      �u�u 0 edl_file_posix  6 ;<; r   � �=>= b   � �?@? b   � �ABA o   � ��t�t 0 
eyetv_path  B o   � ��s�s 0 
eyetv_root  @ o   � ��r�r 0 export_suffix  > o      �q�q 0 exported_inodes_file  < CDC l  � ��p�o�n�p  �o  �n  D EFE l  � ��mGH�m  G h b Elgato adds a few seconds here, but minutes are necessary to ensure success under heavy CPU loads   H �II �   E l g a t o   a d d s   a   f e w   s e c o n d s   h e r e ,   b u t   m i n u t e s   a r e   n e c e s s a r y   t o   e n s u r e   s u c c e s s   u n d e r   h e a v y   C P U   l o a d sF JKJ l  � �LMNL I  � ��lO�k
�l .sysodelanull��� ��� nmbrO ]   � �PQP m   � ��j�j Q m   � ��i�i <�k  M N Hif the script does not seem to work, try increasing this delay slightly.   N �RR � i f   t h e   s c r i p t   d o e s   n o t   s e e m   t o   w o r k ,   t r y   i n c r e a s i n g   t h i s   d e l a y   s l i g h t l y .K STS l  � ��h�g�f�h  �g  �f  T UVU O   �
WXW r   �	YZY e   �[[ l  �\�e�d\ n   �]^] 1  �c
�c 
pLoc^ l  �_�b�a_ 6  �`a` l  � �b�`�_b n   � �cdc 2  � ��^
�^ 
cTrkd 4   � ��]e
�] 
cPlye m   � �ff �gg  T V   S h o w s�`  �_  a G   �hih =  � �jkj 1   � ��\
�\ 
pnamk o   � ��[�[ 0 myshortname  i =  � lml 1   � ��Z
�Z 
pArtm o   � ��Y�Y 0 myshortname  �b  �a  �e  �d  Z o      �X�X 0 mytv  X m   � �nn�                                                                                  hook  alis    D  	Server HD                  �k�H+  �.
iTunes.app                                                      b+�3�        ����  	                Applications    ��*      �k�    �.  "Server HD:Applications: iTunes.app   
 i T u n e s . a p p   	 S e r v e r   H D  Applications/iTunes.app   / ��  V opo l �W�V�U�W  �V  �U  p qrq l �Tst�T  s K E find all .m4v files in ~/Movies that match the name or artist fields   t �uu �   f i n d   a l l   . m 4 v   f i l e s   i n   ~ / M o v i e s   t h a t   m a t c h   t h e   n a m e   o r   a r t i s t   f i e l d sr vwv l �S�R�Q�S  �R  �Q  w xyx l �Pz{�P  z !  find all files in ~/Movies   { �|| 6   f i n d   a l l   f i l e s   i n   ~ / M o v i e sy }~} O &� r  %��� n  !��� 2  !�O
�O 
cobj� l ��N�M� l ��L�K� n  ��� 4  �J�
�J 
cfol� m  �� ���  M o v i e s� 1  �I
�I 
home�L  �K  �N  �M  � o      �H�H 0 movie_dir_list  � m  ���                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��  ~ ��� l ''�G�F�E�G  �F  �E  � ��� l ''�D���D  � &   find all .m4v files in ~/Movies   � ��� @   f i n d   a l l   . m 4 v   f i l e s   i n   ~ / M o v i e s� ��� r  '-��� J  ')�C�C  � o      �B�B 0 
movie_list  � ��� X  .l��A�� Z Dg���@�?� =  DT��� n DP��� I  EP�>��=�> 0 extensionname ExtensionName� ��<� c  EL��� o  EH�;�; 	0 movie  � m  HK�:
�: 
alis�<  �=  �  f  DE� m  PS�� ���  m 4 v� r  Wc��� l W^��9�8� c  W^��� o  WZ�7�7 	0 movie  � m  Z]�6
�6 
alis�9  �8  � n      ���  ;  ab� o  ^a�5�5 0 
movie_list  �@  �?  �A 	0 movie  � o  14�4�4 0 movie_dir_list  � ��� l mm�3�2�1�3  �2  �1  � ��� l mm�0���0  � 1 + find all movies whose name or artist match   � ��� V   f i n d   a l l   m o v i e s   w h o s e   n a m e   o r   a r t i s t   m a t c h� ��� r  mt��� o  mp�/�/ 0 
movie_list  � o      �.�. 0 movie_dir_list  � ��� r  u{��� J  uw�-�-  � o      �,�, 0 
movie_list  � ��� X  |���+�� Z �����*�)� G  ����� =  ����� n ����� I  ���(��'�( 0 	m4v_field  � ��� n  ����� 1  ���&
�& 
psxp� l ����%�$� c  ����� o  ���#�# 	0 movie  � m  ���"
�" 
alis�%  �$  � ��!� m  ���� ���  N a m e�!  �'  �  f  ��� o  ��� �  0 myshortname  � =  ����� n ����� I  ������ 0 	m4v_field  � ��� n  ����� 1  ���
� 
psxp� l ������ c  ����� o  ���� 	0 movie  � m  ���
� 
alis�  �  � ��� m  ���� ���  A r t i s t�  �  �  f  ��� o  ���� 0 myshortname  � l 	������ r  ����� l ������ c  ����� o  ���� 	0 movie  � m  ���
� 
alis�  �  � n      ���  ;  ��� o  ���� 0 
movie_list  �  �  �*  �)  �+ 	0 movie  � o  ��� 0 movie_dir_list  � ��� l ������  �  �  � ��� l ������  � 1 + merge the results from iTunes and ~/Movies   � ��� V   m e r g e   t h e   r e s u l t s   f r o m   i T u n e s   a n d   ~ / M o v i e s� ��� r  ����� b  ����� o  ���
�
 0 mytv  � o  ���	�	 0 
movie_list  � o      �� 0 mytv  � ��� l ������  �  �  � ��� l ������  � 9 3 return if no exports match; this shouldn't happen!   � ��� f   r e t u r n   i f   n o   e x p o r t s   m a t c h ;   t h i s   s h o u l d n ' t   h a p p e n !�    Z  ���� A �� l ����  l ������ I ������
�� .corecnte****       **** o  ������ 0 mytv  ��  ��  ��  �  �    m  ������  L  ������  �  �   	
	 l ����������  ��  ��  
  l ������   : 4 find the most recent export that isn't an open file    � h   f i n d   t h e   m o s t   r e c e n t   e x p o r t   t h a t   i s n ' t   a n   o p e n   f i l e  r  �� l ������ n  �� 4  ����
�� 
cobj m  ������  o  ������ 0 mytv  ��  ��   o      ���� 	0 mymp4    r    n    1  ��
�� 
psxp o   ���� 	0 mymp4   o      ���� 0 mymp4_posix    O  !  r  "#" l $����$ n  %&% 1  ��
�� 
ascd& o  ���� 	0 mymp4  ��  ��  # o      ���� 
0 mydate  ! m  ''�                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��   ()( Y  �*��+,��* k  -�-- ./. r  -9010 l -52����2 n  -5343 4  .5��5
�� 
cobj5 o  14���� 0 kk  4 o  -.���� 0 mytv  ��  ��  1 o      ���� 0 mymp4_kk  / 676 r  :E898 n  :A:;: 1  =A��
�� 
psxp; o  :=���� 0 mymp4_kk  9 o      ���� 0 mymp4_posix_kk  7 <=< O FX>?> r  LW@A@ l LSB����B n  LSCDC 1  OS��
�� 
ascdD o  LO���� 0 mymp4_kk  ��  ��  A o      ���� 0 	mydate_kk  ? m  FIEE�                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��  = F��F Z  Y�GH����G F  YpIJI A Y`KLK o  Y\���� 
0 mydate  L o  \_���� 0 	mydate_kk  J H  clMM n ckNON I  dk��P���� 0 
isfileopen 
IsFileOpenP Q��Q o  dg���� 0 mymp4_posix_kk  ��  ��  O  f  cdH k  s�RR STS r  szUVU o  sv���� 0 mymp4_kk  V o      ���� 	0 mymp4  T WXW r  {�YZY o  {~���� 0 mymp4_posix_kk  Z o      ���� 0 mymp4_posix  X [��[ r  ��\]\ o  ������ 0 	mydate_kk  ] o      ���� 
0 mydate  ��  ��  ��  ��  �� 0 kk  + m  "#���� , l #(^����^ I #(��_��
�� .corecnte****       ****_ o  #$���� 0 mytv  ��  ��  ��  ��  ) `a` l ����������  ��  ��  a bcb l ����de��  d   Setting itunes_root ...   e �ff 0   S e t t i n g   i t u n e s _ r o o t   . . .c ghg l ����ij��  i M G safely quote any single quote characters for system calls: ' --> '"'"'   j �kk �   s a f e l y   q u o t e   a n y   s i n g l e   q u o t e   c h a r a c t e r s   f o r   s y s t e m   c a l l s :   '   - - >   ' " ' " 'h lml r  ��non n ��pqp I  ����r���� 0 replace_chars  r sts o  ������ 0 mymp4_posix  t uvu m  ��ww �xx  'v y��y m  ��zz �{{ 
 ' " ' " '��  ��  q  f  ��o o      ���� 0 mymp4_posix_safequotes  m |}| O ��~~ r  ����� c  ����� n  ����� m  ����
�� 
ctnr� o  ������ 	0 mymp4  � m  ����
�� 
utxt� o      ���� 0 itunes_path   m  �����                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��  } ��� l ��������  � ? 9 fix AppleScript's strange trailing colon issue for paths   � ��� r   f i x   A p p l e S c r i p t ' s   s t r a n g e   t r a i l i n g   c o l o n   i s s u e   f o r   p a t h s� ��� Z ��������� > ����� n  ����� 4  �����
�� 
cha � m  ��������� o  ������ 0 itunes_path  � m  ���� ���  :� r  ����� b  ����� o  ������ 0 itunes_path  � m  ���� ���  :� o      ���� 0 itunes_path  ��  ��  � ��� O ����� r  ����� n  ����� 1  ����
�� 
pnam� o  ������ 	0 mymp4  � o      ���� 0 itunes_file  � m  �����                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��  � ��� r  ����� l �������� n  ����� I  ��������� 0 rootname RootName� ���� o  ������ 0 itunes_file  ��  ��  �  f  ����  ��  � o      ���� 0 itunes_root  � ��� l ����������  ��  ��  � ��� l ��������  � T N save the iTunes file inode to the exported files file "*.exported_inodes.txt"   � ��� �   s a v e   t h e   i T u n e s   f i l e   i n o d e   t o   t h e   e x p o r t e d   f i l e s   f i l e   " * . e x p o r t e d _ i n o d e s . t x t "� ��� l ��������  � K E find the exported file with the command: find . -type f -inum <inum>   � ��� �   f i n d   t h e   e x p o r t e d   f i l e   w i t h   t h e   c o m m a n d :   f i n d   .   - t y p e   f   - i n u m   < i n u m >� ��� n ���� I  �������� 0 write_to_file  � ��� b  �
��� l ������� c  ���� n ���� I  �������� 0 	fileinode 	FileInode� ���� o  � ���� 0 mymp4_posix  ��  ��  �  f  ��� m  ��
�� 
TEXT��  ��  � o  	��
�� 
ret � ��� o  
���� 0 exported_inodes_file  � ���� m  ��
�� boovtrue��  ��  �  f  ��� ��� l ��������  ��  ��  � ��� l ������  �   return if no .edl file   � ��� .   r e t u r n   i f   n o   . e d l   f i l e� ��� O  ,��� Z +������� H  "�� l !������ I !�����
�� .coredoexbool        obj � 4  ���
�� 
file� o  ���� 0 edl_file  ��  ��  ��  � L  %'����  ��  ��  � m  ���                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��  � ��� l --�������  ��  �  � ��� l --�~���~  � 3 - add the mp4 chapters if the .edl file exists   � ��� Z   a d d   t h e   m p 4   c h a p t e r s   i f   t h e   . e d l   f i l e   e x i s t s� ��� l --�}�|�{�}  �|  �{  � ��� l --�z���z  � ' ! define the mp4chaps chapter file   � ��� B   d e f i n e   t h e   m p 4 c h a p s   c h a p t e r   f i l e� ��� r  ->��� b  -:��� b  -8��� l -4��y�x� n  -4��� 1  04�w
�w 
psxp� o  -0�v�v 0 itunes_path  �y  �x  � o  47�u�u 0 itunes_root  � o  89�t�t 0 mp4chaps_suffix  � o      �s�s 0 itunes_chapter_file  � ��� l ??�r�q�p�r  �q  �p  � ��� l ??�o���o  � F @ translate the .edl file into a mp4chaps chapter file using perl   � ��� �   t r a n s l a t e   t h e   . e d l   f i l e   i n t o   a   m p 4 c h a p s   c h a p t e r   f i l e   u s i n g   p e r l�    r  ?T b  ?P b  ?L b  ?H	 b  ?D

 m  ?B �: 
 # ! / u s r / b i n / p e r l 
 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 #   C O N V E R T   E D L   F I L E S   T O   M P 4 C H A P S   F I L E S     # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 
 #   C o p y r i g h t   �   2 0 1 2  2 0 1 3   S t e v e n   T .   S m i t h   < s t e v e   d o t   t   d o t   s m i t h   a t   g m a i l   d o t   c o m > ,   G P L   #         T h i s   p r o g r a m   i s   f r e e   s o f t w a r e :   y o u   c a n   r e d i s t r i b u t e   i t   a n d / o r   m o d i f y  #         i t   u n d e r   t h e   t e r m s   o f   t h e   G N U   G e n e r a l   P u b l i c   L i c e n s e   a s   p u b l i s h e d   b y  #         t h e   F r e e   S o f t w a r e   F o u n d a t i o n ,   e i t h e r   v e r s i o n   3   o f   t h e   L i c e n s e ,   o r  #         ( a t   y o u r   o p t i o n )   a n y   l a t e r   v e r s i o n .  #  #         T h i s   p r o g r a m   i s   d i s t r i b u t e d   i n   t h e   h o p e   t h a t   i t   w i l l   b e   u s e f u l ,  #         b u t   W I T H O U T   A N Y   W A R R A N T Y ;   w i t h o u t   e v e n   t h e   i m p l i e d   w a r r a n t y   o f  #         M E R C H A N T A B I L I T Y   o r   F I T N E S S   F O R   A   P A R T I C U L A R   P U R P O S E .     S e e   t h e  #         G N U   G e n e r a l   P u b l i c   L i c e n s e   f o r   m o r e   d e t a i l s .  #  #         Y o u   s h o u l d   h a v e   r e c e i v e d   a   c o p y   o f   t h e   G N U   G e n e r a l   P u b l i c   L i c e n s e  #         a l o n g   w i t h   t h i s   p r o g r a m .     I f   n o t ,   s e e   < h t t p : / / w w w . g n u . o r g / l i c e n s e s / > .  
 
 u s e   s t r i c t ; 
 
 m y   $ e d l _ f i l e   =   q { o  BC�n�n 0 edl_file_posix  	 m  DG � ( } ; 
 m y   $ t x t _ f i l e   =   q { o  HK�m�m 0 itunes_chapter_file   m  LO �� } ; 
 
 s u b   s e c 2 h h m m s s   { 
 m y   $ r e m   =   $ _ [ 0 ] / 3 6 0 0 ; 
 m y   $ h h   =   i n t ( $ r e m ) ; 
 $ r e m   =   ( $ r e m   -   $ h h ) * 6 0 ; 
 m y   $ m m   =   i n t ( $ r e m ) ; 
 $ r e m   =   ( $ r e m   -   $ m m ) * 6 0 ; 
         m y   $ s s   =   i n t ( $ r e m ) ; 
         $ r e m   =   ( $ r e m   -   $ s s ) ; 
         $ r e m   =   s p r i n t f ( " % . 3 f " , $ r e m ) ;     #   m i l l i s e c o n d   p r e c i s i o n 
         $ r e m   = ~   s / ^ 0 / / ; 
         r e t u r n   s p r i n t f ( " % 0 2 d : % 0 2 d : % 0 2 d % s " , $ h h , $ m m , $ s s , $ r e m ) ; 
 } 
 
 o p e n   ( E D L , $ e d l _ f i l e )   | |   d i e ( " C a n n o t   o p e n   e d l   f i l e   "   .   $ e d l _ f i l e ) ; 
 o p e n   ( T X T , " > " , $ t x t _ f i l e )   | |   d i e ( " C a n n o t   o p e n   t x t   f i l e   "   .   $ t x t _ f i l e ) ; 
 m y   $ l i n e ; 
 m y   @ t i m e s ; 
 m y   $ c o m s k i p n o   =   0 ; 
 m y   $ c o m s k i p c h a p n o   =   0 ; 
 p r i n t   T X T   " 0 0 : 0 0 : 0 0 . 0 0 0   B e g i n n i n g \ n " ; 
 w h i l e   ( $ l i n e   =   < E D L > )   { 
         c h o m p   $ l i n e ; 
         #   p a r s e   t h e   s p a c e - d e l i m i t e d   e d l   a s c i i   t i m e s   i n t o   a n   a r r a y   o f   n u m b e r s 
         @ t i m e s   =   s p l i t   '   ' ,   $ l i n e ; 
         @ t i m e s   =   m a p   { $ _ + 0 }   @ t i m e s ;   #   ( u n n e c e s s a r i l y )   c o n v e r t   s t r i n g s   t o   n u m b e r s 
         $ c o m s k i p n o   + =   1   i f   ( $ c o m s k i p n o   = =   0   & &   $ t i m e s [ 0 ]   ! =   0 . 0 ) ; 
         i f   ( $ # t i m e s   <   2   | |   $ t i m e s [ 2 ]   = =   0 . 0 )   { 
                 i f   ( $ t i m e s [ 0 ]   ! =   0 . 0 )   { 
                         p r i n t   T X T   s p r i n t f ( " % s   C h a p t e r   % d   E n d \ n " , s e c 2 h h m m s s ( $ t i m e s [ 0 ] ) , $ c o m s k i p n o ) ; 
                 } 
 	   $ c o m s k i p n o + + ; 
                 p r i n t   T X T   s p r i n t f ( " % s   C h a p t e r   % d   S t a r t \ n " , s e c 2 h h m m s s ( $ t i m e s [ 1 ] ) , $ c o m s k i p n o ) ; 
         }   e l s e   { 
                 #   n e v e r   s e e n   t h i s   c a s e ,   b u t   h e r e   f o r   l o g i c a l   c o n s i s t e n c y 
                 $ c o m s k i p c h a p n o + + ; 
                 i f   ( $ t i m e s [ 0 ]   ! =   0 . 0 )   { 
                         p r i n t   T X T   s p r i n t f ( " % s   C h a p t e r   % d   S t a r t \ n " , s e c 2 h h m m s s ( $ t i m e s [ 0 ] ) , $ c o m s k i p c h a p n o ) ; 
                 } 
                 p r i n t   T X T   s p r i n t f ( " % s   C h a p t e r   % d   E n d \ n " , s e c 2 h h m m s s ( $ t i m e s [ 1 ] ) , $ c o m s k i p c h a p n o ) ; 
         } 
 } 
 c l o s e   ( E D L )   ; 
 c l o s e   ( T X T )   ; 
 o      �l�l 0 perlcode perlCode  l UU�k�j�i�k  �j  �i    l UU�h�h   7 1 define the perl  script and run it and delete it    � b   d e f i n e   t h e   p e r l     s c r i p t   a n d   r u n   i t   a n d   d e l e t e   i t  r  U^ b  UZ b  UX  o  UV�g�g 0 
eyetv_path    o  VW�f�f 0 
eyetv_root   o  XY�e�e 0 perl_suffix   o      �d�d 0 	perl_file   !"! l __�c#$�c  # M G safely quote any single quote characters for system calls: ' --> '"'"'   $ �%% �   s a f e l y   q u o t e   a n y   s i n g l e   q u o t e   c h a r a c t e r s   f o r   s y s t e m   c a l l s :   '   - - >   ' " ' " '" &'& r  _u()( n _q*+* I  `q�b,�a�b 0 replace_chars  , -.- n  `g/0/ 1  cg�`
�` 
psxp0 o  `c�_�_ 0 	perl_file  . 121 m  gj33 �44  '2 5�^5 m  jm66 �77 
 ' " ' " '�^  �a  +  f  _`) o      �]�] 0 perl_file_safequotes  ' 898 l vv�\�[�Z�\  �[  �Z  9 :;: n v�<=< I  w��Y>�X�Y 0 write_to_file  > ?@? b  w|ABA o  wz�W�W 0 perlcode perlCodeB o  z{�V
�V 
ret @ CDC c  |�EFE o  |�U�U 0 	perl_file  F m  ��T
�T 
utxtD G�SG m  ���R
�R boovfals�S  �X  =  f  vw; HIH r  ��JKJ I ���QL�P
�Q .sysoexecTEXT���     TEXTL b  ��MNM b  ��OPO m  ��QQ �RR  p e r l   'P o  ���O�O 0 perl_file_safequotes  N m  ��SS �TT  '   | |   t r u e�P  K o      �N�N 0 perlres perlResI UVU O ��WXW I ���MY�L
�M .coredeloobj        obj Y 4  ���KZ
�K 
fileZ o  ���J�J 0 	perl_file  �L  X m  ��[[�                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��  V \]\ l ���I�H�G�I  �H  �G  ] ^_^ l ���F`a�F  ` 3 - execute mp4chaps and delete the chapter file   a �bb Z   e x e c u t e   m p 4 c h a p s   a n d   d e l e t e   t h e   c h a p t e r   f i l e_ cdc l ���Eef�E  e #  remove any existing chapters   f �gg :   r e m o v e   a n y   e x i s t i n g   c h a p t e r sd hih r  ��jkj I ���Dl�C
�D .sysoexecTEXT���     TEXTl b  ��mnm b  ��opo b  ��qrq o  ���B�B 0 mp4chaps  r m  ��ss �tt 
   - r   'p o  ���A�A 0 mymp4_posix_safequotes  n m  ��uu �vv 4 '   >   / d e v / n u l l   2 > & 1   | |   t r u e�C  k o      �@�@ 0 mp4chapsres mp4chapsResi wxw l ���?yz�?  y "  import the comskip chapters   z �{{ 8   i m p o r t   t h e   c o m s k i p   c h a p t e r sx |}| r  ��~~ I ���>��=
�> .sysoexecTEXT���     TEXT� b  ����� b  ����� b  ����� o  ���<�< 0 mp4chaps  � m  ���� ��� 
   - i   '� o  ���;�; 0 mymp4_posix_safequotes  � m  ���� ��� 4 '   >   / d e v / n u l l   2 > & 1   | |   t r u e�=   o      �:�: 0 mp4chapsres mp4chapsRes} ��� l ���9���9  �   delete the chapter file   � ��� 0   d e l e t e   t h e   c h a p t e r   f i l e� ��8� O ����� I ���7��6
�7 .coredeloobj        obj � 4  ���5�
�5 
file� l ����4�3� b  ����� b  ����� o  ���2�2 0 itunes_path  � o  ���1�1 0 itunes_root  � o  ���0�0 0 mp4chaps_suffix  �4  �3  �6  � m  �����                                                                                  MACS  alis    l  	Server HD                  �k�H+  �
Finder.app                                                     �&�`�        ����  	                CoreServices    ��*      �`D    ��	�  3Server HD:System: Library: CoreServices: Finder.app    
 F i n d e r . a p p   	 S e r v e r   H D  &System/Library/CoreServices/Finder.app  / ��  �8   X ��� l     �/�.�-�/  �.  �-  � ��� l     �,���,  � &   extract the root name of a file   � ��� @   e x t r a c t   t h e   r o o t   n a m e   o f   a   f i l e� ��� i    ��� I      �+��*�+ 0 rootname RootName� ��)� o      �(�( 	0 fname  �)  �*  � k     4�� ��� l     �'���'  � d ^ http://stackoverflow.com/questions/12907517/extracting-file-extensions-from-applescript-paths   � ��� �   h t t p : / / s t a c k o v e r f l o w . c o m / q u e s t i o n s / 1 2 9 0 7 5 1 7 / e x t r a c t i n g - f i l e - e x t e n s i o n s - f r o m - a p p l e s c r i p t - p a t h s� ��� r     ��� c     ��� o     �&�& 	0 fname  � m    �%
�% 
utxt� o      �$�$ 0 root  � ��� r    ��� n   	��� 1    	�#
�# 
txdl� 1    �"
�" 
ascr� o      �!�! 
0 delims  � ��� r    ��� m    �� ���  .� n     ��� 1    � 
�  
txdl� 1    �
� 
ascr� ��� Z   +����� E    ��� o    �� 0 root  � m    �� ���  .� r    '��� c    %��� l   #���� n    #��� 7   #���
� 
citm� m    �� � m     "����� o    �� 0 root  �  �  � m   # $�
� 
ctxt� o      �� 0 root  �  �  � ��� r   , 1��� o   , -�� 
0 delims  � n     ��� 1   . 0�
� 
txdl� 1   - .�
� 
ascr� ��� L   2 4�� o   2 3�� 0 root  �  � ��� l     ����  � &   extract the root name of a file   � ��� @   e x t r a c t   t h e   r o o t   n a m e   o f   a   f i l e� ��� i    ��� I      ���� 0 extensionname ExtensionName� ��� o      �
�
 	0 fname  �  �  � k     -�� ��� r     ��� c     ��� o     �	�	 	0 fname  � m    �
� 
utxt� o      �� 0 extn  � ��� r    ��� n   	��� 1    	�
� 
txdl� 1    �
� 
ascr� o      �� 
0 delims  � ��� r    ��� m    �� ���  .� n     ��� 1    �
� 
txdl� 1    �
� 
ascr� ��� Z   $���� � E    � � o    ���� 0 extn    m     �  .� r      c     l   ���� n    	 4   ��

�� 
citm
 m    ������	 o    ���� 0 extn  ��  ��   m    ��
�� 
ctxt o      ���� 0 extn  �  �   �  r   % * o   % &���� 
0 delims   n      1   ' )��
�� 
txdl 1   & '��
�� 
ascr �� L   + - o   + ,���� 0 extn  ��  �  l     ��������  ��  ��    l     ����   &   return a field from an m4v file    � @   r e t u r n   a   f i e l d   f r o m   a n   m 4 v   f i l e  i     I      ������ 0 	m4v_field     o      ���� 0 posix_filename    !��! o      ���� 0 
field_name  ��  ��   k     #"" #$# r     %&% m     '' �(( , / o p t / l o c a l / b i n / m p 4 i n f o& o      ���� 0 mp4info  $ )*) l   ��+,��  + M G safely quote any single quote characters for system calls: ' --> '"'"'   , �-- �   s a f e l y   q u o t e   a n y   s i n g l e   q u o t e   c h a r a c t e r s   f o r   s y s t e m   c a l l s :   '   - - >   ' " ' " '* ./. r    010 n   232 I    ��4���� 0 replace_chars  4 565 o    ���� 0 posix_filename  6 787 m    99 �::  '8 ;��; m    << �== 
 ' " ' " '��  ��  3  f    1 o      ���� 0 posix_filename_safequotes  / >?> r     @A@ I   ��B��
�� .sysoexecTEXT���     TEXTB l   C����C b    DED b    FGF b    HIH b    JKJ b    LML o    ���� 0 mp4info  M m    NN �OO    'K o    ���� 0 posix_filename_safequotes  I m    PP �QQ z '   |   p e r l   - n e   ' c h o m p ;   $ f = $ _ ;   $ v = $ _ ;   $ f = ~ s /   * ( . + ) : . * / $ 1 / ;   $ f = ~ /G o    ���� 0 
field_name  E m    RR �SS d /   & &   d o   { $ v = ~ s / . * :   * ( . + ) $ / $ 1 / ;   p r i n t   $ v ; } '   | |   t r u e��  ��  ��  A o      ���� 0 res  ? T��T L   ! #UU o   ! "���� 0 res  ��   VWV l     ��������  ��  ��  W XYX l     ��Z[��  Z   get the inode of a file   [ �\\ 0   g e t   t h e   i n o d e   o f   a   f i l eY ]^] i    _`_ I      ��a���� 0 	fileinode 	FileInodea b��b o      ���� 0 posix_filename  ��  ��  ` k     -cc ded l     ��fg��  f M G safely quote any single quote characters for system calls: ' --> '"'"'   g �hh �   s a f e l y   q u o t e   a n y   s i n g l e   q u o t e   c h a r a c t e r s   f o r   s y s t e m   c a l l s :   '   - - >   ' " ' " 'e iji r     
klk n    mnm I    ��o���� 0 replace_chars  o pqp o    ���� 0 posix_filename  q rsr m    tt �uu  's v��v m    ww �xx 
 ' " ' " '��  ��  n  f     l o      ���� 0 posix_filename_safequotes  j yzy r    {|{ I   ��}��
�� .sysoexecTEXT���     TEXT} l   ~����~ b    � b    ��� m    �� ���  l s   - i   '� o    ���� 0 posix_filename_safequotes  � m    �� ���  '   | |   t r u e��  ��  ��  | o      ���� 0 fi  z ���� Z    -������ >   ��� o    ���� 0 fi  � m    �� ���  � k    (�� ��� r    #��� n    !��� 4    !���
�� 
cwor� m     ���� � o    ���� 0 fi  � o      ���� 0 fi  � ���� L   $ (�� c   $ '��� o   $ %���� 0 fi  � m   % &��
�� 
nmbr��  ��  � L   + -�� m   + ,�� ���  ��  ^ ��� l     ��������  ��  ��  � ��� l     ������  �   test if a file is open   � ��� .   t e s t   i f   a   f i l e   i s   o p e n� ��� i    ��� I      ������� 0 
isfileopen 
IsFileOpen� ���� o      ���� 0 posix_filename  ��  ��  � k     )�� ��� l     ������  � M G safely quote any single quote characters for system calls: ' --> '"'"'   � ��� �   s a f e l y   q u o t e   a n y   s i n g l e   q u o t e   c h a r a c t e r s   f o r   s y s t e m   c a l l s :   '   - - >   ' " ' " '� ��� r     
��� n    ��� I    ������� 0 replace_chars  � ��� o    ���� 0 posix_filename  � ��� m    �� ���  '� ���� m    �� ��� 
 ' " ' " '��  ��  �  f     � o      ���� 0 posix_filename_safequotes  � ��� r    ��� I   �����
�� .sysoexecTEXT���     TEXT� l   ������ b    ��� b    ��� m    �� ���  l s o f   '� o    ���� 0 posix_filename_safequotes  � m    �� ��� � '   |   t a i l   - n   + 2   |   p e r l   - a n e   ' B E G I N   { $ r v = q / f a l s e / ; } ;   $ _ = @ F [ 0 ] ;   ! / ^ m d w o r k e r $ /   & &   d o   { $ r v = q / t r u e / ; } ;   E N D   { p r i n t   $ r v ; } '   | |   t r u e��  ��  ��  � o      ���� 0 res  � ��� l   ������  � B < original test; ignores benign Spotlight (mdworker) indexing   � ��� x   o r i g i n a l   t e s t ;   i g n o r e s   b e n i g n   S p o t l i g h t   ( m d w o r k e r )   i n d e x i n g� ��� l   ������  � � � set res to do shell script ("lsof '" & posix_filename_safequotes & "' > /dev/null 2>&1 && echo 'true' || echo 'false' || true")   � ���    s e t   r e s   t o   d o   s h e l l   s c r i p t   ( " l s o f   ' "   &   p o s i x _ f i l e n a m e _ s a f e q u o t e s   &   " '   >   / d e v / n u l l   2 > & 1   & &   e c h o   ' t r u e '   | |   e c h o   ' f a l s e '   | |   t r u e " )� ��� Z    &������ =   ��� o    ���� 0 res  � m    �� ���  t r u e� r     ��� m    ��
�� boovtrue� o      ���� 0 res  ��  � r   # &��� m   # $��
�� boovfals� o      ���� 0 res  � ���� L   ' )�� o   ' (���� 0 res  ��  � ��� l     ��������  ��  ��  � ��� l     ������  �   string replacement   � ��� &   s t r i n g   r e p l a c e m e n t� ��� i    ��� I      ������� 0 replace_chars  � ��� o      ���� 0 	this_text  � ��� o      ���� 0 search_string  � ���� o      ���� 0 replacement_string  ��  ��  � k     &�� ��� r     ��� n    ��� 1    ��
�� 
txdl� 1     ��
�� 
ascr� o      ���� 
0 delims  �    r     l   ���� o    ���� 0 search_string  ��  ��   n      1    
��
�� 
txdl 1    ��
�� 
ascr  r    	
	 n     2    ��
�� 
citm o    ���� 0 	this_text  
 l     ���� o      ���� 0 	item_list  ��  ��    r     l   ���� o    ���� 0 replacement_string  ��  ��   n      1    ��
�� 
txdl 1    ��
�� 
ascr  r     c     l   ��� o    �~�~ 0 	item_list  ��  �   m    �}
�} 
TEXT o      �|�| 0 	this_text    r    # o    �{�{ 
0 delims   n      !  1     "�z
�z 
txdl! 1     �y
�y 
ascr "�x" L   $ &## o   $ %�w�w 0 	this_text  �x  � $%$ l     �v�u�t�v  �u  �t  % &'& i    ()( I      �s*�r�s 0 write_to_file  * +,+ o      �q�q 0 	this_data  , -.- o      �p�p 0 target_file  . /�o/ o      �n�n 0 append_data  �o  �r  ) k     Y00 121 l     �m34�m  3 = 7from http://www.apple.com/applescript/sbrt/sbrt-09.html   4 �55 n f r o m   h t t p : / / w w w . a p p l e . c o m / a p p l e s c r i p t / s b r t / s b r t - 0 9 . h t m l2 6�l6 Q     Y7897 k    ::: ;<; r    =>= c    ?@? l   A�k�jA o    �i�i 0 target_file  �k  �j  @ m    �h
�h 
utxt> l     B�g�fB o      �e�e 0 target_file  �g  �f  < CDC r   	 EFE I  	 �dGH
�d .rdwropenshor       fileG 4   	 �cI
�c 
fileI o    �b�b 0 target_file  H �aJ�`
�a 
permJ m    �_
�_ boovtrue�`  F l     K�^�]K o      �\�\ 0 open_target_file  �^  �]  D LML Z   'NO�[�ZN =   PQP o    �Y�Y 0 append_data  Q m    �X
�X boovfalsO I   #�WRS
�W .rdwrseofnull���     ****R l   T�V�UT o    �T�T 0 open_target_file  �V  �U  S �SU�R
�S 
set2U m    �Q�Q  �R  �[  �Z  M VWV I  ( 1�PXY
�P .rdwrwritnull���     ****X o   ( )�O�O 0 	this_data  Y �NZ[
�N 
refnZ l  * +\�M�L\ o   * +�K�K 0 open_target_file  �M  �L  [ �J]�I
�J 
wrat] m   , -�H
�H rdwreof �I  W ^_^ I  2 7�G`�F
�G .rdwrclosnull���     ****` l  2 3a�E�Da o   2 3�C�C 0 open_target_file  �E  �D  �F  _ b�Bb L   8 :cc m   8 9�A
�A boovtrue�B  8 R      �@�?�>
�@ .ascrerr ****      � ****�?  �>  9 k   B Ydd efe Q   B Vgh�=g I  E M�<i�;
�< .rdwrclosnull���     ****i 4   E I�:j
�: 
filej o   G H�9�9 0 target_file  �;  h R      �8�7�6
�8 .ascrerr ****      � ****�7  �6  �=  f k�5k L   W Yll m   W X�4
�4 boovfals�5  �l  ' mnm l     �3�2�1�3  �2  �1  n opo l     �0qr�0  q  y testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script   r �ss �   t e s t i n g   c o d e :   t h i s   w i l l   n o t   b e   c a l l e d   w h e n   t r i g g e r e d   f r o m   E y e T V ,   b u t   o n l y   w h e n   t h e   s c r i p t   i s   r u n   a s   a   s t a n d - a l o n e   s c r i p tp tut i     #vwv I     �/�.�-
�/ .aevtoappnull  �   � ****�.  �-  w O     xyx k    zz {|{ l   �,}~�,  } 2 ,set rec to unique ID of item 1 of recordings   ~ � X s e t   r e c   t o   u n i q u e   I D   o f   i t e m   1   o f   r e c o r d i n g s| ��� l   �+���+  � y s for all your id's, run /Library/Application\ Support/ETVComskip/MarkCommercials.app/Contents/MacOS/MarkCommercials   � ��� �   f o r   a l l   y o u r   i d ' s ,   r u n   / L i b r a r y / A p p l i c a t i o n \   S u p p o r t / E T V C o m s k i p / M a r k C o m m e r c i a l s . a p p / C o n t e n t s / M a c O S / M a r k C o m m e r c i a l s� ��� r    ��� m    �*�* �M�� o      �)�) 0 rec  � ��(� n   ��� I   	 �'��&�' 0 
exportdone 
ExportDone� ��%� o   	 
�$�$ 0 rec  �%  �&  �  f    	�(  y m     ���                                                                                  EyTV  alis    @  	Server HD                  �k�H+  �.	EyeTV.app                                                      o�F͔z�        ����  	                Applications    ��*      ͔��    �.  !Server HD:Applications: EyeTV.app    	 E y e T V . a p p   	 S e r v e r   H D  Applications/EyeTV.app  / ��  u ��#� l     �"�!� �"  �!  �   �#       ������������  � 	���������� 0 
exportdone 
ExportDone� 0 rootname RootName� 0 extensionname ExtensionName� 0 	m4v_field  � 0 	fileinode 	FileInode� 0 
isfileopen 
IsFileOpen� 0 replace_chars  � 0 write_to_file  
� .aevtoappnull  �   � ****� � Z������ 0 
exportdone 
ExportDone� ��� �  �� 0 recordingid recordingID�  � $������
�	��������� ����������������������������������������� 0 recordingid recordingID� 0 myid  � 0 mp4chaps  � 0 mp4chaps_suffix  � 0 export_suffix  �
 0 
edl_suffix  �	 0 perl_suffix  � 0 myshortname  � 0 eyetvr_file  � 0 
eyetv_path  � 0 
eyetv_file  � 0 
eyetv_root  � 0 edl_file  � 0 edl_file_posix  � 0 exported_inodes_file  �  0 mytv  �� 0 movie_dir_list  �� 0 
movie_list  �� 	0 movie  �� 	0 mymp4  �� 0 mymp4_posix  �� 
0 mydate  �� 0 kk  �� 0 mymp4_kk  �� 0 mymp4_posix_kk  �� 0 	mydate_kk  �� 0 mymp4_posix_safequotes  �� 0 itunes_path  �� 0 itunes_file  �� 0 itunes_root  �� 0 itunes_chapter_file  �� 0 perlcode perlCode�� 0 	perl_file  �� 0 perl_file_safequotes  �� 0 perlres perlRes�� 0 mp4chapsres mp4chapsRes� O�� j p v | ����� ��� � ��� ������� ��� ���������������������������n��f�������������������������������wz������������36QS����su��
�� 
long
�� .misccurdldt    ��� null
�� 
shdt
�� 
tstr
�� 
ret 
�� 
rtyp
�� 
utxt
�� .earsffdralis        afdr�� 0 write_to_file  
�� 
cRec
�� kfrmID  
�� 
Titl
�� 
pURL
�� 
alis
�� 
ctnr
�� 
cha 
�� 
pnam�� 0 rootname RootName
�� 
psxp�� �� <
�� .sysodelanull��� ��� nmbr
�� 
cPly
�� 
cTrk�  
�� 
pArt
�� 
pLoc
�� 
home
�� 
cfol
�� 
cobj
�� 
kocl
�� .corecnte****       ****�� 0 extensionname ExtensionName�� 0 	m4v_field  
�� 
bool
�� 
ascd�� 0 
isfileopen 
IsFileOpen�� 0 replace_chars  �� 0 	fileinode 	FileInode
�� 
TEXT
�� 
file
�� .coredoexbool        obj 
�� .sysoexecTEXT���     TEXT
�� .coredeloobj        obj ����&E�O�E�O�E�O�E�O�E�O�E�O)*j �,�%*j �,%�%�%�%�%���l a %em+ Oa  &*a �a 0a ,EE�O*a �a 0a ,a &E�UOa  �a ,�&E�UO�a i/a  �a %E�Y hOa  	�a ,E�UO)�k+ E�O��%�%E�O�a  ,E�O��%�%E�Oa !a " j #Oa $ .*a %a &/a '-a ([[a ,\Z�8\[a ),\Z�8B1a *,EE�UOa  *a +,a ,a -/a .-E^ UOjvE^ O =] [a /a .l 0kh )] a &k+ 1a 2  ] a &] 6FY h[OY��O] E^ OjvE^ O ^] [a /a .l 0kh )] a &a  ,a 3l+ 4� 
 )] a &a  ,a 5l+ 4� a 6& ] a &] 6FY h[OY��O�] %E�O�j 0k hY hO�a .k/E^ O] a  ,E^ Oa  ] a 7,E^ UO sl�j 0kh �a .] /E^ O] a  ,E^ Oa  ] a 7,E^ UO] ] 	 )] k+ 8a 6& ] E^ O] E^ O] E^ Y h[OY��O)] a 9a :m+ ;E^ Oa  ] a ,�&E^ UO] a i/a < ] a =%E^ Y hOa  ] a ,E^ UO)] k+ E^ O))] k+ >a ?&�%�em+ Oa  *a @�/j A hY hUO] a  ,] %�%E^ Oa B�%a C%] %a D%E^ O��%�%E^  O)]  a  ,a Ea Fm+ ;E^ !O)] �%]  �&fm+ Oa G] !%a H%j IE^ "Oa  *a @]  /j JUO�a K%] %a L%j IE^ #O�a M%] %a N%j IE^ #Oa  *a @] ] %�%/j JU� ������������� 0 rootname RootName�� ����� �  ���� 	0 fname  ��  � �������� 	0 fname  �� 0 root  �� 
0 delims  � ��������������
�� 
utxt
�� 
ascr
�� 
txdl
�� 
citm����
�� 
ctxt�� 5��&E�O��,E�O���,FO�� �[�\[Zk\Z�2�&E�Y hO���,FO�� ������������� 0 extensionname ExtensionName�� ����� �  ���� 	0 fname  ��  � �������� 	0 fname  �� 0 extn  �� 
0 delims  � �����������
�� 
utxt
�� 
ascr
�� 
txdl
�� 
citm
�� 
ctxt�� .��&E�O��,E�O���,FO�� ��i/�&E�Y hO���,FO�� ������������ 0 	m4v_field  �� ����� �  ������ 0 posix_filename  �� 0 
field_name  ��  � ������������ 0 posix_filename  �� 0 
field_name  �� 0 mp4info  �� 0 posix_filename_safequotes  �� 0 res  � '9<��NPR���� 0 replace_chars  
�� .sysoexecTEXT���     TEXT�� $�E�O)���m+ E�O��%�%�%�%�%j E�O�� ��`���������� 0 	fileinode 	FileInode�� ����� �  ���� 0 posix_filename  ��  � �������� 0 posix_filename  �� 0 posix_filename_safequotes  �� 0 fi  � 
tw�������������� 0 replace_chars  
�� .sysoexecTEXT���     TEXT
�� 
cwor
�� 
nmbr�� .)���m+ E�O�%�%j E�O�� ��k/E�O��&Y �� ������������� 0 
isfileopen 
IsFileOpen�� ����� �  ���� 0 posix_filename  ��  � �������� 0 posix_filename  �� 0 posix_filename_safequotes  �� 0 res  � ������~�� 0 replace_chars  
�~ .sysoexecTEXT���     TEXT�� *)���m+ E�O�%�%j E�O��  eE�Y fE�O�� �}��|�{���z�} 0 replace_chars  �| �y��y �  �x�w�v�x 0 	this_text  �w 0 search_string  �v 0 replacement_string  �{  � �u�t�s�r�q�u 0 	this_text  �t 0 search_string  �s 0 replacement_string  �r 
0 delims  �q 0 	item_list  � �p�o�n�m
�p 
ascr
�o 
txdl
�n 
citm
�m 
TEXT�z '��,E�O���,FO��-E�O���,FO��&E�O���,FO�� �l)�k�j���i�l 0 write_to_file  �k �h��h �  �g�f�e�g 0 	this_data  �f 0 target_file  �e 0 append_data  �j  � �d�c�b�a�d 0 	this_data  �c 0 target_file  �b 0 append_data  �a 0 open_target_file  � �`�_�^�]�\�[�Z�Y�X�W�V�U�T�S
�` 
utxt
�_ 
file
�^ 
perm
�] .rdwropenshor       file
�\ 
set2
�[ .rdwrseofnull���     ****
�Z 
refn
�Y 
wrat
�X rdwreof �W 
�V .rdwrwritnull���     ****
�U .rdwrclosnull���     ****�T  �S  �i Z <��&E�O*�/�el E�O�f  ��jl Y hO����� 
O�j OeW X   *�/j W X  hOf� �Rw�Q�P���O
�R .aevtoappnull  �   � ****�Q  �P  �  � ��N�M�L�N �M��M 0 rec  �L 0 
exportdone 
ExportDone�O � �E�O)�k+ Uascr  ��ޭ