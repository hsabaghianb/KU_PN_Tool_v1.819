function Draw_TRMG_with_Probability_Arc(TRMG)

bg = biograph(TRMG.A);

%set node label
for i=1:numel(bg.nodes)
    label=num2str(i);
    label=[label,'-'];
    bg.nodes(i).shape='circle';
    
    bg.nodes(i).Color=[1,1,1];
    bg.nodes(i).LineColor=[0,0,0];
    bg.nodes(i).TextColor=[0,0,0];
    if numel(find(i==TRMG.VS))>0
        bg.nodes(i).LineWidth=0.3;
    else
        bg.nodes(i).LineWidth=1.5;        
    end
    
    for j=1:numel(TRMG.RM(:,i))
        label=strcat(label, num2str(TRMG.RM(j,i)));
    end
    
    bg.nodes(i).Label=label;    
end
bg.ShowWeights='on'; %Weight is transition number that initialized 
                     %by non-zero elements of TRMG.A while creating 
                     %bg by fumction call "bg = biograph(TRMG.A):" 

% set edge Weights with time to fire
k=1;
for i=1:numel(bg.nodes)
    for j=1:numel(bg.nodes)
        if TRMG.A(i,j)~=0  && i~=j 
           bg.Edges(k).Weight=TRMG.Pr(i,j);
           k=k+1;
        end
    end
end
h = view(bg);




