2arraysIn_1coeffOut:

	// This folder holds the standard correlation algorithms (Pearson, Spearman...)

	input: 2 datasets (as arrays)
	output: 1 number (or coefficient)

	Correlation Algorithms:

		pearson.rb
		spearman.rb
		
	Statistical Analysis:

		mean.rb - mean of array1 and array2 together
		median.rb - median of array1 and array2 together
		mode.rb - mode of array1 and array2 together
		sum.rb - sums all values of array1 and array2 together
		sumSquares.rb - same as sum.rb, but squares each value first then sums
		covariance.rb - similar to correlation, but not normalized

	Probability Tests:

		kendall.rb - idk, some sort of non-parametric hypothesis test 
		tPearson.rb - the value of a T-test, based on Pearson's algorithm




2arraysIn_1arrayOut:

	input: 2 datasets (as arrays)
	output: an array of coefficients

	Statistical Analysis:

		anovaOneWay.rb - output[0] = degrees of freedom between groups
  						 output[1] = degrees of freedom within groups
					     output[2] = k value
					     output[3] = levene value
						 output[3] = total number of cases
						 output[4] = sum of squares between groups
						 output[5] = sum of squares within groups
						 output[6] = total mean
						 output[7] = F-test value
						 output[8] = probability of F-test




ManyArraysIn_1arrayOut:

	input: is able to take 2 or more datasets (as arrays), but right now
			it's set up to take only 2 datasets
	output: is able to return a matrix of coefficients, but right now it's
			only set up to return 1 array of coefficients

	Statistical Analysis:

		twoSamplesIndependent.rb - output[0] = "set t and probability for given u" ...so 											basically idk
    							   output[1] = Cohen's d is how much "effect size"




