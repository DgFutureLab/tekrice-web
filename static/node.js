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

//////

var test = {"my":"json"};

var width_m = 420;

var svg_moisture = d3.select(".moisture")
  .data(window.data)
  .attr("width", 420)
  .attr("height", 200);

var line_moisture = d3.svg.line().x

svg_moisture.append("g")
  .attr("class", "x axis")
  .attr("transform", "translate(" + );

//////

var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width  = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var parseDate = d3.time.format("%d-%b-%y").parse;

var x = d3.time.scale().range([0, width]);
var y = d3.scale.linear().range([height, 0]);

var xAxis = d3.svg.axis().scale(x).orient("bottom");
var yAxis = d3.svg.axis().scale(y).orient("left");

var line = d3.svg.line()
  .x(function(d) { return x(d.date); })
  .y(function(d) { return y(d.close); });

var svg = d3.select(".chart")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.tsv("/data.tsv", function(error, data) {
  data.forEach(function(d) {
    d.date = parseDate(d.date);
    d.close = +d.close;
  });

  x.domain(d3.extent(data, function(d) { return d.date; }));
  y.domain(d3.extent(data, function(d) { return d.close; }));

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6).attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Price ($)");

  svg.append("path").datum(data).attr("class", "line").attr("d", line);
});

function type(d) {
  d.frequency = +d.frequency;
  return d;
}
