function [Run_Time, Sim_Time] = SSS_of_Modelscheduling(Tr_Delay, max_Tr_firing)
tic;

%initialize simulation clock
SimClk=0;
Tr_firing_count=0;

%assign initial marking to each place as a cellarray
P1 = {[1 1 0 0 0 ]};
P2 = {};
P3 = {};
P4 = {[1 1 0 0 0 ]};
P5 = {};
P6 = {};
P7 = {[0 1 0 0 0 ]};

%Initialize counter for timed transitions
TrCntr = Tr_Delay;
EnabledTimedTr=zeros(1,6);

Timed_dead_lock=0;
while (Timed_dead_lock==0) && (Tr_firing_count <= max_Tr_firing)
	Timed_dead_lock=1;

	MinTrCntr=max(TrCntr);

	Imm_dead_lock=0;
	while (Imm_dead_lock==0)  && (Tr_firing_count <= max_Tr_firing)
		Imm_dead_lock=1;

		%-----------------------------------------------------
		%---------------- Immediate Transitions --------------
		%-----------------------------------------------------
		EnabledCns=[];
		EnabledCnsProbWeit=[];

		%Check precondition and firing of transition t2
		if numel(P2)>=1 && numel(P7)>=1
			EnabledCns=[EnabledCns,2];
			EnabledCnsProbWeit=[EnabledCnsProbWeit,1];
		end

		%Check precondition and firing of transition t5
		if numel(P5)>=1 && numel(P7)>=1
			EnabledCns=[EnabledCns,5];
			EnabledCnsProbWeit=[EnabledCnsProbWeit,1];
		end
		if numel(EnabledCns)>0
			if numel(EnabledCns)>1
				r=rand*sum(EnabledCnsProbWeit);
				i=1;
				while r>0
					r=r-EnabledCnsProbWeit(i);
					i=i+1;
				end
				Selected_Cns=EnabledCns(i-1);
			else
				Selected_Cns=EnabledCns(1);
			end

			switch Selected_Cns
				case 2
					Imm_dead_lock=0;
			Tr_firing_count=Tr_firing_count+1;
					%remove token from input places
					P2(1:1)=[];
					P7(1:1)=[];
					%add tokens to the output places
					P3=[P3,repmat({[1,0,0,0]},1,1)];
				case 5
					Imm_dead_lock=0;
			Tr_firing_count=Tr_firing_count+1;
					%remove token from input places
					P5(1:1)=[];
					P7(1:1)=[];
					%add tokens to the output places
					P6=[P6,repmat({[1,0,0,0]},1,1)];
			end   %of Switch
		end

		%-----------------------------------------------------
		%------------------ Timed Transitions ----------------
		%-----------------------------------------------------

		%Check precondition and firing of transition t1
		if numel(P1)>=1			Timed_dead_lock=0;
			if TrCntr(1) <= 0
				Tr_firing_count=Tr_firing_count+1;
				Imm_dead_lock=0;
				%remove token from input places
				P1(1:1)=[];
				%add tokens to the output places
				P2=[P2,repmat({[1,0,0,0]},1,1)];
				TrCntr(1)=Tr_Delay(1);
				EnabledTimedTr(1)=0;
			else
				MinTrCntr=min([MinTrCntr,TrCntr(1)]);
				EnabledTimedTr(1)=1;
			end
		else
			TrCntr(1)=Tr_Delay(1);
				EnabledTimedTr(1)=0;
		end

		%Check precondition and firing of transition t3
		if numel(P3)>=1			Timed_dead_lock=0;
			if TrCntr(3) <= 0
				Tr_firing_count=Tr_firing_count+1;
				Imm_dead_lock=0;
				%remove token from input places
				P3(1:1)=[];
				%add tokens to the output places
				P1=[P1,repmat({[1,0,0,0]},1,1)];
				P7=[P7,repmat({[1,0,0,0]},1,1)];
				TrCntr(3)=Tr_Delay(3);
				EnabledTimedTr(3)=0;
			else
				MinTrCntr=min([MinTrCntr,TrCntr(3)]);
				EnabledTimedTr(3)=1;
			end
		else
			TrCntr(3)=Tr_Delay(3);
				EnabledTimedTr(3)=0;
		end

		%Check precondition and firing of transition t4
		if numel(P4)>=1			Timed_dead_lock=0;
			if TrCntr(4) <= 0
				Tr_firing_count=Tr_firing_count+1;
				Imm_dead_lock=0;
				%remove token from input places
				P4(1:1)=[];
				%add tokens to the output places
				P5=[P5,repmat({[1,0,0,0]},1,1)];
				TrCntr(4)=Tr_Delay(4);
				EnabledTimedTr(4)=0;
			else
				MinTrCntr=min([MinTrCntr,TrCntr(4)]);
				EnabledTimedTr(4)=1;
			end
		else
			TrCntr(4)=Tr_Delay(4);
				EnabledTimedTr(4)=0;
		end

		%Check precondition and firing of transition t6
		if numel(P6)>=1			Timed_dead_lock=0;
			if TrCntr(6) <= 0
				Tr_firing_count=Tr_firing_count+1;
				Imm_dead_lock=0;
				%remove token from input places
				P6(1:1)=[];
				%add tokens to the output places
				P4=[P4,repmat({[1,0,0,0]},1,1)];
				P7=[P7,repmat({[1,0,0,0]},1,1)];
				TrCntr(6)=Tr_Delay(6);
				EnabledTimedTr(6)=0;
			else
				MinTrCntr=min([MinTrCntr,TrCntr(6)]);
				EnabledTimedTr(6)=1;
			end
		else
			TrCntr(6)=Tr_Delay(6);
				EnabledTimedTr(6)=0;
		end

	end %of while Imm_dead_lock

	%Improve Simulation Clock
	SimClk=SimClk+MinTrCntr;

	%Decrease TrCntr of Enabled Tr
	TrCntr(EnabledTimedTr==1)=TrCntr(EnabledTimedTr==1)-MinTrCntr;

end %of while Timed_dead_lock

Run_Time=SimClk;
Sim_Time=toc;
