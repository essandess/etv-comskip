FasdUAS 1.101.10   ��   ��    k             i         I     ������
�� .aevtoappnull  �   � ****��  ��    k       	 	  
  
 l     �� ��    R L note: 90000 is a magic number which might depend on the recording file type         l     �� ��    ? 9 indices in the ".eyetvr" file are seconds * 90000.  YMMV         r         ^         m        ?�        m    ����  _�  o      ���� $0 secondspermarker SecondsPerMarker      l   ������  ��        l   ������  ��        l   �� ��    8 2 probably won't have to modify anything below here         r       !   I   �� "��
�� .sysoexecTEXT���     TEXT " m     # # ! locate PlistBuddy | head -1   ��   ! o      ���� 0 
plistbuddy 
PlistBuddy   $ % $ r     & ' & J    ����   ' o      ���� 0 markers   %  ( ) ( r     * + * m     , ,       + o      ���� 0 currentfile CurrentFile )  - . - r     / 0 / m    ����   0 o      ���� "0 reloadfilecount ReloadFileCount .  1�� 1 I     �������� 0 myidle myIdle��  ��  ��     2 3 2 l     ������  ��   3  4 5 4 l     ������  ��   5  6 7 6 l     �� 8��   8 4 . get array of time chops from the .eyetvr file    7  9 : 9 i     ; < ; I      �� =���� 0 
getmarkers 
GetMarkers =  > ? > o      ���� 	0 fname   ?  @�� @ o      ���� 0 	use_plist  ��  ��   < k     � A A  B C B p       D D �� E�� $0 secondspermarker SecondsPerMarker E ������ 0 
plistbuddy 
PlistBuddy��   C  F G F Z      H I���� H =      J K J o     ���� 	0 fname   K m     L L       I k     M M  N O N r    
 P Q P J    ����   Q o      ���� 0 m   O  R�� R L     S S o    ���� 0 m  ��  ��  ��   G  T U T l   ������  ��   U  V W V Z    Q X Y�� Z X =     [ \ [ o    ���� 0 	use_plist   \ m    ����  Y k    E ] ]  ^ _ ^ r    # ` a ` I   !�� b��
�� .sysoexecTEXT���     TEXT b b     c d c m     e e  dirname     d n     f g f 1    ��
�� 
strq g o    ���� 	0 fname  ��   a o      ���� 0 dirname dirName _  h i h r   $ 1 j k j I  $ /�� l��
�� .sysoexecTEXT���     TEXT l b   $ + m n m b   $ ) o p o m   $ % q q  	basename     p n   % ( r s r 1   & (��
�� 
strq s o   % &���� 	0 fname   n m   ) * t t   .eyetvr   ��   k o      ���� 0 basename baseName i  u v u r   2 ; w x w b   2 9 y z y b   2 7 { | { b   2 5 } ~ } o   2 3���� 0 dirname dirName ~ m   3 4    /    | o   5 6���� 0 basename baseName z m   7 8 � �  .plist    x o      ���� 	0 fname   v  ��� � r   < E � � � b   < C � � � b   < ? � � � o   < =���� 0 
plistbuddy 
PlistBuddy � m   = > � �   -c "Print"     � n   ? B � � � 1   @ B��
�� 
strq � o   ? @���� 	0 fname   � o      ���� 0 cmd  ��  ��   Z r   H Q � � � b   H O � � � b   H K � � � o   H I���� 0 
plistbuddy 
PlistBuddy � m   I J � �   -c "Print markers"     � n   K N � � � 1   L N��
�� 
strq � o   K L���� 	0 fname   � o      ���� 0 cmd   W  � � � r   R Y � � � I  R W�� ���
�� .sysoexecTEXT���     TEXT � o   R S���� 0 cmd  ��   � o      ���� 0 res   �  � � � l  Z Z�� ���   �  display dialog res    �  � � � r   Z _ � � � n   Z ] � � � 2  [ ]��
�� 
cpar � o   Z [���� 0 res   � o      ���� 0 res   �  � � � r   ` d � � � J   ` b����   � o      ���� 0 markers   �  � � � Y   e � ��� � ��� � k   u � � �  � � � r   u } � � � c   u { � � � n   u y � � � 4   v y�� �
�� 
cobj � o   w x���� 0 i   � o   u v���� 0 res   � m   y z��
�� 
nmbr � o      ���� 0 num   �  � � � r   ~ � � � � ]   ~ � � � � o   ~ ���� 0 num   � o    ����� $0 secondspermarker SecondsPerMarker � o      ���� 0 num   �  ��� � r   � � � � � o   � ����� 0 num   � n       � � �  ;   � � � o   � ����� 0 markers  ��  �� 0 i   � m   h i����  � \   i p � � � l  i n ��� � I  i n�� ���
�� .corecnte****       **** � o   i j���� 0 res  ��  ��   � m   n o���� ��   �  � � � L   � � � � o   � ����� 0 markers   �  ��� � l  � ��� ���   �  display dialog markers   ��   :  � � � l     ������  ��   �  � � � l     �� ���   � 3 - ask EyeTV what the currently playing file is    �  � � � i     � � � I      ��������  0 getcurrentfile GetCurrentFile��  ��   � Q     / � � � � k    % � �  � � � l   �� ���   � K E no recording record for watching live tv, so put this in a try block    �  � � � O    " � � � k    ! � �  � � � r     � � � c     � � � l    ��� � e     � � n     � � � 1    ��
�� 
pURL � 4    �� �
�� 
cRec � l  	  ��� � n   	  � � � 1    ��
�� 
pnam � 4   	 �� �
�� 
cPlw � m    ���� ��  ��   � m    ��
�� 
TEXT � o      ���� $0 currentrecording currentRecording �  ��� � r    ! � � � n     � � � 1    ��
�� 
psxp � 4    �� �
�� 
file � o    ���� $0 currentrecording currentRecording � o      ���� $0 currentrecording currentRecording��   � m     � ��null        ��  ]	EyeTV.app�U  �u1'�(���  ��| �? H��������,p{ ��������<�EyTV   alis    0  kika                       �֤�H+    ]	EyeTV.app                                                       ���W3        ����  	                Applications    ��      �W��      ]  kika:Applications:EyeTV.app    	 E y e T V . a p p  
  k i k a  Applications/EyeTV.app  / ��   �  ��� � L   # % � � o   # $���� $0 currentrecording currentRecording��   � R      ����~
�� .ascrerr ****      � ****�  �~   � L   - / � � m   - . � �       �  � � � l     �}�|�}  �|   �  � � � i     � � � I      �{�z�y�{ 0 myidle myIdle�z  �y   � k     � � �  �  � p       �x�w�x 0 markers  �w     p       �v�u�v 0 currentfile CurrentFile�u    p       �t�s�t "0 reloadfilecount ReloadFileCount�s   	 l     �r�q�r  �q  	 

 O      Z    �p H     1    �o
�o 
Plng L     m    �n�n �p   r     1    �m
�m 
CTme o      �l�l 0 ct   m      �  l   �k�j�k  �j    l   �i�i   � � we reload the markers when the current file changes, or every 15 times through the loop in case the markers have changed (e.g. comskip just finished processing the file)     r     I    �h�g�f�h  0 getcurrentfile GetCurrentFile�g  �f   o      �e�e 0 f F  Z    F !�d�c  G    *"#" >   "$%$ o     �b�b 0 f F% o     !�a�a 0 currentfile CurrentFile# ?   % (&'& o   % &�`�` "0 reloadfilecount ReloadFileCount' m   & '�_�_ ! k   - B(( )*) r   - 0+,+ m   - .�^�^  , o      �]�] "0 reloadfilecount ReloadFileCount* -.- r   1 4/0/ o   1 2�\�\ 0 f F0 o      �[�[ 0 currentfile CurrentFile. 121 r   5 >343 I   5 <�Z5�Y�Z 0 
getmarkers 
GetMarkers5 676 o   6 7�X�X 0 f F7 8�W8 m   7 8�V�V �W  �Y  4 o      �U�U 0 
newmarkers 
newMarkers2 9�T9 r   ? B:;: o   ? @�S�S 0 
newmarkers 
newMarkers; o      �R�R 0 markers  �T  �d  �c   <=< r   G L>?> [   G J@A@ o   G H�Q�Q "0 reloadfilecount ReloadFileCountA m   H I�P�P ? o      �O�O "0 reloadfilecount ReloadFileCount= BCB l  M M�N�M�N  �M  C DED Y   M �F�LGHIF k   [ �JJ KLK r   [ aMNM n   [ _OPO 4   \ _�KQ
�K 
cobjQ o   ] ^�J�J 0 i  P o   [ \�I�I 0 markers  N o      �H�H 0 bt  L RSR r   b jTUT n   b hVWV 4   c h�GX
�G 
cobjX l  d gY�FY [   d gZ[Z o   d e�E�E 0 i  [ m   e f�D�D �F  W o   b c�C�C 0 markers  U o      �B�B 0 et  S \�A\ Z   k �]^�@�?] F   k v_`_ @   k naba o   k l�>�> 0 ct  b o   l m�=�= 0 bt  ` B   q tcdc o   q r�<�< 0 ct  d o   r s�;�; 0 et  ^ k   y �ee fgf O   y �hih I  } ��:�9j
�: .EyTVJumpnull    ��� null�9  j �8k�7
�8 
To  k o    ��6�6 0 et  �7  i m   y z �g lml l  � ��5n�5  n  display dialog "Jumped"   m o�4o  S   � ��4  �@  �?  �A  �L 0 i  G m   P Q�3�3 H I  Q V�2p�1
�2 .corecnte****       ****p o   Q R�0�0 0 markers  �1  I m   V W�/�/ E q�.q L   � �rr m   � ��-�- �.   � sts l     �,�+�,  �+  t uvu l     �*�)�*  �)  v w�(w i    xyx I     �'�&�%
�' .miscidlenmbr    ��� null�&  �%  y L     zz I     �$�#�"�$ 0 myidle myIdle�#  �"  �(       �!{|}~��!  { � ����
�  .aevtoappnull  �   � ****� 0 
getmarkers 
GetMarkers�  0 getcurrentfile GetCurrentFile� 0 myidle myIdle
� .miscidlenmbr    ��� null| � �����
� .aevtoappnull  �   � ****�  �  �  �  �� #��� ,����  _�� $0 secondspermarker SecondsPerMarker
� .sysoexecTEXT���     TEXT� 0 
plistbuddy 
PlistBuddy� 0 markers  � 0 currentfile CurrentFile� "0 reloadfilecount ReloadFileCount� 0 myidle myIdle� !��!E�O�j E�OjvE�O�E�OjE�O*j+ 
} � <������ 0 
getmarkers 
GetMarkers� ��� �  �
�	�
 	0 fname  �	 0 	use_plist  �  � 
��������� ��� 	0 fname  � 0 	use_plist  � 0 m  � 0 dirname dirName� 0 basename baseName� 0 cmd  � 0 res  � 0 markers  �  0 i  �� 0 num  �  L e���� q t  ��� � �����������
�� 
strq
�� .sysoexecTEXT���     TEXT�� 0 
plistbuddy 
PlistBuddy
�� 
cpar
�� .corecnte****       ****
�� 
cobj
�� 
nmbr�� $0 secondspermarker SecondsPerMarker� ���  jvE�O�Y hO�k  2��,%j E�O��,%�%j E�O��%�%�%E�O��%��,%E�Y ��%��,%E�O�j E�O��-E�OjvE�O 'l�j kkh ���/�&E�O�� E�O��6F[OY��O�OP~ �� �����������  0 getcurrentfile GetCurrentFile��  ��  � ���� $0 currentrecording currentRecording�  ������������������� �
�� 
cRec
�� 
cPlw
�� 
pnam
�� 
pURL
�� 
TEXT
�� 
file
�� 
psxp��  ��  �� 0 '� *�*�k/�,E/�,E�&E�O*�/�,E�UO�W 	X  	� �� ����������� 0 myidle myIdle��  ��  � �������������� 0 ct  �� 0 f F�� 0 
newmarkers 
newMarkers�� 0 i  �� 0 bt  �� 0 et  �  ���������������������������
�� 
Plng�� 
�� 
CTme��  0 getcurrentfile GetCurrentFile�� 0 currentfile CurrentFile�� "0 reloadfilecount ReloadFileCount
�� 
bool�� 0 
getmarkers 
GetMarkers�� 0 markers  
�� .corecnte****       ****
�� 
cobj
�� 
To  
�� .EyTVJumpnull    ��� null�� �� *�, �Y *�,E�UO*j+ E�O��
 ���& jE�O�E�O*�kl+ E�O�E�Y hO�kE�O Bk�j 
lh ��/E�O��k/E�O��	 ���& � 	*�l UOY h[OY��Ok� ��y��������
�� .miscidlenmbr    ��� null��  ��  �  � ���� 0 myidle myIdle�� *j+  ascr  ��ޭ