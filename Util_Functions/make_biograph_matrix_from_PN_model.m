function [mat,shape,label]=make_biograph_matrix_from_PN_model(H)

%First P then T Nodes in adjacency matrix
dimension=numel(H.P)+numel(H.T);
mat=zeros(dimension,dimension);
shift=numel(H.P);
for i=1:numel(H.T)
    if numel(H.Pre_Weight{i})>0   %we supposed that just one Pre Arc (Inhiitor or ordinary arc) exist for each Tr
       mat(H.PPre{i},i+shift)=H.Pre_Weight{i};
    end
    if numel(H.InhPre_Weight{i})>0 
       mat(H.InhPPre{i},i+shift)=-H.InhPre_Weight{i}; 
    end
    if numel(H.Post_Weight{i})>0    
       mat(i+shift,H.PPost{i})=H.Post_Weight{i};
    end
%     mat(H.PPre{i},i+shift)=1;
%     mat(i+shift,H.PPost{i})=1;
end

shape=ones(1,dimension);
shape(shift+1:dimension)=shape(shift+1:dimension)+1;
label=[H.P;H.T];
% oldp=[];
% contp=[];

% %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% %find old places and control places to remove from cpn_model graph drawing
% for i=1:numel(H.P)    
%     %find old places
%     if all(mat(:,i)==0) && all(mat(i,:)==0)
%         oldp=[oldp,i];
%     
%     %find control places
%     elseif numel(find(bitand(H.M0{1,i},7)==4))>0
%         contp=[contp,i];
%     end
% end

% %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% %find full control transition to remove from graph drawing
% contt=[];
% for i=1:numel(H.T)
%     [in,old_in,out]=Socket_List_of_a_Transition(H,i);
%     if all(ismember(in,contp)) && all(ismember(out,contp))
%         contt=[contt,i];
%     end
% end
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

%bypass Places except PI and PO
% All_Places_Except_PI_and_PO=setdiff(1:numel(H.P),[H.PI_Places,H.PO_Places]);
% for i=1:numel(All_Places_Except_PI_and_PO) 
%     P=All_Places_Except_PI_and_PO(i);
%     Prd=find(mat(:,P));
%     Cns=find(mat(P,:));
%     mat(Prd,Cns)=1;
% end

% hidden=[oldp,contp,H.MEM_Places,All_Places_Except_PI_and_PO,contt+shift];
% hidden=[oldp,contp,contt+shift];
% mat(:,hidden)=[];
% mat(hidden,:)=[];
% shape(hidden)=[];
% label(hidden)=[];

'done'

