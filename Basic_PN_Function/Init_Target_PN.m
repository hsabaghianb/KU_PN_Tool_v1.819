function [PN_model] = Init_Target_PN(CompName)
    t=null_model_PN(CompName);
    t.Response_exclusion=0;
    t.Target_mode=1;
    t.low_level_model=null_model_PN('');
    PN_model=t;