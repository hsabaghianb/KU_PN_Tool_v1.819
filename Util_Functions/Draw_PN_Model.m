function Draw_PN_Model(H)

[cm,shape,label]=make_biograph_matrix_from_PN_model(H);
shift=numel(H.P);


bg = biograph(cm);

j=0;
for i=1:numel(bg.nodes)
    if shape(i)==1
        bg.nodes(i).shape='circle';
%       bg.nodes(i).Label=label{i};

        bg.nodes(i).Label=[num2str(i),'-',label{i},',',num2str(H.Cap(i)), '(', num2str(numel(H.M0{i})), ')'];
        
        if H.Pl_Type(i)==0
            bg.nodes(i).Color=[0.85,0.85,0.85];
            bg.nodes(i).LineColor=[0,0,0];
            bg.nodes(i).TextColor=[0,0,0];
        elseif H.Pl_Type(i)==1
            bg.nodes(i).Color=[1,1,1];
            bg.nodes(i).LineColor=[0,0,0];
            bg.nodes(i).TextColor=[0,0,0];
        end
    elseif shape(i)==2
        j=j+1;
        bg.nodes(i).shape='box';                       %% 0/TrDly/Rate, TknDly, Priority, Probability
        if H.Tr_Type(i-shift)==0       %Immediate
            bg.nodes(i).Label=[num2str(j),'-',label{i},',',num2str(H.ProbWeight(i-shift)), '/', num2str(H.TknDly(i-shift)), '/', num2str(H.Priority(i-shift))];
            
            bg.nodes(i).Color=[0,0,0];
            bg.nodes(i).LineColor=[0,0,0];
            bg.nodes(i).TextColor=[1,1,1];
            bg.nodes(i).FontSize=bg.nodes(i).FontSize+2; 
            
        elseif H.Tr_Type(i-shift)==1    %Timed
            bg.nodes(i).Label=[num2str(j),'-',label{i},',',num2str(H.Delay(i-shift)), '/', num2str(H.TknDly(i-shift)), '/', num2str(H.Priority(i-shift)), '/', num2str(H.ProbWeight(i-shift))];

            bg.nodes(i).Color=[1,1,1];
            bg.nodes(i).LineColor=[0,0,0.4];
            bg.nodes(i).TextColor=[0,0,0.4];
            
        elseif H.Tr_Type(i-shift)==2    %Stochastic exponentioal
            bg.nodes(i).Label=[num2str(j),'-',label{i},', Exp(',num2str(H.Rate(i-shift)), ')/', num2str(H.TknDly(i-shift)), '/', num2str(H.Priority(i-shift)), '/', num2str(H.ProbWeight(i-shift))];
            
            bg.nodes(i).Color=[0.85,0.85,0.85];
            bg.nodes(i).LineColor=[0,0,0];
            bg.nodes(i).TextColor=[0,0,0];
            
        elseif H.Tr_Type(i-shift)==3    %Stochastic Normal Random
            bg.nodes(i).Label=[num2str(j),'-',label{i},', Norm(',num2str(H.Rate(i-shift)), ',', num2str(H.Rate2(i-shift)), ')/', num2str(H.TknDly(i-shift)), '/', num2str(H.Priority(i-shift)), '/', num2str(H.ProbWeight(i-shift))];
            
            bg.nodes(i).Color=[0.85,0.85,0.85];
            bg.nodes(i).LineColor=[0,0,0];
            bg.nodes(i).TextColor=[0,0,0];
            
        elseif H.Tr_Type(i-shift)==4    %Stochastic Uniform Random
            bg.nodes(i).Label=[num2str(j),'-',label{i},', Unif(',num2str(H.Rate(i-shift)), ',', num2str(H.Rate2(i-shift)),  ')/', num2str(H.TknDly(i-shift)), '/', num2str(H.Priority(i-shift)), '/', num2str(H.ProbWeight(i-shift))];
            
            bg.nodes(i).Color=[0.85,0.85,0.85];
            bg.nodes(i).LineColor=[0,0,0];
            bg.nodes(i).TextColor=[0,0,0];
        elseif H.Tr_Type(i-shift)>=11 && H.Tr_Type(i-shift)<=27 %BPMN Component Same as Time Transition
            bg.nodes(i).Label=[num2str(j),'-',label{i},',',num2str(H.Delay(i-shift)), '/', num2str(H.TknDly(i-shift)), '/', num2str(H.Priority(i-shift)), '/', num2str(H.ProbWeight(i-shift))];

            bg.nodes(i).Color=[1,1,1];
            bg.nodes(i).LineColor=[0,0,0.4];
            bg.nodes(i).TextColor=[0,0,0.4];
        else
            errmsg=['Error:Transition Type ', num2str(Type), ' is unknown! (in transition ''', Name, ''')'];
            error(errmsg);
        end
    end
    
end
bg.ShowWeights='on'; %Weight is arc weight

h = view(bg);
k=1;



