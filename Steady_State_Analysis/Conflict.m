function [Conflct_Array]= Conflict(PN_model, high_Priority_Tr)
   a=zeros(1,numel(PN_model.P));
   for i=1:numel(high_Priority_Tr)
       a(PN_model.PPre{high_Priority_Tr(i)})=a(PN_model.PPre{high_Priority_Tr(i)})+1;
   end
   Conflct_Array=(a>1);
end
   
   
   