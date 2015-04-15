var line_humid = d3.svg.line()
  .x(function(d) { return x(d.date); })
  .y(function(d) { return y(d.humidity); });

var svg_humid = d3.select(".moisture")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.csv("/data/test_humid.csv", function(error, data) {
  data.forEach(function(d) {
    d.date = parseDate(d.date);
    d.humidity = +d.humidity;
  });

  x.domain(d3.extent(data, function(d) { return d.date; }));
  y.domain(d3.extent(data, function(d) { return d.humidity; }));

  svg_humid.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  svg_humid.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6).attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Humidity (%)");

  svg_humid.append("path").datum(data).attr("class", "line").attr("d", line_humid);
});
