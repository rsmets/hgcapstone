// Math.floor(Math.random() * ((y-x)+1) + x); Generate randoms numbers between x - y

$( document ).ready(function() {
//copied over the analyze js file and replaced the selectedId with a hard coded 1 for now. 
//need to make a random num gnerator eventually and call docorrelations on each random num.
//made some minor changes to the copied code, obviously.
    
    request = $.ajax({
         url: "/data_types/" + 1 + "/correlations",
         method: "POST",
         dataType: "json"
        });
    // Upon success, make a new map!
    successCallback = function(dataTypeCorrelations){
      makeheatMap(dataTypeCorrelations['data_types_correlations']);
    }

    request.done(successCallback);



  var margin = { top: 100, right: 0, bottom: 100, left: 100 },
         width = 1000 - margin.left - margin.right,
         height = 500 - margin.top - margin.bottom,
         gridSize = Math.floor(width / 24),
         legendElementWidth = gridSize*2,
         buckets = 10,
         colors = ["#660000", "#8B0000", "#b20000", "#ff6666", "#e4e4e4","#9595cf","#5a6890","#314374", "#081d58"], // alternatively colorbrewer.YlGnBu[9]
         setIdsY = [1, 2, 3, 4],
         setIdsX = [5, 6, 7, 8];

  var dataTransformation = function(oldData){
    debugger;
    d3.select('svg').text('')
    console.log(legendElementWidth);
    var i = 0;
    var dataToCompare = []; // Event ID's to be compared against
    var dataTCName = []; 
    var pcoeffVal = []; // Pearson's coefficients
    var scoeffVal = []; // Spearman's coefficients
    var newFormattedData = []; 
    setIds = [];

    while(i < oldData.length){
      console.log(oldData[i].data_type2.name);
      dataToCompare.push(oldData[i].event2_id);
      setIds.push(oldData[i].data_type2.name);//.substring(0,25));
      pcoeffVal.push(oldData[i].p_coeff);
      scoeffVal.push(oldData[i].s_coeff);
      //console.log(oldData[i].data_type2.name);
      i++;
    }

    for(i = 0; i < 2; i++){
      var flag = 0;
      for(j = 0; j < dataToCompare.length; j++){
        var set = { coeff: "", Id: "", value: "" };

        if(j+1 == 1)
          flag = 3;
        if(flag == 0) 
          set.Id = dataToCompare[j];
        else
          set.Id = (dataToCompare[j] - 1);
        if(i == 0){
          set.coeff = 1;
          set.value = pcoeffVal[j];
        }
        if(i == 1){
          set.coeff = 2;
          set.value = scoeffVal[j];
        }

        newFormattedData.push(set);
      }
    }
    
    return newFormattedData
  }

  var transformed = [{y_ID: 1, x_ID: 5, value: .3},
                     {y_ID: 1, x_ID: 6, value: .1},
                     {y_ID: 1, x_ID: 7, value: -.2},
                     {y_ID: 1, x_ID: 8, value: .5},
                     {y_ID: 2, x_ID: 5, value: .9},
                     {y_ID: 2, x_ID: 6, value: -.9},
                     {y_ID: 2, x_ID: 7, value: -.6},
                     {y_ID: 2, x_ID: 8, value: 7},
                     {y_ID: 3, x_ID: 5, value: -.4},
                     {y_ID: 3, x_ID: 6, value: -.8},
                     {y_ID: 3, x_ID: 7, value: .56},
                     {y_ID: 3, x_ID: 8, value: .12},
                     {y_ID: 4, x_ID: 5, value: 0.0},
                     {y_ID: 4, x_ID: 6, value: .7612},
                     {y_ID: 4, x_ID: 7, value: -.921},
                     {y_ID: 4, x_ID: 8, value: -.5} 
                     ];
  //  How to make that nasty map
  var makeheatMap = function(data) {
    //transformed = dataTransformation(data)
    debugger
    var colorScale = d3.scale.quantile()
       .domain([-1.0, 1.0])
       .range(colors);

    var svg = d3.select("#heatmap-chart").append("svg")
        .call(tip)
       .attr("width", width + margin.left + margin.right)
       .attr("height", height + margin.top + margin.bottom)
       .append("g")
       .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var yLabels = svg.selectAll(".yLabel")
         .data(setIdsY)
         .enter().append("text")
           .text(function (d) { return d; })
           .attr("x", -10)
           .attr("y", function (d, i) { return i * gridSize; })
           .style("text-anchor", "end")
           .attr("transform", "translate(+125," + gridSize / 1.5 + ")")
           .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "coeffLabel mono axis axis-workweek" : "coeffLabel mono axis"); });

    var xLabels = svg.selectAll(".xLabel") // data set label
       .data(setIdsX)
       .enter().append("text")
         .text(function(d) { return d; })
         .style("text-anchor", "end")
         .attr("transform", function(d, i){
            return "translate(" + (i * gridSize + 150) + ", -6)" + "rotate(45)"
         })
         .attr("class", function(d, i) { return ((i >= 7 && i <= 16) ? "timeLabel mono axis axis-worktime" : "timeLabel mono axis"); });


    var heatMap = svg.selectAll(".Id")
       .data(transformed)
       .enter()
       .append("a")
       .append("rect")
       .attr("x", function(d, i) { return (d.x_ID - 1) * gridSize - 15; })
       .attr("y", function(d, i) { return (d.y_ID - 1) * gridSize; })
       .attr("rx", 4)
       .attr("ry", 4)
      //  .attr("mr-link", "your_custom_link_based/off/this/data")
       .attr("class", "Id bordered")
       .attr("width", gridSize)
       .attr("height", gridSize)
       .style("fill", colors[0])
       .style({'stroke': '#7e7e7e', 'stroke-width': 1.0})
       .on('mouseover', mouseover)
       .on('mouseout', mouseouttie)
       .on("click", function(d){
        debugger
          generateGraphInModal(d.y_ID, d.x_ID, "hello", "world");
       });

    heatMap.transition().duration(1000)
       .style("fill", function(d) { return colorScale(d.value); });

    heatMap.append("title").text(function(d) { return d.value; });

    var legend = svg.selectAll(".legend")
       .data([0].concat(colorScale.quantiles()), function(d) { return d; })
       .enter().append("g")
       .attr("class", "legend");

    legend.append("rect")
     .attr("x", function(d, i) { return legendElementWidth * i; })
     .attr("y", height)
     .attr("width", legendElementWidth)
     .attr("height", gridSize / 2)
     .style("fill", function(d, i) { return colors[i]; })
     .style({'stroke': '#7e7e7e', 'stroke-width': 1.0});

    legend.append("text")
     .attr("class", "mono")
     .text(function(d, i) { return "~ " + (Math.round((i*2-8)*100)/100); })
     .attr("x", function(d, i) { return legendElementWidth * i + 20; })
     .attr("y", height + gridSize);

   }

});