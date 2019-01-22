# Evacuation-Sign-Location-Simulation
This Matlab code is used for the simulation of Bowen Zhang's graduation project, Evacuation Sign Localization.  
The main work of this project is to generate the simulated real path in a floormap, then add IMU noise to the real path, which is defined as observation path. Unknown the parameters of the noise model, this project can use extra information like the boundary of the floormap, the distribution of the evacuation sign (this means you need to detect the evacuation sign with visual sensors in the real world) to reproduce the real path without noise. The method to fuse those information is to use Particle Filter. 

## Main Functions
* Simulate the sample signal of the real path  
* Add noise to the data of real path (with IMU noise model)
* Combine the data above with the data of floormap, make the prediction of the path (with Particle Filter)
* Combine the data above with the distribution of evacuation sign, make the prediction of the path (with Particle Filter)
* Design some experiments, calculate the error and draw path images

## Core Scripts Description
* MainFunction.m
  * Main entry of the simulation, handle the basic logic of the simulation
  * The main loop of this script is:  
    * Configure some control flag (like whether draw the figure out)
    * Load parameters (floormap, some basic parameters like the position of the signs), simulated real path can be generated manually or loaded the previous one
    * Generate the observation path (add noise to the real path)
    * (Optional) Use `Kalman Filter` to predict the original path
    * Use `Particle Filter` to predict the original path
  * Important Naming Rules:
    * pre- = Predicted
    * -map = The floormap of the simulation place
    * -sign = The evacuation sign in the simulation place
    * bound- = The boundary of the walking zone
    * -std = Standard deviation
    * -squ = Square deviation
* GePath_Real.m
  * Generate the simulated real path
  * Can generated manually, which needs user click several points in the floormap with mouse, then press enter
  * Can loaded the previous real path, which was generated in the same way
* GePath_Obser.m
  * Generate the observed path / Add noise to the signal of real path
  * The IMU noise model is from this[https://github.com/ethz-asl/kalibr/wiki/IMU-Noise-Model]
* PrePath_Kalman.m
  * Use Kalman Filter to predict the path
* PrePath_Map.m
  * Use Particle Filter to predict the path, which fuses data from the observed path and floormap (boundary of the walking zone)
* PrePath_Sign.m
  * Use Particle Filter to predict the path, which fuses data from the observed path and floormap (boundary of the walking zone), the distribution of evacuation sign (position of the signs)
* GetBoundaryByClick.m, GetSignCoorByClick.m
  * Script to generate some basic parameters which will be used in the main function

## Folder Description  
* \cadfile
  * Contains the floormap (png)
* \database
  * Contains the basic parameters generated from GetBoundaryByClick.m, GetSignCoorByClick.m, used for the MainFunction.m
* \finalterm
  * This script contains many experiments, which is used to evaluate the alogrithm and research the impacts from the parameters
* \lmps
  * Contains the handle script for the LMPS IMU Chip
  * This folder aims to achieve to strapdown solution for the IMU chip, but it haven't be finished
* \output
  * Contains the output images
