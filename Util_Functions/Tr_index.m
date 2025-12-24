function indx=Tr_index(PN_model, Tr_Name)
   indx=0;
   i=1;
   while i<numel(PN_model.T) && indx==0       
        if numel(PN_model.T{i})==numel(Tr_Name)
            if all(PN_model.T{i}==Tr_Name)
                indx=i;
            end
        end
        i=i+1;
   end
            
end
