// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).ready(function() {

  var opts = {
  lines: 5, // The number of lines to draw
  length: 0, // The length of each line
  width: 30, // The line thickness
  radius: 21, // The radius of the inner circle
  corners: 0, // Corner roundness (0..1)
  rotate: 18, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#000', // #rgb or #rrggbb or array of colors
  speed: 1.3, // Rounds per second
  trail: 63, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  top: '50%', // Top position relative to parent
  left: '50%' // Left position relative to parent
};
  var target = document.getElementById('spinner');
  var spinner = new Spinner(opts).spin(target);
  var timeLabels; 
  var coeffLabels;
  spinner.stop();
  
  var mouseover = function(d){
    //console.log("timelabel: " + timeLabels[0][d.Id]);
    d3.select(timeLabels[0][d.xPos-1]).style({'fill': 'none', 'stroke': 'blue', 'stroke-width': 0.5});
    //d3.select(coeffLabels[0][d.Id-1]).style("fill", "yellow");
    tip.show(d);
    d3.select(this).style({'stroke': '#636F57', 'stroke-width': 4.5}).style("cursor","pointer");
  }

  var mouseouttie = function(d, i){
    d3.select(timeLabels[0][d.xPos-1]).style({'fill': 'black', 'stroke': 'none', 'stroke-width': 1.0});
    tip.hide(d);
    d3.select(this).style({'stroke': '#7e7e7e', 'stroke-width': 1.0});
  }

  var margin = { top: 200, right: 0, bottom: 100, left: 100 },
       width = 1000 - margin.left - margin.right,
       height = 500 - margin.top - margin.bottom,
       gridSize = Math.floor(width / 24),
       legendElementWidth = gridSize*2,
       buckets = 9,
       colors = ["#660000", "#8B0000", "#b20000", "#ff6666", "#e4e4e4","#9595cf","#5a6890","#314374", "#081d58"], // alternatively colorbrewer.YlGnBu[9]
       coeffs = ["Spearman", "Pearson", "Kendall"],
       setNames = [],
       dataLinks = [],
       title0 = "";

  var dataTransformation = function(oldData){
    //console.log("oldData: ");
    //console.log(oldData);
    d3.select('svg').text('')
    var i = 0;
    var dataToCompare = []; // Event ID's to be compared against
    var dataTCName = [];
    var pcoeffVal = []; // Pearson's coefficients
    var scoeffVal = []; // Spearman's coefficients
    var kcoeffVal = []; // Kendall's coefficients
    var newFormattedData = [];
    setNames = [];
    dataLinks = [];

    while(i < oldData.length){
      //console.log(oldData[i].data_type2.name);
      dataToCompare.push(oldData[i].event2_id);
      setNames.push(oldData[i].data_type2.name);//.substring(0,25));
      pcoeffVal.push(oldData[i].p_coeff);
      scoeffVal.push(oldData[i].s_coeff);
      kcoeffVal.push(oldData[i].k_coeff);
      dataLinks.push(oldData[i].data_type2.url);
      i++;
    }

    title0 = oldData[0].data_type1.name;
    console.log(setNames);
    for(i = 0; i < 3; i++){
      var flag = 0;
      for(j = 0; j < dataToCompare.length; j++){
        var set = { coeff: "", Id: "", value: "", xPos: "", origin: ""};
        if(j+1 == selectedId) // This fixes the possibility of D3 rendering a blank box at selected Id's location
          flag = 1;
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
        if(i == 2){
          set.coeff = 3;
          set.value = kcoeffVal[j];
        }
        set.xPos = j+1;
        newFormattedData.push(set);
      }

    }

    return newFormattedData
  }
  //  How to make that nasty map
  var makeheatMap = function(data) {
    transformed = dataTransformation(data)
    //console.log("transformed: ");
    //console.log(transformed);
    var colorScale = d3.scale.quantile()
       .domain([-1.0, 1.0])
       .range(colors);

    var svg = d3.select("#heatmap-chart")
        .call(tip)
       //.attr("width", width + margin.left + margin.right)
       //.attr("height", height + margin.top + margin.bottom)
       .append("g")
       .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    timeData = svg.selectAll(".timeLabel").data(setNames);

    timeLabels = timeData.enter().append("a")
       .attr("xlink:href", function(d, i){
          return dataLinks[i];})
       .attr("xlink:target", "_blank")
       .append("text")
       .text(function(d) { return d +" - "; })
       .style("text-anchor", "end")
       .attr("transform", function(d, i){
          return "translate(" + (i*1.09 * gridSize + 5) +", +50)" + "rotate(35)"
       })
       .attr("class", function(d, i) { return ((i >= 7 && i <= 16) ? "timeLabel mono axis axis-worktime" : "timeLabel mono axis"); });

    coeffLabels = svg.selectAll(".coeffLabel")
         .data(coeffs)
         .enter().append("text")
           .text(function (d) { return d; })
           .attr("x", -10)
           .attr("y", function (d, i) { return i * gridSize * 1.09; })
           .style("text-anchor", "end")
           .attr("transform", "translate(-25," + ((gridSize / 1.5) + 50) +")")
           .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "coeffLabel mono axis axis-workweek" : "coeffLabel mono axis"); });

    var heatMap = svg.selectAll(".Id")
       .data(transformed)
       .enter()
       .append("a")
       .append("rect")
       .attr("x", function(d, i) { return (d.xPos*1.09 - 1) * gridSize - 15; })
       .attr("y", function(d, i) { return (d.coeff*1.09 - 1) * gridSize + 50; })
       .attr("rx", 4)
       .attr("ry", 4)
       .attr("class", "Id bordered")
       .attr("width", gridSize)
       .attr("height", gridSize)
       .style("fill", colors[0])
       .style({'stroke': '#7e7e7e', 'stroke-width': 1.0})
       .on('mouseover', mouseover)
       .on('mouseout', mouseouttie)
       .on("click", function(d){
          clearDrawing();
          //if(d.Id < selectedId){
          $("#myModalLabel").empty();
          generateGraphInModal(selectedId, d.Id, title0, setNames[d.xPos-1] );
          //} else {
          //  $("#myModalLabel").empty();
          //  generateGraphInModal(selectedId, d.Id+1, title0, setNames[d.xPos-1] );
          //}
          //$('#myModal').modal('hide');
       });

    heatMap.transition().duration(1000)
       .style("fill", function(d) { return colorScale(d.value); });

    //heatMap.append("title").text(function(d) { return d.value; });

    var legend = svg.selectAll(".legend")
       .data([0].concat(colorScale.quantiles()), function(d) { return d; })
       .enter().append("g")
       .attr("class", "legend");

    legend
     .append("rect")
     .attr("x", function(d, i) { return legendElementWidth * i; })
     .attr("y", height)
     .attr("width", legendElementWidth)
     .attr("height", gridSize / 2)
     .style("fill", function(d, i) { return colors[i]; })
     .style({'stroke': '#7e7e7e', 'stroke-width': 1.0});

    legend.append("text")
     .attr("class", "mono")
     .text(function(d, i) { 
        if(i < 4)
          return "-0." + (Math.abs(Math.round((i*2-8)*100)/100)); 
        else
          return "0." + (Math.round((i*2-8)*100)/100)
      })
     .attr("x", function(d, i) { return legendElementWidth * i + 25; })
     .attr("y", height + gridSize);

    legend.append("text")
      .attr("class", "mono")
      .text("Inversely (-1) Correlated <----------------------------------------------Neutral--------------------------------------------> Directly (+1) Correlated")
      .attr("x", legendElementWidth - 85)
      .attr("y", height - 10);

      spinner.stop();
  }

  // When you select stuff, call the JSON correlation API

  var findSelectedOptionFromSelectAndStartGraphGeneration = function(dataTypeSelect, tagSelect){
    selectedId = $(dataTypeSelect).find('option:selected').val();
    selectedTagId = $(tagSelect).find('option:selected').val();


    request = $.ajax({
      url: "/data_types/" + selectedId + "/correlations",
      method: "POST",
      dataType: "json",
      data: {tag_id: selectedTagId}
    });
    spinner.spin(target);

    // Upon success, make a new map!
    successCallback = function(dataTypeCorrelations){
      makeheatMap(dataTypeCorrelations['data_types_correlations']);
        
    }

    request.done(successCallback);

  }
  selectDataTypeElement = $('#analyze-data-type');
  selectTagElement = $('#analyze-tag');
  selectDataTypeElement.change(function(e){findSelectedOptionFromSelectAndStartGraphGeneration(selectDataTypeElement, selectTagElement)})
  selectTagElement.change(function(e){findSelectedOptionFromSelectAndStartGraphGeneration(selectDataTypeElement, selectTagElement)})
  findSelectedOptionFromSelectAndStartGraphGeneration(selectDataTypeElement, selectTagElement);

});
