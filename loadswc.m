% this function loads an SWC file from the named folder using the correct
% character types and space as a delimiter. 

%this is for an extension to look at cleaning of the files for later
%[rounds_of_deletion, total_deleted, deg1nodes, fixedAcurr] = idbigz_deletion(Acurr, currentsideletter); 


function A = loadswc(currslice, currfnm) % takes current side and file name as argument, opens file
        
        %currfnm = 'slice_4_tile_1.swc'; LPS_PC1_slice_4_tile_0_1.swc
        %filename = fullfile('Documents','LPS_PC1_PB_work','LPS_PC1_slice_4_tile_0_1.swc');
        filename = fullfile('Documents','LPS_PC1_PB_work',currfnm);
        fileID = fopen(filename);
        A = textscan(fileID, '%n %n %12f %12f %12f %12f %n', 'Delimiter', ' ','CommentStyle','#');
        % neutube uses %d %d %g %g %g %g %d\n
        fclose(fileID);
        % this is error handling if you want to look at specific
        % coordinates
%         x1 = A{1,3}(2170,1)
%         y1 = A{1,4}(2170,1)
%         z1 = A{1,5}(2170,1)
end