// Math.floor(Math.random() * ((y-x)+1) + x); Generate randoms numbers between x - y

$( document ).ready(function() {
//copied over the analyze js file and replaced the coeffType with a hard coded 1 for now. 
//need to make a random num gnerator eventually and call docorrelations on each random num.
//made some minor changes to the copied code, obviously.
  var exclusionSet = {};
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
  zIndex: 2e9, // ThfindSelectedOptionFromSelectAndStartGraphGeneration(selectElement)findSelectedOptionFromSelectAndStartGraphGeneration(selectElement)findSelectedOptionFromSelectAndStartGraphGeneration(selectElement)e z-index (defaults to 2000000000)
  top: '50%', // Top position relative to parent
  left: '50%' // Left position relative to parent
};
var target = document.getElementById('spinner');
var spinner = new Spinner(opts).spin(target);
    /*
    request = $.ajax({
         url: "/data_types/correlations",
         method: "POST",
         dataType: "json"
        });
    // Upon success, make a new map!
    successCallback = function(dataTypeCorrelations){
      makeheatMap(dataTypeCorrelations['data_types_correlations']);

    }

    request.done(successCallback);*/

  var findSelectedOptionFromSelectAndStartGraphGeneration = function(htmlSelectElement){
    coeffType = $(htmlSelectElement).find('option:selected').val();
    request = $.ajax({
         url: "/data_types/correlations",
         method: "POST",
         dataType: "json",
         data: Object.keys(exclusionSet)
        });
    spinner.spin(target);

    // Upon success, make a new map!
    successCallback = function(dataTypeCorrelations){
      makeheatMap(dataTypeCorrelations['data_types_correlations']);
    }

    request.done(successCallback);

  }
  selectElement = $('#correlation-type');
  refreshElement = $('#random-refresh');
  refreshElement.click(function(){
    findSelectedOptionFromSelectAndStartGraphGeneration(selectElement);
  })

  selectElement.change(function(e){
    findSelectedOptionFromSelectAndStartGraphGeneration(e.target);
  })
  findSelectedOptionFromSelectAndStartGraphGeneration(selectElement)
  
  var coeffLabels;
  var timeLabels;

  var mouseover = function(d){
    //console.log("timelabel: " + timeLabels[0][d.Id]);
    d3.select(timeLabels[0][d.xPos-1]).style({'fill': 'none', 'stroke': 'blue', 'stroke-width': 0.5});
    d3.select(coeffLabels[0][d.yPos-1]).style({'fill': 'none', 'stroke': 'blue', 'stroke-width': 0.5});
    //d3.select(coeffLabels[0][d.Id-1]).style("fill", "yellow");
    tip.show(d);
    d3.select(this).style({'stroke': '#636F57', 'stroke-width': 4.5}).style("cursor","pointer");
  }

  var mouseouttie = function(d, i){
    d3.select(timeLabels[0][d.xPos-1]).style({'fill': 'black', 'stroke': 'none', 'stroke-width': 1.0});
    d3.select(coeffLabels[0][d.yPos-1]).style({'fill': 'black', 'stroke': 'none', 'stroke-width': 1.0});
    tip.hide(d);
    d3.select(this).style({'stroke': '#7e7e7e', 'stroke-width': 1.0});
  }

  var margin = { top: 100, right: 0, bottom: 100, left: 100 },
         width = 1000 - margin.left - margin.right,
         height = 500 - margin.top - margin.bottom,
         gridSize = Math.floor(width / 24),
         legendElementWidth = gridSize*2,
         buckets = 10,
         colors = ["#660000", "#8B0000", "#b20000", "#ff6666", "#e4e4e4","#9595cf","#5a6890","#314374", "#081d58"], // alternatively colorbrewer.YlGnBu[9]
         //colors = ["#0066FF", "#005CE6", "#0052CC", "#0047B2", "#003D99", "#003380", "#002966", "#001F4C", "#001433", "#000A1A",
         //         "#000000",
         //         "#1A0500", "#330A00", "#4C0F00", "#661400", "#801A00", "#991F00", "#B22400", "#CC2900", "#E62E00", "#FF3300"]
         ysetNames = [], //populate for axis label
         xsetNames = [],
         ynames = [],
         xnames = [];


  var addToExclusionSet = function(id, name){
    if(exclusionSet[id] == null){
      exclusionSet[id] = name;
      var excl = "<span class='exclusion' id='exclusion-set-"+id+"'>"+ name 
      + "<span class='glyphicon glyphicon-remove'>  </span>" +"</span>";
      $("#exclusion-set").append(excl);
      var exclusionItem = $("#exclusion-set-"+id);
      exclusionItem.click(function(){
        removeFromExclusionSet(id, name);
      })
    }
  }

  var removeFromExclusionSet = function(id, name){
    delete exclusionSet[id];
    $("#exclusion-set-"+id).remove();
  }

  var dataTransformation = function(oldData){
    console.log(oldData);
    d3.select('svg').text('')
    var i = 0;
    var xDataIds = [];
    var yDataIds = [];
    var pcoeffVal = []; // Pearson's coefficients
    var scoeffVal = []; // Spearman's coefficients
    var newFormattedData = [];
    var coeffObjs = [];
    ysetNames = [];
    xsetNames = [];
    ynames = [];
    xnames = [];

    dataTypesByName = {};

    while(i < oldData.length){
      dataTypesByName[oldData[i].data_type1.name] = oldData[i].data_type1.id;
      dataTypesByName[oldData[i].data_type2.name] = oldData[i].data_type2.id;

      console.log("yID: " + oldData[i].event1_id);
      yDataIds.push(oldData[i].event1_id);
      xDataIds.push(oldData[i].event2_id);
      if(i < Math.sqrt(oldData.length)){
        xsetNames.push(oldData[i].data_type2.name);//.substring(0,25));
        xnames[oldData[i].event2_id] = oldData[i].data_type2.name;
      }
      if(i % Math.sqrt(oldData.length) == 0){
        ysetNames.push(oldData[i].data_type1.name);
        ynames[oldData[i].event1_id] = oldData[i].data_type1.name;
      }

      pcoeffVal.push(oldData[i].p_coeff);
      scoeffVal.push(oldData[i].s_coeff);
      
      i++;
    }

    for(i = 0; i < yDataIds.length; i++){
      
      var set = { yId: "", xId: "", value: "" , xPos: (i%8 + 1), yPos: (Math.floor(i/8) + 1)};

      set.xId = xDataIds[i];
      set.yId = yDataIds[i];
      if(coeffType == "Spearman")
        set.value = scoeffVal[i];
      else if(coeffType == "Pearson")
        set.value = pcoeffVal[i];


      newFormattedData.push(set);
    }
    
    return newFormattedData
  }

  //  How to make that nasty map
  var makeheatMap = function(data) {
    transformed = dataTransformation(data)
    var colorScale = d3.scale.quantile()
       .domain([-1.0, 1.0])
       .range(colors);

    var svg = d3.select("#heatmap-chart")
        .call(tip)
       .append("g")
       .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    coeffData = svg.selectAll(".coeffLabel")
         .data(ysetNames);
    
    coeffLabels = coeffData.enter().append("text")
           .text(function (d, i) { 
                return d; 
            })
           .attr("x", -30)
           .attr("y", function (d, i) { return i * gridSize * 1.09; })
           .style("text-anchor", "end")
           .attr("transform", "translate(+310," + ((gridSize / 1.5) + 50) +")")
           .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "coeffLabel mono axis axis-workweek" : "coeffLabel mono axis"); });
    
    coeffData.enter().append("text").text(function (d, i) { 
                return " [x] "; 
            })
           .attr("x", -10)
           .attr("y", function (d, i) { return i * gridSize * 1.09; })
           .style("text-anchor", "end")
           .attr("transform", "translate(+310," + ((gridSize / 1.5) + 50) +")")
           .attr("class", function (d, i) { return ((i >= 0 && i <= 4) ? "coeffLabel mono axis axis-workweek" : "coeffLabel mono axis"); })
           .style("fill", "red")
           .on('mouseover', function(d,i){
              d3.select(coeffData[0][i]).style("cursor", "pointer");
           })
           .on("click", function(d, i){
              addToExclusionSet(dataTypesByName[d], d);
           })
           ;

    timeLabels = svg.selectAll(".timeLabel") // data set label
       .data(xsetNames)
       .enter().append("text")
         .text(function(d, i) { 
            return d + " - ";
          })
         .style("text-anchor", "end")
         .attr("transform", function(d, i){
            return "translate(" + (i*1.09 * gridSize + 320) +", +50)" + "rotate(20)"
         })
         .attr("class", function(d, i) { return ((i >= 7 && i <= 16) ? "timeLabel mono axis axis-worktime" : "timeLabel mono axis"); });

    //// Make Da Heat ////
    var heatMap = svg.selectAll(".Id")
       .data(transformed)
       .enter()
       .append("a")
       .append("rect")
       .attr("x", function(d, i) { return (d.xPos*1.09 - 1) * gridSize + 305; })
       .attr("y", function(d, i) { return (d.yPos*1.09 - 1) * gridSize + 50; })
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
          $("#myModalLabel").empty();
          console.log(d.yId + " " + d.xId + " " + ynames[d.yId] + " " + xnames[d.xId])
          generateGraphInModal(d.yId, d.xId, ynames[d.yId], xnames[d.xId] );
       });

    heatMap.transition().duration(1000)
       .style("fill", function(d) { return colorScale(d.value); });

    var legend = svg.selectAll(".legend")
       .data([0].concat(colorScale.quantiles()), function(d) { return d; })
       .enter().append("g")
       .attr("class", "legend");

    legend.append("a")
     .attr("xlink:href", "http://en.wikipedia.org/wiki/gongoozler")
     .append("rect")
     .attr("x", function(d, i) { return legendElementWidth * i + 140; })
     .attr("y", height + 120)
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
          return "0." + (Math.round((i*2-8)*100)/100);
           })
     .attr("x", function(d, i) { return legendElementWidth * i + 165; })
     .attr("y", height + gridSize + 120);

    legend.append("text")
      .attr("class", "mono")
      .text("Inversely (-1) Correlated to Directly (+1) Correlated")
      .attr("x", legendElementWidth + 250)
      .attr("y", height + 100);

      spinner.stop();

   }
});