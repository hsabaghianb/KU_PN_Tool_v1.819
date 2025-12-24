function PN_model=Arc_T2P(PN_model, Trans, Place, PO_Place_Name)
PN_model.PPost{Trans}=[PN_model.PPost{Trans},Place];
PN_model.Post_Weight{Trans}=[PN_model.Post_Weight{Trans},1];
if numel(PN_model.low_level_model(Trans).T)>0
    %find low level Places with the same place name
%     Pnum=Find_Place_With_Name_max7char(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PN_model.P{Place});
    Pnum=Find_Place_With_Name(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PO_Place_Name);
    %add that low level place to PO_Places list
    PN_model.low_level_model(Trans).PO_Places=[PN_model.low_level_model(Trans).PO_Places,Pnum];
end
PN_model.Prd{Place}=[PN_model.Prd{Place},Trans];
