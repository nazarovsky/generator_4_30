% Testing according to 4-30
% 5 points 17th harmonic
% 22.08.2014 11:16
clear all;clc;
H=[0.1 1.0 5.0 10.0 20.0];
HARM_NUMBER=17;
fs=12800;
f0=50.0;
duration=60;
U_c=230;
I_c=5;
FL=1.0; % flicker level

for k=H
% ----------------------
% Testing state 1
Un=U_c;
In=I_c;
fn=f0;
VAL_MATRIX=[     Un      Un       Un      0  ; 
                 0 -2*pi/3  +2*pi/3      0  ;
                 In      In       In      0  ; 
                 0       0        0      0 ];
GEN=generator(fs,fn,duration,VAL_MATRIX);
GEN=GEN.generate;
HARM_MATRIX=zeros(8,GEN.MAX_HARM_NUMBER);
HARM_MATRIX(1,HARM_NUMBER)=k/100;
HARM_MATRIX(2,HARM_NUMBER)=k/100;
HARM_MATRIX(3,HARM_NUMBER)=k/100;
GEN=GEN.add_harmonics(HARM_MATRIX);

GEN=GEN.savefile(['signal\' num2str(k,'%2.2f') ' ' num2str(HARM_NUMBER,'%2.0f') 'harm\test_state_1.txt']);
clear GEN;

% ----------------------
% Testing state 2

Un=U_c;
In=I_c;
fn=f0-1;

VAL_MATRIX=[  0.73*Un   0.80*Un   0.87*Un 0  ; 
                 0  -2*pi/3  +2*pi/3      0  ;
                 In      In       In      0  ; 
                 0       0        0       0 ];
GEN=generator(fs,fn,duration,VAL_MATRIX);
GEN=GEN.generate;
% add flicker Pst=1�0.1 at 39 cpm  [ cpm=39 deltaU/U=0.894 ]
GEN=GEN.add_flicker([39 39 39 0 0 0 0 0],[0.894 0.894 0.894 0 0 0 0 0], 1);
% add harmonics   0.1 x 3rd at 0� | 0.05 x 5th at 0� | 0.05 x 29th at 0�
HARM_MATRIX=zeros(8,GEN.MAX_HARM_NUMBER);
HARM_MATRIX(1,HARM_NUMBER)=k/100;
HARM_MATRIX(2,HARM_NUMBER)=k/100;
HARM_MATRIX(3,HARM_NUMBER)=k/100;
GEN=GEN.add_harmonics(HARM_MATRIX);
% % add interharmonic 0.01 x 7.5 f_nom 
IHARM_MATRIX=zeros(8,GEN.MAX_IHARM_NUMBER);
IHARM_MATRIX(1,8)=0.01;
IHARM_MATRIX(2,8)=0.01;
IHARM_MATRIX(3,8)=0.01;
GEN=GEN.add_interharmonics(IHARM_MATRIX);

GEN=GEN.savefile(['signal\' num2str(k,'%2.2f') ' ' num2str(HARM_NUMBER,'%2.0f') 'harm\test_state_2.txt']);
clear GEN;
% ----------------------
% Testing state 3

Un=U_c;
In=I_c;
fn=f0+1;

VAL_MATRIX=[  1.52*Un   1.40*Un   1.28*Un 0  ; 
                 0  -2*pi/3  +2*pi/3      0  ;
                 In      In       In      0  ; 
                 0       0        0       0 ];
GEN=generator(fs,fn,duration,VAL_MATRIX);
GEN=GEN.generate;
% add flicker Pst=4�0.1 at 110 cpm  [ cpm=110 deltaU/U=0.722 ]
GEN=GEN.add_flicker([110 110 110 0 0 0 0 0],4*[0.722 0.722 0.722 0 0 0 0 0], 1);
% add harmonics   0.1 x 7rd at 180� | 0.05 x 13th at 0� | 0.05 x 25th at 0�
HARM_MATRIX=zeros(8,GEN.MAX_HARM_NUMBER);
HARM_MATRIX(1,HARM_NUMBER)=k/100;
HARM_MATRIX(2,HARM_NUMBER)=k/100;
HARM_MATRIX(3,HARM_NUMBER)=k/100;
GEN=GEN.add_harmonics(HARM_MATRIX);
% % add interharmonic 0.01 x 3.5 f_nom 
IHARM_MATRIX=zeros(8,GEN.MAX_IHARM_NUMBER);
IHARM_MATRIX(1,4)=0.01;
IHARM_MATRIX(2,4)=0.01;
IHARM_MATRIX(3,4)=0.01;
GEN=GEN.add_interharmonics(IHARM_MATRIX);

GEN=GEN.savefile(['signal\' num2str(k,'%2.2f') ' ' num2str(HARM_NUMBER,'%2.0f') 'harm\test_state_3.txt']);
clear GEN;
end;
