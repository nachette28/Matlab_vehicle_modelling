function createfigure1(XData1, YData1, YData2, Parent1)  %crates slip plot
%CREATEFIGURE1(XData1, YData1, YData2, Parent1)
%  XDATA1:  line xdata
%  YDATA1:  line ydata
%  YDATA2:  line ydata
%  PARENT1:  text parent

%  Auto-generated by MATLAB on 29-May-2019 09:58:40

% Create figure
figure('Tag','ScopePrintToFigure',...
    'Color',[0.156862745098039 0.156862745098039 0.156862745098039]);

% uicontainer currently does not support code generation, enter 'doc uicontainer' for correct input syntax
% In order to generate code for uicontainer, you may use GUIDE. Enter 'doc guide' for more information
% uicontainer(...);

% uicontainer currently does not support code generation, enter 'doc uicontainer' for correct input syntax
% In order to generate code for uicontainer, you may use GUIDE. Enter 'doc guide' for more information
% uicontainer(...);

% uipanel currently does not support code generation, enter 'doc uipanel' for correct input syntax
% In order to generate code for uipanel, you may use GUIDE. Enter 'doc guide' for more information
% uipanel(...);

% Create axes
axes1 = axes('Tag','DisplayAxes1_RealMag',...
    'ColorOrder',[1 1 0.0666666666666667;0.0745098039215686 0.623529411764706 1;1 0.411764705882353 0.16078431372549;0.392156862745098 0.831372549019608 0.0745098039215686;0.717647058823529 0.274509803921569 1;0.0588235294117647 1 1;1 0.0745098039215686 0.650980392156863]);
hold(axes1,'on');

% Create hgtransform
hgtransform('HitTest','off','Matrix',[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]);

% Create hgtransform
hgtransform('HitTest','off','Matrix',[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]);

% Create line
line(XData1,YData1,'DisplayName','Slip L','Tag','DisplayLine1',...
    'LineWidth',0.75,...
    'Color',[1 0 1]);

% Create line
line(XData1,YData2,'DisplayName','Slip R','Tag','DisplayLine2',...
    'LineWidth',0.75,...
    'Color',[0 0 1]);

% Create ylabel
ylabel({'Slip [%]'});

% Create xlabel
xlabel({'Time[s]'});

% Create title
title({'Wheels slip (wet and snow surfaces)'},'FontSize',12,...
    'Interpreter','none');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 600]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[-50.5230315110956 444.70728359986]);
% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-1 1]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'ClippingStyle','rectangle','GridAlpha',0.4,'GridColor',...
    [0.686274509803922 0.686274509803922 0.686274509803922],...
    'TickLabelInterpreter','none','XColor',[0 0 0],'XGrid','on','YColor',...
    [0 0 0],'YGrid','on','ZColor',[0 0 0]);
% Create legend
legend(axes1,'show');

% Create text
text('Tag','TimeOffsetStatus','Parent',Parent1,'Units','pixels',...
    'VerticalAlignment','bottom',...
    'Position',[0 0 0],...
    'Color',[0.686274509803922 0.686274509803922 0.686274509803922],...
    'Visible','on');
