# plate-reader-data-visualization

## Setting up data file

To use this visualization, you will need to take the original data file and reformat it to fit this code.

1) Add a sheet called "Time", and paste in the time column from your data. This should have dimensions (`y` by 1), where `y` is the number of timepoints.
2) Add a sheet called "Legend", and input the label of each column from your data. This should have dimensions (1 by `x`), where `x` is the number of wells.
3) Add a sheet called "Colours", and input the hexcode for each column of your data. Same colours are recommended for each replicate group. This should have dimensions (1 by `x`), where `x` is the number of wells.
4) Add a sheet for each table of data, and paste in only the data, excluding the temperature, time, and column labels. This should have dimensions (`y` by `x`).

## Configuring the code

With the data sheet set up, you will need to configure the code to use the data you input.

1) Move the data sheet into the folder named `"data"` in this folder.
2) Replace the `filename` string with your file name, including the extension.
3) Change the `start_col` and other parameters to match the dimensions of your data in the sheets with the data from the tables.
4) Change the `num_replicates` parameter to match how many replicates were done of each sample.
5) Change the sheet names under the `Table Data Import` comment to match the sheets in your data file.
6) Run all the sections before the `Figures and Plots` section, and make sure they run without errors.
7) Run and modify the figures sections to generate the desired figures.