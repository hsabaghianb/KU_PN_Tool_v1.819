function [PN_model,Transaction_ID]=CLA_T4_func(PN_model,Tr)

    %Remove Token From All Pre Places
    GPL_Token={};                                %initialize with control token
    pre=PN_model.PPre{Tr};
    Pre_Weight=PN_model.Pre_Weight{Tr};
    for p=1:numel(pre)
        if PN_model.Pl_Type(pre(p))==1 && Pre_Weight(p)>numel(GPL_Token)      %if place is a Data Place(containing GPL) and the weight of its arc is greater than the other incomming arc
            GPL_Token=PN_model.M0{pre(p)}(1:Pre_Weight(p));                   %copy the data token(soppose that all input data token are the same if not this algorithm should b revised)
        end                                                  
        PN_model.M0{pre(p)}(1:Pre_Weight(p))=[];
    end
    if numel(GPL_Token)==0
        GPL_Token={[0,0,0,0]};
    end
    
    for i=1:numel(GPL_Token)
        if numel(GPL_Token{i})>=4
            GPL_Token{i}(4)=GPL_Token{i}(4)+PN_model.TknDly(Tr); 
        end
    end
% ----------------------------------------------------
if PN_model.ProbWeight(1)>0.000001
    PN_model.ProbWeight(1)=PN_model.ProbWeight(1)-0.05;
    PN_model.ProbWeight(2)=PN_model.ProbWeight(2)+0.05;
end
% ----------------------------------------------------
    %Add Token To All Post Places
    post=PN_model.PPost{Tr};
    Post_Weight=PN_model.Post_Weight{Tr};
    for p=1:numel(post)
        if PN_model.Pl_Type(post(p))==1            %if place is a Data Place
%            PN_model.M0{post(p)}=[PN_model.M0{post(p)},repmat(GPL_Token(1),1,Post_Weight(p))];
            if Post_Weight(p)<=numel(GPL_Token)
                PN_model.M0{post(p)}=[PN_model.M0{post(p)},GPL_Token(1:Post_Weight(p))];
            else
                PN_model.M0{post(p)}=[PN_model.M0{post(p)},GPL_Token,repmat({[1,0,0,0]},1,Post_Weight(p)-numel(GPL_Token))];
            end
        else
            PN_model.M0{post(p)}=[PN_model.M0{post(p)},repmat({[0,0,0,0]},1,Post_Weight(p))];
        end
    end
    Transaction_ID=GPL_Token{1}(2);