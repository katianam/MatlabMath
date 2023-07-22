function [rounds_of_deletion, total_deleted,deg1_nodes,fixedA] = idbigz_deletion(Acr, currentsideletter)

deg1_nodes = [];
count_bad_nodes = 0;
desired_dim = 9.56;
true_dim =  1.66;
total_deleted = 0;
rounds_of_deletion = 0;

if currentsideletter(1:1) == '3'
    cutoff_dist = 30;
elseif currentsideletter(1:1) == '4'
    cutoff_dist = 40;
end
% Acr{6} = normradius(Acr{6});

for j = 1:20

count_bad_nodes = 0;
    for i = 1:1:length(Acr{1}) %32354 dorsal 4_1

    %     if j == 1   
           Acr{1,6}(i,1) = normradius(Acr{1,6}(i,1)); % only normalize the radius on the first run
    %     end
           self = Acr{1,1}(i,1); %which neuron is being evaluated
           parent = int16(Acr{1,7}(i,1));
           %index_parent = Acr{1}(parent);
           children = findchild(Acr, self);
           degree = finddegree(parent, children);
           if degree == 1 && (parent > 0  )     % check not a beginning (soma) or the file is mislabeled and there is not an integer in the parent spot
                 deg1_nodes = [deg1_nodes;i];
    %              if index_parent == 0
    %                  Acr{1,7}(index_parent,1) = 0;
               
                     %&& mod(Acr{1,7}(i,1),1) == 0 error handling - fixed
                
%                    gparent = int16(Acr{1,7}(parent,1)); % assign grand parent node
%                    if gparent >0  % check if grandparent is a beginning
                      %for just z distance dist(1) = abs(Acr{1,5}(i,1) - Acr{1,5}(parent,1)); %distance to parent
                      %for just z distance dist(2) = abs(Acr{1,5}(parent,1) - Acr{1,5}(gparent,1)); %distance from parent to grandparent   
                            xdist = abs(abs(Acr{1,3}(i,1)) - abs(Acr{1,3}(parent,1)));
                            ydist = abs(abs(Acr{1,4}(i,1)) - abs(Acr{1,4}(parent,1)));
                            zdist = abs(abs(Acr{1,5}(i,1)) - abs(Acr{1,5}(parent,1)))*(desired_dim/true_dim);
                            dist(1) =  sqrt( (xdist)^2 + (ydist)^2 + (zdist)^2 );

%                             xdist2 = abs((Acr{1,3}(parent,1) - Acr{1,3}(gparent,1)));
%                             ydist2 = abs((Acr{1,4}(parent,1) - Acr{1,4}(gparent,1)));
%                             zdist2 = abs((Acr{1,5}(parent,1) - Acr{1,5}(gparent,1)))*(desired_dim/true_dim);
%                             dist(2) =  sqrt( (xdist2)^2 + (ydist2)^2 + (zdist2)^2 );

%                         if min(dist) > cutoff_dist  %both parent and grandparent are too far away                  
%                                  k = find (Acr{7} == parent | Acr{7} == self ); %find those that had parent or child as their parent and move them to gparent
%                                  for l = 1: length(k) %update those that had the node we are deleting as parent to the current node being deleted's parent
%                                     Acr{1,7}(k(l),1) = gparent; %gparent is new parent
%                                 end
%                                 Acr{1,7}(parent,1) = 0; %reset  parent id  (detatch from gparent)
%                                 Acr{1,3}(parent,1) = 0;
%                                 Acr{1,4}(parent,1) = 0;
%                                 Acr{1,5}(parent,1) = 0; 
%                                 Acr{1,7}(i,1) = 0;%reset current node's parent
%                                 Acr{1,3}(i,1) = 0;
%                                 Acr{1,4}(i,1) = 0;
%                                 Acr{1,5}(i,1) = 0;   
%                                 count_bad_nodes =  count_bad_nodes +2;
                        if dist(1) > cutoff_dist               
                                k = find (Acr{7} == self); %find who has parent of node we are deleting and move to the deleted nodes old parent 
                                for l = 1: length(k) %update those that had the node we are deleting as parent to the current node being deleted's parent
                                    Acr{1,7}(k(l),1) = parent;
                                end
                                Acr{1,7}(i,1) = 0; %remove current node from parent 
                                Acr{1,3}(i,1) = 0;
                                Acr{1,4}(i,1) = 0;
                                Acr{1,5}(i,1) = 0;
                                count_bad_nodes =  count_bad_nodes +1;

                  end
           end
    end
 total_deleted_this_round = count_bad_nodes;
 
    if total_deleted_this_round == 0
    countbadnodes = count_bad_nodes;
            break
    end

 rounds_of_deletion = rounds_of_deletion + 1;
 total_deleted = total_deleted + total_deleted_this_round;
end


rounds_of_deletion;
total_deleted;

fixedA = delete_nodes(Acr); %run this when wanting to carry out deletion
%fixedA = Acr; % run this to skip deletion
size(deg1_nodes);

function child = findchild(A,slf)
    child = find(A{7} == slf);                         
end
function deg = finddegree(parent, children)
    if parent == -1
        numparents = 0;
    else
        numparents = 1;
    end
  
    TF = isempty(children);
    if TF == 1
        numchildren = 0;
    else
        numchildren = length(children);
    end
   deg = numchildren + numparents;

end
end
