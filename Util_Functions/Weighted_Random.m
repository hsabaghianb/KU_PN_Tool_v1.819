function Index=Weighted_Random(Weight)
    Index=[];
    r=rand(1)*sum(Weight);
    s=0;
    i=1;
    while numel(Index)==0
        s=s+Weight(i);
        if r<s
            Index=i;
        end
        i=i+1;
    end
end