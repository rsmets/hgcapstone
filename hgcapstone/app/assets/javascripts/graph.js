// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.



$( document ).ready(function() {
  $("#graphForm").submit(function(){
    debugger; 
    var year1 = $("#graphForm input[name=num]").val();
    var year2 = $("#graphForm input[name=num2]").val();
    getData(year1, year2)
    return false;});
    console.log( "ready!" );


});

var getData = function(year, year2){


$.ajax({
           type: "GET",
           contentType: "application/json; charset=utf-8",
           //params: {limit:10},
           data: {year:year, year2:year2},
           url: 'data',
           dataType: 'json',
           success: function (data) {
                
               var parsed_data = parse(data)

               var lineData = [{
  x: parsed_data[0],
  y: parsed_data[1]
}, {
  x: parsed_data[2],
  y: parsed_data[3]
}, {
  x: parsed_data[4],
  y: parsed_data[5]
}, {
  x: parsed_data[6],
  y: parsed_data[7]
}, {
  x: parsed_data[8],
  y: parsed_data[9]
}];
               debugger;
               //draw(parsed_data);
               drawLineChart(lineData);
           },
           error: function (result) {
               alert("error");
               error();
           }
       });
}

getData(10, 1980);

function parse(data){
  var out = [];
  var i = 0;
  for(i = 0; i < 5;i++){
    out.push(data.graph[i].year);
    out.push(data.graph[i].population);
    //out.push(data.graph[i].gdp);
  }
  alert(out);
  //data

  return out;
}

function parse_xy(data){

  var nameAndAgeList = data.graph[0].map(function(item) {
    return {
      year: item.year,
      population: item.population
    };
  });

  //var out = [{:x, :y}];
  //var i = 0;
  //for(i = 0; i < 5;i++){
  //  out.push({x: data.graph[i].year, y: data.graph[i].population});
  //}
  alert(nameAndAgeList);
  //data

  return nameAndAgeList;
}

function drawLineChart(lineData){
  var vis = d3.select('#line_chart'),
    WIDTH = 1000,
    HEIGHT = 500,
    MARGINS = {
      top: 20,
      right: 20,
      bottom: 20,
      left: 20
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
  .attr('stroke', 'blue')
  .attr('stroke-width', 2)
  .attr('fill', 'none');
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