function B = delete_nodes(A)
    if ~isempty(A)
        for i = 1: length(A{1})
        if  A{7}(i,1) == 0
            A{1}(i,1) = 0;
            A{2}(i,1) = 0;
            A{6}(i,1) = 0;
        end
        end
    B = A;
    end
end
