


function LoadLevel(levelno)
global LevelStructure;
LevelElements = {'crate_on_empty' 'crate_on_target' 'donald_on_empty' 'donald_on_target' 'empty' 'target' 'wall'}';
LevelCharacters = {'$' '*' '@' '+' '_' '.' '#'}';
LevelImages = {'crate_on_empty.jpg' 'crate_on_target.jpg' 'donald_on_empty.jpg' 'donald_on_target.jpg' 'empty.jpg' 'target.jpg' 'wall.jpg'}';
LevelStructure = table(LevelElements, LevelCharacters, LevelImages);
LevelStructure.LevelCharacters= categorical(LevelStructure.LevelCharacters);
LevelStructure.ImageData = cellfun(@imread, LevelStructure.LevelImages, 'UniformOutput', 0);
%% Import Level
filename = cat(2, 'C:\Users\czar3k\Documents\MATLAB\Sokoban\Levels8\level_', mat2str(levelno), '.txt');
delimiter = '';
formatSpec = '%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
dataArrayCell = dataArray{1, 1};
dataArrayChar = char(dataArrayCell);
fclose(fileID);
level = dataArrayChar;
level(find(level == ' ')) = '_'
%% Clear temporary variables
clearvars filename formatSpec fileID dataArray ans;
tic;
rownum = size(level, 1);
colnum = size(level, 2);
lvl = (zeros(50 * rownum, 50 * colnum, 3));
for i = 1:rownum
    for j = 1:colnum
       % lvl((i - 1) * 50 + 1:i * 50, (j - 1) * 50 + 1:j * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == level1table(i, j)));
       lvl((i - 1) * 50 + 1:i * 50, (j - 1) * 50 + 1:j * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == level(i, j)));
    end
end 
lvl = uint8(lvl);
fig_h = figure;
addprop(fig_h,'level');
addprop(fig_h, 'lvl');
addprop(fig_h, 'levelno');
addprop(fig_h, 'moves');
set(fig_h, 'level', level);
set(fig_h, 'lvl', lvl);
set(fig_h, 'levelno', levelno);
set(fig_h, 'moves', 0);
toc;
set(fig_h,'KeyPressFcn', @key_pressed_fcn);
image(lvl);
daspect('manual')
axis equal;
axis off;
end


function key_pressed_fcn(fig_obj,eventDat)
tic;
global LevelStructure;
currentlevel = get(fig_obj, 'level');
currentlvl = get(fig_obj, 'lvl');
youpressed = get(fig_obj, 'CurrentKey');
moves = get(fig_obj, 'moves');
levelsize = size(currentlevel);
% restart
if strcmp(youpressed, 'r')
    reloadlevelno = get(fig_obj, 'levelno');
    close(fig_obj);
    LoadLevel(reloadlevelno);
    disp('Restarted');
    return
end
% next level
if strcmp(youpressed, 'n')
    reloadlevelno = get(fig_obj, 'levelno') + 1;
    close(fig_obj);
    LoadLevel(reloadlevelno);
    disp('Next level');
    return
end
% move left
if strcmp(youpressed, 'leftarrow')
    [current_pos_row, current_pos_col] = find(currentlevel == '+');
    if (isempty(current_pos_row))
       [current_pos_row, current_pos_col] = find(currentlevel == '@');
    end   
    % check if left move if possible & no crate on the left
    if (current_pos_col > 1 && (currentlevel(current_pos_row, current_pos_col - 1) == '_' | currentlevel(current_pos_row, current_pos_col - 1) == '.'))
        % move left possible & no crate on the left
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end
        if currentlevel(current_pos_row, current_pos_col - 1) == '_'
            currentlevel(current_pos_row, current_pos_col - 1) = '@';
        else    
            currentlevel(current_pos_row, current_pos_col - 1) = '+';
        end     
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col -1 - 1) * 50 + 1:(current_pos_col - 1) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col - 1)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
        % check if left move if possible & crate on the left
    if (current_pos_col > 2 && (currentlevel(current_pos_row, current_pos_col - 1) == '$' | currentlevel(current_pos_row, current_pos_col - 1) == '*') && (currentlevel(current_pos_row, current_pos_col - 2) == '_' | currentlevel(current_pos_row, current_pos_col - 2) == '.'))
        % move left possible &  crate on the left & left - 1 not outside &
        % left - 1 is empty
        % fill current position
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end   
        % fill position on the left
        if currentlevel(current_pos_row, current_pos_col - 1) == '$'
            currentlevel(current_pos_row, current_pos_col - 1) = '@';
        else    
            currentlevel(current_pos_row, current_pos_col - 1) = '+';
        end
        % fill position on the left - 1
        if currentlevel(current_pos_row, current_pos_col - 2) == '_'
            currentlevel(current_pos_row, current_pos_col - 2) = '$';
        else    
            currentlevel(current_pos_row, current_pos_col - 2) = '*';
        end
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1 - 1) * 50 + 1:(current_pos_col - 1) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col - 1)));
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1 - 2) * 50 + 1:(current_pos_col - 2) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col - 2)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
end
if strcmp(youpressed, 'rightarrow')
%     disp('Move left');
    levelsize = size(currentlevel);
    [current_pos_row, current_pos_col] = find(currentlevel == '+');
    if (isempty(current_pos_row))
       [current_pos_row, current_pos_col] = find(currentlevel == '@');
    end   
    % check if right move if possible
    if (current_pos_col < levelsize(2) && (currentlevel(current_pos_row, current_pos_col + 1) == '_' | currentlevel(current_pos_row, current_pos_col + 1) == '.'))
        % move left possible
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end
        if currentlevel(current_pos_row, current_pos_col + 1) == '_'
            currentlevel(current_pos_row, current_pos_col + 1) = '@';
        else    
            currentlevel(current_pos_row, current_pos_col + 1) = '+';
        end     
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col +1 - 1) * 50 + 1:(current_pos_col + 1) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col + 1)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
    % check if right move if possible & crate on the right
    if (current_pos_col + 1 < levelsize(2) && (currentlevel(current_pos_row, current_pos_col + 1) == '$' | currentlevel(current_pos_row, current_pos_col + 1) == '*') && (currentlevel(current_pos_row, current_pos_col + 2) == '_' | currentlevel(current_pos_row, current_pos_col + 2) == '.'))
        % move right possible &  crate on the right & right + 1 not outside &
        % right + 1 is empty
        % fill current position
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end   
        % fill position on the right
        if currentlevel(current_pos_row, current_pos_col + 1) == '$'
            currentlevel(current_pos_row, current_pos_col + 1) = '@';
        else    
            currentlevel(current_pos_row, current_pos_col + 1) = '+';
        end
        % fill position on the right + 1
        if currentlevel(current_pos_row, current_pos_col + 2) == '_'
            currentlevel(current_pos_row, current_pos_col + 2) = '$';
        else    
            currentlevel(current_pos_row, current_pos_col + 2) = '*';
        end
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1 + 1) * 50 + 1:(current_pos_col + 1) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col + 1)));
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1 + 2) * 50 + 1:(current_pos_col + 2) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col + 2)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
end
% move up
if strcmp(youpressed, 'uparrow')
    [current_pos_row, current_pos_col] = find(currentlevel == '+');
    if (isempty(current_pos_row))
       [current_pos_row, current_pos_col] = find(currentlevel == '@');
    end   
    % check if up move if possible
    if (current_pos_row > 1 && (currentlevel(current_pos_row - 1, current_pos_col) == '_' | currentlevel(current_pos_row - 1, current_pos_col) == '.'))
        % move up possible
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end
        if currentlevel(current_pos_row - 1, current_pos_col) == '_'
            currentlevel(current_pos_row - 1, current_pos_col) = '@';
        else    
            currentlevel(current_pos_row - 1, current_pos_col) = '+';
        end     
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1 - 1) * 50 + 1:(current_pos_row - 1) * 50, (current_pos_col - 1) * 50 + 1:(current_pos_col) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row - 1, current_pos_col)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
    % check if up move if possible & crate on the up
    if (current_pos_row > 2 && (currentlevel(current_pos_row - 1, current_pos_col) == '$' | currentlevel(current_pos_row - 1, current_pos_col) == '*') && (currentlevel(current_pos_row - 2, current_pos_col) == '_' | currentlevel(current_pos_row - 2, current_pos_col) == '.'))
        % move up possible &  crate on the up & up - 1 not outside &
        % up - 1 is empty
        % fill current position
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end   
        % fill position on the up
        if currentlevel(current_pos_row - 1, current_pos_col) == '$'
            currentlevel(current_pos_row - 1, current_pos_col) = '@';
        else    
            currentlevel(current_pos_row - 1, current_pos_col) = '+';
        end
        % fill position on the up - 1
        if currentlevel(current_pos_row - 2, current_pos_col) == '_'
            currentlevel(current_pos_row - 2, current_pos_col) = '$';
        else    
            currentlevel(current_pos_row - 2, current_pos_col) = '*';
        end
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1 - 1) * 50 + 1:(current_pos_row - 1) * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row - 1, current_pos_col)));
        currentlvl((current_pos_row - 1 - 2) * 50 + 1:(current_pos_row - 2) * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row - 2, current_pos_col)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
    
    
end
% move down
if strcmp(youpressed, 'downarrow')
    [current_pos_row, current_pos_col] = find(currentlevel == '+');
    if (isempty(current_pos_row))
       [current_pos_row, current_pos_col] = find(currentlevel == '@');
    end   
    % check if  down if possible
    if (current_pos_row < levelsize(1) && (currentlevel(current_pos_row + 1, current_pos_col) == '_' | currentlevel(current_pos_row + 1, current_pos_col) == '.'))
        % move down possible
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end
        if currentlevel(current_pos_row + 1, current_pos_col) == '_'
            currentlevel(current_pos_row + 1, current_pos_col) = '@';
        else    
            currentlevel(current_pos_row + 1, current_pos_col) = '+';
        end     
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1 + 1) * 50 + 1:(current_pos_row + 1) * 50, (current_pos_col - 1) * 50 + 1:(current_pos_col) * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row + 1, current_pos_col)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
    % check if down move if possible & crate on the up
    if (current_pos_row + 1 < levelsize(1) && (currentlevel(current_pos_row + 1, current_pos_col) == '$' | currentlevel(current_pos_row + 1, current_pos_col) == '*') && (currentlevel(current_pos_row + 2, current_pos_col) == '_' | currentlevel(current_pos_row + 2, current_pos_col) == '.'))
        % move down possible &  crate on the down & down + 1 not outside &
        % down + 1 is empty
        % fill current position
        if currentlevel(current_pos_row, current_pos_col) == '+'
            currentlevel(current_pos_row, current_pos_col) = '.';
        else
            currentlevel(current_pos_row, current_pos_col) = '_';
        end   
        % fill position on the up
        if currentlevel(current_pos_row + 1, current_pos_col) == '$'
            currentlevel(current_pos_row + 1, current_pos_col) = '@';
        else    
            currentlevel(current_pos_row + 1, current_pos_col) = '+';
        end
        % fill position on the down + 1
        if currentlevel(current_pos_row + 2, current_pos_col) == '_'
            currentlevel(current_pos_row + 2, current_pos_col) = '$';
        else    
            currentlevel(current_pos_row + 2, current_pos_col) = '*';
        end
        set(fig_obj, 'level', currentlevel);
        currentlvl((current_pos_row - 1) * 50 + 1:current_pos_row * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row, current_pos_col)));
        currentlvl((current_pos_row - 1 + 1) * 50 + 1:(current_pos_row + 1) * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row + 1, current_pos_col)));
        currentlvl((current_pos_row - 1 + 2) * 50 + 1:(current_pos_row + 2) * 50, (current_pos_col - 1) * 50 + 1:current_pos_col * 50,:) = cell2mat(LevelStructure.ImageData(LevelStructure.LevelCharacters == currentlevel(current_pos_row + 2, current_pos_col)));
        set(fig_obj, 'lvl', currentlvl);
        image(currentlvl);
        moves = moves + 1;
        set(fig_obj, 'moves', moves);
    end
end
fig_obj.Name = cat(2, 'No of moves: ',  mat2str(moves)); 
if isempty(find(currentlevel == '$'))
    fig_obj.Name = cat(2, 'Level Completed in ', mat2str(moves), ' moves!');
    msgbox('Congratulations!');
    leveltoload = fig_obj.levelno + 1 
    LoadLevel(leveltoload);
end
daspect('manual')
axis equal;
axis off;
toc;
end

