function [outputArg1,outputArg2] = main_microvasc()
%This is the main function for calling the other functions loadswc,
%load_image and max_dist.  

Acurr = loadswc();%opening the file, can later pass currentfm and side

[maxDistx,maxDisty,maxDistz] = max_dist(Acurr);
load_image(Acurr);


end

