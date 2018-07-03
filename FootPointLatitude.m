% /*
% * FootpointLatitude
% *
% * Computes the footpoint latitude for use in converting transverse
% * Mercator coordinates to ellipsoidal coordinates.
% *
% * Inputs:
% *   y - The UTM northing coordinate, in meters.
% *
% * Returns:
% *   The footpoint latitude, in radians.
% *
% */
function[FootpointLatitude] = FootPointLatitude(y2)
     numOfPoints = length(y2);
     global sm_a;
     global sm_b;

    FootpointLatitude=zeros(numOfPoints,1);
     
% 	/* Precalculate n (Eq. 10.18) */
	n = (sm_a - sm_b) / (sm_a + sm_b);
    
% 	/* Precalculate alpha_ (Eq. 10.22) */
% 	/* (Same as alpha in Eq. 10.17) */
	alpha_ = (sm_a + sm_b) / 2.0 * (1 + n.^2 / 4) + n.^4 / 64 ;
    
    % 	/* Precalculate y_ (Eq. 10.23) */
	y_ = y2 / alpha_;
    
% 	/* Precalculate beta_ (Eq. 10.22) */
	beta_ = (3.0 * n / 2.0) + (-27.0 * n.^3 / 32.0) + (269.0 * n.^5 / 512.0);

% 	/* Precalculate gamma_ (Eq. 10.22) */
	gamma_ = (21.0 *n.^2 / 16.0) + (-55.0 * n.^4 / 32.0);

% 	/* Precalculate delta_ (Eq. 10.22) */
	delta_ = (151.0  * n.^3 / 96.0) + (-417.0 * n.^5 / 128.0);

% 	/* Precalculate epsilon_ (Eq. 10.22) */
	epsilon_ = (1097.0 * n.^4 / 512.0);
    
    for i=1:numOfPoints
   
% 	/* Now calculate the sum of the series (Eq. 10.21) */
	FootpointLatitude(i) = y_(i) + (beta_ * sin(2.0 * y_(i))) + (gamma_ * sin(4.0 * y_(i))) + (delta_ * sin(6.0 * y_(i))) + (epsilon_ * sin(8.0 * y_(i)));
    end
