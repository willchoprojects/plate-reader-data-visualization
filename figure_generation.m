%% Initialization

clear
close all
clc

filename = "020322 LacIP sensors plate reader S7.xlsx";
filepath = "data/" + filename;

%% Parameters

% Start and end columns and rows for data in separated sheets
start_col = "A";
end_col = "AV";
start_row = "1";
end_row = "79";

% Number of replicates of each sample, for averaging
num_replicates = 6;

% Time should always be in column A
time_start_col = "A";

% For processing data, to remove background noise for OD data and
% fluorescence data
od_control_data_start_col = 31;
od_control_data_end_col = 36;
fp_control_data_start_col = 43;
fp_control_data_end_col = 48;

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

removal_indices = [od_control_data_start_col od_control_data_end_col; fp_control_data_start_col fp_control_data_end_col];
legend_text_processed = remove_columns(legend_text_raw, removal_indices);
colour_codes_processed = remove_columns(colour_codes_raw, removal_indices);
od_data_processed = remove_columns(remove_background(od_data_raw, od_control_data_start_col, od_control_data_end_col, true), removal_indices);
yfp_data_processed = remove_columns(remove_background(yfp_data_raw, fp_control_data_start_col, fp_control_data_end_col, true), removal_indices);
cfp_data_processed = remove_columns(remove_background(cfp_data_raw, fp_control_data_start_col, fp_control_data_end_col, true), removal_indices);

%% Plot Parameters

legend_location = 'northeast';
line_style = 'none';
marker_style = '.';
marker_size = 12;

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

%% Average RFU vs Average OD600

yfp_cfp = yfp_data./cfp_data;

% fig = figure;
% annotation('textbox',[x y w h])
% fig.Position = [0,0,2000,400];
% tiledlayout(1,3);


colour_codes = {'#1f78b4','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#33a02c','#33a02c','#33a02c','#33a02c','#33a02c','#33a02c','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#33a02c','#33a02c','#33a02c','#33a02c','#33a02c','#33a02c','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#1f78b4','#33a02c','#33a02c','#33a02c','#33a02c','#33a02c','#33a02c'};

nexttile
indices = 1:12;
od_data_filtered = od_data(:, indices);
yfp_cfp_filtered = yfp_cfp(:, indices);
plot_average_data_non_figure(od_data_filtered, yfp_cfp_filtered, true, true, num_replicates, '', 'Average OD600', 'Average RFU', legend_text(indices), legend_location, line_style, marker_style, marker_size, colour_codes(indices));
xlim([0.17 1.3])
ylim([0 140])

nexttile
indices = 13:24;
od_data_filtered = od_data(:, indices);
yfp_cfp_filtered = yfp_cfp(:, indices);
plot_average_data_non_figure(od_data_filtered, yfp_cfp_filtered, true, true, num_replicates, '', 'Average OD600', 'Average RFU', legend_text(indices), legend_location, line_style, marker_style, marker_size, colour_codes(indices));
xlim([0.17 1.3])
ylim([0 140])

nexttile
indices = 25:36;
od_data_filtered = od_data(:, indices);
yfp_cfp_filtered = yfp_cfp(:, indices);
plot_average_data_non_figure(od_data_filtered, yfp_cfp_filtered, true, true, num_replicates, '', 'Average OD600', 'Average RFU', legend_text(indices), legend_location, line_style, marker_style, marker_size, colour_codes(indices));
xlim([0.17 1.3])
ylim([0 140])