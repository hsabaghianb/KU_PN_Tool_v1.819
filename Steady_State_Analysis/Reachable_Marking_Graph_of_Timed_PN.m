function [PN_model,TRMG] = Reachable_Marking_Graph_of_Timed_PN(PN_model,Initial_Delay)
%TRMG:Timed Reachable Marking Graph is a record of 4 field RM, RMD A and D
%TRMG.RM: Reachable Marking is a matrix each column is a marking. number of row is equal to number of places
%TRMG.RMD: Reachable Marking Delay is a matrix. column TRMG.RMD(:,k) corresponds to column TRMG.RM(:,k).
%          number of row is equal to number of tarnsitions.
%          each element of a column rpresents time to fire of corresponding transition
%TRMG.A: Adjacency Matrix. each element A(i,j) corresponds with a transition from state i to state j.  
%TRMG.D: Delay Matrix. each element D(i,j) represents the state transition delay  from state i to state j.  
%A(i,j) is a record of Tr and D. Tr is corresponding Transition and D is reminder time to fire of Tr

nofp=numel(PN_model.P);
noft=numel(PN_model.T);


error=0;
PN_model.Tr_Type(PN_model.Tr_Type==1 & PN_model.Delay==0)=0;  %find zero delayed timed transition and change them to Immediate Tr 

if any(xor(PN_model.Delay,PN_model.Tr_Type)) 
	find(xor(PN_model.Delay,PN_model.Tr_Type));
	sprintf('!!!! Transition PN_model.Tr_Type and PN_model.Delay do not coincide');
	error=1;
end
if all(PN_model.Delay==0) 
	sprintf('!!!! There is no timed transition - program can infinitelly run');
	error=2;
end 

if (error==0)
  %initialize counters
  CountT=zeros(size(PN_model.Delay,1),1);
  for k=1:noft
	if (PN_model.Tr_Type(k)==1)			%timed
		CountT(k)=PN_model.Delay(k);
	elseif (PN_model.Tr_Type(k)==2)			%stochastic
		CountT(k)=ceil(rand(1)*PN_model.Delay(k));
	elseif (PN_model.Tr_Type(k)==0)
		CountT(k)=0;
	end;
  end
  CountT_backup=CountT;

  %initialize Timed Reachable Marking Graph data structure
    TRMG.A=[];
    TRMG.D=[];
    TRMG.RM=[];
    TRMG.RMD=[];
%     TRMG.RMD=CountT';
    Previous_State=1;
    first_time_after_firing=0;
  
  %PN Player Main Cycle
  tick=Initial_Delay;
  end_flag=0;
  while ~end_flag %tick<=100 
	%generation of vector of  enabled transitions
	for k=1:noft
        x(k)=all(Number_of_Tokens_in_Places(PN_model,PN_model.PPre{k})>0) && all(Number_of_Tokens_in_Places(PN_model,PN_model.PPost{k})<PN_model.Cap(PN_model.PPost{k}) | PN_model.Cap(PN_model.PPost{k})==0 );  			% x - enabled transition
        %set again counter of not enabled transition  
        if x(k)==0						
            if (PN_model.Tr_Type(k)==1)			%timed
                CountT(k)=PN_model.Delay(k);
            elseif (PN_model.Tr_Type(k)==2)			%stochastic
                CountT(k)=ceil(rand(1)*PN_model.Delay(k));
            end
        end
    end
    if first_time_after_firing
        CountT_backup=CountT;
        first_time_after_firing=0;
    end
    
	if (~any(x)) 
		sprintf('!!!! deadlock');
        end_flag=1;
	end		
	y=x & (~CountT);                  			% y - enabled transition with CountT=0

	if (any(y) && ~end_flag) 

        %Add new state to TRMG
        Cur_Marking=Number_of_Tokens_in_Places(PN_model,2:numel(PN_model.P));
        TRMG.RM=[TRMG.RM,Cur_Marking'];  %Add marking to RM
        TRMG.RMD=[TRMG.RMD,CountT_backup'];     %Add delayes to RMD

        if size(TRMG.RM,2)>1
            %check for duplication
            Compare_RM_Mat= TRMG.RM(:,1:end-1)==repmat(TRMG.RM(:,end),1,size(TRMG.RM,2)-1);
            Compare_RMD_Mat= TRMG.RMD(:,1:end-1)==repmat(TRMG.RMD(:,end),1,size(TRMG.RMD,2)-1);
            duplicated_Column_index=find(all(Compare_RM_Mat) & all(Compare_RMD_Mat));
            if numel(duplicated_Column_index)==0              %if it was not repeated
                Next_State=size(TRMG.RM,2);                     %Accept recently added state as next state      
            else                                            %else
                Next_State=duplicated_Column_index;             %remove recently added state and consider the old copy as next state
                TRMG.RM(:,end)=[];
                TRMG.RMD(:,end)=[];
                end_flag=1;
            end
            TRMG.A(Previous_State,Next_State)=fir;                          %Add firing Tr as a link from previous to next state into the adjacency matrix TRMG.A 
            TRMG.D(Previous_State,Next_State)=TRMG.RMD(fir,Previous_State); %Add time to fire of Tr as a link from previous to next state into the adjacency matrix TRMG.D
            Previous_State=Next_State;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                            Firing just one of enabled Transition
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%random selection of transition which fires and fire it 
		[m,fir]=max(rand(size(y)).*y+PN_model.Priority.*y);
        
        %Remove Token From All Pre Places
        GPL_Token=[0,0];                                %initialize with control token
        pre=PN_model.PPre{fir};
        for p=1:numel(pre)
            if PN_model.Pl_Type(pre(p))==1              %if place is a Data Place(containing GPL)
                GPL_Token=PN_model.M0{pre(p)}(1);       %copy the data token(soppose that all input data token are the same if not this algorithm should b revised)
            end
            PN_model.M0{pre(p)}(1)=[];
        end

        %Add Token To All Post Places
        post=PN_model.PPost{fir};
        for p=1:numel(post)
            if PN_model.Pl_Type(post(p))==1            %if place is a Data Place(containing GPL)
                PN_model.M0{post(p)}=[PN_model.M0{post(p)},GPL_Token];
            else
                PN_model.M0{post(p)}=[PN_model.M0{post(p)},{[0,0]}];
            end
        end
        first_time_after_firing=1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %         %Add new state to TRMG
% % %             Cur_Marking=Number_of_Tokens_in_Places(PN_model,2:numel(PN_model.P));
% % %             Compare_RM_Mat=TRMG.RM==repmat(Cur_Marking',1,size(TRMG.RM,2));
% % %             
% % %             Compare_RMD_Mat=TRMG.RMD==repmat(CountT_backup',1,size(TRMG.RMD,2));
% % %             Next_State=find(all(Compare_RM_Mat) & all(Compare_RMD_Mat));
% % %             if numel(Next_State)==0
% % %                 TRMG.RM=[TRMG.RM,Cur_Marking'];
% % %                 Next_State=size(TRMG.RM,2);
% % %             else
% % %                 end_flag=1;
% % %             end
% % %             TRMG.A(Previous_State,Next_State)=fir;
% % %             TRMG.D(Previous_State,Next_State)=TRMG.RMD(fir,Previous_State);
% % %             Previous_State=Next_State;
% % %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
% %         %set counter of fired transition - single server semantics
% %         if (PN_model.Tr_Type(fir)==1)				%timed
% %             CountT(fir)=PN_model.Delay(fir);
% %         elseif (PN_model.Tr_Type(fir)==2)			%stochastic
% % 			CountT(fir)=ceil(rand(1)*PN_model.Delay(fir));
% %         end
	else
      	%changing counters for enabled timed and stochast transition
		tick=tick+1;
		if (rem(tick,100)==0)
			%sprintf('Tick %i',tick)
		end
		CountT=((CountT-1).*(x & PN_model.Tr_Type)) + (CountT.*(~(x & PN_model.Tr_Type)));   
		if (any(CountT<0)) 
			sprintf('!!!!negative time');
		end
	end
  end %Main Cycle

end %endif
% TRMG.RM(:,1:Next_State-1)=[];
% TRMG.RMD(:,1:Next_State-1)=[];
% TRMG.A(:,1:Next_State-1)=[];
% TRMG.A(1:Next_State-1,:)=[];
% TRMG.D(:,1:Next_State-1)=[];
% TRMG.D(1:Next_State-1,:)=[];
