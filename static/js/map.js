var contentString = new Array(window.data["objects"].length);
var positionArray = new Array(window.data["objects"].length);
var markerArray   = new Array(window.data["objects"].length);

truncateDecimals = function (number, digits) {
  var multiplier   = Math.pow(10,digits),
      adjustedNum  = number * multiplier,
      truncatedNum = Math[adjustedNum < 0 ? 'ceil' : 'floor'](adjustedNum);
  return truncatedNum / multiplier;
}

get_distance_data = function (i) {
  if (window.data["objects"][0]["nodes"][i] != undefined) {
    if (window.data["objects"][0]["nodes"][i]["sensors"][0]["latest_reading"]["value"] != undefined) {
      return window.data["objects"][0]["nodes"][i]["sensors"][0]["latest_reading"]["value"];
    }
    else {
      return null;
    }
  }
  else {
    return null;
  }
}

get_temperature_data = function (i) {
  if (window.data["objects"][0]["nodes"][i]["sensors"][1]["latest_reading"]["value"] != undefined) {
    return window.data["objects"][0]["nodes"][i]["sensors"][1]["latest_reading"]["value"];
  }
  else {
    return null;
  }
}

get_humidity_data = function (i) {
  if (window.data["objects"][0]["nodes"][i]["sensors"][2]["latest_reading"]["value"] != undefined) {
    return window.data["objects"][0]["nodes"][i]["sensors"][2]["latest_reading"]["value"];
  }
  else {
    return null;
  }
}

for (var i = 0; i < window.data["objects"][0]["nodes"].length; i++) {
  var distance = get_distance_data();
  var riceimage;
  if (parseFloat(distance) < 30) {
    riceimage = '<img src="/images/sadrice25.jpg"/>';
  } else {
    riceimage = '<img src="/images/happyrice25.jpg"/>';
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
    + '<img src="/images/wheat10.png" />'
    //+ truncateDecimals(parseFloat(get_distance_data(i)), 2)
    + '<br />'
    + '<img src="/images/water50.png" />'
    //+ truncateDecimals(parseFloat(get_humidity_data(i)), 2)
    + '<br />'
    + '<img src="/images/temp50.png" />'
    //+ truncateDecimals(parseFloat(get_temperature_data(i)), 2)
    + '<br />'
    + '<a href="/node/'
    + window.nodesite
    + '/'
    + window.data["objects"][0]["nodes"][i]["id"]
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
    zoom: 22,
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
    var alias;

    if (node["alias"]) {
      alias = node["alias"].toString();
    } else {
      alias = window.nodesite + parseInt(i);
    }

    if (parseFloat(distance) < 30) {
      icon = { url:'/images/redpin75.png', id:alias };
    } else {
      icon = { url:'/images/greenpin75.png', id:alias };
    }

    var marker = new google.maps.Marker({
      position: nodeLatLng,
        map: map,
      title: alias,
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
