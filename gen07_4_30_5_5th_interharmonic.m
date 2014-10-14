% Testing according to 4-30
% 5 points 5.5 th interharmonic
% 22.08.2014 11:16
clear all;clc;
IH=[0.1 1.0 2.0 3.0 5.0];
IHARM_NUMBER=6; % 1st interharmonic is below 50 hz 
fs=12800;
f0=50.0;
duration=60;
U_c=230;
I_c=5;
FL=1.0; % flicker level

for k=IH
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

IHARM_MATRIX=zeros(8,GEN.MAX_IHARM_NUMBER);
IHARM_MATRIX(1,IHARM_NUMBER)=k/100;
IHARM_MATRIX(2,IHARM_NUMBER)=k/100;
IHARM_MATRIX(3,IHARM_NUMBER)=k/100;
GEN=GEN.add_interharmonics(IHARM_MATRIX);

GEN=GEN.savefile(['signal\' num2str(k,'%2.2f') ' ' num2str((IHARM_NUMBER-0.5),'%2.1f') 'iharm\test_state_1.txt']);
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
% add flicker Pst=1±0.1 at 39 cpm  [ cpm=39 deltaU/U=0.894 ]
GEN=GEN.add_flicker([39 39 39 0 0 0 0 0],[0.894 0.894 0.894 0 0 0 0 0], 1);
% add harmonics   0.1 x 3rd at 0° | 0.05 x 5th at 0° | 0.05 x 29th at 0°
HARM_MATRIX=zeros(8,GEN.MAX_HARM_NUMBER);
HARM_MATRIX(1,3)=0.1;
HARM_MATRIX(2,3)=0.1;
HARM_MATRIX(3,3)=0.1;
HARM_MATRIX(1,5)=0.05;
HARM_MATRIX(2,5)=0.05;
HARM_MATRIX(3,5)=0.05;
HARM_MATRIX(1,29)=0.05;
HARM_MATRIX(2,29)=0.05;
HARM_MATRIX(3,29)=0.05;
GEN=GEN.add_harmonics(HARM_MATRIX);
% % add interharmonic 
IHARM_MATRIX=zeros(8,GEN.MAX_IHARM_NUMBER);
IHARM_MATRIX(1,IHARM_NUMBER)=k/100;
IHARM_MATRIX(2,IHARM_NUMBER)=k/100;
IHARM_MATRIX(3,IHARM_NUMBER)=k/100;
GEN=GEN.add_interharmonics(IHARM_MATRIX);

GEN=GEN.savefile(['signal\' num2str(k,'%2.2f') ' ' num2str((IHARM_NUMBER-0.5),'%2.1f') 'iharm\test_state_2.txt']);
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
% add flicker Pst=4±0.1 at 110 cpm  [ cpm=110 deltaU/U=0.722 ]
GEN=GEN.add_flicker([110 110 110 0 0 0 0 0],4*[0.722 0.722 0.722 0 0 0 0 0], 1);
% add harmonics   0.1 x 7rd at 180° | 0.05 x 13th at 0° | 0.05 x 25th at 0°
HARM_MATRIX=zeros(8,GEN.MAX_HARM_NUMBER);
HARM_MATRIX(1,7)=-0.1;
HARM_MATRIX(2,7)=0.1;
HARM_MATRIX(3,7)=0.1;
HARM_MATRIX(1,13)=0.05;
HARM_MATRIX(2,13)=0.05;
HARM_MATRIX(3,13)=0.05;
HARM_MATRIX(1,25)=0.05;
HARM_MATRIX(2,25)=0.05;
HARM_MATRIX(3,25)=0.05;
GEN=GEN.add_harmonics(HARM_MATRIX);
% % add interharmonic
IHARM_MATRIX=zeros(8,GEN.MAX_IHARM_NUMBER);
IHARM_MATRIX(1,IHARM_NUMBER)=k/100;
IHARM_MATRIX(2,IHARM_NUMBER)=k/100;
IHARM_MATRIX(3,IHARM_NUMBER)=k/100;
%GEN=GEN.add_interharmonics(IHARM_MATRIX);

GEN=GEN.savefile(['signal\' num2str(k,'%2.2f') ' ' num2str((IHARM_NUMBER-0.5),'%2.1f') 'iharm\test_state_3.txt']);
clear GEN;
end;

%-------------------------------
%GEN=GEN.draw;
%  tic
 
%  t=toc
%figure; 
% plot(sqrt(2)*abs(fft(GEN.UA)/length(GEN.UA)))

% disp('Loading');
% [A,B]=mex_swallow_csv('signal\signal.txt');
% clear B;

