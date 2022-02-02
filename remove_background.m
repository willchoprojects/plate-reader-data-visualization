function processed_data = remove_background(unprocessed_data, background_start_col, background_end_col, is_single_average)
    dimension_indicator = 2;
    background_data = unprocessed_data(:,background_start_col:background_end_col);

    if(is_single_average)
        averaged_background = mean(mean(background_data), dimension_indicator);
    else 
        averaged_background = mean(background_data, dimension_indicator);
    end
    
    processed_data = unprocessed_data - averaged_background;
end

