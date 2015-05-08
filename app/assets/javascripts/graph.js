  // Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).ready(function() {

    var dt = $("#test").data("dt");
    var dt2 = $("#test").data("dt2");
    var year_1 = $("#test").data("year");
    var year_2 = $("#test").data("year2");
    var dtid = $("#test").data("id");
    var dtid2 = $("#test").data("id2");

    getData(dt, dt2, year_1, year_2, dtid, dtid2)
    return false;});
    console.log( "ready!" );


var getData = function(dt, dt2, year, year2, dt_id, dt_id2){

$.ajax({
           type: "GET",
           contentType: "application/json; charset=utf-8",
           //params: {limit:10},
           //data: {selected_dt:dt, selected_dt2:dt2, num:year_1, num2:year_2},
           url: 'data',
           dataType: 'json',
           success: function (data) {
                
               var data1 = format(data.data_menu, dt_id);
               var data2 = format(data.data_menu, dt_id2);
               //var data1 = data.data_menu.slice(0, year2-year+1)
               //var data2 = data.data_menu.slice(year2-year+1, data.data_menu.length);
               debugger;
               var parsed_data1 = parse_xy(data1);
               var parsed_data2 = parse_xy(data2);
               var formatted_data1 = format_data(parsed_data1, dt, '#ff7f0e', dt_id);
               var formatted_data2 = format_data(parsed_data2, dt2, '#2ca02c');
               var combined_data = format_combined_data(parsed_data1, parsed_data2, dt, dt2, '#ff7f0e', '#2ca02c', 0);
               var combined_data_norm = format_combined_data(parsed_data1, parsed_data2, dt, dt2, '#ff7f0e', '#2ca02c', 1);

               clearDrawing();

               $('#graph-line').on('click',function(){
                  clearDrawing();
                  drawNVline(combined_data, '#line_chart1', dt, dt2);
                  drawNVline(combined_data_norm, '#line_chart2', dt, dt2);
                  drawNVline(formatted_data1, '#line_chart3', dt);
                  drawNVline(formatted_data2, '#line_chart4', dt2);
                });

               $('#graph-bar').on('click',function(){
                  clearDrawing();
                  drawMultiBarChart(combined_data, '#line_chart1', dt, dt2);
                  drawMultiBarChart(combined_data_norm, '#line_chart2', dt, dt2);
                  drawMultiBarChart(formatted_data1,'#line_chart3', dt);
                  drawMultiBarChart(formatted_data2, '#line_chart4', dt);
               });

               $('#graph-scatter').on('click',function(){
                  clearDrawing();
                  drawScatter(combined_data, '#line_chart1', dt);
                  drawScatter(combined_data_norm, '#line_chart2', dt);
                  drawScatter(formatted_data1, '#line_chart3', dt);
                  drawScatter(formatted_data2, '#line_chart4', dt);
               });

               //drawLineChart(parsed_data1, '#line_chart', dt, 'blue');
               //drawLineChart(parsed_data2, '#line_chart2', dt2, 'red');
               //drawNormalizedChart(parsed_data1, parsed_data2, '#line_chart3', dt, dt2);
           },
           error: function (result) {
               alert("error");
               error();
           }
       });
}

function drawMultiBarChart(data, graph_name, dt, multi) {
    var chart = nv.models.multiBarChart()
      .margin({left: 100})
      .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
      .rotateLabels(0)      //Angle to rotate x-axis labels.
      //.showControls(true)   //Allow user to switch between 'Grouped' and 'Stacked' mode.
      .groupSpacing(0.1)    //Distance between each group of bars.
    ;

    if(multi){ // Multi
      chart.showControls(true);
    }
    else{ // Single
      chart.showControls(false);
    }
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

function drawNVline(data, graph_name, dt) {
  var chart = nv.models.lineChart()
                .margin({left: 100})  //Adjust chart margins to give the x-axis some breathing room.
                .useInteractiveGuideline(true)  //We want nice looking tooltips and a guideline!
                //.transitionDuration(350)  //how fast do you want the lines to transition?
                .showLegend(true)       //Show the legend, allowing users to turn on/off line series.
                .showYAxis(true)        //Show the y-axis
                .showXAxis(true)        //Show the x-axis
  ;
  


  chart.xAxis     //Chart x-axis settings
      .axisLabel('Time (Years)')
      .tickFormat(d3.format('r'));

  chart.yAxis     //Chart y-axis settings
      .axisLabel('Amount')
      .tickFormat(d3.format(',1000fM'));

  /* Done setting the chart up? Time to render it!*/
  
  //var myData = format_data(data, dt, '#ff7f0e');   //You need data...
  //var myData = sinAndCos()
  
  //debugger;
  d3.select(graph_name)    //Select the <svg> element you want to render the chart in.   
      .datum(data)         //Populate the <svg> element with chart data...
      .call(chart);          //Finally, render the chart!

  //Update the chart when window resizes.
  nv.utils.windowResize(function() { chart.update() });
  return chart;
}

/*used to format the data in proper form for NVD3
  values: 
  key: 
  color:
*/

//used to grab the proper data types from the overall data table
function format(data, dt_id){
  var out = [];
  var i = 0;
  while( i < data.length){
    if(data[i].data_type_id == dt_id){
      out.push(data[i]);
    }i++;
  }
  return out;
}


function parse_xy(data){
  
  var xymap = data.map(function(item) {
    return {
      x: item.value_1,
      y: item.value_2,
      data_type_id: item.data_type_id
    };
  });
  //debugger;
  return xymap;
}

function format_data(data, dt, colr){
  var x_y = [];
  debugger;
  data.map(function(item){
    x_y.push({x: item.x, y: item.y})
  })
//debugger;
  return [
    {
      values: x_y,
      key: dt,
      color: colr
    }
  ];

}

function format_combined_data(data, data2, dt, dt2, colr, colr2, norm_flag){
  var x_y = [];
  var x_y2 = [];

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
//debugger;
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

/**************************************
 * Simple test data generator
 */
function sinAndCos() {
  var sin = [],sin2 = [],
      cos = [];

  //Data is represented as an array of {x,y} pairs.
  for (var i = 0; i < 100; i++) {
    sin.push({x: i, y: Math.sin(i/10)});
    sin2.push({x: i, y: Math.sin(i/10) *0.25 + 0.5});
    cos.push({x: i, y: .5 * Math.cos(i/10)});
  }

  //Line chart data should be sent as an array of series objects.
  return [
    {
      values: sin,      //values - represents the array of {x,y} data points
      key: 'Sine Wave', //key  - the name of the series.
      color: '#ff7f0e'  //color - optional: choose your own line color.
    },
    
  ];
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

/**************************************
 * Simple test data generator
 */
function randomData(groups, points) { //# groups,# points per group
  var data = [],
      shapes = ['circle', 'cross', 'triangle-up', 'triangle-down', 'diamond', 'square'],
      random = d3.random.normal();

  for (i = 0; i < groups; i++) {
    data.push({
      key: 'Group ' + i,
      values: []
    });

    for (j = 0; j < points; j++) {
      data[i].values.push({
        x: random()
      , y: random()
      , size: Math.random()   //Configure the size of each scatter point
      , shape: (Math.random() > 0.95) ? shapes[j % 6] : "circle"  //Configure the shape of each scatter point.
      });
    }
  }

  return data;
}

function drawLineViewFinder(data, graph_name, dt) {
  var chart = nv.models.lineWithFocusChart();

  chart.xAxis
      .tickFormat(d3.format(',f'));

  chart.yAxis
      .tickFormat(d3.format(',.2f'));

  chart.y2Axis
      .tickFormat(d3.format(',.2f'));

  d3.select('#chart svg')
      .datum(data)
      .transition().duration(500)
      .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
}
/**************************************
 * Simple test data generator
 */

function testData() {
  return stream_layers(3,128,.1).map(function(data, i) {
    return { 
      key: 'Stream' + i,
      values: data
    };
  });
}

//Generate some nice data.
function exampleData() {
  return stream_layers(3,10+Math.random()*100,.1).map(function(data, i) {
    return {
      key: 'Stream #' + i,
      values: data
    };
  });
}

function clearDrawing(){
  d3.selectAll("svg > *").remove();
}

function calcAvg(lineData, num){
  var i = 0;
  var total = 0;
  while(lineData[i] != null){
    if(num == 1)
      total = total + lineData[i].y;
    else
      total += lineData[i].y2;
    i++;
  }
  console.log(total/i);
  return total/i;
}

function calculateMagDiff(lineData){
  var y1_avg = calcAvg(lineData, 1);
  var y2_avg = calcAvg(lineData, 2);
  var order = 0;

  var min = Math.min(y1_avg,y2_avg);
  while(min < Math.max(y1_avg,y2_avg)){
    order++;
    min = min * 10;
  }
  console.log(order);
  return order;
}

function normalizeVal(lineData){
  var i = 0;
  var total = 0;
  while(lineData[i] != null){
    total = total + lineData[i].y;
    i++;
  }
  console.log(total/i);
  return total;
}

function drawNormalizedChart(lineData, lineData2, graph_name, dt, dt2){
  var num = 0;
  var y_total = 0;
  var y2_total = 0;

  y_total = normalizeVal(lineData);
  y2_total = normalizeVal(lineData2);
  //debugger;

  var vis = d3.select(graph_name),
    WIDTH = 1000,
    HEIGHT = 500,
    MARGINS = {
      top: 30,
      right: 20,
      bottom: 30,
      left: 150
    },
    xRange = d3.scale.linear().range([MARGINS.left, WIDTH - MARGINS.right]).domain([
      Math.min(
        d3.min(lineData, function(d) {
          return d.x;
        }), 
        d3.min(lineData2, function(d) {
            return d.x;
        })
      ), 
      Math.max(
        d3.max(lineData, function(d) {
          return d.x;
        }),
        d3.max(lineData2, function(d) {
          return d.x;
        })
      )
    ]),
    yRange = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([
      Math.min(
        d3.min(lineData, function(d) {
          return d.y /y_total;
        }), 
        d3.min(lineData2, function(d) {
            return d.y /y2_total;
        })
      ), 
      Math.max(
        d3.max(lineData, function(d) {
          return d.y / y_total;
        }),
        d3.max(lineData2, function(d) {
          return d.y / y2_total;
        })
      )
      ]);

    var xAxis = d3.svg.axis()
      .scale(xRange)
      .tickSize(5)
      .tickSubdivide(true),
    yAxis = d3.svg.axis()
      .scale(yRange)
      .tickSize(5)
      .orient('left')
      .tickSubdivide(true);
 
    vis.append('svg:g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + (HEIGHT - MARGINS.bottom) + ')')
      .call(xAxis);
     
    vis.append('svg:g')
      .attr('class', 'y axis')
      .attr('transform', 'translate(' + (MARGINS.left) + ',0)')
      .call(yAxis);

    var lineFunc = d3.svg.line()
    .x(function(d) {
      return xRange(d.x);
    })
    .y(function(d) {
      return yRange(d.y / y_total);
    })
    .interpolate('linear');

    vis.append('svg:path')
      .attr('d', lineFunc(lineData))
      .attr('stroke', 'blue')
      .attr('stroke-width', 2)
      .attr('fill', 'none');

    var lineFunc2 = d3.svg.line()
    .x(function(d) {
      return xRange(d.x);
    })
    .y(function(d) {
      return yRange(d.y / y2_total);
    })
    .interpolate('linear');

    vis.append('svg:path')
      .attr('d', lineFunc2(lineData2))
      .attr('stroke', 'red')
      .attr('stroke-width', 2)
      .attr('fill', 'none');

    vis.append("text")
          .attr("x", (WIDTH / 2))             
          .attr("y", (MARGINS.top))
          .attr("text-anchor", "middle")  
          .style("font-size", "16px") 
          .text("Normalize Data vs Time");
}

function drawLineChart(lineData, graph_name, dt, color){

  var vis = d3.select(graph_name),
    WIDTH = 1000,
    HEIGHT = 500,
    MARGINS = {
      top: 30,
      right: 20,
      bottom: 30,
      left: 150
    },
    xRange = d3.scale.linear().range([MARGINS.left, WIDTH - MARGINS.right]).domain([d3.min(lineData, function(d) {
      return d.x;
    }), d3.max(lineData, function(d) {
      return d.x;
    })]),
    yRange = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([d3.min(lineData, function(d) {
      return d.y;
    }), d3.max(lineData, function(d) {
      return d.y;
    })]),
    xAxis = d3.svg.axis()
      .scale(xRange)
      .tickSize(5)
      .tickSubdivide(true),
    yAxis = d3.svg.axis()
      .scale(yRange)
      .tickSize(5)
      .orient('left')
      .tickSubdivide(true);
 
vis.append('svg:g')
  .attr('class', 'x axis')
  .attr('transform', 'translate(0,' + (HEIGHT - MARGINS.bottom) + ')')
  .call(xAxis);
 
vis.append('svg:g')
  .attr('class', 'y axis')
  .attr('transform', 'translate(' + (MARGINS.left) + ',0)')
  .call(yAxis);

  var lineFunc = d3.svg.line()
  .x(function(d) {
    return xRange(d.x);
  })
  .y(function(d) {
    return yRange(d.y);
  })
  .interpolate('linear');

  
  vis.append('svg:path')
    .attr('d', lineFunc(lineData))
    .attr('stroke', color)
    .attr('stroke-width', 2)
    .attr('fill', 'none');

  vis.append("text")
    .attr("x", (WIDTH / 2))             
    .attr("y", (MARGINS.top))
    .attr("text-anchor", "middle")  
    .style("font-size", "16px") 
    .text(dt);
  
}
 
function draw(data) {
    debugger;
    var color = d3.scale.category20b();
    var width = 420,
        barHeight = 20;
 
    var x = d3.scale.linear()
        .range([0, width])
        .domain([300000000, d3.max(data)]);
 
    var chart = d3.select("#graph")
        .attr("width", width)
        .attr("height", barHeight * data.length);
 
    var bar = chart.selectAll("g")
        .data(data)
        .enter().append("g")
        .attr("transform", function (d, i) {
                  return "translate(0," + i * barHeight + ")";
              });
 
    bar.append("rect")
        .attr("width", x)
        .attr("height", barHeight - 1)
        .style("fill", function (d) {
                   return color(d)
               })
 
    bar.append("text")
        .attr("x", function (d) {
                  return x(d) - 10;
              })
        .attr("y", barHeight / 2)
        .attr("dy", ".35em")
        .style("fill", "white")
        .text(function (d) {
                  return d;
              });
        console.log("made it!")
}

 
function error() {
    console.log("error")
}