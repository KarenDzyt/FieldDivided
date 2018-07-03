% /*
% * UTMXYToLatLon
% *
% * Converts x and y coordinates in the Universal Transverse Mercator
% * projection to a latitude/longitude pair.
% *
% * Inputs:
% *	x - The easting of the point, in meters.
% *	y - The northing of the point, in meters.
% *	zone - The UTM zone in which the point lies.
% *	southhemi - True if the point is in the southern hemisphere;
% *               false otherwise.
% *
% * Outputs:
% *	latlon - A 2-element array containing the latitude and
% *            longitude of the point, in radians.
% *
% * Returns:
% *	The function does not return a value.
% *
% */
function [x2,y2] = UTMXYToLatLon(x,y,southhemi)
    numOfPoints = length(x);
    global UTMScaleFactor;
	x2 = x - 500000.0;
	x2 = x2 / UTMScaleFactor;
    y2 = y;
    
% 	/* If in southern hemisphere, adjust y accordingly. */
   for i=1:numOfPoints
        if (southhemi)
		    y2(i) = y2(i) - 10000000.0;
        end
    end
	y2 = y2 / UTMScaleFactor;

    

