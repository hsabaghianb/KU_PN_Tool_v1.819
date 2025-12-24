function varargout = KUPNTool(varargin)
% KUPNTOOL MATLAB code for KUPNTool.fig
%      KUPNTOOL, by itself, creates a new KUPNTOOL or raises the existing
%      singleton*.
%
%      H = KUPNTOOL returns the handle to a new KUPNTOOL or the handle to
%      the existing singleton*.
%
%      KUPNTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KUPNTOOL.M with the given input arguments.
%
%      KUPNTOOL('Property','Value',...) creates a new KUPNTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KUPNTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KUPNTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KUPNTool

% Last Modified by GUIDE v2.5 07-Jan-2018 13:21:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KUPNTool_OpeningFcn, ...
                   'gui_OutputFcn',  @KUPNTool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before KUPNTool is made visible.
function KUPNTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KUPNTool (see VARARGIN)

% Choose default command line output for KUPNTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KUPNTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KUPNTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in select_file.
function select_file_Callback(hObject, eventdata, handles)
global CurrentPath;
[PATHSTR,NAME,EXT] = fileparts(get(handles.PN_model_FileName, 'String'));
if numel(PATHSTR)==0
   PATHSTR=CurrentPath;  
end
[filename, pathname, filterindex] = uigetfile([PATHSTR,'\*.m'], 'Pick a PN model file name');
if (filename~=0)
    set(handles.PN_model_FileName, 'String', [pathname,filename]);
end

% --- Executes on button press in select_file2.
function select_file2_Callback(hObject, eventdata, handles)
global CurrentPath;
[PATHSTR,NAME,EXT] = fileparts(get(handles.PN_model_FileName, 'String'));
if numel(PATHSTR)==0
   PATHSTR=CurrentPath;  
end
[filename, pathname, filterindex] = uigetfile([PATHSTR,'\*.txt'], 'Pick a Report file name');
if (filename~=0)
    set(handles.Sim_Result_FileName, 'String', [pathname,filename]);
end


function PN_model_FileName_Callback(hObject, eventdata, handles)
% hObject    handle to PN_model_FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PN_model_FileName as text
%        str2double(get(hObject,'String')) returns contents of PN_model_FileName as a double


% --- Executes during object creation, after setting all properties.
function PN_model_FileName_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sim_Result_FileName_Callback(hObject, eventdata, handles)
% hObject    handle to Sim_Result_FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sim_Result_FileName as text
%        str2double(get(hObject,'String')) returns contents of Sim_Result_FileName as a double


% --- Executes during object creation, after setting all properties.
function Sim_Result_FileName_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxSimStep_Callback(hObject, eventdata, handles)
% hObject    handle to MaxSimStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxSimStep as text
%        str2double(get(hObject,'String')) returns contents of MaxSimStep as a double



% --- Executes during object creation, after setting all properties.
function MaxSimStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxSimStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% **********************************************************************************************
% ***************                                                                ***************
% ********                              Drawing PN Graph                                ********
% ***************                                                                ***************          
% **********************************************************************************************
function PN_graph_Callback(hObject, eventdata, handles)
[PATHSTR,NAME,EXT] = fileparts(get(handles.PN_model_FileName, 'String'));
PN_model_handle=str2func(NAME);
PN_model=PN_model_handle();
Draw_PN_Model(PN_model);


% **********************************************************************************************
% ***************                                                                ***************
% ********                             Drawing RMG and TRMG                             ********
% ***************                                                                ***************          
% **********************************************************************************************
function RMG_TRMG_Callback(hObject, eventdata, handles)
global Max_Sim_Step; 
Max_Sim_Step=str2double(get(handles.MaxSimStep,'String'));

[PATHSTR,NAME,EXT] = fileparts(get(handles.PN_model_FileName, 'String'));
PN_model_handle=str2func(NAME);
PN_model=PN_model_handle();

%Checking for hierarchy and timed token
Hierarchical=0;
for i=1:numel(PN_model.T)
    if (numel(PN_model.low_level_model(i).T)>0)
       Hierarchical=1;
    end
end
if Hierarchical==1
    disp('This option is not available for Hierarchical model in this version');  
end 

% if any(PN_model.TknDly~=0)
%     disp('This option is not available for Timed_Token model in this version');  
% end 

if Hierarchical==0 % && all(PN_model.TknDly==0)
    if all(PN_model.Tr_Type==0) %if all transitions are immediate DTMC solution will be used to find steady state probability
        % Initialize Reachable Marking Graph(RMG)
        Previous_State=1;
        first_firing_tr=[];
        PN_model = Reachable_Marking_Graph_of_SPN_ver4(PN_model,Previous_State, first_firing_tr);
        Draw_RMG(PN_model.RMG);
        
        
        
    elseif all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==1) ) %if all transitions are timed or immediat  
%         if all(PN_model.Delay==0) 
%             disp('!!!! All of timed transition have zero timed delay - Please change them to immediate and run it again');
%         else 
            %Analytical solution
            Previous_State=1;
            first_firing_tr=[];
            time2fire=[];
            Initial_Delay=0;
            PN_model=Init_Counters(PN_model);
            [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver5(PN_model, Previous_State, first_firing_tr, time2fire, Initial_Delay);
%             [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver41(PN_model, Previous_State, first_firing_tr, Initial_Delay);
%             [PN_model] = Conflict_Accurate_Reachable_Marking_Graph_of_Timed_PN_ver4(PN_model, Previous_State, first_firing_tr, Initial_Delay);
            PN_model.TRMG.VS=GTPN_Vanishing_States(PN_model.TRMG,PN_model);
            Draw_TRMG_with_Transition_on_Arc(PN_model.TRMG);
%             if numel(PN_model.TRMG.VS)>0 
%                 Reduced_TRMG=Remove_Vanishing_States_of_GTPN(PN_model.TRMG,PN_model);
%                 Draw_TRMG_with_Transition_on_Arc(Reduced_TRMG);
%             end

%         end

    elseif all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==2) ) %if all transitions are stochastic or immediate  
        % Initialize Reachable Marking Graph(RMG)
        Previous_State=1;
        first_firing_tr=[];
        PN_model = Reachable_Marking_Graph_of_SPN_ver4(PN_model,Previous_State, first_firing_tr);
        PN_model.RMG.VS=GSPN_Vanishing_States(PN_model.RMG,PN_model);
        Draw_RMG(PN_model.RMG); 
        if numel(PN_model.RMG.VS)>0 
            Reduced_RMG=Remove_Vanishing_States_of_GSPN(PN_model.RMG,PN_model);
            Draw_RMG(Reduced_RMG);
        end
    else 
        disp('Error: Steady state solution is supported for pure (Immediate, Timed and Stochastic) model...'); 
        disp('       Mixed models like Immediate-Timed and Immediate-Stochastic are also supported...'); 
        disp('       But it is not supported for mixed Timed-Stochastic model.'); 
    end
end

% **********************************************************************************************
% ***************                                                                ***************
% ********                            Drawing CTMC and DTMC                             ********
% ***************                                                                ***************          
% **********************************************************************************************
function CTMC_DTMC_Callback(hObject, eventdata, handles)
global Max_Sim_Step; 
Max_Sim_Step=str2double(get(handles.MaxSimStep,'String'));

[PATHSTR,NAME,EXT] = fileparts(get(handles.PN_model_FileName, 'String'));
PN_model_handle=str2func(NAME);
PN_model=PN_model_handle();

%Checking for hierarchy and timed token
Hierarchical=0;
for i=1:numel(PN_model.T)
    if (numel(PN_model.low_level_model(i).T)>0)
       Hierarchical=1;
    end
end
if Hierarchical==1
    disp('This option is not available for Hierarchical model in this version');  
end 

% if any(PN_model.TknDly~=0)
%     disp('This option is not available for Timed_Token model in this version');  
% end 

if Hierarchical==0 %&& all(PN_model.TknDly==0)
    
    if all(PN_model.Tr_Type==0) %if all transitions are immediate DTMC solution will be used to find steady state probability
        Previous_State=1;
        first_firing_tr=[];
        PN_model = Reachable_Marking_Graph_of_SPN_ver4(PN_model,Previous_State, first_firing_tr);
        SumProb=sum(PN_model.RMG.R,2);
        SumProb=SumProb+(SumProb==0);
        DivMat=repmat(SumProb,1,size(PN_model.RMG.R,2));
        PN_model.RMG.R=PN_model.RMG.R./(DivMat);
        Draw_DTMC_CTMC(PN_model.RMG);
    
    elseif all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==1) ) %if all transitions are timed or immediat  
%         if all(PN_model.Delay==0) 
%             disp('!!!! All of timed transition have zero timed delay - Please change them to immediate and run it again');
%         else 
            %Analytical solution
            Previous_State=1;
            first_firing_tr=[];
            time2fire=[];
            Initial_Delay=0;
            PN_model=Init_Counters(PN_model);
            [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver5(PN_model, Previous_State, first_firing_tr, time2fire, Initial_Delay);
            PN_model.TRMG.VS=GTPN_Vanishing_States(PN_model.TRMG,PN_model);
            Draw_TRMG_with_Timed_Arc(PN_model.TRMG);
            Draw_TRMG_with_Probability_Arc(PN_model.TRMG);
            if numel(PN_model.TRMG.VS)>0 
                Reduced_TRMG=Remove_Vanishing_States_of_GTPN(PN_model.TRMG,PN_model);
                Draw_TRMG_with_Timed_Arc(Reduced_TRMG);
                Draw_TRMG_with_Probability_Arc(Reduced_TRMG);
                Draw_TRMG_with_Probability_over_Time_on_Arc(Reduced_TRMG);
            end           
%         end

    elseif all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==2) ) %if all transitions are stochastic or immediate  
        Previous_State=1;
        first_firing_tr=[];
        PN_model = Reachable_Marking_Graph_of_SPN_ver4(PN_model,Previous_State, first_firing_tr);
        PN_model.RMG.VS=GSPN_Vanishing_States(PN_model.RMG,PN_model);
        PN_model.RMG = Normalaize_Probability_Weight_of_Outgoing_Tr_for_Each_State(PN_model, PN_model.RMG);   %In mixed immadiate-stochastic model RMG.R is mixed of transition rate and transition probability weight
        Draw_DTMC_CTMC(PN_model.RMG);
        if numel(PN_model.RMG.VS)>0 
            Reduced_RMG=Remove_Vanishing_States_of_GSPN(PN_model.RMG,PN_model);
            Draw_DTMC_CTMC(Reduced_RMG);
        end
    else 
        disp('Error: Steady state solution is supported for pure (Immediate, Timed and Stochastic) model...'); 
        disp('       Mixed models like Immediate-Timed and Immediate-Stochastic are also supported...'); 
        disp('       But it is not supported for mixed Timed-Stochastic model.'); 
    end
end

% **********************************************************************************************
% ***************                                                                ***************
% ********                            Steady state analysis                             ********
% ***************                                                                ***************          
% **********************************************************************************************
function steady_state_Callback(hObject, eventdata, handles)
global Max_Sim_Step; 
Max_Sim_Step=str2double(get(handles.MaxSimStep,'String'));

[PATHSTR,NAME,EXT] = fileparts(get(handles.PN_model_FileName, 'String'));
PN_model_handle=str2func(NAME);
PN_model=PN_model_handle();

%Checking for hierarchy and timed token
Hierarchical=0;
for i=1:numel(PN_model.T)
    if (numel(PN_model.low_level_model(i).T)>0)
       Hierarchical=1;
    end
end
if Hierarchical==1
    disp('This option is not available for Hierarchical model in this version');  
end 

% if any(PN_model.TknDly~=0)
%     disp('This option is not available for Timed_Token model in this version');  
% end 

if Hierarchical==0 % && all(PN_model.TknDly==0)
    if all(PN_model.Tr_Type==0) %if all transitions are immediate; DTMC solution will be used to find steady state probability
        Previous_State=1;
        first_firing_tr=[];
        PN_model = Reachable_Marking_Graph_of_SPN_ver4(PN_model,Previous_State, first_firing_tr);
        
        SumProb=sum(PN_model.RMG.R,2);
        SumProb=SumProb+(SumProb==0);
        DivMat=repmat(SumProb,1,size(PN_model.RMG.R,2));
        PN_model.RMG.R=PN_model.RMG.R./(DivMat);
        
        SumProb=sum(PN_model.RMG.R,2);
        if any(SumProb==0)  %if any deadlock
            disp('Steady state solution is not available for this model, it is not a live model');
            disp('But it is approximately solved adding a transition back to each deadlock states');
            deadlock_state=find(SumProb==0);
            other_state= SumProb~=0;
            
%             PN_model.RMG.R(deadlock_state,deadlock_state)=eye(numel(deadlock_state));
%             [P]=Steady_State_solution_for_DTMC_with_Deadlock(PN_model.RMG.R);

            PN_model.RMG.R(deadlock_state,1)=1;
            [P]=Steady_State_solution_for_DTMC(PN_model.RMG.R); 
            
            P(other_state)=0;
            P=P/sum(P);
            Print_probability_of_non_zero_probability_steady_state(PN_model.RMG.RM,P, SumProb==0);  
        else
            [P]=Steady_State_solution_for_DTMC(PN_model.RMG.R); 
            Print_states_name_and_its_steady_state_probability(PN_model.RMG.RM,P);  
        end
    elseif all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==1) ) %if all transitions are timed or immediat  
%         if all(PN_model.Delay==0) 
%             disp('!!!! All of timed transition have zero timed delay - Please change them to immediate and run it again');
%         else 
            %Analytical solution
            Previous_State=1;
            first_firing_tr=[];
            time2fire=[];
            Initial_Delay=0;
            PN_model=Init_Counters(PN_model);
            [PN_model] = Reachable_Marking_Graph_of_Timed_PN_ver5(PN_model, Previous_State, first_firing_tr, time2fire, Initial_Delay);

            PN_model.TRMG.VS=GTPN_Vanishing_States(PN_model.TRMG,PN_model);
            if numel(PN_model.TRMG.VS)>0 
                Reduced_TRMG=Remove_Vanishing_States_of_GTPN(PN_model.TRMG,PN_model);
                Q=Generation_Matrix_for_TRMG(Reduced_TRMG, PN_model);
                [P]=Steady_State_solution_for_TRMG(Reduced_TRMG,Q);
                Print_StateName_Time2Fires_and_its_steady_state_probability(Reduced_TRMG.RM,Reduced_TRMG.RMD,Reduced_TRMG.RMTD,P);  
            else
                Q=Generation_Matrix_for_TRMG(PN_model.TRMG, PN_model);
                [P]=Steady_State_solution_for_TRMG(PN_model.TRMG,Q);
                Print_StateName_Time2Fires_and_its_steady_state_probability(PN_model.TRMG.RM,PN_model.TRMG.RMD,PN_model.TRMG.RMTD,P);  
            end           

%         end

    elseif all( (PN_model.Tr_Type==0) | (PN_model.Tr_Type==2) ) %if all transitions are stochastic or immediate  
        Previous_State=1;
        first_firing_tr=[];
        PN_model = Reachable_Marking_Graph_of_SPN_ver4(PN_model,Previous_State, first_firing_tr);
        PN_model.RMG.VS=GSPN_Vanishing_States(PN_model.RMG,PN_model);
        PN_model.RMG = Normalaize_Probability_Weight_of_Outgoing_Tr_for_Each_State(PN_model, PN_model.RMG);   %In mixed immadiate-stochastic model RMG.R is mixed of transition rate and transition probability weight
        if numel(PN_model.RMG.VS)>0
            Reduced_RMG=Remove_Vanishing_States_of_GSPN(PN_model.RMG,PN_model);
            Q=Generation_Matrix_for_CTMC(Reduced_RMG);
            [P]=Steady_State_solution_for_CTMC(Q);  
            Print_states_name_and_its_steady_state_probability(Reduced_RMG.RM,P);  
        else
            Q=Generation_Matrix_for_CTMC(PN_model.RMG);
            [P]=Steady_State_solution_for_CTMC(Q);
            Print_states_name_and_its_steady_state_probability(PN_model.RMG.RM,P);  
        end
    else 
        disp('Error: Steady state solution is supported for pure (Immediate, Timed and Stochastic) model...'); 
        disp('       Mixed models like Immediate-Timed and Immediate-Stochastic are also supported...'); 
        disp('       But it is not supported for mixed Timed-Stochastic model.'); 
    end
end

% **********************************************************************************************
% ***************                                                                ***************
% ********                                Simulation                                    ********
% ***************                                                                ***************          
% **********************************************************************************************
function simulate_Callback(hObject, eventdata, handles)
global Num_of_Checked_Tr; 
global Max_Sim_Step; 
Num_of_Checked_Tr=0;
Max_Sim_Step=str2double(get(handles.MaxSimStep,'String'));
[PATHSTR,NAME,EXT] = fileparts(get(handles.PN_model_FileName, 'String'));
PN_model_handle=str2func(NAME);
PN_model=PN_model_handle();
Report_File=get(handles.Sim_Result_FileName, 'String');    
if numel(PN_model.Transition_Report_List)==0 
   PN_model.Transition_Report_List=1:numel(PN_model.T);
end
% PN_model.Transition_Report_List=1:81;
% PN_model=Simulate(PN_model, Report_File);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     PN_model=Apply_Mapping(PN_model, 14);
%             indx=Place_index(PN_model, 'P_node_in(2)');
%             PN_model.M0{indx}={[1,1,1,740*128,2]};
%             indx=Place_index(PN_model, 'P_node_idle(2)');
%             PN_model.M0{indx}(1)=[];
% dim=4;
%             PN_model.TaskCore_LogTable=zeros(dim*dim,size(PN_model.Task_table,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
[PN_model,Run_Time,Simulation_Time]=Simulate_Fast_version(PN_model, Report_File);
Display_File_in_Edit_Box(Report_File);
% Draw_PN_Model(PN_model);



% PN_model=PN_model_handle();
% % PN_model.Transition_Report_List=[];
% PN_model=Simulate_Fast_version(PN_model, 'C:\sabaghian\kashanu_research\Research_Working_Folder\KU_PN_Tool\KU_PN_Tool_v1.70\Sim_Result_Fast.txt');
% % Display_File_in_Edit_Box('C:\sabaghian\kashanu_research\Research_Working_Folder\KU_PN_Tool\KU_PN_Tool_v1.70\Sim_Result_Fast.txt');
% Num_of_Checked_Tr



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
global CurrentPath;
[CurrentPath,~,~]=fileparts(mfilename('fullpath'));
BackSlashLocs=find(CurrentPath=='\');
CurrentPath=CurrentPath(1:BackSlashLocs(end));
