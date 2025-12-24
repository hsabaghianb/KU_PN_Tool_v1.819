function indx=Place_index(PN_model, Place_Name)
   indx=0;
   i=1;
   while i<=numel(PN_model.P) && indx==0       
        if numel(PN_model.P{i})==numel(Place_Name)
            if all(PN_model.P{i}==Place_Name)
                indx=i;
            end
        end
        i=i+1;
   end
            
end
