function t=Init_PN_model(Name, No_of_Pl, No_of_Tr)
t.Name=Name;
t.PPre=cell(1,No_of_Tr);
t.PPost=cell(1,No_of_Tr);
t.Prd=cell(1,No_of_Pl);
t.Cns=cell(1,No_of_Pl);

t.P=cell(No_of_Pl,1);
for i=1:No_of_Pl
	t.P{i}=['P[',int2str(i),']'];
end

t.T=cell(No_of_Tr,1);
for i=1:No_of_Tr
	t.T{i}=['T[',int2str(i),']'];
end

t.Delay=zeros(1,No_of_Tr);
t.Type=zeros(1,No_of_Tr);
t.Cap=ones(1,No_of_Pl);
t.M0=zeros(1,No_of_Pl);
t.Priority=[];
