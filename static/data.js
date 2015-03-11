var w = 500;
var h = 300;
var padding = 30;

var dataset = window.data;

var xScale = d3.scale.linear()
                     .domain( [0, dataset.length - 1] )
                     .range( [padding, w - padding * 2] );

var yScale = d3.scale.linear()
                     .domain( [0, d3.max(dataset, function(d) {
                       return d.value;
                     })] )
                     .range( [h - padding, padding] );

var xAxis = d3.svg.axis()
                  .scale(xScale)
                  .orient("bottom")
                  .ticks(7);

var yAxis = d3.svg.axis()
                  .scale(yScale)
                  .orient("left")
                  .ticks(5);

var svg = d3.select("div#graph")
            .append("svg")
            .attr("width", w)
            .attr("height", h);

svg.append("clipPath")
   .attr("id", "chart-area")
   .append("rect")
   .attr("x", padding)
   .attr("y", padding)
   .attr("width", w - padding * 3)
   .attr("height", h - padding * 2);

svg.append("g")
   .attr("id", "circles")
   .attr("clip-path", "url(#chart-area)")
   .selectAll("circle")
   .data(dataset)
   .enter()
   .append("circle")
   .attr("cx", function(d) {
     return xScale(d.index);
   })
   .attr("cy", function(d) {
     return yScale(d.value);
   })
   .attr("r", 2);

svg.append("g")
   .attr("class", "axis")
   .attr("transform", "translate(0," + (h - padding) + ")")
   .call(xAxis);

svg.append("g")
   .attr("class", "axis")
   .attr("transform", "translate(" + padding + ",0)")
   .call(yAxis);
