function PN_model=InhArc_P2T(PN_model,Place,Trans, PI_Place_Name)
PN_model.InhPPre{Trans}=[PN_model.InhPPre{Trans},Place];
PN_model.InhPre_Weight{Trans}=[PN_model.InhPre_Weight{Trans},1];
if numel(PN_model.low_level_model(Trans).T)>0
    %find low level Places with the same place name
%     Pnum=Find_Place_With_Name_max7char(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PN_model.P{Place});
    Pnum=Find_Place_With_Name(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PI_Place_Name);
    %add that low lwvwl place to PI_Places list
    PN_model.low_level_model(Trans).InhPI_Places=[PN_model.low_level_model(Trans).InhPI_Places,Pnum];
end
PN_model.InhCns{Place}=[PN_model.InhCns{Place},Trans];
