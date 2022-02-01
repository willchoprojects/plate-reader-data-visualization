function plot_replicate_data(x_data, y_data, num_replicates, figure_title, figure_x_label, figure_y_label, legend_labels, legend_location, line_style, marker, marker_size, plot_colours_hexcodes)
    figure

    hold on

    labelled_curves = [];

    for index = 1:length(y_data(1,:))
        curr_curve = plot(x_data(:,index), y_data(:,index), 'LineStyle', line_style, 'Marker', marker, 'MarkerSize', marker_size, 'Color', char(plot_colours_hexcodes(index)));

        if (mod(index, num_replicates) == 0)
            labelled_curves = [labelled_curves curr_curve];
        end
    end

    title(figure_title)
    xlabel(figure_x_label)
    ylabel(figure_y_label)
    legend(labelled_curves, legend_labels((1:(length(y_data(1,:)) / num_replicates)) * num_replicates), 'Location', legend_location)
end
