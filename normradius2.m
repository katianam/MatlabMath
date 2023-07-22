function nradius = normradius2(radius)    

for i = 1:length(radius)
if radius(i) > 4
        nradius(i) = 4;
    else 
        nradius(i) = radius(i);
    end
end 
