
data{
  int N;   // datasize
  vector[N] y;  // outcomes
  int k_groups; //mixtures
}

parameters {

  ordered[k_groups] mu; //ordered becuase of label swtching menace
  vector<lower =0>[k_groups] sigma; //standrd devs of mixtures
  simplex[k_groups] theta; // categorise groups

}

model {
  vector[k_groups] contributions ;
  //priors
  sigma ~ cauchy(0, 2.5);
  mu ~ normal(0, 10);
  //theta ~ dirichlet(rep_vector(2.0, k_groups)); // mixing weights

  //likelihood
  for(i in 1:N){
    for(k in 1:k_groups){
      contributions[k] =log(theta[k]) + normal_lpdf(y[i] | mu[k], sigma[k]);
    }
    target +=log_sum_exp(contributions);
  }
}

generated quantities {
  matrix[N, k_groups] p;
  for (n in 1:N){
    vector[k_groups] ps;
    for (K in 1:k_groups){
      ps[K] = theta[K]*exp(normal_lpdf(y[n] | mu[K], sigma));
    }
    for (k in 1:k_groups){
      p[n, k]=ps[k]/sum(ps);
    }
  }

}
