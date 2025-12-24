function Display_File_in_Edit_Box(File_Path_Name)
fid = fopen(File_Path_Name);
str = textscan(fid, '%s', 'Delimiter','\n'); str = str{1};
fclose(fid);

%# GUI with multi-line editbox
hFig = figure('Menubar','none', 'Toolbar','none');
hPan = uipanel(hFig, 'Title','Display window', ...
    'Units','normalized', 'Position',[0.05 0.05 0.9 0.9]);
hEdit = uicontrol(hPan, 'Style','edit', 'FontSize',9, ...
    'Min',0, 'Max',2, 'HorizontalAlignment','Left', ...
    'Units','normalized', 'Position',[0 0 1 1], ...
    'String',str);

% % %# enable horizontal scrolling
% % jEdit = findjobj(hEdit);
% % jEditbox = jEdit.getViewport().getComponent(0);
% % jEditbox.setWrapping(false);                %# turn off word-wrapping
% % jEditbox.setEditable(false);                %# non-editable
% % set(jEdit,'HorizontalScrollBarPolicy',30);  %# HORIZONTAL_SCROLLBAR_AS_NEEDED
% % 
% % %# maintain horizontal scrollbar policy which reverts back on component resize 
% % hjEdit = handle(jEdit,'CallbackProperties');
% % set(hjEdit, 'ComponentResizedCallback',...
% %     'set(gcbo,''HorizontalScrollBarPolicy'',30)')