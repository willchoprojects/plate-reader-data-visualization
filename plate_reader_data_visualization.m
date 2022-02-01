%% Initialization

clear
close all
clc

filename = "01-28-22 LacIP sensors plate reader S7 LB.xlsx";
filepath = "data/" + filename;

%% Data Import

start_col = "A";
end_col = "AJ";
start_row = "1";
end_row = "79";

num_replicates = 3;

% Only cells with data for range
time = xlsread(filepath, "Time", start_col + start_row + ":" + start_col + end_row);
[~, legend_text, ~] = xlsread(filepath, "Legend", start_col + start_row + ":" + end_col + start_row);
[~, colour_codes, ~] = xlsread(filepath, "Colours", start_col + start_row + ":" + end_col + start_row);

% Table Data Import
od_data = xlsread(filepath, "OD600600", start_col + start_row + ":" + end_col + end_row);
yfp_data = xlsread(filepath, "YFP500,539", start_col + start_row + ":" + end_col + end_row);
cfp_data = xlsread(filepath, "CFP435,505", start_col + start_row + ":" + end_col + end_row);

%% Plot Parameters

legend_location = 'northeast';
line_style = 'none';
marker_style = '.';
marker_size = 16;

%% Figures and Plots

%% YFP/OD vs Time

yfp_od = yfp_data./od_data;
times = repmat(time, 1, length(yfp_od(1,:)));

plot_replicate_data(times, yfp_od, num_replicates, 'YFP/OD vs Time', 'Time', 'YFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% YFP/OD vs OD

yfp_od = yfp_data./od_data;

plot_replicate_data(od_data, yfp_od, num_replicates, 'YFP/OD vs OD', 'OD', 'YFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% YFP/CFP/OD vs OD

cfp_yfp_od = cfp_data./yfp_data./od_data;

plot_replicate_data(od_data, cfp_yfp_od, num_replicates, 'YFP/CFP/OD vs OD', 'OD', 'YFP/CFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% Average YFP/OD vs Time

yfp_od = yfp_data./od_data;
times = repmat(time, 1, length(yfp_od(1,:)));

plot_average_data(times, yfp_od, false, true, num_replicates, 'Average YFP/OD vs Time', 'Time', 'Average YFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% Average YFP/OD vs Average OD

yfp_od = yfp_data./od_data;

plot_average_data(od_data, yfp_od, true, true, num_replicates, 'Average YFP/OD vs Average OD', 'Average OD', 'Average YFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% Average YFP/CFP/OD vs Average OD

cfp_yfp_od = cfp_data./yfp_data./od_data;

plot_average_data(od_data, cfp_yfp_od, true, true, num_replicates, 'Average YFP/CFP/OD vs Average OD', 'Average OD', 'Average YFP/CFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);
