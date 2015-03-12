// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).ready(function() {
  
    //debugger; 
    
    //var year1 = $("#graphForm input[name=num]").val();
    //var year2 = $("#graphForm input[name=num2]").val();

    var dt = $("#test").data("dt");
    var dt2 = $("#test").data("dt2");
    var year_1 = $("#test").data("year");
    var year_2 = $("#test").data("year2");
    debugger;

    //getData(year1, year2)
    getData(dt, dt2, year_1, year_2)
    return false;});
    console.log( "ready!" );




var getData = function(dt, dt2, year, year2){

$.ajax({
           type: "GET",
           contentType: "application/json; charset=utf-8",
           //params: {limit:10},
           //data: {selected_dt:dt, selected_dt2:dt2, num:year_1, num2:year_2},
           url: 'data',
           dataType: 'json',
           success: function (data) {
                
               //var parsed_data = parse(data, year_range)
               var data1 = data.data_menu.slice(0, year2-year+1)
               var data2 = data.data_menu.slice(year2-year+1, data.data_menu.length);
               debugger;
               var parsed_data1 = parse_xy(data1);
               var parsed_data2 = parse_xy(data2);

               clearDrawing();
               drawLineChart(parsed_data1, '#line_chart', dt, 'blue');
               drawLineChart(parsed_data2, '#line_chart2', dt2, 'red');
               //drawLineChart(parsed_data, '#line_chart3');
               drawNormalizedChart(parsed_data1, parsed_data2, '#line_chart3', dt, dt2);
           },
           error: function (result) {
               alert("error");
               error();
           }
       });
}
/*
$.get( "data", function( data ) {
   var parsed_data = parse_xy(data);
   //var data_type = "#{@num}";
   debugger;
   clearDrawing();
   drawLineChart(parsed_data, '#line_chart');
   drawLineChart(parsed_data, '#line_chart2');
   //drawLineChart(parsed_data, '#line_chart3');
   drawNormalizedChart(parsed_data, '#line_chart3');
});*/

//queue().defer(d3.json, "data_menu/data").await(ready); function ready(error, places) { console.log(error); }

function clearDrawing(){
  d3.selectAll("svg > *").remove();
}

function parse_xy(data){
  
  var nameAndAgeList = data.map(function(item) {
    return {
      x: item.year,
      y: item.value,
      event_type: item.event_type_id
    };
  });
  debugger;
  return nameAndAgeList;
}

function calcAvg(lineData, num){
  var i = 0;
  var total = 0;
  //console.log(lineData[0].y_val);
  while(lineData[i] != null){
    if(num == 1)
      total = total + lineData[i].y;
    else
      total += lineData[i].y2;
    //console.log(total);
    i++;
  }
  //debugger;
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
    //debugger;
    min = min * 10;
  }
  console.log(order);
  return order;
}

function normalizeVal(lineData){
  var i = 0;
  var total = 0;
  //console.log(lineData[0].y_val);
  while(lineData[i] != null){
    total = total + lineData[i].y;
    i++;
  }
  //debugger;
  console.log(total/i);
  return total;
}

function drawNormalizedChart(lineData, lineData2, graph_name, dt, dt2){
  var num = 0;
  var y_total = 0;
  var y2_total = 0;

  y_total = normalizeVal(lineData);
  y2_total = normalizeVal(lineData2);
  debugger;

  var vis = d3.select(graph_name),
    WIDTH = 1000,
    HEIGHT = 1000,
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
    yRange = d3.scale.linear().range([MARGINS.left, WIDTH - MARGINS.right]).domain([0.1, 0]);
    /*yRange = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([d3.min(lineData, function(d) {
      return d.y /y_total;
    }), d3.max(lineData, function(d) {
      return d.y / y_total;
    })]);

    yRange2 = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([d3.min(lineData2, function(d) {
      return d.y /y_total;
    }), d3.max(lineData, function(d) {
      return d.y / y_total;
    })]);*/

    var xAxis = d3.svg.axis()
      .scale(xRange)
      .tickSize(5)
      .tickSubdivide(true),
    yAxis = d3.svg.axis()
      .scale(yRange)
      .tickSize(5)
      .orient('left')
      .tickSubdivide(true);

      //debugger;
 
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
    if (num == 1)return yRange(d.y);
    else return yRange(d.y / y_total);
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
    //debugger;
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
        .attr("y", 100)
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

      //debugger;
 
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

/*function drawLineChart(lineData, graph_name, dt, dt2){
  var num = 0;
  var mag_diff = 0;
  if(graph_name == '#line_chart') num = 1;
  else if(graph_name == '#line_chart2') num = 2;
  else{
    mag_diff = calculateMagDiff(lineData);
    debugger;
  }

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
      if(num == 1)return d.y;
      else if(num == 2) return d.y2;
      else return Math.min(d.y * Math.pow(10,mag_diff-1), d.y2);
    }), d3.max(lineData, function(d) {
      if(num == 1)return d.y;
      else if(num ==2) return d.y2;
      else return Math.max(d.y * Math.pow(10,mag_diff), d.y2);
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

      //debugger;
 
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
    if (num == 1)return yRange(d.y);
    else return yRange(d.y * Math.pow(10,mag_diff));
  })
  .interpolate('linear');

  if (num != 2) {
    vis.append('svg:path')
    .attr('d', lineFunc(lineData))
    .attr('stroke', 'blue')
    .attr('stroke-width', 2)
    .attr('fill', 'none');

    vis.append("text")
        .attr("x", (WIDTH / 2))             
        .attr("y", (MARGINS.top))
        .attr("text-anchor", "middle")  
        .style("font-size", "16px") 
        .text(dt);
  };

  var lineFunc2 = d3.svg.line()
  .x(function(d) {
    return xRange(d.x);
  })
  .y(function(d) {
    return yRange(d.y2);
  })
  .interpolate('linear');

  if (num != 1) {
    vis.append('svg:path')
    .attr('d', lineFunc2(lineData))
    .attr('stroke', 'red')
    .attr('stroke-width', 2)
    .attr('fill', 'none');

    vis.append("text")
        .attr("x", (WIDTH / 2))             
        .attr("y", (MARGINS.top))
        .attr("text-anchor", "middle")  
        .style("font-size", "16px") 
        .text(dt2);
  };

  
}*/