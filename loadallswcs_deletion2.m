function b = loadallswcs_deletion(currentside)
% call with loadallswcs_deletion2( 'dorsal') or ('ventral')

currentsideletter = currentside(1);
dimtile = 1024;

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

xcoords = [];
ycoords = [];
zcoords = [];
xcoordso = [];
ycoordso = [];
zcoordso = [];

tbl_rounds_and_total = [];%['total rounds', 'total deleted', 'tile i', 'j'];

if currentsideletter(1:1) == 'd'
    xini = 0; %0
    xlast = 5; %5
    yini = 0; %0
    ylast = 4;  %4
elseif currentsideletter(1:1) == 'v'
    xini = 0;
    xlast = 3; %3
    yini = 0; %0
    ylast = 6; %6
else
   fprintf('Value of the side you are inputting is incorrect' );
end

%open all of the files iteratively and perform functions on them before
%writing to files. 

for i = xini:1:xlast
    for j = yini:1:ylast % cycles from left to right, first row to last row from each file
        TF = ( (i == 4 && j ==1 )|| (i == 5 && j ==2 ));
        if TF == 0
            currentfnm = ['auto_MWA17_' currentside '_tile_' num2str(i) '_' num2str(j) '.swc'];   %current file name for appropriate indices ex:'cleaned_MWA17_ventral_tile_0_0.swc'
            current_tile = [currentside '_tile_' num2str(i) '_' num2str(j) ];
            Acurr = loadswc(currentside, currentfnm); % assign Acurr as the dataset from the swc which is A in the other function
            [rounds_of_deletion, total_deleted, deg1nodes, fixedAcurr] = idbigz_deletion(Acurr, currentsideletter); 
            fixedAcurr{1}(1);
            class(fixedAcurr{1}(1));
            fixedAcurr{2}(1);
            class(fixedAcurr{2}(1));

            class(fixedAcurr{3}(1));
            fixedAcurr{3}(1);
            fixedAcurr{4}(1);
            fixedAcurr{5}(1);%#ok<ASGLU> % call function here for open file to find and eliminate big z neuron nodes
            fixedAcurr{6}(1);
            fixedAcurr{7}(1);
            xcoords = [xcoords ; fixedAcurr{3} + dimtile*i]; %dimtile*i; %abstract the 3rd column to be the x coordinates and add to the end while varying for position . 
            ycoords = [ycoords; fixedAcurr{4} + dimtile*j];   %dimtile*(j+1); %assuming y's  need to go "downward", like a matrix, we subtract a whole block then add up to the particular coordinate. 
            zcoords = [zcoords; fixedAcurr{5}]; % since x and y are moving, z is stationary. 
            xcoordso = [xcoordso ; Acurr{3} + dimtile*i] ;
            ycoordso = [ycoordso; Acurr{4} + dimtile*j]; 
            zcoordso = [zcoordso; Acurr{5}]; 
            writetoSWC(fixedAcurr, currentfnm, currentside); 
            histogram1(deg1nodes);   
            histogram2(deg1nodes);
            tbl_rounds_and_total = [tbl_rounds_and_total; rounds_of_deletion, total_deleted, i,j];
           % total_deleted_this_round = (total_deleted_this_round + count_bad_nodes);
        end
    end
end

plots();
tbl_rounds_and_total
    
% open and close file functions

function A = loadswc(currside, currfnm) % takes current side and file name as argument, opens file
        filename = fullfile('Documents','Fowlkes Lab','Lab Neuron Work',['basis_for_autocleaning_' currside],currfnm);
        fileID = fopen(filename);
        A = textscan(fileID, '%n %n %12f %12f %12f %12f %n', 'Delimiter', ' ', 'CommentStyle','#');
        % neutube uses %d %d %g %g %g %g %d\n
        fclose(fileID);
end

function g = writetoSWC(fixedAcurrent, currentfn, currside)
    %matrixA = zeroes();
    OutputFile = fullfile('Documents','Fowlkes Lab','Lab Neuron Work',['auto_fixed - ' currside],['auto_fixed_complete_deletion_at_30_' currentfn]); 
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
% function to make the histogram for all the data points
    function a = histogram1(deg1_nodes) % before trimming is done
        
        [mean,dists_3d, x_dists,y_dists,z_dists] = dist_3d(Acurr, deg1_nodes); %check for size of distances
        dists_3d_total = [dists_3d_total; dists_3d];
        x_dists_total = [x_dists_total; x_dists];
        y_dists_total = [y_dists_total; y_dists];
        z_dists_total = [z_dists_total; z_dists];
        mean_total = [mean_total;mean];

    end
    function t = histogram2(deg1_nodes) % call the distance function to calculate 3d dist after the trimming is done.
        
        deg1_nodes;
        [mean_d_nodes,dists_3d_d_nodes, x_dists_d_nodes,y_dists_d_nodes,z_dists_d_nodes] = dist_3d(fixedAcurr, deg1_nodes); %check for size of distances
        dists_3d_total_d_nodes = [dists_3d_total_d_nodes; dists_3d_d_nodes];
        x_dists_total_d_nodes = [x_dists_total_d_nodes; x_dists_d_nodes];
        y_dists_total_d_nodes = [y_dists_total_d_nodes; y_dists_d_nodes];
        z_dists_total_d_nodes = [z_dists_total_d_nodes; z_dists_d_nodes];
        mean_total_d_nodes = [mean_total_d_nodes;mean_d_nodes];

    end


    function h = plots()
        %compute stats for graphs
        mean_3d = mean(abs(dists_3d_total(:,1)));
        mean_x = mean(abs(x_dists_total(:,1)));
        mean_y = mean(abs(y_dists_total(:,1)));
        mean_z = mean(abs(z_dists_total(:,1)));
        
        mean_3d_d_nodes = mean(abs(dists_3d_total_d_nodes(:,1)));
        mean_x_d_nodes = mean(abs(x_dists_total_d_nodes(:,1)));
        mean_y_d_nodes = mean(abs(y_dists_total_d_nodes(:,1)));
        mean_z_d_nodes = mean(abs(z_dists_total_d_nodes(:,1)));
        %nbins = 20;
        bin_width = 3;
        
        
        
        figure; %plot the histogram
        subplot(2,2,1)
        histogram(dists_3d_total, 'BinWidth',bin_width)
        hold on;
        histogram(dists_3d_total_d_nodes, 'BinWidth',bin_width)
        title('3d distances');
        %axis ([-5 40 0 8000])
        hold on;
        %text(-3,5000,['mean: ' num2str(mean_3d) '  std: ' num2str(std(dists_3d_total(:,1)))]);
        xlabel([currentside ': mean pre-deletion= ' num2str(mean_3d) '  std= ' num2str(std(dists_3d_total(:,1))) ' mean post-deletion= ' num2str(mean_3d_d_nodes) '  std= ' num2str(std(dists_3d_total_d_nodes(:,1)))]);
        subplot(2,2,2)
        histogram(abs(x_dists_total), 'BinWidth',bin_width)
        hold on;
        histogram(abs(x_dists_total_d_nodes), 'BinWidth',bin_width)
        title('x distances');
        %axis ([-20 20 0 2000])
          hold on;
        %text(-15,1400,['mean: ' num2str(mean_x) '  std: ' num2str(std(x_dists_total(:,1)))]);
        xlabel([currentside ': mean pre-deletion= ' num2str(mean_x) '  std= ' num2str(std(x_dists_total(:,1)))  ' mean post-deletion= ' num2str(mean_x_d_nodes) '  std= ' num2str(std(x_dists_total_d_nodes(:,1)))]);
        subplot(2,2,3)
        histogram(abs(y_dists_total), 'BinWidth',bin_width)
        hold on;
        histogram(abs(y_dists_total_d_nodes), 'BinWidth',bin_width)
        title('y distances');
        %axis ([-20 20 0 2000])
          hold on;
        %text(-16,1400,['mean: ' num2str(mean_y) '  std: ' num2str(std(y_dists_total(:,1)))]);
        xlabel([currentside ': mean pre-deletion= ' num2str(mean_y) '  std= ' num2str(std(y_dists_total(:,1))) ' mean post-deletion= ' num2str(mean_y_d_nodes) '  std= ' num2str(std(y_dists_total_d_nodes(:,1)))]);
        subplot(2,2,4)
        histogram(abs(z_dists_total), 'BinWidth',bin_width)
        hold on;
        histogram(abs(z_dists_total_d_nodes), 'BinWidth',bin_width)
        title('z distances');
        %axis ([-3 3 0 2500])
          hold on;
        %text(-3,1500,['mean: ' num2str(mean_z) '  std: ' num2str(std(z_dists_total(:,1)))]);
        xlabel([currentside ': mean pre-deletion= ' num2str(mean_z) '  std= ' num2str(std(z_dists_total(:,1))) ' mean post-deletion= ' num2str(mean_z_d_nodes) '  std= ' num2str(std(z_dists_total_d_nodes(:,1)))]);
        %plot the coordinates
     
        figure;
        axis ij; 
        %subplot(1,2,1);
        plot3(xcoordso,ycoordso,zcoordso,'.');
        xlabel('x'); ylabel('y'); zlabel('z');
        xlabel('original coordinates');
        axis image;
        axis vis3d
        grid on

      
        figure;
        axis ij;
        %subplot(1,2,2);
        plot3(xcoords,ycoords,zcoords,'.');  
        xlabel('x'); ylabel('y'); zlabel('z');
        xlabel('new coordinates');
        axis image;
        axis vis3d
        grid on
        end
end
