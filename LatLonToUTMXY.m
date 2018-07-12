% /*
% * LatLonToUTMXY
% *
% * Converts a latitude/longitude pair to x and y coordinates in the
% * Universal Transverse Mercator projection.
% *
% * Inputs:
% *   lat - Latitude of the point, in radians.
% *   lon - Longitude of the point, in radians.
% *   zone - UTM zone to be used for calculating values for x and y.
% *          If zone is less than 1 or greater than 60, the routine
% *          will determine the appropriate zone from the value of lon.
% *
% * Outputs:
% *   xy - A 2-element array where the UTM x and y values will be stored.
% *
% * Returns:
% *   void
% *
% */

function [x,y,southhemi] = LatLonToUTMXY(x1,y1)
    numOfPoints = length(x1);
    global UTMScaleFactor;
    southhemi=zeros(numOfPoints,1);
% 	/* Adjust easting and northing for UTM system. */
    
	x = x1 * UTMScaleFactor + 500000.0;
	y = y1 * UTMScaleFactor;
	
    for i=1:numOfPoints
        if(y(i) < 0)
		    y(i) = y(i) + 10000000.0;
            southhemi(i)=1;
        end
    end


