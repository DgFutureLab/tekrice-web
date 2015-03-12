// Visual padding
var w = 700;
var h = 300;
var padding = 30;

// Dataset
var dataset = window.data;

// Scales
var xScale = d3.scale.linear()
                     .domain( [0, dataset.length - 1] )
                     .range( [padding, w - padding * 2] );

var yScale = d3.scale.linear()
                     .domain( [0, d3.max(dataset, function(d) {
                       return d.value;
                     })] )
                     .range( [h - padding, padding] );

// Axis
var xAxis = d3.svg.axis()
                  .scale(xScale)
                  .orient("bottom")
                  .ticks(7);

var yAxis = d3.svg.axis()
                  .scale(yScale)
                  .orient("left")
                  .ticks(5);

// Initialize the SVG
var svg = d3.select("div#graph")
            .append("svg")
            .attr("width", w)
            .attr("height", h);

// Circles
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
   .attr("r", 5)
   .attr("fill", "blue")
   .on("mouseover", function(d) {
     var xPosition = parseFloat( d3.select(this).attr("cx") );
     var yPosition = parseFloat( d3.select(this).attr("cy") ) + 100 ;

     d3.select("#infobox")
       .style("left", xPosition + "px")
       .style("top", yPosition + "px")
       .select("#value")
       .text(d.value);
     d3.select("#infobox").classed("hidden", false);
   })
   .on("mouseout", function(d) {
     d3.select("#infobox").classed("hidden", true);
   });

// Lines
var lineFunction = d3.svg.line()
                         .x(function(d) { return xScale(d.index); })
                         .y(function(d) { return yScale(d.value); })
                         .interpolate("linear");

var lineGraph = svg.append("path")
                   .attr("d", lineFunction(dataset))
                   .attr("stroke", "blue")
                   .attr("stroke-width", 1)
                   .attr("fill", "none");

// Appending Axis
svg.append("g")
   .attr("class", "axis")
   .attr("transform", "translate(0," + (h - padding) + ")")
   .call(xAxis);

svg.append("g")
   .attr("class", "axis")
   .attr("transform", "translate(" + padding + ",0)")
   .call(yAxis);
