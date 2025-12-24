function PN_model=Weighted_Arc_P2T(PN_model, Place, Trans, Arc_Weight, PI_Place_Name)
PN_model.PPre{Trans}=[PN_model.PPre{Trans},Place];
PN_model.Pre_Weight{Trans}=[PN_model.Pre_Weight{Trans},Arc_Weight];
if numel(PN_model.low_level_model(Trans).T)>0
    %find low level Places with the same place name
%     Pnum=Find_Place_With_Name_max7char(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PN_model.P{Place});
    Pnum=Find_Place_With_Name(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PI_Place_Name);
    %add that low lwvwl place to PI_Places list
    PN_model.low_level_model(Trans).PI_Places=[PN_model.low_level_model(Trans).PI_Places,Pnum];
end
PN_model.Cns{Place}=[PN_model.Cns{Place},Trans];
