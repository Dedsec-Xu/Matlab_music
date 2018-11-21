function w = nmat22snd(nmat,synthtype,fs)
% Create waveform of NMAT using a simple synthesis
% w = nmat2snd(nmat,<synthtype>,<fs>,<f_min>,<f_max>)
% Create waveform of NMAT using a simple FM synthesis. The default sampling rate is 
% 22050 Hz and velocities are scaled to have
% a max value of 1.
%
% SYNTHTYPE 'fm' (default) uses FM synthesis to approximate horn sound.
% SYNTHTYPE 'shepard' creates waveform of NMAT using Shepard tones. 
% These tones have also been 
%  called 'Circular tones' because they are specifically constructed to contain 
%  frequency components at octave intervals with an emphasis of the spectral 
%  components between 500Hz and 1000 Hz that effectively 
%  eliminates octave information (Shepard, 1964). 
%
% Part of the code has been obtained from the work of Ed Doering.
%  Ed.Doering@Rose-Hulman.Edu
%
% Input argument:
%	NMAT = notematrix
%     SYNTHTYPE (Optional) = Synthesis type, either FM synthesis ('fm', default) 
%           or Shepard tones ('shepard')
%     FS (optional) = sampling rate (default 22050)
%
% Output:
%	Y = waveform
%
% Example 1: samples1 = nmat2snd(laksin);
% Example 2: samples2 = nmat2snd(laksin,'shepard', 22050);
%
% Reference:
%    Moore, F. R. (1990). Elements of Computer Music. New York: Prentice-Hall.
%    Shepard, R. N. (1964). Circularity in judgements of 
%       relative pitch. Journal of the Acoustical Society of America, 
%       36, 2346-2353. 
%
% Change History :
% Date		Time	Prog	Note
% 29.9.2003	20:13	TE	Created under MATLAB 5.3 (PC)
% 4/15/05           JBP added ability to specify number of partials in
%                       tone, also shifted harmonic envelope such that tones are actually 3
%                       semitones lower than desired. To fix, transpose input up by 3 semitones
%                       (3 midi notes) to get correct pitch with better envelope.
% 2.5.2005	9:30	TE	Almost a total revision if the shepard function
%� Part of the MIDI Toolbox, Copyright � 2004, University of Jyvaskyla, Finland
% See License.txt

if isempty(nmat), return; end
if nargin<3, fs = 44100; end
if nargin<2, synthtype='piano'; end

%%%%%%%%%%%%  WARNINGS

% END WARNINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(synthtype)
          case 'fm'

% convert MIDI numbers to frequencies in Hz
notes(:,1)=onset(nmat,'sec');
notes(:,2)=dur(nmat,'sec')+0.01;
notes(:,3)=midi2hz(pitch(nmat));
notes(:,4)=velocity(nmat);

[yp,] = audioread('piano.wav'); %get piano sound
sig = y(1:48000,1);
[n,wn] = buttord(30*2/fs,100*2/fs,0.1,30);  
[B,A] = butter(n,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);

% generate time vector for output waveform; end time is nearest integer
% above the last note event time (give some extra room)
tt=0:1/fs:ceil(max(notes(:,1))+max(notes(:,2)))-(1/fs);

% scale note velocities so max velocity is one
notes(:,4)=notes(:,4)/max(notes(:,4));
% convert each note to a waveform, and add the waveform to the output waveform
y=zeros(size(tt));


for i=1:size(notes,1),
   % convert note to waveform using the instrument defined by 'fncname'
   w=pianosynth(notes(i,2:4),fs,sig_abs_filt)); % 
   % place waveform in the output file
   ttint=round(notes(i,1)*fs)+1:round(notes(i,1)*fs)+length(w);
   y(ttint)=y(ttint)+w;
end

   w=y/4; %rescale to fit between -1 and +1 (4 is a conservative estimate)
 %rescale to fit between -1 and +1 (4 is a conservative estimate)

% play the sound if no output arguments, otherwise return the sound
%if nargout<1
%   soundsc(y,fs);
%else
%   out=y;
%end

          case 'shepard'

notes = size(nmat,1);
duration =dur(nmat,'sec');
pitchheight =pitch(nmat);
onsets=onset(nmat,'sec');

% create vector for output waveform
tt=0:1/fs:ceil(max(onset(nmat,'sec'))+max(dur(nmat,'sec')+.01))-(1/fs);

% convert each note to a waveform, and add the waveform to the output waveform
y=zeros(size(tt));
for i=1:notes
   w=feval('shepardtone',pitchheight(i),duration(i),fs);
   % place waveform in the output file
   ttint=round(onsets(i)*fs)+1:round(onsets(i)*fs)+length(w);
   y(ttint)=y(ttint)+w;
end
   w=y/30; %rescale to fit between -1 and +1 (30 is a conservative estimate)




			case 'piano'


% play the sound if no output arguments, otherwise return the sound
%if nargout<1
%   soundsc(y,fs);
%else
%   out=y;
%end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function y1=fmsynth(note,fs)
		% FM horn instrument (Moore p. 327)
		%
		% note is in duration-frequency-amplitude format
		% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

		% generate time vector
		du=note(1);
		tt=0:1/fs:du;

		fc = note(2);	%carrier frequency
		h = 1;		%harmonicity ratio
		fm = h*fc;	%modulating frequency
		Imin=0;		%minimum modulation index
		Imaxmin = 5;	%modulation index (max value above Imin)

		% envelopes
		env=envelope([0 0 -1; 0.047354167 1 -1; 0.1725625 0.4908 0; 0.385208333 0.3344 -1; 1 0 0],du,fs);

		%disp(['env ' num2str(size(env)) 'tt ' num2str(size(tt))])
		aa = note(3)*env; 
		ii = Imin+Imaxmin*env;

		% output waveform
		y1 = aa.*sin(2*pi*fc*tt + ii.*sin(2*pi*fm*tt));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function y2=envelope(v,du,fs)
		% envelope function (Moore p. 184, and p. 514)
		%	env=envelope(vlist,du,fs) accepts a matrix 'vlist' where each row is a triple indicating
		%  time (arbitrary units), value (usually between 0 and 1), and transition type.
		%  'du' is the envelope duration in seconds, and 'fs' is the sampling frequency in Hz.
		%
		%  See p. 184 and p. 514 of F. Richard Moore's text ("Elements of Computer Music", 1990, 

		% Find the number of vertices
		numv=size(v,1);

		% Set the time column to occur over duration
		v(:,1)=(v(:,1)/v(numv,1))*du;

		% Generate the envelope (guard against divide by zero error by adding
		% a small number to denominator)
		y2=[];
		for k=1:numv-1 
		   ii=linspace(0,1,(v(k+1,1)-v(k,1))*fs);
		   if v(k,3)==0
		      y2=[y2 linspace(v(k,2),v(k+1,2),size(ii,2))];
		   else
		      y2=[y2 v(k,2)+(v(k+1,2)-v(k,2))*(1-exp(v(k,3)*ii))/(1-exp(v(k,3)+1e-12))];
		   end
		end

		% Figure out how many samples are expected
		nums=size(0:1/fs:du,2);

		% Figure out how many samples were generated
		numg=size(y2,2);

		% Pad or trim the vector as needed
		% (NOTE: This method is a bit of a kluge -- maybe someone can suggest a better
		% way!)
		if numg<nums
		   y2=[y2 zeros(1,nums-numg)];
		elseif numg>nums
		   y2(nums+1:numg)=[];
		end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			function s = shepardtone(pitch,dur,fs)
            t = 0:1/fs:dur;
            f = midi2hz(pitch);
            u = zeros(size(t));

            % Thresholds for the spectra, Krumhansl & Kessler, 1982, p341: "loudness envelope over five-octave range (
            %          from 77.8 Hz to 2349 Hz), which consisted of three parts: a gradually increasing section over the 
            %          first octave and a half, a constant section over the
            %          middle two octaves, and a symmetrically decreasing
            %          section over the last octave and a half. The
            %          corresponding amplitude of the sine wave components
            %          at each frequency was determined using the
            %          amplitude-loudness curves of Fletcher and Munson
            %          (1933), originally introduced by Shepard (1964).
            
            % Loudness envelope min and max (simpler version than suggested above)
            f_min=16;
            f_max=20000;
            
            % Number of partials needed
            f_max_part = min(f_max,fs/2);
            pl=ceil(log2(f_min/f));
            ph=floor(log2(f_max_part/f));
            partials = f*2.^(pl:ph);
                        
            % Amplitudes
            ampl = 1-cos(2*pi*(log(partials/f_min)./log((f_max)/f_min)));
            ampl = ampl/(max(ampl));
            
            % Calculate waves for the partials
            warning off
            for j=1:length(partials)
               u = u + ampl(j).*sin(2*pi*partials(j)*t);
            end
            
            % Envelope
            ramp=.1;
            envelope(1:ramp*fs)=t(1:ramp*fs).*t(1:ramp*fs);
            envelope(length(t)-ramp*fs+1:length(t))=fliplr(envelope(1:ramp*fs));
            envelope(ramp*fs:end-ramp*fs)=max(envelope);
            factor=exp(1)/max(envelope);
            y=envelope.*factor;
            s=y.*u;
            warning on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			function y4=pianosynth(note,fs,sig)
			% FM horn instrument (Moore p. 327)
			%
			% note is in duration-frequency-amplitude format
			% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

			% generate time vector
			% FM horn instrument (Moore p. 327)

			du=note(1);
			tt=0:1/fs:du;

			fc = note(2);	%carrier frequency


			
		
			tt = note(1);
			nn = round(tt * fs);
			x = [1:1:nn];
			t = 0:1/fs:du;
			y2(x) = sig_abs_filt(round(x*(48000-1)/nn) + 1);
			%plot(t,sig,'b',t,sig_abs_filt,'r'),title('ԭʼ�ź�(��ɫ)����磨��ɫ��');

			%fs = 44100; %sample rate
			music = [];
			dt = 1/fs;
			%double f;
			double freq;
			%T = 1;
			%---------------------------generate botton frequence
			    freq = 27.5 * (2^((fc - 21)/12))/2;
			%---------------------------the tone of piano
			        Af = [freq*1,987.8
				 	      freq*2,368.6
						  freq*3,620.2
						  freq*4,483.9
						  freq*5,156.7
						  freq*6,83.62
						  freq*7,120.1
						  freq*8,70.73
						  freq*9,5.348
						  freq*10,24.41
						  freq*11,27.35
						  freq*12,21.3
						  freq*13,10.31
						  freq*14,6.477
						  freq*15,15.91
						  freq*16,3.495
						  freq*17,2.546
						  freq*18,0.4751
						  freq*19,0.8858
						  freq*20,0.3792
						  freq*21,0.6012
						  freq*22,0.4224
						  freq*23,0.1538
						  freq*24,0.4154
						  freq*25,0.2032];
			%-------------------------generate envelope
				%t = [0:dt:T];
			    large = size(t);
			    tone = zeros(1,large(2));
			    stren = Af(:,2)/max(Af(:,2));
			    %mod = (10*t)./exp(10*t);
			    %mod = mod / max(mod);
			%-------------------------generate music
			    for i=1:25
			    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
			    end
				y4 = y2.*tone;
			end