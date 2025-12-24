function PN_model=Convert_PN_Model_to_a_Caped_PN_Model(PN_model)

    %% convert the PN_Model to a Caped PN_Model
    [PN_model]=Simulate_Fast_version(PN_model,'FTsim.txt');
    Cur_Marking=Number_of_Tokens_in_Places(PN_model,1:numel(PN_model.P));
    Having_Token_Places=find(Cur_Marking>=1);
    Num_of_Token=Cur_Marking(Having_Token_Places);
    [PN_model,Cap]=New_Transition(PN_model,'Cap', 'General_func',0,0,0,1,1);
    [PN_model,EndP]=New_Place(PN_model,'EndP',0,1,{});
    PN_model=Arc_T2P(PN_model,Cap,EndP);
    for i=1:numel(Having_Token_Places)
        PN_model.M0{Having_Token_Places(i)}={};
        PN_model=Weighted_Arc_P2T(PN_model,Having_Token_Places(i),Cap,Num_of_Token(i));
        % Draw_PN_Model(PN_model);
    end
end