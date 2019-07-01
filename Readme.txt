%%Read Me%%

To run the simulation, the following steps must be followed.

Make sure that Microsoft Office Excel is set to use the point as the decimal separator and the coma as the thousands 
separator (this is required to load the custom GPC drive cycle funtionality)

Make sure the "Powertrain Blockset Drive Cycle Data by MathWorks Automotive" Add-On is downloaded and istalled. 
This can be done from matlab itself by opening the Add-Ons page and searching for "Powertrain Blockset Drive Cycle" 
(this is needed to enable the drive cycle block containing the oficial drive cycles such as the NEDC and the EPA drive cycle)

Once the previous steps have been done, the model can be initiated. This will lad the desired vehicle layout parameters on to 
the model, as well as specify the traction conditions, be it Dry tarmac, wet tarmak, snow or ice.
To initialte the model, open the initiateModel.m script and run it. In the command prompt, specify the vehicle's parameters

Once the initiateModel.m script has been runned, the EV_basic_8_1.slx Simulink model file can be oppened and runned. If the 
previous steps have been followe, no error codes should arrise. (it is important to note that the simulation time has to be 
set by the user and will depend on the chosen drive cycle.
In extreme low friction situations, such as ice conditions for both tire surfaces, the model may get 'stuck' due to the traction 
control block not being able to keep up with the step time, in such situations, the accuracy requiremnt should be reduced and the 
minimum time step should be decreased.

Finally, once the simulation has finnished, the scopes may be opened and the vehicle's behabiour studied. To simplify the results 
analysis step, a simple script has been developed to automatically generate the most relevant plots, as well as to sotre them if needed
To run this script, open the display_plots.m file, specify the directory where they are to be saved (optional) and run the program
In the command prompt, user input will be required to specify if the results should be saved (2) or not (1).
Once runned, the figures diplaying the obtained results will be generated.

Apart from the basic simulation program, other functionality has been developed to enable the comparison of different drivetrain 
layouts by using the save_L1_data.m and save_L2_data.m, as well as the plot_to_latex_compt.m scripts. These work in a similar 
manner to the previously described proces. First the Layout 1 has to be defined using the initiateModel script and simulated 
using the simulink model. Once simulated the save_L1_data.m script must be runned, then the layout 2 can be initiated and 
simulated, and the save_L2_data.m runned. 
Finally the plot_to_LateX_comp.m script can be executed to plot the comparison plot between the Layout 1 and Layout 2.