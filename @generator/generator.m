classdef generator
    % 
    % generates test signals with power quality distortions
    % 
    properties
        F_s        % sampling frequency 
        F_main     % AC mains fundamental frequency
        Duration   % duration of signal

                   % magnitudes of Voltages (rms). default:
        UA_mag     % 100
        UB_mag     % 100 
        UC_mag     % 100 
        UN_mag     % 0 (added for 9-2 compatibility)
                   
                   % magnitudes of Currents (rms). default:
        IA_mag     % 5
        IB_mag     % 5
        IC_mag     % 5 
        IN_mag     % 0 (added for 9-2 compatibility)
                   
                   % phases of the voltage signals. default:
        UA_phase   % 0
        UB_phase   % -2*pi/3
        UC_phase   % +2*pi/3
        UN_phase   % 0   
                   
                   % phases of currents signals relative to voltages. default:
        IA_phase   % 0
        IB_phase   % 0
        IC_phase   % 0
        IN_phase   % 0  
        
        
        MAX_HARM_NUMBER % 
        
        UA_harm_mag % array 1..50 of Harmonic magnitudes
        UB_harm_mag
        UC_harm_mag
        UN_harm_mag
        
        IA_harm_mag
        IB_harm_mag
        IC_harm_mag
        IN_harm_mag

        MAX_IHARM_NUMBER % 

        UA_iharm_mag % array 1..50 of interharmonic magnitudes (1st is below 50 hz)
        UB_iharm_mag
        UC_iharm_mag
        UN_iharm_mag
        
        IA_iharm_mag
        IB_iharm_mag
        IC_iharm_mag
        IN_iharm_mag


        
        Sampling_interval % 1/F_s
        t          % time for all signals
        generated  % 0 if signals are not generated 
        UA
        UB
        UC
        UN
        
        IA
        IB
        IC
        IN
        
        
    end
    
    methods
      % constructor  
      function GEN = generator(F_s,F_main, Duration, varargin)
         % VAL_MATRIX in varargin is in the following format
         % VAL_MATRIX = [ UA_rms    UB_rms    UC_rms    UN_rms   ;
         %                UA_phase  UB_phase  UC_phase  UN_phase ;
         %                IA_rms    IB_rms    IC_rms    IN_rms   ;
         %                IA_phase  IB_phase  IC_phase  IN_phase ] ;
         narginchk(3,4);
         if (F_s<=0)
             error('Sampling frequency should be >=0');
         end
         GEN.F_s     = F_s;
         GEN.Sampling_interval=1/F_s;
         if (F_main>F_s)
             error('Mains frequency should be lesser than Sampling frequency');
         end
         GEN.F_main  = F_main;
         GEN.Duration= Duration;

         if (~isempty(varargin)) && (isequal(size(varargin{1}), [4 4]))
             VAL_MATRIX=varargin{1};
         else
             VAL_MATRIX=[   100     100      100      0 ; 
                              0 -2*pi/3  +2*pi/3      0 ;
                              5       5        5      0 ; 
                              0       0        0      0 ];
         end
         
         GEN.UA_mag=VAL_MATRIX(1,1); GEN.UB_mag=VAL_MATRIX(1,2); 
         GEN.UC_mag=VAL_MATRIX(1,3); GEN.UN_mag=VAL_MATRIX(1,4);
         
         GEN.UA_phase=VAL_MATRIX(2,1); GEN.UB_phase=VAL_MATRIX(2,2); 
         GEN.UC_phase=VAL_MATRIX(2,3); GEN.UN_phase=VAL_MATRIX(2,4); 
         
         GEN.IA_mag=VAL_MATRIX(3,1); GEN.IB_mag=VAL_MATRIX(3,2); 
         GEN.IC_mag=VAL_MATRIX(3,3); GEN.IN_mag=VAL_MATRIX(3,4);
         
         GEN.IA_phase=VAL_MATRIX(4,1)+VAL_MATRIX(2,1);
         GEN.IB_phase=VAL_MATRIX(4,2)+VAL_MATRIX(2,2);
         GEN.IC_phase=VAL_MATRIX(4,3)+VAL_MATRIX(2,3);
         GEN.IN_phase=VAL_MATRIX(4,4)+VAL_MATRIX(2,4);
         
         GEN.generated=false;
         GEN.t=0:GEN.Sampling_interval:(GEN.Duration-GEN.Sampling_interval);

         GEN.MAX_HARM_NUMBER=50;
         GEN.UA_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);
         GEN.UB_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);
         GEN.UC_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);
         GEN.UN_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);
         
         GEN.IA_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);
         GEN.IB_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);
         GEN.IC_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);
         GEN.IN_harm_mag=zeros(1,GEN.MAX_HARM_NUMBER);

         GEN.MAX_IHARM_NUMBER=50;
         GEN.UA_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);
         GEN.UB_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);
         GEN.UC_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);
         GEN.UN_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);
         
         GEN.IA_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);
         GEN.IB_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);
         GEN.IC_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);
         GEN.IN_iharm_mag=zeros(1,GEN.MAX_IHARM_NUMBER);


         
      end % generator
      
      % generates the signal into Ux and Ix (x=A,B,C,N)
      function GEN=generate(GEN)
         GEN.UA=sqrt(2)*GEN.UA_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.UA_phase) ; 
         GEN.UB=sqrt(2)*GEN.UB_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.UB_phase) ;  
         GEN.UC=sqrt(2)*GEN.UC_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.UC_phase) ; 
         GEN.UN=sqrt(2)*GEN.UN_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.UN_phase) ; 
         
         GEN.IA=sqrt(2)*GEN.IA_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.IA_phase) ; 
         GEN.IB=sqrt(2)*GEN.IB_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.IB_phase) ;  
         GEN.IC=sqrt(2)*GEN.IC_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.IC_phase) ; 
         GEN.IN=sqrt(2)*GEN.IC_mag*sin(2*pi*GEN.F_main*GEN.t + GEN.IN_phase) ; 
         GEN.generated=true;
      end  % generate

      % Add Harmonics to Ux and Ix
      function GEN=add_harmonics(GEN,HARM_MATRIX)
         % magnitudes in relative of Ux / Ix mag (e.g. 0.01 = 1% )  note that Ux(1)=Ix(1)=0 
         % HARM MATRIX = [ UA_(1) UA_(2) ...  UA_(MAX_HARM_NUMBER) ;
         %                 UB_(1) UB_(2) ...  UB_(MAX_HARM_NUMBER) ; 
         %                 UC_(1) UC_(2) ...  UC_(MAX_HARM_NUMBER) ; 
         %                 UN_(1) UN_(2) ...  UN_(MAX_HARM_NUMBER) ; 
         %                 IA_(1) IA_(2) ...  IA_(MAX_HARM_NUMBER) ;
         %                 IB_(1) IB_(2) ...  IB_(MAX_HARM_NUMBER) ; 
         %                 IC_(1) IC_(2) ...  IC_(MAX_HARM_NUMBER) ; 
         %                 IN_(1) IN_(2) ...  IN_(MAX_HARM_NUMBER) ]
         if ~GEN.generated
            error('Signals are not generated! Use generate before adding Harmonics');
         end;
         narginchk(2,2);
         GEN.UA_harm_mag=GEN.UA_mag*HARM_MATRIX(1,:);
         GEN.UB_harm_mag=GEN.UB_mag*HARM_MATRIX(2,:);
         GEN.UC_harm_mag=GEN.UC_mag*HARM_MATRIX(3,:);
         GEN.UN_harm_mag=GEN.UN_mag*HARM_MATRIX(4,:);
         GEN.IA_harm_mag=GEN.IA_mag*HARM_MATRIX(5,:);
         GEN.IB_harm_mag=GEN.IB_mag*HARM_MATRIX(6,:);
         GEN.IC_harm_mag=GEN.IC_mag*HARM_MATRIX(7,:);
         GEN.IN_harm_mag=GEN.IN_mag*HARM_MATRIX(8,:);

         GEN.UA=GEN.UA + sqrt(2)*GEN.UA_harm_mag((GEN.UA_harm_mag~=0))*sin(find(GEN.UA_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);
         GEN.UB=GEN.UB + sqrt(2)*GEN.UB_harm_mag((GEN.UB_harm_mag~=0))*sin(find(GEN.UB_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);
         GEN.UC=GEN.UC + sqrt(2)*GEN.UC_harm_mag((GEN.UC_harm_mag~=0))*sin(find(GEN.UC_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);
         GEN.UN=GEN.UN + sqrt(2)*GEN.UN_harm_mag((GEN.UN_harm_mag~=0))*sin(find(GEN.UN_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);

         GEN.IA=GEN.IA + sqrt(2)*GEN.IA_harm_mag((GEN.IA_harm_mag~=0))*sin(find(GEN.IA_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);
         GEN.IB=GEN.IB + sqrt(2)*GEN.IB_harm_mag((GEN.IB_harm_mag~=0))*sin(find(GEN.IB_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);
         GEN.IC=GEN.IC + sqrt(2)*GEN.IC_harm_mag((GEN.IC_harm_mag~=0))*sin(find(GEN.IC_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);
         GEN.IN=GEN.IN + sqrt(2)*GEN.IN_harm_mag((GEN.IN_harm_mag~=0))*sin(find(GEN.IN_harm_mag~=0)'.*2*pi*GEN.F_main*GEN.t);
         
         
         GEN.generated=true;
      end  % add_harmonics     

      % Add interharmonics to Ux and Ix
      function GEN=add_interharmonics(GEN,IHARM_MATRIX)
         % magnitudes in relative of Ux / Ix mag (e.g. 0.01 = 1% )  UA_ih(1)->0.5F UA_ih(2)->1.5F etc 
         % IHARM MATRIX = [ UA_ih(1) UA_ih(2) ...  UA_ih(MAX_IHARM_NUMBER) ;
         %                  UB_ih(1) UB_ih(2) ...  UB_ih(MAX_IHARM_NUMBER) ; 
         %                  UC_ih(1) UC_ih(2) ...  UC_ih(MAX_IHARM_NUMBER) ; 
         %                  UN_ih(1) UN_ih(2) ...  UN_ih(MAX_IHARM_NUMBER) ; 
         %                  IA_ih(1) IA_ih(2) ...  IA_ih(MAX_IHARM_NUMBER) ;
         %                  IB_ih(1) IB_ih(2) ...  IB_ih(MAX_IHARM_NUMBER) ; 
         %                  IC_ih(1) IC_ih(2) ...  IC_ih(MAX_IHARM_NUMBER) ; 
         %                  IN_ih(1) IN_ih(2) ...  IN_ih(MAX_IHARM_NUMBER) ]
         if ~GEN.generated
            error('Signals are not generated! Use generate before adding Interharmonics');
         end;
         narginchk(2,2);
         GEN.UA_iharm_mag=GEN.UA_mag*IHARM_MATRIX(1,:);
         GEN.UB_iharm_mag=GEN.UB_mag*IHARM_MATRIX(2,:);
         GEN.UC_iharm_mag=GEN.UC_mag*IHARM_MATRIX(3,:);
         GEN.UN_iharm_mag=GEN.UN_mag*IHARM_MATRIX(4,:);
         GEN.IA_iharm_mag=GEN.IA_mag*IHARM_MATRIX(5,:);
         GEN.IB_iharm_mag=GEN.IB_mag*IHARM_MATRIX(6,:);
         GEN.IC_iharm_mag=GEN.IC_mag*IHARM_MATRIX(7,:);
         GEN.IN_iharm_mag=GEN.IN_mag*IHARM_MATRIX(8,:);

         GEN.UA=GEN.UA + sqrt(2)*GEN.UA_iharm_mag((GEN.UA_iharm_mag~=0))*sin((find(GEN.UA_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);
         GEN.UB=GEN.UB + sqrt(2)*GEN.UB_iharm_mag((GEN.UB_iharm_mag~=0))*sin((find(GEN.UB_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);
         GEN.UC=GEN.UC + sqrt(2)*GEN.UC_iharm_mag((GEN.UC_iharm_mag~=0))*sin((find(GEN.UC_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);
         GEN.UN=GEN.UN + sqrt(2)*GEN.UN_iharm_mag((GEN.UN_iharm_mag~=0))*sin((find(GEN.UN_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);

         GEN.IA=GEN.IA + sqrt(2)*GEN.IA_iharm_mag((GEN.IA_iharm_mag~=0))*sin((find(GEN.IA_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);
         GEN.IB=GEN.IB + sqrt(2)*GEN.IB_iharm_mag((GEN.IB_iharm_mag~=0))*sin((find(GEN.IB_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);
         GEN.IC=GEN.IC + sqrt(2)*GEN.IC_iharm_mag((GEN.IC_iharm_mag~=0))*sin((find(GEN.IC_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);
         GEN.IN=GEN.IN + sqrt(2)*GEN.IN_iharm_mag((GEN.IN_iharm_mag~=0))*sin((find(GEN.IN_iharm_mag~=0)'-0.5).*2*pi* GEN.F_main *GEN.t);
         
         
         GEN.generated=true;
      end  % add_harmonics     


      
      % Add flicker to Ux and Ix
      function GEN=add_flicker(GEN, FREQ_VECTOR, MAG_VECTOR, form )
          % FREQ_VECTOR = [FmodUA FmodUB FmodUC FmodUN FmodIA FmodIB FmodIC FmodIN] (changes/minute)  |  
          % MAG_VECTOR  = [dUA dUB dUC dUN dIA dIB dIC dIN] in percent (deltaU/U)  | 
          % FORM        = 0-sinewave 1-rectwave
          FREQ_VECTOR=FREQ_VECTOR/120;
          MAG_VECTOR=MAG_VECTOR/100;
          switch form
              case 0
                  GEN.UA=GEN.UA.*(1+MAG_VECTOR(1)/2*sin(2*pi*FREQ_VECTOR(1)*GEN.t));
                  GEN.UB=GEN.UB.*(1+MAG_VECTOR(2)/2*sin(2*pi*FREQ_VECTOR(2)*GEN.t));
                  GEN.UC=GEN.UC.*(1+MAG_VECTOR(3)/2*sin(2*pi*FREQ_VECTOR(3)*GEN.t));
                  GEN.UN=GEN.UN.*(1+MAG_VECTOR(4)/2*sin(2*pi*FREQ_VECTOR(4)*GEN.t));
                  
                  GEN.IA=GEN.IA.*(1+MAG_VECTOR(5)/2*sin(2*pi*FREQ_VECTOR(5)*GEN.t));
                  GEN.IB=GEN.IB.*(1+MAG_VECTOR(6)/2*sin(2*pi*FREQ_VECTOR(6)*GEN.t));
                  GEN.IC=GEN.IC.*(1+MAG_VECTOR(7)/2*sin(2*pi*FREQ_VECTOR(7)*GEN.t));
                  GEN.IN=GEN.IN.*(1+MAG_VECTOR(8)/2*sin(2*pi*FREQ_VECTOR(8)*GEN.t));
              case 1
                  GEN.UA=GEN.UA.*(1+MAG_VECTOR(1)/2*sign(sin(2*pi*FREQ_VECTOR(1)*GEN.t)));
                  GEN.UB=GEN.UB.*(1+MAG_VECTOR(2)/2*sign(sin(2*pi*FREQ_VECTOR(2)*GEN.t)));
                  GEN.UC=GEN.UC.*(1+MAG_VECTOR(3)/2*sign(sin(2*pi*FREQ_VECTOR(3)*GEN.t)));
                  GEN.UN=GEN.UN.*(1+MAG_VECTOR(4)/2*sign(sin(2*pi*FREQ_VECTOR(4)*GEN.t)));
                  
                  GEN.IA=GEN.IA.*(1+MAG_VECTOR(5)/2*sign(sin(2*pi*FREQ_VECTOR(5)*GEN.t)));
                  GEN.IB=GEN.IB.*(1+MAG_VECTOR(6)/2*sign(sin(2*pi*FREQ_VECTOR(6)*GEN.t)));
                  GEN.IC=GEN.IC.*(1+MAG_VECTOR(7)/2*sign(sin(2*pi*FREQ_VECTOR(7)*GEN.t)));
                  GEN.IN=GEN.IN.*(1+MAG_VECTOR(8)/2*sign(sin(2*pi*FREQ_VECTOR(8)*GEN.t)));
          end
          
      end % add_flicker
      
      function GEN=draw(GEN)
          figure;
          subplot(2,1,1);
          plot(GEN.t, GEN.UA,'r'); hold on;
          plot(GEN.t, GEN.UB,'g');
          plot(GEN.t, GEN.UC,'b');
          legend('UA','UB','UC');
          title('Voltages'); 
          subplot(2,1,2);
          plot(GEN.t, GEN.IA,'r'); hold on;
          plot(GEN.t, GEN.IB,'g');
          plot(GEN.t, GEN.IC,'b');
          legend('IA','IB','IC');
          title('Currents');
      end % draw
      
      
      
      function GEN=savefile(GEN,fname)
          narginchk(2,2);
          
          if ~GEN.generated
              error('Signals are not generated! Use generate before saving');
          end;
          disp(['... writing ' fname]);
          Z=[GEN.t' GEN.IA' GEN.IB' GEN.IC' GEN.IN' GEN.UA' GEN.UB' GEN.UC' GEN.UN'];
          % make folder if not exists
          [dirpath,filename,fileext] = fileparts(fname); 
          if (dirpath(end) ~= '/')
              dirpath = [dirpath '/'];
          end
          if (exist(dirpath, 'dir') == 0)
              mkdir(dirpath); 
          end            
          mex_WriteMatrix(fname,Z,'%10.10f',',');
          clear Z;
          fprintf('\n');
          clear mex_WriteMatrix;
      end % save

      
      
      
    end
end
            