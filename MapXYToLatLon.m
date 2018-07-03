% /*
% * MapXYToLatLon
% *
% * Converts x and y coordinates in the Transverse Mercator projection to
% * a latitude/longitude pair.  Note that Transverse Mercator is not
% * the same as UTM; a scale factor is required to convert between them.
% *
% * Inputs:
% *   x - The easting of the point, in meters.
% *   y - The northing of the point, in meters.
% *   lambda0 - Longitude of the central meridian to be used, in radians.
% *
% * Outputs:
% *   philambda - A 2-element containing the latitude and longitude
% *               in radians.
% *
% * Returns:
% *   The function does not return a value.
% *
% * Remarks:
% *   The local variables Nf, nuf2, tf, and tf2 serve the same purpose as
% *   N, nu2, t, and t2 in MapLatLonToXY, but they are computed with respect
% *   to the footpoint latitude phif.
% *
% *   x1frac, x2frac, x2poly, x3poly, etc. are to enhance readability and
% *   to optimize computations.
% *
% */
function[philambda_log,philambda_lat] = MapXYToLatLon(x2,y2,UTMCentralMeridian)
     numOfPoints = length(x2);
     global sm_a;
     global sm_b;
     
    cf=zeros(numOfPoints,1);
    Nf=zeros(numOfPoints,1);
    nuf2=zeros(numOfPoints,1);
    Nfpow=zeros(numOfPoints,1);tf=zeros(numOfPoints,1);tf2=zeros(numOfPoints,1);tf4=zeros(numOfPoints,1);
    x1frac=zeros(numOfPoints,1);x2frac=zeros(numOfPoints,1);x3frac=zeros(numOfPoints,1);x4frac=zeros(numOfPoints,1);
    x5frac=zeros(numOfPoints,1);x6frac=zeros(numOfPoints,1);x7frac=zeros(numOfPoints,1);x8frac=zeros(numOfPoints,1);
    x2poly=zeros(numOfPoints,1);x3poly=zeros(numOfPoints,1);x4poly=zeros(numOfPoints,1);
    x5poly=zeros(numOfPoints,1);x6poly=zeros(numOfPoints,1);x7poly=zeros(numOfPoints,1);x8poly=zeros(numOfPoints,1);
    philambda_log=zeros(numOfPoints,1);philambda_lat=zeros(numOfPoints,1);
    
% 	/* Get the value of phif, the footpoint latitude. */
	phif = FootPointLatitude(y2);

% 	/* Precalculate ep2 */
	ep2 = (sm_a^2 - sm_b^2 ) /sm_b^2;
    
    for i=1:numOfPoints
% 	/* Precalculate cos (phif) */
	cf(i) = cos(phif(i));

% 	/* Precalculate nuf2 */
	nuf2(i) = ep2 * cf(i)^2;

% 	/* Precalculate Nf and initialize Nfpow */
	Nf(i) = sm_a^2  / (sm_b * sqrt(1 + nuf2(i)));
	Nfpow(i) = Nf(i);

% 	/* Precalculate tf */
	tf(i) = tan(phif(i));
	tf2(i) = tf(i) * tf(i);
	tf4(i) = tf2(i) * tf2(i);

% 	/* Precalculate fractional coefficients for x**n in the equations
% 	below to simplify the expressions for latitude and longitude. */
	x1frac(i) = 1.0 / (Nfpow(i) * cf(i));

	Nfpow(i) = Nfpow(i) * Nf(i);    %/* now equals Nf**2) */
	x2frac(i) = tf(i) / (2.0 * Nfpow(i));

	Nfpow(i) = Nfpow(i) * Nf(i);   %/* now equals Nf**3) */
	x3frac(i) = 1.0 / (6.0 * Nfpow(i) * cf(i));

	Nfpow(i) = Nfpow(i) * Nf(i);   %/* now equals Nf**4) */
	x4frac(i) = tf(i) / (24.0 * Nfpow(i));

	Nfpow(i) = Nfpow(i) * Nf(i);   %/* now equals Nf**5) */
	x5frac(i) = 1.0 / (120.0 * Nfpow(i) * cf(i));

	Nfpow(i) = Nfpow(i) * Nf(i);   %/* now equals Nf**6) */
	x6frac(i) = tf(i) / (720.0 * Nfpow(i));

	Nfpow(i) = Nfpow(i) * Nf(i);   %/* now equals Nf**7) */
	x7frac(i) = 1.0 / (5040.0 * Nfpow(i) * cf(i));

	Nfpow(i) = Nfpow(i) * Nf(i);   %/* now equals Nf**8) */
	x8frac(i) = tf(i) / (40320.0 * Nfpow(i));

% 	/* Precalculate polynomial coefficients for x**n.
% 	-- x**1 does not have a polynomial coefficient. */
	x2poly(i) = -1.0 - nuf2(i);

	x3poly(i) = -1.0 - 2 * tf2(i) - nuf2(i);

	x4poly(i) = 5.0 + 3.0 * tf2(i) + 6.0 * nuf2(i) - 6.0 * tf2(i) * nuf2(i) - 3.0 * (nuf2(i) *nuf2(i)) - 9.0 * tf2(i) * (nuf2(i) * nuf2(i));

	x5poly(i) = 5.0 + 28.0 * tf2(i) + 24.0 * tf4(i) + 6.0 * nuf2(i) + 8.0 * tf2(i) * nuf2(i);

	x6poly(i) = -61.0 - 90.0 * tf2(i) - 45.0 * tf4(i) - 107.0 * nuf2(i) + 162.0 * tf2(i) * nuf2(i);

	x7poly(i) = -61.0 - 662.0 * tf2(i) - 1320.0 * tf4(i) - 720.0 * (tf4(i) * tf2(i));

	x8poly(i) = 1385.0 + 3633.0 * tf2(i) + 4095.0 * tf4(i) + 1575 * (tf4(i) * tf2(i));

% 	/* Calculate latitude */
	philambda_lat(i) = phif(i) + x2frac(i) * x2poly(i) * (x2(i) * x2(i)) + x4frac(i) * x4poly(i) * x2(i).^4 + x6frac(i) * x6poly(i) * x2(i).^6 + x8frac(i) * x8poly(i) * x2(i).^8;

% 	/* Calculate longitude */
	philambda_log(i) = UTMCentralMeridian(i) + x1frac(i) * x2(i) + x3frac(i) * x3poly(i) * x2(i).^3 + x5frac(i) * x5poly(i) * x2(i).^5 + x7frac(i) * x7poly(i) * x2(i).^7;
    end
