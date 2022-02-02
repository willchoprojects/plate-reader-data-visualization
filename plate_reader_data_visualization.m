%% Initialization

clear
close all
clc

filename = "sample_data.xlsx";
filepath = "data/" + filename;

%% Parameters

% Start and end columns and rows for data in separated sheets
start_col = "A";
end_col = "AJ";
start_row = "1";
end_row = "79";

% Number of replicates of each sample, for averaging
num_replicates = 3;

% Time should always be in column A
time_start_col = "A";

% For processing data, to remove background noise for OD data and
% fluorescence data
od_control_data_start_col = 10;
od_control_data_end_col = 12;
fp_control_data_start_col = 7;
fp_control_data_end_col = 9;

% Processed data tends to blow up near 0 since there are divisions by
% datapoints close to zero when the data is normalized to 0
od_cutoff = 0;%.15;

%% Data Import

% Only cells with data for range
time = xlsread(filepath, "Time", time_start_col + start_row + ":" + time_start_col + end_row);
[~, legend_text_raw, ~] = xlsread(filepath, "Legend", start_col + start_row + ":" + end_col + start_row);
[~, colour_codes_raw, ~] = xlsread(filepath, "Colours", start_col + start_row + ":" + end_col + start_row);

% Table Data Import
od_data_raw = xlsread(filepath, "OD600600", start_col + start_row + ":" + end_col + end_row);
yfp_data_raw = xlsread(filepath, "YFP500,539", start_col + start_row + ":" + end_col + end_row);
cfp_data_raw = xlsread(filepath, "CFP435,505", start_col + start_row + ":" + end_col + end_row);

%% Data Processing

removal_indices = [1 6; od_control_data_start_col od_control_data_end_col; fp_control_data_start_col fp_control_data_end_col];
legend_text_processed = remove_columns(legend_text_raw, removal_indices);
colour_codes_processed = remove_columns(colour_codes_raw, removal_indices);
od_data_processed = remove_columns(remove_background(od_data_raw, od_control_data_start_col, od_control_data_end_col, true), removal_indices);
yfp_data_processed = remove_columns(remove_background(yfp_data_raw, fp_control_data_start_col, fp_control_data_end_col, true), removal_indices);
cfp_data_processed = remove_columns(remove_background(cfp_data_raw, fp_control_data_start_col, fp_control_data_end_col, true), removal_indices);

%% Plot Parameters

legend_location = 'northeast';
line_style = 'none';
marker_style = '.';
marker_size = 16;

%% Figures and Plots

%% Raw Data

legend_text = legend_text_raw;
colour_codes = colour_codes_raw;
od_data = od_data_raw;
yfp_data = yfp_data_raw;
cfp_data = cfp_data_raw;

%% OD vs Time

times = repmat(time, 1, length(od_data(1,:)));

plot_replicate_data(times, od_data, num_replicates, 'Raw OD vs Time', 'Time', 'OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% YFP vs Time

times = repmat(time, 1, length(yfp_data(1,:)));

plot_replicate_data(times, yfp_data, num_replicates, 'Raw YFP vs Time', 'Time', 'YFP', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% CFP vs Time

times = repmat(time, 1, length(cfp_data(1,:)));

plot_replicate_data(times, cfp_data, num_replicates, 'Raw CFP vs Time', 'Time', 'CFP', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% Processed Data

legend_text = legend_text_processed;
colour_codes = colour_codes_processed;
od_data = od_data_processed;
yfp_data = yfp_data_processed;
cfp_data = cfp_data_processed;

times = repmat(time, 1, length(od_data(1,:)));

filter_matrix = repmat(mean(od_data(:,od_control_data_start_col:od_control_data_end_col),2) > od_cutoff, 1, length(od_data(1,:)));

num_rows = sum(sum(filter_matrix)) / length(filter_matrix(1,:));
num_cols = length(filter_matrix(1,:));
times = reshape(times(filter_matrix), num_rows, num_cols);
od_data = reshape(od_data(filter_matrix), num_rows, num_cols);
yfp_data = reshape(yfp_data(filter_matrix), num_rows, num_cols);
cfp_data = reshape(cfp_data(filter_matrix), num_rows, num_cols);

%% YFP/OD (RFU/OD600) vs OD

yfp_od = yfp_data./od_data;

plot_replicate_data(od_data, yfp_od, num_replicates, 'RFU/OD600 vs OD600', 'OD600', 'RFU/OD600', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);


%% YFP/OD vs CFP/OD

yfp_od = yfp_data./od_data;
cfp_od = cfp_data./od_data;

plot_replicate_data(cfp_od, yfp_od, num_replicates, 'YFP/OD vs CFP/OD', 'CFP/OD', 'YFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% YFP/OD/CFP/OD vs OD

yfp_cfp = yfp_data./cfp_data;

plot_replicate_data(od_data, yfp_cfp, num_replicates, 'YFP/OD/CFP/OD vs OD', 'CFP/OD', 'YFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);

%% Average YFP/OD vs Average CFP/OD

yfp_od = yfp_data./od_data;
cfp_od = cfp_data./od_data;

plot_average_data(cfp_od, yfp_od, true, true, num_replicates, 'Average YFP/OD vs Average CFP/OD', 'Average YFP/OD', 'Average CFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);


%% Average YFP/OD/CFP/OD vs Average OD

yfp_cfp = yfp_data./cfp_data;

plot_average_data(od_data, yfp_cfp, true, true, num_replicates, 'Average YFP/OD/CFP/OD vs Average OD', 'Average OD', 'Average YFP/OD/CFP/OD', legend_text, legend_location, line_style, marker_style, marker_size, colour_codes);
