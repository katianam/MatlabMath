function [mb_coords] = get_mb_coords(slice_num, tile_num)

    
        currfnm = 'Slice4_tile6_slice149_mb_all.txt';
       
        filename = fullfile('Documents','LPS_PC1_PB_work', 'xy_coords_of_mb','xy_coords_of_mb', currfnm);
        fileID = fopen(filename);
        mb_coords = textscan(fileID, '%12f %12f', 'Delimiter', ' ','CommentStyle','#');
        % neutube uses %d %d %g %g %g %g %d\n
        fclose(fileID);
    
end