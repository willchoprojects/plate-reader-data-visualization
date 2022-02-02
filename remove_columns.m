function truncated_matrix = remove_columns(matrix, removal_indices)
    truncated_matrix = matrix;
    
    remove_column_indices = [];
    for index = 1:length(removal_indices)
        remove_column_indices = [remove_column_indices removal_indices(index,1):removal_indices(index,2)];
    end
    
    truncated_matrix(:, remove_column_indices) = [[]];
end

