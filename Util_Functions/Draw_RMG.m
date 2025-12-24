function Draw_RMG(RMG)

cm = RMG.A;

%Add some extra node to cm to make sure that biograph (artificially) draw self connecting arc 
sc = find(diag(cm));
cm = cm-diag(diag(cm)); 
n = size(cm,1);
m = numel(sc);         %numer of self connecting arc
if numel(m)==0         %if there is some self connecting arc
    m=0;
end    
cm(n+m,n+m)=0;         %add m additional state (which will be used to show self connecting arc)
if numel(m)==0         %if there is some self connecting arc
   cm(sub2ind([n+m,n+m],[sc;(1:m)'+n],[(1:m)'+n;sc]))=[RMG.R(sub2ind([3,3],sc,sc)); RMG.R(sub2ind([3,3],sc,sc))];
end
bg = biograph(cm);
bg.edges(1).Label='test';
for i=1:numel(bg.nodes)
    label=num2str(i);
    label=[label,'-'];
    
    bg.nodes(i).shape='circle';
    bg.nodes(i).Color=[1,1,1];
    bg.nodes(i).TextColor=[0,0,0];
    bg.nodes(i).LineColor=[0,0,0];        
    if numel(find(i==RMG.VS))>0
        bg.nodes(i).LineWidth=0.3;
    else
        bg.nodes(i).LineWidth=1.5;        
    end
    
    if i<=size(RMG.RM,2)
        for j=1:numel(RMG.RM(:,i))
            str=num2str(RMG.RM(j,i));
            if (numel(str)>1)
                str=['(',str,')'];
            end
            label=strcat(label, str);
        end
        bg.nodes(i).Label=label;    
    end
end

bg.ShowWeights='on'; %Weight is transition number that initialized
                     %by non-zero elements of RMG.A while creating 
                     %bg by fumction call "bg = biograph(RMG.A):" 
                     
bg.Description='Reachable marking graph';

view(bg)

