# Developing graphical user interface enabling fringe pattern analysis using Hilbert-Huang transform method

# Bachelor's thesis 2020 by Mateusz Koliński

A graphical user interface was developed, enabling fringe pattern analysis using Hilbert-Huang transform in MATLAB environment, employing AppDesigner application. To calculate output phase distribution only a single fringe pattern is required. Application implements the following steps:

1. Uploading a fringe pattern image with preliminary filtration using BM3D algorithm (Block-Matching and 3D filtering)

![Uploaded fringe pattern](/Assets/1Upload.png)

2. Two-dimensional empirical mode decomposition and summation of selected BIMFs
![2DEMD](/Assets/2EMD.png)

3. Calculation of fringe orientation map

![Orientation Map](/Assets/3Orient.png)

4. Smoothing fringe orientation map

![Smooeting](/Assets/4Smooth.png.png)

5. Hilbert spiral transform

![Hilbert](/Assets/5Hilbert.png.png)

6. Calculation of phase distribution

![Phase](/Assets/6Phase.png.png)

7. Phase unwrapping

![Unwrapping](/Assets/7Unwrapping.png.png)

8. Image cropping, phase distribution surface fitting and subtraction of fitted term from the phase distribution.

![Fitting](/Assets/8Fit.png.png)


The user during each step has the possibility of tailoring important parameters as well as saving every image, viewing it in a new window, changing the viewing mode, legend, color maps and tooltips. Additionally there is a possibility of saving every image from the entire application to a single file and loading them in similar fashion.
