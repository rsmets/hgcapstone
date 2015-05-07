// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).ready(function() {


  var margin = { top: 50, right: 0, bottom: 100, left: 30 },
       width = 960- margin.left - margin.right,
       height = 500 - margin.top - margin.bottom,
       gridSize = Math.floor(width / 24),
       legendElementWidth = gridSize*2,
       buckets = 10,
       colors = ["#660000", "#8B0000", "#9e1a1a", "#9e2b2b", "#ffffff","#9595cf","#5a6890","#314374", "#081d58", "2100DD"], // alternatively colorbrewer.YlGnBu[9]
       coeffs = ["S_coeff", "P_coeff"],
       setIds = [];


  var dataTransformation = function(oldData){
    
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
      setIds.push(oldData[i].data_type2.name.substring(0,5));
      pcoeffVal.push(oldData[i].p_coeff);
      scoeffVal.push(oldData[i].s_coeff);
      //console.log(oldData[i].data_type2.name);
      i++;
    }

    for(i = 0; i < 2; i++){
      for(j = 0; j < dataToCompare.length; j++){
        var set = { coeff: "", Id: "", value: "" };
        set.Id = dataToCompare[j];
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
    
    debugger
    return newFormattedData
  }
  //  How to make that nasty map
  var makeheatMap = function(data) {
    transformed = dataTransformation(data)
    debugger
    var colorScale = d3.scale.quantile()
       .domain([0, buckets - 1, d3.max(transformed, function (d) { return d.value; })])
       .range(colors);

    var svg = d3.select("#heatmap-chart").append("svg")
       .attr("width", width + margin.left + margin.right)
       .attr("height", height + margin.top + margin.bottom)
       .append("g")
       .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var coeffLabels = svg.selectAll(".coeffLabel")
       .data(coeffs)
       .enter().append("text")
         .text(function (d) { return d; })
         .attr("x", 0)
         .attr("y", function (d, i) { return i * gridSize; })
         .style("text-anchor", "end")
         .attr("transform", "translate(+10," + gridSize / 1.5 + ")")
         .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "coeffLabel mono axis axis-workweek" : "coeffLabel mono axis"); });

    var timeLabels = svg.selectAll(".timeLabel") // data set label
       .data(setIds)
       .enter().append("text")
         .text(function(d) { return d; })
         .attr("x", function(d, i) { return i * gridSize; })
         .attr("y", 0)
         .style("text-anchor", "end")
         .attr("transform", "translate(+75, -6)")
         .attr("class", function(d, i) { return ((i >= 7 && i <= 16) ? "timeLabel mono axis axis-worktime" : "timeLabel mono axis"); });

    var heatMap = svg.selectAll(".Id")
       .data(transformed)
       .enter()
      //  .append('a')
      //  .attr('href', "your_custom_link_based/off/this/data")
       .append("rect")
       .attr("x", function(d) { return (d.Id - 1) * gridSize; })
       .attr("y", function(d) { return (d.coeff - 1) * gridSize; })
       .attr("rx", 4)
       .attr("ry", 4)
      //  .attr("mr-link", "your_custom_link_based/off/this/data")
       .attr("class", "Id bordered")
       .attr("width", gridSize)
       .attr("height", gridSize)
       .style("fill", colors[0])
       .style({'stroke': 'black', 'stroke-width': 0.5});

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
     .style({'stroke': 'black', 'stroke-width': 0.5});

    legend.append("text")
     .attr("class", "mono")
     .text(function(d) { return "≥ " + (Math.round(d)); })
     .attr("x", function(d, i) { return legendElementWidth * i; })
     .attr("y", height + gridSize);
   }







  // When you select stuff, call the JSON correlation API
  selectElement = $('#analyze-data-type')
  selectElement.change(function(e){
    selectedId = $(e.target).find('option:selected').val();

    request = $.ajax({
      url: "/data_types/"+selectedId+"/correlations",
      method: "POST",
      dataType: "json"
    });

    // Upon success, make a new map!
    successCallback = function(dataTypeCorrelations){
      makeheatMap(dataTypeCorrelations['data_types_correlations']);
    }


    request.done(successCallback);

  })
});