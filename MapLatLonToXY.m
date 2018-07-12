% /*
% * MapLatLonToXY
% *
% * Converts a latitude/longitude pair to x and y coordinates in the
% * Transverse Mercator projection  N(i)ote that Transverse Mercator is not
% * the same as UTM; a scale factor is required to convert between them
% *
% * Reference: Hoffmann-Wellenhof, B, Lichtenegger, H, and Collins, J,
% * GPS: Theory and Practice, 3rd ed  N(i)ew York: Springer-Verlag Wien, 1994
% *
% * Inputs:
% *    lat_radian - Latitude of the point, in radians
% *    lambda - Longitude of the point, in radians
% *    lambda0 - Longitude of the central meridian to be used, in radians
% *
% * Outputs:
% *    xy - A 2-element array containing the x and y coordinates
% *         of the computed point
% *
% * Returns:
% *    The function does not return a value
% *
% */

function [x1,y1] = MapLatLonToXY( lon_radian,lat_radian,UTMCentralMeridian)
    global sm_a;  
    global sm_b;
    numOfPoints = length(lon_radian);
    
	N=zeros(numOfPoints,1);t=zeros(numOfPoints,1); t2=zeros(numOfPoints,1); l=zeros(numOfPoints,1);
	l3coef=zeros(numOfPoints,1); l4coef=zeros(numOfPoints,1); l5coef=zeros(numOfPoints,1); l6coef=zeros(numOfPoints,1); l7coef=zeros(numOfPoints,1);l8coef=zeros(numOfPoints,1);
	x1=zeros(numOfPoints,1);y1=zeros(numOfPoints,1);
    
	ep2 = (sm_a^2 - sm_b^2) / sm_b^2;

	nu2 = ep2 * cos(lat_radian).^2;
    
for i=1:numOfPoints
	N(i) = sm_a^2 / (sm_b * sqrt(1 + nu2(i)));

	t(i) = tan(lat_radian(i));
	t2(i) = t(i) * t(i) ;

	l(i) = lon_radian(i) - UTMCentralMeridian(i);
    

	l3coef(i) = 1.0 - t2(i) + nu2(i);

	l4coef(i) = 5.0 - t2(i) + 9 * nu2(i) + 4.0 * (nu2(i) * nu2(i));

	l5coef(i) = 5.0 - 18.0 * t2(i) + (t2(i) * t2(i)) + 14.0 * nu2(i) - 58.0 * t2(i) * nu2(i);

	l6coef(i) = 61.0 - 58.0 * t2(i) + (t2(i) * t2(i)) + 270.0 * nu2(i) - 330.0 * t2(i) * nu2(i);

	l7coef(i) = 61.0 - 479.0 * t2(i) + 179.0 * (t2(i) * t2(i)) - (t2(i) * t2(i) * t2(i));

	l8coef(i) = 1385.0 - 3111.0 * t2(i) + 543.0 * (t2(i) * t2(i)) - (t2(i) * t2(i) * t2(i));

% 	/* Calculate easting (x) */
	x1(i)= N(i) * cos(lat_radian(i)) * l(i) + (N(i) / 6.0 * cos(lat_radian(i))^3 * l3coef(i) * l(i)^3)+ (N(i) / 120.0 * cos(lat_radian(i))^5 * l5coef(i) * l(i)^5)+ (N(i) / 5040.0 * cos(lat_radian(i))^7 * l7coef(i) * l(i)^7);
        
% 	/* Calculate northing (y) */
	y1(i)= ArcLengthOfMeridian(lat_radian(i))+ (t(i) / 2.0 * N(i) * cos(lat_radian(i))^2 * l(i)^2)+ (t(i) / 24.0 * N(i) * cos(lat_radian(i))^4 * l4coef(i) * l(i)^4)+ (t(i) / 720.0 * N(i) * cos(lat_radian(i))^6 * l6coef(i) * l(i)^6)+ (t(i) / 40320.0 * N(i) * cos(lat_radian(i))^8 * l8coef(i) * l(i)^8);
end
