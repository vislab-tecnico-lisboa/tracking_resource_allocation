function [tracks,nextId]=createNewTracks(tracks,...
    unassignedDetections,...
    centroids,...
    bboxes,...
    colorHists,...
    nextId,...
    size_transition_model,...
    size_measurement_model,...
    size_init_state_covariance,...
    size_process_noise,...
    size_measurement_noise)
centroids = centroids(unassignedDetections, :);
bboxes = bboxes(unassignedDetections, :);

for i = 1:size(centroids, 1)
    
    centroid = centroids(i,:);
    bbox = bboxes(i, :);
    colorHist = colorHists(i,:);
    
    % Create a Kalman filter object for centroids.
    % Create a Kalman filter object.
%    stateKalmanFilter = configureKalmanFilter('ConstantVelocity', ...
%        [centroid bbox(4)/bbox(3)], size_init_state_covariance, size_process_noise, 100);
    stateKalmanFilter=vision.KalmanFilter(...
        size_transition_model,...
        size_measurement_model,...
        'State',...
        [centroid bbox(4)/bbox(3) 0 0 0],...
        'StateCovariance',...
        size_init_state_covariance,...
        'ProcessNoise',...
        size_process_noise,...
        'MeasurementNoise',...
        size_measurement_noise);
    
    % Create a new track.
    newTrack = struct(...
        'id', nextId, ...
        'bbox', bbox, ...
        'stateKalmanFilter', stateKalmanFilter,...
        'age', 1, ...
        'totalVisibleCount', 1, ...
        'colorHist', colorHist, ...
        'consecutiveInvisibleCount', 0);
    
    % Add it to the array of tracks.
    tracks(end + 1) = newTrack;
    
    % Increment the next id.
    nextId = nextId + 1;
end
end