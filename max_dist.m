function [max_xdist,max_ydist, max_zdist] = max_dist(A)
% this file is to extract information from the coordinates, such as
% distance between vessels

%determining the maximum distance from any point to a vessel

%align the xcoord values then determine biggest gap. 

xcoords = A{3}(:);
ycoords = A{4}(:);
zcoords = A{5}(:);
num_nodes = length(xcoords);
xdists = zeros(num_nodes,1);
ydists = zeros(num_nodes,1);
zdists = zeros(num_nodes,1);

xcoords_consec = sort(xcoords);
ycoords_consec = sort(ycoords);
zcoords_consec = sort(zcoords);

lx = num_nodes - 1;


for i = 1: lx
%     ith = i
%     xcoords_consec(i,1)
%     xcoords_consec(i+1,1)
%     a = (xcoords_consec(i,1) - xcoords_consec(i+1,1))
%     zcoords_consec(i,1);
%     zcoords_consec(i+1,1);

    xdists(i,1) = abs((xcoords_consec(i,1) - xcoords_consec(i+1,1)));
    ydists(i,1) = abs((ycoords_consec(i,1) - ycoords_consec(i+1,1)));
    zdists(i,1) = abs((zcoords_consec(i,1) - zcoords_consec(i+1,1)));
end
maxxcrd = max(xcoords_consec)
maxycrd = max(ycoords_consec)
maxzcrd = max(zcoords_consec)
[max_xdist,max_xdist_index] = max(xdists);
[max_ydist,max_ydist_index] = max(ydists);
[max_zdist,max_zdist_index] = max(zdists);

% x = max_xdist_index
% y = max_ydist_index
% z = max_zdist_index
coord_max_xdist = xcoords_consec(max_xdist_index); %xcoords_consec(max_xdist_index)
coord_max_ydist = ycoords_consec(max_ydist_index);
coord_max_zdist = zcoords_consec(max_zdist_index);


%3D distance computation

% for i = 1:10:1000
%     for j = 1:10:1000
%         for k = 1:10:500
%             curr_coord = (i,j,k)
%             distance 


adjusted_zdists = zdists*4.22336;
%adj_zcoords = zcoords*2.22336;
%printingZs = zdists(1:10)
bin_width = .0000001;
%plotting histoigram of distances
        figure; %plot the histogram
        subplot(2,2,1)
        histogram(xdists,'BinWidth',bin_width)
        hold on;
        title('x distances');
        axis ([-.1 1 0 10000])
        subplot(2,2,2)
        histogram(ydists,'BinWidth',bin_width)
        title('y distances');
        axis ([-.1 1 0 10000])
        hold on;
        subplot(2,2,3)
        histogram(adjusted_zdists,'BinWidth',bin_width)
        axis ([-.1 1 0 10000])
        hold on;
        title('z distances');
        hold on;
        figure; 
        histogram(adjusted_zdists,'BinWidth',bin_width/4)
        axis ([-.1 1 0 10000])
        hold on;
        title('z distances');
    
end

