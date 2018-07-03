% ArcLengthOfMeridian: Computes the ellipsoidal distance from the equator to a point at a
% given latitude.The ellipsoidal distance of the point from the equator, in meters.
function[ Meridian ] = ArcLengthOfMeridian( x )
    global sm_a;
    global sm_b;
    
	n = (sm_a - sm_b) / (sm_a + sm_b);
	alpha = ((sm_a + sm_b) / 2.0) * (1.0 + n^2 / 4.0) + n^2 / 64.0;
	beta = (-3.0 * n / 2.0) + (9.0 * n^3 / 16.0) + (-3.0 * n^5 / 32.0);
	gamma = (15.0 * n^2 / 16.0) + (-15.0 * n^4 / 32.0);
	delta = (-35.0 * n^3 / 48.0) + (105.0 * n^5 / 256.0);
	epsilon = (315.0 * n^4 / 512.0);
	Meridian = alpha * (x + (beta * sin(2.0 * x)) + (gamma * sin(4.0 * x)) + (delta * sin(6.0 * x)) + (epsilon * sin(8.0 * x)));
    