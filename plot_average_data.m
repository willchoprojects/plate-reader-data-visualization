function plot_average_data(x_data, y_data, is_displaying_x_errors, is_displaying_y_errors, num_replicates, figure_title, figure_x_label, figure_y_label, legend_labels, legend_location, line_style, marker, marker_size, plot_colours_hexcodes)    
    [x_data_averages, x_data_stds] = congregate_data(x_data, num_replicates);
    [y_data_averages, y_data_stds] = congregate_data(y_data, num_replicates);

    figure

    hold on

    labelled_curves = [];

    for index = 1:length(y_data_averages(1,:))
        curr_curve = plot(x_data_averages(:, index), y_data_averages(:,index), 'LineStyle', line_style, 'Marker', marker, 'MarkerSize', marker_size, 'Color', char(plot_colours_hexcodes(index * 3)));

        if (is_displaying_y_errors)
            errorbar(x_data_averages(:, index), y_data_averages(:, index), y_data_stds(:, index), 'Color', char(plot_colours_hexcodes(index * 3)))
        end
        
        if (is_displaying_x_errors)
            errorbar(x_data_averages(:, index), y_data_averages(:, index), x_data_stds(:, index), 'horizontal', 'Color', char(plot_colours_hexcodes(index * 3)))
        end
       
        labelled_curves = [labelled_curves curr_curve];
    end

    title(figure_title)
    xlabel(figure_x_label)
    ylabel(figure_y_label)
    legend(labelled_curves, legend_labels((1:(length(y_data(1,:)) / num_replicates)) * num_replicates), 'Location', legend_location)
end

function [data_averages, data_stds] = congregate_data(data, num_replicates)
    dimension_indicator = 2; % to indicate we are averaging columns
    standard_deviation_weight = 0; % to indicate we ignore the weights but want to operate on the columns
    
    averages= [];
    stds = [];

    for index = 1:(length(data(1,:)) / num_replicates)
        col_index = (index - 1) * num_replicates + 1;
        sectioned_data = data(:,col_index:(col_index + num_replicates - 1));

        averages = [averages mean(sectioned_data, dimension_indicator)];
        stds = [stds std(sectioned_data, standard_deviation_weight, dimension_indicator)];
    end
    
    data_averages = averages;
    data_stds = stds;
end