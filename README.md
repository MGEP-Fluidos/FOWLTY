# FOWLTY
Matlab/Simulink toolbox to simulate offshore wind farms and recreate faults on different subcomponents of the turbines. 

Note that upgrades of the code will be uploaded gradually and documented in the releases section. 

For any question, problem, or query, the users are encouraged to write in the discussions on the GitHub page or an email to "ypena@mondragon.edu". However, note that providing support for this toolbox is not part of my work and the time I need to reply will depend on the amount of work I have.

# INSTALLING THE TOOLBOX
In order to use the FOLTY toolbox, the following steps should be carried out:

1.- Download the latest version of the toolbox, and add the folder (and all the subfolders) to the Matlab path.

2.- From the folder, run the "install.m" file. After this, restart Matlab. There should be a "FOWLTY" section on the Simulink library browser.

3.- Double-click on the "Farm Template" block, and follow the instructions to generate the desired farm.

4.- Once all the steps are finished, five different files should be generated in the selected folder:
   - a ".slx" file with the Simulink model of the farm;

   - a ".mat" file containing the wind information;
      
   - an initialisation file (".m") to initialise the required variables and run the Simulink farm model from MATLAB and visualise results (note that the model can also be run from Simulink once the initialisation file is run);
      
   - a function called "windRealisationGenerator.m" which can be used to generate more ".mat" wind files as specified in the next section;
      
   - and, if the faulty turbine model is selected, a file termed "faultScenarios.m" will also be included to define the desired faults.

# USING THE TOOLBOX
For the correct use of the toolbox, the following considerations should be taken into account:

1.- The wind farm is generated along with a single wind file, with a unique mean wind speed. However, it is possible to use the same wind farm with additional wind files defined for different mean wind speeds (or the same, but a different realisation of such speed). To generate more wind files, the "windRealisationGenerator.m" function can be used, specifying the original wind file and the specifications of the new desired wind. Note that it is important to select the original wind file since there are some variables (such as the wind field grid) that should be the same in order to work (since the wind farm simulink model is defined considering such variables).

2.- It is possible to define different wind turbine models using the "nrelvals.m" file located in the "nrel5mw" folder. To this end, copy such a file and define the specifications of the new turbine on the new file. Then, open the "lib_FOWLTY.slx" library in Simulink open the turbine block and create a new turbine block by copying one of the existing ones (faulty or not faulty, depending on the requirements). Then, run the previously generated Matlab file until it asks you to select the turbine block to be updated, go to Simulink, select the block you just generated, go back to the command window, and press enter. After these steps are finished, a new turbine type should appear when creating a wind farm.

3.- For a comprehensive definition of the assumptions considered, the interested reader is referred to [1].

# REFERENCING THE WORK
When using the toolbox, please, reference [1] and [2] to acknowledge the work carried out by the authors.

[1] Peña-Sanchez, Y., Penalba, M., Knudsen, T., Nava, V., & Pardo, D. (2024). Development and validation of a health-aware floating offshore wind farm simulation platform: FOWLTY. Wind Energy and Engineering Research, vol. 2, p. 100008. https://doi.org/10.1016/j.weer.2024.100008

# ACKNOWLEDGEMENTS
Special thanks to the original developers of the "SimWindFarm" toolbox, on which the FOWLTY toolbox is based:

[2] Grunnet, J. D., Soltani, M., Knudsen, T., Kragelund, M. N., & Bak, T. (2010). Aeolus toolbox for dynamics wind farm model, simulation and control. In European wind energy conference and exhibition, EWEC 2010: Conference proceedings.

This project has received funding from the European Union’s Horizon 2020 research and innovation program under the Maire Sklodowska-Curie grant agreement No. 101034297.
