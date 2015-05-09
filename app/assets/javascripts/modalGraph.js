var graphModal = function(eventId0, eventId1, title0, title1){
    $.ajax({
           type: "GET",
           contentType: "application/json; charset=utf-8",
           url: '/analyze/graph/'+eventId0+','+eventId1+'',
           dataType: 'json',

           success: function (data) {
              $("#myModalLabel").empty();
              //console.log("1" + title0 + eventId0 + title1 + eventId1 + "" );
              var choice = 0;
              var graphTitle = "" + title0 + " vs. " + title1 + "";
              var rawD0 = format(data, eventId0);
              var rawD1 = format(data, eventId1);
              var mappedD0 = mapData(rawD0);
              var mappedD1 = mapData(rawD1);
              var readyD0 = nvd3Format(mappedD0, title0, '#ff7f0e');
              var readyD1 = nvd3Format(mappedD1, title1, '#2ca02c');
              var comboD = format_combined_data(mappedD0, mappedD1, title0, title1, '#ff7f0e', '#2ca02c', 1);
              console.log("2" + title0 + eventId0 + title1 + eventId1+ "" );
              d3.select("#myModalLabel").append("text").text(graphTitle);
              setTimeout(function(){ drawMultiBarChart(comboD,'#graph'); }, 1000);
              $('#graph-norm').on('click',function(){
                clearDrawing();
                comboD = format_combined_data(mappedD0, mappedD1, title0, title1, '#ff7f0e', '#2ca02c', 1);
                if(choice == 0)
                  drawMultiBarChart(comboD,'#graph');
                else if(choice == 1)
                  drawNVline(comboD, '#graph');
                else if(choice == 2)
                  drawScatter(comboD, '#graph');
              });

              $('#graph-nonnorm').on('click',function(){
                  clearDrawing();
                  comboD = format_combined_data(mappedD0, mappedD1, title0, title1, '#ff7f0e', '#2ca02c', 0);
                  if(choice == 0)
                    drawMultiBarChart(comboD,'#graph');
                  else if(choice == 1)
                    drawNVline(comboD, '#graph');
                  else if(choice == 2)
                    drawScatter(comboD, '#graph');
              });

              $('#graph-bar').on('click',function(){
                  clearDrawing();
                  choice = 0;
                  drawMultiBarChart(comboD,'#graph');
              });

              $('#graph-line').on('click',function(){
                  clearDrawing();
                  choice = 1;
                  drawNVline(comboD, '#graph');
              });

              $('#graph-scatter').on('click',function(){
                  clearDrawing();
                  choice = 2;
                  drawScatter(comboD, '#graph');
              });

           }
         });
   }

   var generateGraphInModal = function(eventId0, eventId1, title0, title1){

      $('#myModal').modal('toggle');
      $('#myModal').modal('show');
      $('#myModal').on('shown.bs.modal', graphModal(eventId0, eventId1, title0, title1));

   }

   function clearDrawing(){
    $("#graph").empty();
  }

    function drawScatter(data, graph_name){
  var chart = nv.models.scatterChart()
                .margin({top:50})
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

function drawNVline(data, graph_name) {
  var chart = nv.models.lineChart()
                .margin({left: 100, top: 50})  //Adjust chart margins to give the x-axis some breathing room.
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

   function drawMultiBarChart(data, graph_name) {
    var chart = nv.models.multiBarChart()
      .margin({top:50})
      .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
      .rotateLabels(0)      //Angle to rotate x-axis labels.
      .showControls(true)   //Allow user to switch between 'Grouped' and 'Stacked' mode.
      .groupSpacing(0.1)    //Distance between each group of bars.
    ;
  
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
    return total;
  }
    
  var format_combined_data = function(data, data2, dt, dt2, colr, colr2, norm_flag){
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