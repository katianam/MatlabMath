function b = loadallswcs_m(currentslice)
% call with loadallswcs_m('1') or ('2')

currentslicenumber = num2str(currentslice(1));
% currentslicenumberformat = currentslice
dimtile = 1728; %1920 is actual dimension, adjusting for 10% overlap

dists_3d_total=[];
x_dists_total = [];
y_dists_total = [];
z_dists_total = [];
mean_total = [];
x_dists_total_d_nodes = [];
y_dists_total_d_nodes = [];
z_dists_total_d_nodes = [];
dists_3d_total_d_nodes = [];
mean_total_d_nodes = [];
A_all_tiles = cell(1,7);

xcoords = [];
ycoords = [];
zcoords = [];
xcoordso = [];
ycoordso = [];
zcoordso = [];
radii = [];
mb = [];

tbl_rounds_and_total = [];%['total rounds', 'total deleted', 'tile i', 'j'];

if currentslicenumber(1:1) == '3'
    xini = 0; %0
    xlast = 0; %5
    yini = 1; %0
    ylast = 3;  %4
elseif currentslicenumber == '4'
    xini = 0;
    xlast = 0; %3
    yini = 1; %0
    ylast = 1; %6
else
   fprintf('Value of the side you are inputting is incorrect' );
end

%open all of the files iteratively and perform functions on them before
%writing to files. 

for i = xini:1:xlast
    for j = yini:1:ylast % cycles from left to right, first row to last row from each file
        TF = ( (i == 2 && j ==5 )|| (i == 3 && j ==2 )); % need to check out what this error handling was for
        if TF == 0
            currentfnm = ['LPS_PC1_slice_' currentslicenumber '_tile_' num2str(i) '_' num2str(j) '.swc'];   %current file name for appropriate indices ex:'cleaned_MWA17_ventral_tile_0_0.swc'
            current_tile = [currentslice '_tile_' num2str(i) '_' num2str(j) ];
            Acurr = loadswc(currentslice, currentfnm); % assign Acurr as the dataset from the swc which is A in the other function
            %details = whos('Acurr');
            %[rounds_of_deletion, total_deleted, deg1nodes, fixedAcurr] = idbigz_deletion(Acurr, currentslicenumber); - save this for
            %deletion later
%             rounds_of_deletion = 10; %temp fix
%             total_deleted = 100; %temp fix
%             deg1nodes = [1,2,3,4,5]; %temp fix
            fixedAcurr =  Acurr; %temp fix
%           #ok<ASGLU> % call function here for open file to find and eliminate big z neuron nodes

            xcoords = [xcoords ; fixedAcurr{3} + dimtile*i]; %dimtile*i; %abstract the 3rd column to be the x coordinates and add to the end while varying for position . 
            ycoords = [ycoords; fixedAcurr{4} + dimtile*j];   %dimtile*(j+1); %assuming y's  need to go "downward", like a matrix, we subtract a whole block then add up to the particular coordinate. 
            zcoords = [zcoords; fixedAcurr{5}*8.38]; % since x and y are moving, z is stationary. 
            
            mb_cds = get_mb_coords(127,5);
            %check_mb_cds = whos('mb_cds');
            mbx =[mb_cds{1} + dimtile*i];
            mby =[mb_cds{2} + dimtile*j];
            mbz = [mb_cds{1}*0 + (127*7.63)]; 
            %ones(length(mbx{1}),1)*(127*7.63);  
            
%             mb = [mbx,mby,mbz]
            
%             mb =[1350 + dimtile*i,650 + dimtile*j,999];
            A_all_tiles {1}= [A_all_tiles{1}; Acurr{1}+ length(xcoords)-length(fixedAcurr{3})]; %index column
            A_all_tiles {2}= [A_all_tiles{2}; Acurr{2}]; % type of "neuron"
            A_all_tiles {3}= xcoords;
            A_all_tiles {4}= ycoords;
            A_all_tiles {5}= zcoords;
            A_all_tiles {6}= [A_all_tiles{6}; Acurr{6}]; %diameter
            A_all_tiles {7}= [A_all_tiles{7}; Acurr{7}+ length(xcoords)]; % parent node
            
            [distances_cv, cv_diameter, xyzd_closest] = closest_vessel(mbx,mby,mbz, A_all_tiles);
            diameter = cv_diameter         
            
            % a marker size is 1/72 of an inch - convert neutube diameter to
            % inch then reduce by 72 to get appropriate marker size
            
            radii = [radii; fixedAcurr{6}];
            xcoordso = [xcoordso ; Acurr{3} + dimtile*i] ;
            ycoordso = [ycoordso; Acurr{4} + dimtile*j]; 
            zcoordso = [zcoordso; (Acurr{5}*8.38)]; %adjusting to appropriate dimensions for .91 micron xy pixels and 7.63 z pixels 
            writetoSWC(fixedAcurr, currentfnm, currentslicenumber); 
%             histogram1(deg1nodes);   
%             histogram2(deg1nodes);
%             tbl_rounds_and_total = [tbl_rounds_and_total; rounds_of_deletion, total_deleted, i,j];
           % total_deleted_this_round = (total_deleted_this_round + count_bad_nodes);
        end
    end
end

plots();
tbl_rounds_and_total;
    
% open and close file functions--------------------------------------------

function A = loadswc(currslice, currfnm) % takes current side and file name as argument, opens file
    
        %currfnm = 'slice_4_tile_1.swc'; %hardcoded example for error handling
        crntfn = currfnm;
        filename = fullfile('Documents','LPS_PC1_PB_work',currfnm );
        fileID = fopen(filename);
        A = textscan(fileID, '%n %n %12f %12f %12f %12f %n', 'Delimiter', ' ','CommentStyle','#');
        % neutube uses %d %d %g %g %g %g %d\n
        fclose(fileID);
    
end
%--------------------------------------------------------------------------
function g = writetoSWC(fixedAcurrent, currentfn, currslice)
    %matrixA = zeroes();
    OutputFile = fullfile('Documents','LPS_PC1_PB_work','fixed_LPS_PC1_swc_files',['auto_fixed_slice_' currslice],['auto_fixed_complete_deletion_at_trial_' currentfn]); 
    fid = fopen(OutputFile, 'w'); 
    if ~isempty(fixedAcurrent{1})
%      for J = 1: length(fixedAcurrent{1})
%          for I = 1:7
%              matrixA(J,I) = fixedAcurrent{1,I}(J,1); %put rows of cells into a matrix        
%          end
%      end
%for J = 1: length(fixedAcurrent{1})
        matrixA = [fixedAcurrent{1},fixedAcurrent{2},fixedAcurrent{3},fixedAcurrent{4}, fixedAcurrent{5}, fixedAcurrent{6}, fixedAcurrent{7}];
%end
    else 
        matrixA = [];
    end   
      matrixAT = matrixA.';
      fprintf(fid, '%12f %12f %12f %12f %12f %12f %12f \r\n', matrixAT);
  
     fclose(fid);
end
% function to make the histogram for all the data points-------------------
%     function a = histogram1(deg1_nodes) % before trimming is done
%         
%         [mean,dists_3d, x_dists,y_dists,z_dists] = dist_3d(Acurr, deg1_nodes); %check for size of distances
%         dists_3d_total = [dists_3d_total; dists_3d];
%         x_dists_total = [x_dists_total; x_dists];
%         y_dists_total = [y_dists_total; y_dists];
%         z_dists_total = [z_dists_total; z_dists];
%         mean_total = [mean_total;mean];
% 
%     end
%     function t = histogram2(deg1_nodes) % call the distance function to calculate 3d dist after the trimming is done.
%         
%         deg1_nodes;
%         [mean_d_nodes,dists_3d_d_nodes, x_dists_d_nodes,y_dists_d_nodes,z_dists_d_nodes] = dist_3d(fixedAcurr, deg1_nodes); %check for size of distances
%         dists_3d_total_d_nodes = [dists_3d_total_d_nodes; dists_3d_d_nodes];
%         x_dists_total_d_nodes = [x_dists_total_d_nodes; x_dists_d_nodes];
%         y_dists_total_d_nodes = [y_dists_total_d_nodes; y_dists_d_nodes];
%         z_dists_total_d_nodes = [z_dists_total_d_nodes; z_dists_d_nodes];
%         mean_total_d_nodes = [mean_total_d_nodes;mean_d_nodes];
% 
%     end

%--------------------------------------------------------------------------
    function h = plots()
        %compute stats for graphs
%         mean_3d = mean(abs(dists_3d_total(:,1)));
%         mean_x = mean(abs(x_dists_total(:,1)));
%         mean_y = mean(abs(y_dists_total(:,1)));
%         mean_z = mean(abs(z_dists_total(:,1)));
%         
%         mean_3d_d_nodes = mean(abs(dists_3d_total_d_nodes(:,1)));
%         mean_x_d_nodes = mean(abs(x_dists_total_d_nodes(:,1)));
%         mean_y_d_nodes = mean(abs(y_dists_total_d_nodes(:,1)));
%         mean_z_d_nodes = mean(abs(z_dists_total_d_nodes(:,1)));
%         %nbins = 20;
%         bin_width = 3;
        
%         figure; %plot the histogram
%         subplot(2,2,1)
%         histogram(dists_3d_total, 'BinWidth',bin_width)
%         hold on;
%         histogram(dists_3d_total_d_nodes, 'BinWidth',bin_width)
%         title('3d distances');
%         %axis ([-5 40 0 8000])
%         hold on;
%         %text(-3,5000,['mean: ' num2str(mean_3d) '  std: ' num2str(std(dists_3d_total(:,1)))]);
%         xlabel([currentslice ': mean pre-deletion= ' num2str(mean_3d) '  std= ' num2str(std(dists_3d_total(:,1))) ' mean post-deletion= ' num2str(mean_3d_d_nodes) '  std= ' num2str(std(dists_3d_total_d_nodes(:,1)))]);
%         subplot(2,2,2)
%         histogram(abs(x_dists_total), 'BinWidth',bin_width)
%         hold on;
%         histogram(abs(x_dists_total_d_nodes), 'BinWidth',bin_width)
%         title('x distances');
%         %axis ([-20 20 0 2000])
%           hold on;
%         %text(-15,1400,['mean: ' num2str(mean_x) '  std: ' num2str(std(x_dists_total(:,1)))]);
%         xlabel([currentslice ': mean pre-deletion= ' num2str(mean_x) '  std= ' num2str(std(x_dists_total(:,1)))  ' mean post-deletion= ' num2str(mean_x_d_nodes) '  std= ' num2str(std(x_dists_total_d_nodes(:,1)))]);
%         subplot(2,2,3)
%         histogram(abs(y_dists_total), 'BinWidth',bin_width)
%         hold on;
%         histogram(abs(y_dists_total_d_nodes), 'BinWidth',bin_width)
%         title('y distances');
%         %axis ([-20 20 0 2000])
%           hold on;
%         %text(-16,1400,['mean: ' num2str(mean_y) '  std: ' num2str(std(y_dists_total(:,1)))]);
%         xlabel([currentslice ': mean pre-deletion= ' num2str(mean_y) '  std= ' num2str(std(y_dists_total(:,1))) ' mean post-deletion= ' num2str(mean_y_d_nodes) '  std= ' num2str(std(y_dists_total_d_nodes(:,1)))]);
%         subplot(2,2,4)
%         histogram(abs(z_dists_total), 'BinWidth',bin_width)
%         hold on;
%         histogram(abs(z_dists_total_d_nodes), 'BinWidth',bin_width)
%         title('z distances');
%         %axis ([-3 3 0 2500])
%           hold on;
%         %text(-3,1500,['mean: ' num2str(mean_z) '  std: ' num2str(std(z_dists_total(:,1)))]);
%         xlabel([currentslice ': mean pre-deletion= ' num2str(mean_z) '  std= ' num2str(std(z_dists_total(:,1))) ' mean post-deletion= ' num2str(mean_z_d_nodes) '  std= ' num2str(std(z_dists_total_d_nodes(:,1)))]);
%         
%         
%         %Plot the coordinates
%         details = size(radii)
%         beg_diameters = radii(1:4)
        
%convert radius of the node to marker size (diameter I am assuming?)------
        marker_size = int16(radii*5.669291376); %micrometers to 1/72 inch*1000 for representation purposes;
%         beg_markers = marker_size(1:4)
%         radii_details = size( radii)
        
%         figure; a Matlab examople....for variable diameter width
%         markerSize = randi([5 25], 1,1); % Whatever you want...
%         lineWidth = 3; % Whatever...
%         h = plot( xcoordso,ycoordso, 'k.-', 'MarkerSize', markerSize,'LineWidth', lineWidth);
        
%         figure;
%         axis ij; 
%         %subplot(1,2,1);
%         plot3(xcoordso,ycoordso,zcoordso,'k.','MarkerSize', 3 ); %radii
%         xlabel('x'); ylabel('y'); zlabel('z'); 
%         xlabel('original coordinates');
%         axis image;
%         axis vis3d
%         grid on
     
        figure;
        axis ij;
        %subplot(1,2,2);
        plot3(xcoords,ycoords,zcoords,'k.','MarkerSize', 5); 
        xlabel('x'); ylabel('y'); zlabel('z');
        xlabel('microbleed with closest vessel');
        axis image;
        axis vis3d
        hold on 
%         plot3(mb(1),mb(2),mb(3),'r.','MarkerSize', 15); 
        plot3(mbx,mby,mbz,'r.','MarkerSize', 5);
        hold on 
        plot3(xyzd_closest(1),xyzd_closest(2),xyzd_closest(3),'b.','MarkerSize', 30); 
        grid on 
        
    end
    
        % Matlab example markerSize = randi([5 25], 1,1); % Whatever you want...
%             lineWidth = 3; % Whatever...
%             h = plot(fitresult,'b', xData, yData, 'k.-', ...
%                 'MarkerSize', markerSize, ...
%                 'LineWidth', lineWidth);
end
