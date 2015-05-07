$( document ).ready(function() {

  var dataTransformation = function(oldData){
      
      console.log(legendElementWidth);
      var i = 0;
      var dataToCompare = []; // Event ID's to be compared against
      var dataTCName = []; 
      var pcoeffVal = []; // Pearson's coefficients
      var scoeffVal = []; // Spearman's coefficients
      var newFormattedData = []; 
      setIds = [];

      console.log("yo");
      debugger

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
      
      return newFormattedData
    }

  var makeheatMap = function(data) {
    debugger
    console.log("i'm here");
      transformed = dataTransformation(data)
      var colorScale = d3.scale.quantile()
         .domain([-1.0, 1.0])
         .range(colors);

      var svg = d3.select("#heatmap-chart").append("svg")
          .call(tip)
         .attr("width", width + margin.left + margin.right)
         .attr("height", height + margin.top + margin.bottom)
         .append("g")
         .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      var coeffLabels = svg.selectAll(".coeffLabel")
         .data(coeffs)
         .enter().append("text")
           .text(function (d) { return d; })
           .attr("x", -10)
           .attr("y", function (d, i) { return i * gridSize; })
           .style("text-anchor", "end")
           .attr("transform", "translate(-10," + gridSize / 1.5 + ")")
           .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "coeffLabel mono axis axis-workweek" : "coeffLabel mono axis"); });

      var timeLabels = svg.selectAll(".timeLabel") // data set label
         .data(setIds)
         .enter().append("text")
           .text(function(d) { return d; })
           .style("text-anchor", "end")
           .attr("transform", function(d, i){
              return "translate(" + (i * gridSize) +", -6)" + "rotate(45)"
           })
           .attr("class", function(d, i) { return ((i >= 7 && i <= 16) ? "timeLabel mono axis axis-worktime" : "timeLabel mono axis"); });


      var heatMap = svg.selectAll(".Id")
         .data(transformed)
         .enter()
        //  .append('a')
        //  .attr('href', "your_custom_link_based/off/this/data")
         .append("rect")
         .attr("x", function(d) { return (d.Id - 1) * gridSize - 50; })
         .attr("y", function(d) { return (d.coeff - 1) * gridSize; })
         .attr("rx", 4)
         .attr("ry", 4)
        //  .attr("mr-link", "your_custom_link_based/off/this/data")
         .attr("class", "Id bordered")
         .attr("width", gridSize)
         .attr("height", gridSize)
         .style("fill", colors[0])
         .style({'stroke': '#E6E6E6', 'stroke-width': 1.5})
         .on('mouseover', tip.show)
         .on('mouseout', tip.hide)
         .on("click", function(d){
          console.log("yooo you did it + " + d.Id);
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
       .style({'stroke': '#E6E6E6', 'stroke-width': 1.5});

      legend.append("text")
       .attr("class", "mono")
       .text(function(d, i) { return "~ " + (Math.round((i*2-8)*100)/100); })
       .attr("x", function(d, i) { return legendElementWidth * i + 20; })
       .attr("y", height + gridSize);

     }

      $("button").click(function(){
          $.ajax({url: "explore"});
          // Upon success, make a new map!
          successCallback = function(){
            makeheatMap(dataTypeCorrelations['data_types_correlations']);
          }

          request.done(successCallback);
      });
});