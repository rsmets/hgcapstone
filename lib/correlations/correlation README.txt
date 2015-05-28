// This folder holds the standard correlation algorithms (Pearson, Spearman...)

Correlation Algorithms (for Analyze):

	input: 2 datasets (as arrays)
	output: 1 number (or coefficient)

	* pearson.rb - linear correlation algorithm 
	* spearman.rb - linear correlation algorithm
	* kendall.rb - linear correlation algorithm
	* dCorr.rb - non-linear correlation algorithm (about 4.5sec each correlation!)

Correlation Algorithms (for Explore):

	input: 2 datasets (as arrays)
	output: 1 matrix (of coefficients)

	* pearson2.rb - linear correlation algorithm 
	* spearman2.rb - linear correlation algorithm 
	


// (subfolder) non-correlations
// -------- WARNING: these output numbers outside of the range -1 to 1 --------

	input: 2 datasets (as arrays)
	output: 1 number

	* covariance.rb - similar to correlation, but not normalized
	* tPearson.rb - a probability test


