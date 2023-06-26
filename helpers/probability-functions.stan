// shifted lognormal probability density function
real shift_lognormal_pdf(real y,
												 real mu,
												 real sigma,
												 real delta) {
	real p;

	p = (1.0 / ((y - delta) * sigma * sqrt(2 * pi()))) *
		exp(-1 * (log(y - delta) - mu)^2 / (2 * sigma^2));

	return p;
}

real shift_lognormal_lpdf(real y,
													real mu,
													real sigma,
													real delta) {
	real p;

	p = (1.0 / ((y - delta) * sigma * sqrt(2 * pi()))) *
		exp(-1 * (log(y - delta) - mu)^2 / (2 * sigma^2));

	return log(p);
}

// shifted lognormal random number generator
real shift_lognormal_rng(real mu,
												 real sigma,
												 real delta) {

	return delta + lognormal_rng(mu, sigma);
}

// shifted lognormal cdf
real shift_lognormal_cdf(real x,
												 real mu,
												 real sigma,
												 real delta) {
	real p;

	p = (1.0 / 2.0) * (1 + erf((log(x - delta) - mu) / (sigma * sqrt(2))));

	return p;
}

// shifted lognormal log cdf
real shift_lognormal_lcdf(real x,
													real mu,
													real sigma,
													real delta) {
	real p;

	p = shift_lognormal_cdf(x | mu, sigma, delta);

	return log(p);
}
