
functions {
}
data {
  int<lower=1> N;  // total number of observations
  int Y[N];  // response variable
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  int<lower=1> J_1[N];
  int<lower=1> N_1;
  int<lower=1> M_1;
  vector[N] Z_1_1;
  int prior_only;  //
}
transformed data {
}
parameters {
     vector[K] b;  // population-level effects
   vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  vector[N_1] z_1[M_1];  // unscaled group-level effects
}
transformed parameters {
  // group-level effects
  vector[N_1] r_1_1;
  vector[N] eta;
  r_1_1 = sd_1[1] * (z_1[1]);
    eta = X * b ;
  for (n in 1:N) {
    eta[n] = eta[n] + (r_1_1[J_1[n]]) * Z_1_1[n];
  }
}
model {
  // prior specifications
    for( k in 2:K){
b[k]~ cauchy(0, 2.5); //Gelman 2008
}
b[1] ~ cauchy(0, 10); //Gelman 2008

  sd_1 ~ student_t(3, 0, 10);
  z_1[1] ~ normal(0, 1);
  // likelihood contribution
  if (!prior_only) {
    Y ~ bernoulli_logit(eta);
  }
}
generated quantities {
}
