function PN_model=Remove_Arc_T2P(PN_model, Trans, Place)
post=PN_model.PPost{Trans};
PN_model.PPost{Trans}(post==Place)=[];
PN_model.Post_Weight{Trans}(post==Place)=[];
% if numel(PN_model.low_level_model(Trans).T)>0
%     %find low level Places with the same place name
% %     Pnum=Find_Place_With_Name_max7char(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PN_model.P{Place});
%     Pnum=Find_Place_With_Name(PN_model.low_level_model(Trans).P, 1:numel(PN_model.low_level_model(Trans).P), PI_Place_Name);
%     %add that low lwvwl place to PI_Places list
%     PN_model.low_level_model(Trans).PI_Places=[PN_model.low_level_model(Trans).PI_Places,Pnum];
% end
Prd=PN_model.Prd{Place};
PN_model.Prd{Place}(Prd==Trans)=[];