# Developing graphical user interface enabling fringe pattern analysis using Hilbert-Huang transform method

# Bachelor's thesis 2020 by Mateusz Koliński

A graphical user interface was developed, enabling fringe pattern analysis using Hilbert-Huang transform in MATLAB environment, employing AppDesigner application. To calculate output phase distribution only a single fringe pattern is required. Application implements the following steps: preliminary filtration using BM3D algorithm (Block-Matching and 3D filtering), two-dimensional empirical mode decomposition, summation of selected BIMFs, calculation of fringe orientation map, Hilbert spiral transform, calculation of phase distribution, phase unwrapping, image cropping, phase distribution surface fitting and subtraction of fitted term from the phase distribution.
The user during each step has the possibility of tailoring important parameters as well as saving every image, viewing it in a new window, changing the viewing mode, legend, color maps and tooltips. Additionally there is a possibility of saving every image from the entire application to a single file and loading them in similar fashion.
