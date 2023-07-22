function [outputArg1,outputArg2] = load_image(A, max_xcoord, max_ycoord, max_zcoord)
%This plots an image from the SWC file data traced from the
%microscopy images. Creates 3D plot of vasculature

xcoords = A{3};
ycoords = A{4};
zcoords = A{5};
%adj_zcoords = zcoords*2.22336;
adj_zcoords = zcoords*4.3847;

figure;
        axis ij;
        %subplot(1,2,2);
        plot3(xcoords,ycoords,adj_zcoords,'.');  
        xlabel('x'); ylabel('y'); zlabel('z');
        xlabel('traced coordinates');
        axis image;
        axis vis3d
        grid on
end


