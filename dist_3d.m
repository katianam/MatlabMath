function [avg, dists, xdists, ydists, zdists] = dist_3d(Data1, nodes) 


Data = cell(1,7);

if isempty(nodes) == 0 % nodes is not empty

      Data{1} = Data1{1}(nodes);
      Data{2} = Data1{2}(nodes);
      Data{3} = Data1{3}(nodes);
      Data{4} = Data1{4}(nodes);
      Data{5} = Data1{5}(nodes);
      Data{6} = Data1{6}(nodes);
      Data{7} = Data1{7}(nodes);
 else 
    Data = Data1;
 end

coords = {Data{3}, Data{4}, Data{5}};
parents = {Data{7}};
desired_dim = 9.56;
true_dim = 1.66;
dists = [];
xdists =[];
ydists =[];
zdists =[];
index = [];


for i = 1:(length(parents{1}) )

    curr_par = Data{1,7}(i);                                                                                                                    %#ok<*NASGU>
    if curr_par > 0 && mod(curr_par,1) ==0
        index = [index; i];
        xdist = abs(abs(coords{1,1}(i,1)) - abs(Data1{1,3}(curr_par,1)));
        ydist = abs(abs(coords{1,2}(i,1)) - abs(Data1{1,4}(curr_par,1)));
        zdist = abs(abs(coords{1,3}(i,1)) - abs(Data1{1,5}(curr_par,1)))*(desired_dim/true_dim);
        xdists = [xdists; xdist];
        ydists = [ydists; ydist];
        zdists = [zdists; zdist];     
        dist =  sqrt( (xdist)^2 + (ydist)^2 + (zdist)^2 );
        dists = [dists; dist];
    end
end

avg = mean(dists);
mode1 = mode(dists);
median1 = median(dists);


end