function PN_model=Remove_Place(PN_model, Place)
cns=PN_model.Cns{Place};
prd=PN_model.Prd{Place};
if numel(cns)>0 || numel(prd)>0 
   error('A place with producer or consumer can not be removed');
end
PN_model.P(Place)=[];
PN_model.Cns(Place)=[];
PN_model.Prd(Place)=[];
PN_model.InhCns(Place)=[];
PN_model.M0(Place)=[];
PN_model.Cap(Place)=[];
PN_model.Pl_Type(Place)=[];
for i=1:numel(PN_model.T)
    PN_model.PPre{i}(PN_model.PPre{i}>=Place)=PN_model.PPre{i}(PN_model.PPre{i}>=Place)-1;
    PN_model.PPost{i}(PN_model.PPost{i}>=Place)=PN_model.PPost{i}(PN_model.PPost{i}>=Place)-1;
    PN_model.InhPPre{i}(PN_model.InhPPre{i}>=Place)=PN_model.InhPPre{i}(PN_model.InhPPre{i}>=Place)-1;
end



