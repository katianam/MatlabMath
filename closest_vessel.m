function [dists, diam_single_cv, xyzd_coords_closest] = closest_vessel(mbx,mby,mbz,A_tot)
 
dists = [];
% x_close = [];
% y_close = [];
% z_close = [];

length_mbx = length(mbx)

%centroid calculation
cent_mbx = mean(mbx) 
cent_mby = mean(mby) 
cent_mbz = mean(mbz) 

min_x = cent_mbx -25; %subtracts 25 from the xcoord center to set the lower bound of where to look for vessels
min_y = cent_mby -25; 
min_z = cent_mbz -25; 

% min_x = mbx -25; %subtracts 25 from all the xcoords to set the lower bound of where to look for vessels
% min_y = mby -25; 
% min_z = mbz -25; 

max_x = cent_mbx+25; 
max_y = cent_mby+25;
max_z = cent_mbz+25; 

% max_x = mbx+25; 
% max_y = mby+25;
% max_z = mbz+25; 
 
[cvi_row, ~] = find( (A_tot{3}< max_x) & (A_tot{3} > min_x) & (A_tot{4}< max_y) & (A_tot{4} > min_y) & (A_tot{5}< max_z) & (A_tot{5} > min_z) ); %index of closest z's
xyzdcoords_close = [A_tot{3}(cvi_row), A_tot{4}(cvi_row), A_tot{5}(cvi_row), A_tot{6}(cvi_row)];

% num_vessels_close = min( length(x_close), length(y_close), length(z_close));
% cvi_check = abs(A_tot{3}(cvi_row(1),1));
% cvi_check2 = abs(mb_coords(1));
% cvi_check3 = abs(abs(A_tot{3}(cvi_row(1),1)) - abs(mb_coords(1))); 
 
for i = 1:1:2 %length(cvi_row)
    xdist = abs(abs(A_tot{3}(cvi_row(i),1)) - abs(mbx(i)));
    ydist = abs(abs(A_tot{4}(cvi_row(i),1)) - abs(mby(i)));
    zdist = abs(abs(A_tot{5}(cvi_row(i),1)) - abs(mbz(i)));
    dists(i) =  sqrt( (xdist)^2 + (ydist)^2 + (zdist)^2 );
end

threeD_dists = dists(:);
single_cvi = find(dists == (min(dists)));
diam_single_cv = (xyzdcoords_close(single_cvi,4));
xyzd_coords_closest = xyzdcoords_close(single_cvi,:);

end
% for j = 1:20
%     for i = 1:1:length(x_close)
%         xdist = abs(abs(A_tot{3}(min_x+i,1)) - abs(mb_coords(1)));
%         ydist = abs(abs(A_tot{4}(min_y+i,1)) - abs(A_tot{4}(parent,1)));
%         zdist = abs(abs(A_tot{5}(min_z +i,1)) - abs(A_tot{5}(parent,1)));
%         dist(i) =  sqrt( (xdist)^2 + (ydist)^2 + (zdist)^2 ); 
%     end
% end 

% x_close = find( (A_tot{3}< max_x)  ); %index of closest x's
% x_close = find( (A_tot{3}< max_x)  ); %index of closest x's
% x_close = find( (A_tot{3}< max_x) && (A_tot{3} > min_x) ); %index of closest x's
% y_close = find( (A_tot{4}< max_y) && (A_tot{4} > min_y) ); %index of closest y's
% z_close = find( (A_tot{5}< max_z) && (A_tot{5} > min_z) ); %index of closest z's

