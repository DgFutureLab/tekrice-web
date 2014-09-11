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

var margin = {top: 20, right: 20, bottom: 30, left: 40},
    width  = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var x = d3.scale.ordinal()
  .rangeRoundBands([0, width], .1);

var y = d3.scale.linear()
  .range([height, 0]);

var xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom");

var yAxis = d3.svg.axis()
  .scale(y)
  .orient("left")
  .ticks(10, "%");

var svg = d3.select(".chart")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.json("http://128.199.191.249/reading/node_2/distance", function(data) {
  console.log(data);
});

d3.tsv("/data.tsv", type, function(error, data) {
  x.domain(data.map(function(d) { return d.letter; }));
  y.domain([0, d3.max(data, function(d) { return d.frequency; })]);

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);
  
  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Frequency");

  svg.selectAll(".bar")
    .data(data)
    .enter().append("rect")
    .attr("class", "bar")
    .attr("x", function(d) { return x(d.letter); })
    .attr("width", x.rangeBand())
    .attr("y", function(d) { return y(d.frequency); })
    .attr("height", function(d) { return height - y(d.frequency); });
});

function type(d) {
  d.frequency = +d.frequency;
  return d;
}
