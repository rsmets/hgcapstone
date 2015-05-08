// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).ready(function() {

  var margin = { top: 200, right: 0, bottom: 100, left: 300 },
       width = 1000 - margin.left - margin.right,
       height = 500 - margin.top - margin.bottom,
       gridSize = Math.floor(width / 24),
       legendElementWidth = gridSize*2,
       buckets = 10,
       colors = ["#660000", "#8B0000", "#b20000", "#ff6666", "#e4e4e4","#9595cf","#5a6890","#314374", "#081d58"], // alternatively colorbrewer.YlGnBu[9]
       coeffs = ["Spearman", "Pearson"],
       setIds = [];

    var tip = d3.tip()
        .attr('class', 'd3-tip')
        .style("cursor", "crosshair")
        .style("visibility","visible")
        .style("background","rgba(0,0,0,0.85)")
        .style("padding", "12px")
        .style("font-family", "Veranda")
        .style("color", "#fff")
        .style("opacity", .5)
        .offset([-10, 0])
        .html(function(d, i) {
          return "<span style='color:red'> Correlation Value: " + d.value;
        });
                  


  var dataTransformation = function(oldData){
    d3.select('svg').text('')
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

        if(j+1 == selectedId)
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
  //  How to make that nasty map
  var makeheatMap = function(data) {
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
           .attr("transform", "translate(-25," + gridSize / 1.5 + ")")
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


    var title = setIds[selectedId];
    console.log(title);

    var heatMap = svg.selectAll(".Id")
       .data(transformed)
       .enter()
       .append("a")
       /*.attr("xlink:href", function(d){
          if(d.Id < selectedId)
            return "http://en.wikipedia.org/wiki/gongoozler";
          else
            return "http://en.wikipedia.org/wiki/coyote"

        })*/
       .append("rect")
       .attr("x", function(d, i) { return (d.Id - 1) * gridSize - 15; })
       .attr("y", function(d, i) { return (d.coeff - 1) * gridSize; })
       .attr("rx", 4)
       .attr("ry", 4)
      //  .attr("mr-link", "your_custom_link_based/off/this/data")
       .attr("class", "Id bordered")
       .attr("width", gridSize)
       .attr("height", gridSize)
       .style("fill", colors[0])
       .style({'stroke': '#7e7e7e', 'stroke-width': 1.0})
       .on('mouseover', tip.show).style("cursor", "pointer")
       .on('mouseout', tip.hide)
       .on("click", function(d){
          clearDrawing();
          if(d.Id < selectedId)
            generateGraphInModal(selectedId, d.Id);
          else
            generateGraphInModal(selectedId, d.Id+1)
          //$('#myModal').modal('hide');
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

   var generateGraphInModal = function(eventId0, eventId1){

      $('#myModal').modal('toggle');
      $('#myModal').on('shown.bs.modal', function(e){
        $.ajax({
           type: "GET",
           contentType: "application/json; charset=utf-8",
           url: '/analyze/graph/'+eventId0+','+eventId1+'',
           dataType: 'json',

           success: function (data) {

              var rawD0 = format(data, eventId0);
              var rawD1 = format(data, eventId1);
              var mappedD0 = mapData(rawD0);
              var mappedD1 = mapData(rawD1);
              var readyD0 = nvd3Format(mappedD0, eventId0, '#ff7f0e');
              var readyD1 = nvd3Format(mappedD1, eventId1, '#2ca02c');
              debugger
              var comboD = format_combined_data(mappedD0, mappedD1, eventId0, eventId1, '#ff7f0e', '#2ca02c', 0);
              
              $('#graph-line').on('click',function(){
                  clearDrawing();
                  drawNVline(comboD, '#graph', eventId0, eventId1);
                });

               $('#graph-bar').on('click',function(){
                  clearDrawing();
                  drawMultiBarChart(comboD,'#graph', eventId0, eventId1);
               });

               $('#graph-scatter').on('click',function(){
                  clearDrawing();
                  drawScatter(comboD, '#graph', eventId0);
               });

           }
         });
      });

      $('#myModal').modal('show');
      $('#myModal').append("asdfasdfadfasd");
      console.log(eventId0);
      console.log(eventId1);
   }

   function clearDrawing(){
    $("#graph").empty();
  }

    function drawScatter(data, graph_name, dt){
  var chart = nv.models.scatterChart()
                .showDistX(true)    //showDist, when true, will display those little distribution lines on the axis.
                .showDistY(true)
                //.transitionDuration(350)
                .color(d3.scale.category10().range());

  //Configure how the tooltip looks.
  chart.tooltipContent(function(key) {
      return '<h3>' + key + '</h3>';
  });

  //Axis settings
  chart.xAxis.tickFormat(d3.format('.02f'));
  chart.yAxis.tickFormat(d3.format('.02f'));

  //We want to show shapes other than circles.
  //chart.scatter.onlyCircles(false);

  //var myData = randomData(4,40);
  d3.select(graph_name)
      .datum(data)
      .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
}

function drawNVline(data, graph_name, dt) {
  var chart = nv.models.lineChart()
                .margin({left: 100})  //Adjust chart margins to give the x-axis some breathing room.
                .useInteractiveGuideline(true)  //We want nice looking tooltips and a guideline!
                //.transitionDuration(350)  //how fast do you want the lines to transition?
                .showLegend(true)       //Show the legend, allowing users to turn on/off line series.
                .showYAxis(true)        //Show the y-axis
                .showXAxis(true);

          chart.xAxis     //Chart x-axis settings
              .axisLabel('Time (Years)')
              .tickFormat(d3.format('r'));

          chart.yAxis     //Chart y-axis settings
              .axisLabel('Amount')
              .tickFormat(d3.format(',1000fM'));

          d3.select(graph_name)    //Select the <svg> element you want to render the chart in.   
              .datum(data)         //Populate the <svg> element with chart data...
              .call(chart);          //Finally, render the chart!

          nv.utils.windowResize(function() { chart.update() });
          return chart;
   }

   function drawMultiBarChart(data, graph_name, dt) {
    var chart = nv.models.multiBarChart()
      .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
      .rotateLabels(0)      //Angle to rotate x-axis labels.
      //.showControls(true)   //Allow user to switch between 'Grouped' and 'Stacked' mode.
      .groupSpacing(0.1)    //Distance between each group of bars.
    ;
    chart.showControls(true);
  
    chart.xAxis
        .tickFormat(d3.format('f'));

    chart.yAxis
        .tickFormat(d3.format(',1000000000f'));

    d3.select(graph_name)
        .datum(data)
        .call(chart);

    nv.utils.windowResize(chart.update);

    return chart;
}
  var normalizeVal = function(lineData){
    var i = 0;
    var total = 0;
    while(lineData[i] != null){
      total = total + lineData[i].y;
      i++;
    }
    console.log(total/i);
    return total;
  }
    
  var format_combined_data = function(data, data2, dt, dt2, colr, colr2, norm_flag){
    var x_y = [];
    var x_y2 = [];
    debugger
    data1_total = 1;
    data2_total = 1;

    if(norm_flag == 1){
      data1_total = normalizeVal(data);
      data2_total = normalizeVal(data2);
    }
    
    data.map(function(item){
      x_y.push({x: item.x, y: (item.y / data1_total)})
    })

    data2.map(function(item){
      x_y2.push({x: item.x, y: (item.y / data2_total)})
    })
    return [
      {
        values: x_y,
        key: dt,
        color: colr
      },
      {
        values: x_y2,
        key: dt2,
        color: colr2
      }
    ];
  }

  
   var format = function(data, eventId){
    var arr0 = [];

    for(var i = 0; i < data.analyze.length; i++){
      if(data.analyze[i].data_type_id == eventId){
        arr0.push(data.analyze[i]);
      }

    }

    return arr0;
   }

   var mapData = function(data){
    var xymap = data.map(function(item) {
      return {
        x: item.value_1,
        y: item.value_2,
        data_type_id: item.data_type_id
      };
    });
    return xymap;
   }

   var nvd3Format = function(data, dt, colr){
      var x_y = [];
      data.map(function(item){
        x_y.push({x: item.x, y: item.y})
      })
      return [
        {
          values: x_y,
          key: dt,
          color: colr
        }
      ];
   }

  // When you select stuff, call the JSON correlation API
  selectElement = $('#analyze-data-type')
  selectElement.change(function(e){
    selectedId = $(e.target).find('option:selected').val();

    request = $.ajax({
      url: "/data_types/" + selectedId + "/correlations",
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
