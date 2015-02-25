// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$.ajax({
           type: "GET",
           contentType: "application/json; charset=utf-8",
           //params: {limit:10},
           data: {limit:10},
           url: 'data',
           dataType: 'json',
           success: function (data) {
                debugger;
               var parsed_data = parse(data)

               //hardcoded for the bar chart prototype
               //parse_xy is still a work in progess so that
               //we can use the data in our db for the prototype line chart
               var lineData = [{
  x: 1,
  y: 5
}, {
  x: 20,
  y: 20
}, {
  x: 40,
  y: 10
}, {
  x: 60,
  y: 40
}, {
  x: 80,
  y: 5
}, {
  x: 100,
  y: 60
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

function parse(data){
  var out = [];
  var i = 0;
  for(i = 0; i < 5;i++){
    out.push(data.graph[i].population);
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
      left: 50
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