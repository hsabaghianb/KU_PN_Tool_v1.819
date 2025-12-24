function PN_model=Mark_Tr_and_Its_Neighbors_as_Unchecked(PN_model,fired_Tr)
%    updated_place=[PN_model.PPre{fired_Tr},PN_model.PPost{fired_Tr}];
%    for p=updated_place
%        PN_model.Tr_State(PN_model.Cns{p})=8;
%        if PN_model.Cap(p)>0  %if capacitance of place is limited
%           PN_model.Tr_State(PN_model.Prd{p})=8;
%        end
%    end

%    old_Tr_State=PN_model.Tr_State;

   PN_model.Tr_State(fired_Tr)=8;          %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   Post_place=PN_model.PPost{fired_Tr};
   Pre_place=PN_model.PPre{fired_Tr};
%    InhPre_place=PN_model.InhPPre{fired_Tr};
   for p=Post_place   
       for Tr=PN_model.Cns{p}
           if PN_model.Tr_State(Tr)==0
              PN_model.Tr_State(Tr)=8;   %mark all consumer Tr to unchecked 8
           end
       end
       for Tr=PN_model.InhCns{p}
%            if PN_model.Tr_State(Tr)==0
              PN_model.Tr_State(Tr)=8;   %mark all Inhibitor consumer Tr to unchecked 8
%            end
       end 
       
       if PN_model.Cap(p)>0  %if capacitance of place is limited
          PN_model.Tr_State(PN_model.Prd{p})=8;
       end
   end
   for p=Pre_place
       if isfield(PN_model, 'Required_Resorce_for_Trs')
           for Tr=PN_model.Cns{p}
               if PN_model.Tr_State(Tr)~=0 && PN_model.Runing(Tr)==0
                  PN_model.Tr_State(Tr)=8;  %mark all non-zero state consumer Tr to unchecked 8
               end
           end
       else
           for Tr=PN_model.Cns{p}
               if PN_model.Tr_State(Tr)~=0
                  PN_model.Tr_State(Tr)=8;  %mark all non-zero state consumer Tr to unchecked 8
               end
           end 
       end
       for Tr=PN_model.InhCns{p}
%            if PN_model.Tr_State(Tr)==0
              PN_model.Tr_State(Tr)=8;  %mark all non-zero state consumer Tr to unchecked 8
%            end
       end 
       recheck_Tr=PN_model.Cns{p};
       if isfield(PN_model, 'Required_Resorce_for_Trs')
           recheck_Tr=setdiff(recheck_Tr,find(PN_model.Runing));
       end
       PN_model.Tr_State(recheck_Tr)=8;     
       
       if PN_model.Cap(p)>0  %if capacitance of place is limited
          PN_model.Tr_State(PN_model.Prd{p})=8;
       end
   end
%     if any(old_Tr_State==3 & PN_model.Tr_State==8)
%         'stop'
%     end
   
end
