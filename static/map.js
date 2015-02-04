var contentString = new Array(window.data["objects"].length);
var positionArray = new Array(window.data["objects"].length);
var markerArray   = new Array(window.data["objects"].length);

truncateDecimals = function (number, digits) {
  var multiplier   = Math.pow(10,digits),
      adjustedNum  = number * multiplier,
      truncatedNum = Math[adjustedNum < 0 ? 'ceil' : 'floor'](adjustedNum);
  return truncatedNum / multiplier;
}

for (var i = 0; i < window.data["objects"][0]["nodes"].length; i++) {
  var distance = window.data["objects"][0]["nodes"][i]["sensors"][1]["latest_reading"];
  var riceimage;
  if (parseFloat(distance) < 30) {
    riceimage = '<img src="/sadrice25.jpg"/>';
  } else {
    riceimage = '<img src="/happyrice25.jpg"/>';
  }
  // Pop-up info
  contentString[i] = '<div class="content">'
    + '<div class="ricepic">'
    + riceimage
    + '</div>'
    + '<div class="chart" id="chart'
    + i.toString()
    + '">'
    + '<br />'
    + '<img src="/wheat10.png" />'
    + truncateDecimals(parseFloat(window.data["objects"][0]["nodes"][i]["sensors"][0]["latest_reading"]), 2)
    + '<br />'
    + '<img src="/water50.png" />'
    + truncateDecimals(parseFloat(window.data["objects"][0]["nodes"][i]["sensors"][1]["latest_reading"]), 2)
    + '<br />'
    + '<img src="/temp50.png" />'
    + truncateDecimals(parseFloat(window.data["objects"][0]["nodes"][i]["sensors"][2]["latest_reading"]), 2)
    + '<br />'
    + '<a href="/node/'
    + window.nodesite
    + '/'
    + window.data["objects"][0]["nodes"][i]["alias"]
    + '">Node Link</a>'
    + '</div>'
    + '</div>';

  positionArray[i] = new google.maps.LatLng( window.data["objects"][0]["nodes"][i]["latitude"], window.data["objects"][0]["nodes"][i]["longitude"] );
}

function initialize() {

  var lat1 = window.data["objects"][0]["nodes"][0]["latitude"];
  var lng1 = window.data["objects"][0]["nodes"][0]["longitude"];
  var latLng1 = new google.maps.LatLng( lat1, lng1 );

  // Map options
  var mapOptions = {
    center: latLng1,
    zoom: 19,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  };

  // Initialize map
  var map = new google.maps.Map( document.getElementById('map-canvas'), mapOptions );

  setMarkers(map, window.data["objects"][0]["nodes"]);
  infowindow = new google.maps.InfoWindow({
    content: "loading..."
  });

}

function setMarkers(map, markers) {

  for (var i = 0; i < markers.length; i++) {
    var node = markers[i];
    var nodeLatLng = new google.maps.LatLng(node["latitude"], node["longitude"]);
    var distance   = markers[i]["sensors"][1]["latest_reading"];
    var icon;
    if (parseFloat(distance) < 30) {
      icon = '/redpin75.png';
    } else {
      icon = '/greenpin75.png';
    }

    var marker = new google.maps.Marker({
      position: nodeLatLng,
      map: map,
      title: node["alias"].toString(),
      icon: icon,
      html: contentString[i]
    });

    google.maps.event.addListener(marker, "click", function() {
      infowindow.setContent(this.html);
      infowindow.open(map, this);
    });
  }
}

google.maps.event.addDomListener( window, 'load', initialize );
