// input: 2 arrays
// output: correlation number where 0 is perfectly correlated

function correlate(a, b) {

	// display steps
	var display = 0;

	// find length of array a and array b
	if (display == 1) {
		console.log("\na.length: "+ a.length +"\nb.length: "+ b.length);
	};

	// subtract every data point in b from every point in a
	// also find smallest difference
	
		// traverse points as far as the length of the shortest array
		var dif = [];
		var minDif = Infinity;
		var end = 0;

		if (a.length <= b.length) {
			end = a.length;
		} else {
			end = b.length;
		};

		// traverse arrays
		for (var i = 0; i < end; i++){

			// find difference
			dif[i] = a[i] - b[i];

			// update smallest difference
			if (dif[i] < minDif) {
				minDif = dif[i];
			}
		};
		if (display == 1) {
			console.log("\ndif= "+ dif +"\nminDif= "+ minDif);
		};

		// find how much each difference varies from the smallest difference
		var vari = [];
		for (var i = 0; i < dif.length; i++) {
			vari[i] = dif[i] - minDif;
		};
		if (display == 1) {
			console.log("\nvariance= "+ vari);
		};

		// find average of those variances
		var avgVari = 0;
		var sum = 0;
		for (var i = 0; i < dif.length; i++) {
			sum += vari[i];
		};
		avgVari = sum / vari.length;
		if (display == 1) {
			console.log("\navg= "+ avgVari);
		};

		return avgVari;
};

// correlate tests
var a = [0,0,0,0,0,0,0,0];
var b = [2,2,2,2,2,2,2,2];	// all points +2 from a's points
var c = [4,4,3,3,2,2,3,3];	// somewhat random
var d = [3,6,4,8,2,0,2,7];	// really random
var e = [4,7,2,9,10];		// shorter than a
var f = [3,6,8,2,3,7,9,2,4,7,3]; // longer than a
var g = [-1,-1,-1,-1,-1,-1,-1];		// all points -1 from a's points
var h = [-3,-5,-4,-9,-6,-1,-1];		// negative and random
var i = [-1,1,-1,1,1,-1,-1,-1];		// both above and below a

console.log("corrAA= "+ correlate(a,a));
console.log("corrAB= "+ correlate(b,a));
console.log("corrAC= "+ correlate(c,a));
console.log("corrAD= "+ correlate(d,a));
console.log("corrAE= "+ correlate(e,a));
console.log("corrAF= "+ correlate(f,a));
console.log("corrAG= "+ correlate(g,a));
console.log("corrAH= "+ correlate(h,a));
console.log("corrAI= "+ correlate(i,a));