function rOut = id3parse(file)
%ID3PARSE Read meta-data about your digital media from an id3 tag
%
% Note that this file does NOT OFFICIALLY COMPLY with any standards
% established by id3.org or associated parties. This script is written
% based on the ID3v2.3 informal standard: http://www.id3.org/id3v2.3.0.html
%
% TAGFRAMES = ID3PARSE(FILENAME);
% Opens the file whose path is given by
% FILENAME for reading, reads the meta-data stored in the ID3 Tag, and
% returns it in the structure TAGFRAMES. The structure's fields represent
% the titles of the various "frames" of information stored in the tag, the
% values of which are the associated data. Recognized frame's are given
% user friendly names (e.g., the TPE1 frame is labeled as 'Artist', TCON
% frame is labeled 'Genre') and have their data converted as appropriate.
% Unrecognized frames use the given 4 character frame identifier and their
% values are given as text (which may or may not be appropriate, depending
% on the content of the frame).
%
% ID3 Tags are a standard which has largely been adopted throughout the
% digital media world as a means of storing meta data about digital media
% such as MP3 audio files and MPEG video files. ID3 Tags live in the byte
% sequence that makes up a file, usually at the beginning of the file
% (which is the only place I look for it in this script). They do not
% affect the remainder of the content in the file, for instance, and MP3
% file's ID3 tag cannot affect the audio data stored in the file. Data
% stored in an ID3 Tag can be wide ranging: from the Artists and Album
% names, to the copyright information, even synchronized lyrics that can be
% presented in time to the music.
%
% Data in the tag is broken into self contained units called frames. Each
% frame has an identifier associated with it, and some arbitrarirly
% formatted data. The identifier tells knowledgable programs how to parse
% the data stored in the tag. Many tags are simple to parse, for instance
% the TPE1 or "Artist" frame simply stores text. Other tags are more
% complicated because they store more complex data, for instance, an image
% of the album cover.
%
% id3.org maintains a list of widely recognized frame identifiers and
% information on how to parse the associated data. Many of the most
% commonly used tags appearing on that list are recognized by this script.
% Frame identifiers are limited to 4 characters, but frames recognized by
% this script will receive more user friendly names for display.
% Unrecognized frames (or frames I haven't gotten around to including in
% this file) use the frame identifier for display, and assume that the data
% is textual, which is a pretty safe bet for most common frames. If an
% error occurs parsing a particular frame, e.g., the data is not formatted
% the way I was expecting, a warning is issued and the frame is reutrned as
% though it was unrecognized.
%
% For official information (techinical and non-technical) regarding ID3
% Tags see: http://www.id3.org

% Release number: 2
% Current Date: September 01 2009
% Original Date: June 07 2005
% Original Author: Brian Mearns
% Contact: bmearns#coe.neu.edu
%
% Modifications Made By Gordon Forbes:
% Made the functions more robust to errors, by specifying:
% 1) That first 3 bytes must match the 'ID3' header
% 2) That file must exist
% 3) Corrected 'convertBytesToID3Size' Function
% 4) Made List of FrameIDs to Process so that errors can be bypassed
% 5) Put check on size of framedata, so erroneous frames don'r get read


if ~exist(file,'file')
    rOut=[];
    return
end

fid = fopen(file,'r');

%% HEADER

fileId = char(fread(fid,3,'uint8')');
if ~strcmp(fileId,'ID3')
    fclose(fid);
    rout=[];
    return
end
majVersion = fread(fid,1,'uint8');
minVersion = fread(fid,1,'uint8');
headerFlags = fread(fid,1,'uint8');
headerFlags = dec2bin(headerFlags,8);
headerFlag_a = headerFlags(1) == '1';    %unsynchronized if set
headerFlag_b = headerFlags(2) == '1';    %extended header present if set
headerFlag_c = headerFlags(3) == '1';    %experimental if set.
tagSize = fread(fid,4,'uint8');
tagSize = convertBytesToID3Size(tagSize);
bytesRead = 0;

%% EXTENDED HEADER
if headerFlag_b
    
    extHeaderSize = fread(fid,4,'uint8');
    extHeaderSize = convertBytesToID3Size(extHeaderSize);
    bytesRead = bytesRead + extHeaderSize + 4;  %extHeaderSize does not index itself, it's own 4 bytes.
    
    %TODO: parse ext header more
    extHeader = fread(fid,extHeaderSize,'uint8');
    
end


%% FRAMES

frames = struct();
valid_frame_headers=gen_valid_frame_headers;
while bytesRead < tagSize;
    
    frameId = char(fread(fid,4,'uint8')');
    bytesRead = bytesRead + 4;
    
    % frameIds must be made up of A-Z and 0-9
    % if not, assume we've reached our padding.
    if double(frameId(1)) == 0
        bytesRead = tagSize;
    else
        
        frameSize = fread(fid,4,'uint8');
        bytesRead = bytesRead + 4;
        frameSize = convertBytesToID3Size(frameSize);
        
        frameFlags = fread(fid,2,'uint8');
        bytesRead = bytesRead + 2;
        frameFlags = dec2bin(frameFlags,8);
        
        frameReadOnly = frameFlags(1,3) == '1';
        frameCompressed = frameFlags(2,1) == '1';
        frameEncrypted = frameFlags(2,2) == '1';
        frameGrouping = frameFlags(2,3) == '1';
        
        if frameCompressed
            frameCompressedSize = fread(fid,4,'uint8');
            bytesRead = bytesRead + 4;
            frameCompressedSize = convertBytesToID3Size(frameCompressedSize);
            frameSize = frameSize - 4;
        end
        
        if frameEncrypted
            frameEncryptionMethod = fread(fid,1,'uint8');
            bytesRead = bytesRead + 1;
            frameSize = frameSize - 1;
        end
        
        
        if frameGrouping
            frameGroupingID = fread(fid,1,'uint8');
            bytesRead = bytesRead + 1;
            frameSize = frameSize - 1;
        end
        
        if frameSize<tagSize
            frameData = fread(fid,frameSize,'uint8')';
            bytesRead = bytesRead + frameSize;
            for k=1:length(valid_frame_headers)
                if strcmp(valid_frame_headers{k},frameId)
                    frames = proccessFrame(frames,frameId,frameData);
                    break;
                end
            end
        end
        
        
    end
    
end%while...




fclose(fid);

rOut = frames;

end%function...id3parse...


%% proccessFrame ******************************************************
function frames = proccessFrame(frames,frameId,frameData)
% FRAMES is the struct to store the frames in
% FRAMEID is the 4 byte text id for the frame
% FRAMEDATA is the frame's data bytes

try
    
    if strncmp(frameId,'T',1)
        
        textEncoding = frameData(1);
        frameData = frameData(2:end);
        idx = find(frameData == 0);
        if isempty(idx)
            idx = length(frameData);
        else
            idx = min(idx(1),length(frameData));
        end
        frameData = frameData(1:idx);
        
        switch frameId
            
            
            %% TIT2
            case 'TIT2'
                frameName = 'Title';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TALB
            case 'TALB'
                frameName = 'Album';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TBPM
            case 'TBPM'
                frameName = 'Beats per minute';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TCOM
            case 'TCOM'
                frameName = 'Composer';
                composers = parseID3List(char(frameData));
                frames = setfield(frames,frameName,composers);
                
                
                %% TCON
            case 'TCON'
                frameName = 'Genre';
                genres = {};
                while ~isempty(frameData)
                    idx = find(frameData == ')');
                    genreCode = frameData(2:idx(1)-1);
                    genreCode = str2num(char(genreCode));
                    genre = getGenre(genreCode);
                    refinement = [];
                    if isempty(idx) || idx(1) < length(frameData)
                        frameData = frameData(idx+1:end);
                        %look for an open paren followed by something OTHER
                        %THAN an open paren, and preceeded by either the
                        %beginning of the line or something OTHER THAN an open
                        %paren.
                        idx = regexp(char(frameData),'(?:[^\(]|^)(\()[^\(]');
                        if isempty(idx)
                            idx = length(frameData)
                        end
                        refinement = frameData(1:idx);
                        if(idx < length(frameData))
                            frameData = frameData(idx+1:end);
                        else
                            frameData = [];
                        end
                    else
                        frameData = [];
                    end
                    refinement = strrep(char(refinement),'((','(');
                    if length(refinement) > 0
                        refinement = [': ',refinement];
                    end
                    genre = [genre{:},refinement]
                    genres = [genres;genre];
                end
                
                
                frames = setfield(frames,frameName,genres);
                
                
                %% TCOP
            case 'TCOP'
                frameName = 'Copyright';
                frames = setfield(frames,frameName,['Copyright  ',char(frameData)]);
                
                
                %% TDAT
            case 'TDAT'
                frameName = 'Recording_Date';
                frames = setfield(frames,frameName,[char(frameData(1:2)),'-',char(frameData(3:4))] );
                
                
                %% TDLY
            case 'TDLY'
                frameName = 'Playlist_Delay';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TENC
            case 'TENC'
                frameName = 'Encoded_By';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TPE1
            case 'TPE1'
                frameName = 'Artist';
                artists = parseID3List(char(frameData));
                frames = setfield(frames,frameName,artists);
                
                
                %% TPE2
            case 'TPE2'
                frameName = 'Band';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TPE3
            case 'TPE3'
                frameName = 'Conductor';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TPE4
            case 'TPE4'
                frameName = 'Interpreted_By';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TLEN
            case 'TLEN'
                frameName = 'Length';
                ms = str2num(char(frameData));
                s = floor(ms/1000);
                ms = ms - s*1000;
                m = floor(s/60);
                s = s - 60*m;
                
                ms = int2str(ms);
                if length(ms) < 2
                    ms = ['0',ms];
                end
                
                s = int2str(s);
                if length(s) < 2
                    s = ['0',s];
                end
                
                m = int2str(m);
                
                frames = setfield(frames,frameName,sprintf('%s:%s.%s',m,s,ms));
                
                
                %% TPUB
            case 'TPUB'
                frameName = 'Publisher';
                frames = setfield(frames,frameName,char(frameData));
                
                
                %% TPOS
            case 'TPOS'
                frameName = 'Part_of_set';
                idx = find(frameData == '/');
                if isempty(idx)
                    idx = length(frameData)+1;
                end
                
                part = char(frameData(1:idx-1));
                
                of = '';
                if idx < length(frameData)
                    of = [' of ', char(frameData(idx+1:end))];
                end
                val = [part, of];
                frames = setfield(frames,frameName,val);
                
                
                %% TRCK
            case 'TRCK'
                frameName = 'Track';
                idx = find(frameData == '/');
                if isempty(idx)
                    idx = length(frameData)+1;
                end
                
                part = char(frameData(1:idx-1));
                
                of = '';
                if idx < length(frameData)
                    of = [' of ', char(frameData(idx+1:end))];
                end
                val = [part, of];
                frames = setfield(frames,frameName,val);
                
                
                %% TYER
            case 'TYER'
                frameName = 'Recording_Year';
                frames = setfield(frames,frameName,char(frameData));
                
                
                
                %% CUSTOM TEXT FRAME
            otherwise
                
                frames = setfield(frames,frameId,char(frameData));
                
                
        end%switch frameId
        
        
        
    else
        switch frameId
            
            %% UFID
            case 'UFID'
                idx = find(frameData == 0);
                ownerIdentifier = char(frameData(1:idx-1));
                identifier = frameData(idx+1:end);
                frameName = 'Unique_File_Identifier';
                if isfield(frames,frameName)
                    ufid = frames.(frameName);
                else
                    ufid = {}
                end
                
                ufid = [ufid;{ownerIdentifier,identifier}];
                
                frames.(frameName) = ufid;
                
                
                %% PRIV
            case 'PRIV'
                idx = find(frameData == 0);
                ownerIdentifier = char(frameData(1:idx-1));
                identifier = frameData(idx+1:end);
                frameName = 'Private_frame';
                if isfield(frames,frameName)
                    priv = frames.(frameName);
                else
                    priv = {};
                end
                
                priv = [priv;{ownerIdentifier,identifier}];
                
                frames = setfield(frames,frameName,priv);
                
                %% MCDI
            case 'MCDI'
                frameName = 'Music_CD_identifier';
                frames = setfield(frames,frameName,char(frameData));
                
                
                
                %% UNKNOWN FRAME
            otherwise
                frames = setField(frames,frameId,char(frameData));
        end%switch frameId
        
    end%if...else...
    
catch
    warning('ID3Parser:IllFormat:Frame','Error parsing the following frame: %s',frameId);
    frames = setField(frames,frameId,char(frameData));
end

end%function ... proccessFrame...

%% parseID3List *********************************************************
function cellArray = parseID3List(List)

cellArray = regexp(List,'([^\/]*)\/','tokens');
cellArray = [cellArray{:},regexp(List,'\/([^\/]*)$','tokens','once')];
if isempty(cellArray)
    cellArray = List;
end

end%function ... parseID3List...


%% convertBytesToID3Size ********************************************
function the_size = convertBytesToID3Size(bytes)

bytes = dec2bin(bytes,8);
bytes(:,1) = []; % remove most significant bit
the_size =bin2dec([bytes(1,:) bytes(2,:) bytes(3,:) bytes(4,:)]);


end%function ... convertBytesToID3Size...

%% getGenre *************************************************************
function genre = getGenre(idx)

persistent genres;

if isempty(genres)
    
    genres = { 'Blues' ,
        'Classic Rock' ,
        'Country' ,
        'Dance' ,
        'Disco' ,
        'Funk' ,
        'Grunge' ,
        'Hip-Hop' ,
        'Jazz' ,
        'Metal' ,
        'New Age' ,
        'Oldies' ,
        'Other' ,
        'Pop' ,
        'R&B' ,
        'Rap' ,
        'Reggae' ,
        'Rock' ,
        'Techno' ,
        'Industrial' ,
        'Alternative' ,
        'Ska' ,
        'Death Metal' ,
        'Pranks' ,
        'Soundtrack' ,
        'Euro-Techno' ,
        'Ambient' ,
        'Trip-Hop' ,
        'Vocal' ,
        'Jazz+Funk' ,
        'Fusion' ,
        'Trance' ,
        'Classical' ,
        'Instrumental' ,
        'Acid' ,
        'House' ,
        'Game' ,
        'Sound Clip' ,
        'Gospel' ,
        'Noise' ,
        'AlternRock' ,
        'Bass' ,
        'Soul' ,
        'Punk' ,
        'Space' ,
        'Meditative' ,
        'Instrumental Pop' ,
        'Instrumental Rock' ,
        'Ethnic' ,
        'Gothic' ,
        'Darkwave' ,
        'Techno-Industrial' ,
        'Electronic' ,
        'Pop-Folk' ,
        'Eurodance' ,
        'Dream' ,
        'Southern Rock' ,
        'Comedy' ,
        'Cult' ,
        'Gangsta' ,
        'Top 40' ,
        'Christian Rap' ,
        'Pop/Funk' ,
        'Jungle' ,
        'Native American' ,
        'Cabaret' ,
        'New Wave' ,
        'Psychadelic' ,
        'Rave' ,
        'Showtunes' ,
        'Trailer' ,
        'Lo-Fi' ,
        'Tribal' ,
        'Acid Punk' ,
        'Acid Jazz' ,
        'Polka' ,
        'Retro' ,
        'Musical' ,
        'Rock & Roll' ,
        'Hard Rock' ,
        };
end

genre = genres(idx+1);

end%function ... getGenre...


function out = gen_valid_frame_headers
out{1}='TALB';
out{end+1}='TBPM';
out{end+1}='TCOM';
%out{end+1}='TCON'; % TCON Was giving warning, so I removed It
out{end+1}='TCOP';
out{end+1}='TDAT';
out{end+1}='TDLY';
out{end+1}='TENC';
out{end+1}='TEXT';
out{end+1}='TFLT';
out{end+1}='TIME';
out{end+1}='TIT1';
out{end+1}='TIT2';
out{end+1}='TIT3';
out{end+1}='TKEY';
out{end+1}='TLAN';
out{end+1}='TLEN';
out{end+1}='TMED';
out{end+1}='TOAL';
out{end+1}='TOFN';
out{end+1}='TOLY';
out{end+1}='TOPE';
out{end+1}='TORY';
out{end+1}='TOWN';
out{end+1}='TPE1';
out{end+1}='TPE2';
out{end+1}='TPE3';
out{end+1}='TPE4';
out{end+1}='TPOS';
out{end+1}='TPUB';
out{end+1}='TRCK';
out{end+1}='TRDA';
out{end+1}='TRSN';
out{end+1}='TRSO';
out{end+1}='TSIZ';
out{end+1}='TSRC';
out{end+1}='TSSE';
out{end+1}='TYER';
out{end+1}='WCOM';
out{end+1}='WCOP';
out{end+1}='WOAF';
out{end+1}='WOAR';
out{end+1}='WOAS';
out{end+1}='WORS';
out{end+1}='WPAY';
out{end+1}='WPUB';

end%function ... gen_valid_frame_headers...