function [PN_model,Pl_num]=New_Place(PN_model,Name,Cap,Type,Marking)
%Type=0:Control place 1:Data Place
%Cap=place capacity (0:Infinite)

Pl_num=numel(PN_model.P)+1;
PN_model.P=[PN_model.P;{Name}];
PN_model.Cap=[PN_model.Cap,Cap];
PN_model.M0=[PN_model.M0,{Marking}];
PN_model.Pl_Type=[PN_model.Pl_Type,Type];
PN_model.Prd=[PN_model.Prd,{[]}];
PN_model.Cns=[PN_model.Cns,{[]}];
PN_model.InhCns=[PN_model.InhCns,{[]}];
