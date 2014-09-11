var data1 = [4,8,15,16,23,42];

var width1 = 420, 
    barHeight1 = 20;

var x1 = d3.scale.linear()
  .domain([0, d3.max(data1)])
  .range([0, width1]);

var chart1 = d3.select(".temp")
  .attr("width", width1)
  .attr("height", barHeight1 * data1.length);

var bar1 = chart1.selectAll("g")
  .data(data1)
  .enter().append("g")
  .attr("transform", function(d,i) { return "translate(0," + i*barHeight1 + ")"; });

bar1.append("rect")
  .attr("width", x1)
  .attr("height", barHeight1 - 1);

bar1.append("text")
  .attr("x", function(d) { return x1(d) - 3; })
  .attr("y", barHeight1 / 2)
  .attr("dy", ".35em")
  .text(function(d) { return d; });

/*
d3.select(".temp").selectAll("div").data(data).enter().append("div").style("width", function(d) {
  return d * 10 + "px";
}).text(function(d) { return d; });
*/

var width = 960,
    barHeight= 20;

var x = d3.scale.linear().range([0, width]);

var chart = d3.select(".chart")
  .attr("width", width);

d3.tsv("/data.tsv", type, function(error, data) {
  x.domain([0, d3.max(data, function(d) { return d.value; })]);

  chart.attr("height", barHeight * data.length);

  var bar = chart.selectAll("g")
    .data(data)
    .enter().append("g")
    .attr("transform", function(d,i) { return "translate(0," + i*barHeight + ")"; });
  
  bar.append("rect")
    .attr("width", function(d) { return x(d.value); })
    .attr("height", barHeight - 1 );
  
  bar.append("text")
    .attr("x", function(d) { return x(d.value) - 3; } )
    .attr("y", barHeight / 2)
    .attr("dy", ".35em")
    .text(function(d) { return d.value; });
});

function type(d) {
  d.value = +d.value;
  return d;
}
