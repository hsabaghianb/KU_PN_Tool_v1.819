function NumTok=Number_of_Tokens_in_Places(PN_model,Pl_List)
NumTok=[];
for p=Pl_List
    NumTok=[NumTok,numel(PN_model.M0{p})];
end