function [PN_model] = Init_PN(CompName)
    t=null_model_PN(CompName);
    t.low_level_model=null_model_PN('');
    PN_model=t;