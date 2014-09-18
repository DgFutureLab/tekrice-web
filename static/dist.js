var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width  = 480 - margin.left - margin.right,
    height = 200 - margin.top - margin.bottom;

var parseDate = d3.time.format("%d-%b-%y").parse;

var x = d3.time.scale().range([0, width]);
var y = d3.scale.linear().range([height, 0]);

var xAxis = d3.svg.axis().scale(x).orient("bottom");
var yAxis = d3.svg.axis().scale(y).orient("left");

var line_dist = d3.svg.line()
  .x(function(d) { return x(d.date); })
  .y(function(d) { return y(d.distance); });

var svg_dist = d3.select(".distance")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.csv("/test_dist.csv", function(error, data) {
  data.forEach(function(d) {
    d.date = parseDate(d.date);
    d.distance = +d.distance;
  });

  x.domain(d3.extent(data, function(d) { return d.date; }));
  y.domain(d3.extent(data, function(d) { return d.distance; }));

  svg_dist.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  svg_dist.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6).attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Distance (cm)");

  svg_dist.append("path").datum(data).attr("class", "line").attr("d", line_dist);
});
