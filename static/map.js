var contentString = new Array(window.data["objects"].length);
var positionArray = new Array(window.data["objects"].length);
var markerArray   = new Array(window.data["objects"].length);

truncateDecimals = function (number, digits) {
  var multiplier   = Math.pow(10,digits),
      adjustedNum  = number * multiplier,
      truncatedNum = Math[adjustedNum < 0 ? 'ceil' : 'floor'](adjustedNum);
  console.log(truncatedNum/multiplier);
  return truncatedNum / multiplier;
}

for (var i = 0; i < window.data["objects"].length; i++) {
  var distance = window.data["objects"][i]["sensors"][0]["latest_reading"]["value"];
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
    + '<div class="bodyContent">'
    /*
    + 'Alias : '
    + window.data["objects"][i]["alias"]
    + '<br />'
    */
    + window.data["objects"][i]["sensors"][0]["alias"]
    + ' : '
    + truncateDecimals(parseFloat(window.data["objects"][i]["sensors"][0]["latest_reading"]["value"]), 2)
    + '<br />'
    + window.data["objects"][i]["sensors"][1]["alias"]
    + ' : '
    + truncateDecimals(parseFloat(window.data["objects"][i]["sensors"][1]["latest_reading"]["value"]), 2)
    + '<br />'
    + window.data["objects"][i]["sensors"][2]["alias"]
    + ' : '
    + truncateDecimals(parseFloat(window.data["objects"][i]["sensors"][2]["latest_reading"]["value"]), 2)
    + '</div>'
    + '</div>';

  positionArray[i] = new google.maps.LatLng( window.data["objects"][i]["latitude"], window.data["objects"][i]["longitude"] );
}

function initialize() {

  var lat1 = window.data["objects"][0]["latitude"];
  var lng1 = window.data["objects"][0]["longitude"];
  var latLng1 = new google.maps.LatLng( lat1, lng1 );

  // Map options
  var mapOptions = {
    center: latLng1,
    zoom: 19,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  };

  // Initialize map
  var map = new google.maps.Map( document.getElementById('map-canvas'), mapOptions );

  setMarkers(map, window.data["objects"]);
  infowindow = new google.maps.InfoWindow({
    content: "loading..."
  });

}

function setMarkers(map, markers) {

  for (var i = 0; i < markers.length; i++) {
    var site = markers[i];
    var siteLatLng = new google.maps.LatLng(site["latitude"], site["longitude"]);
    var distance = window.data["objects"][i]["sensors"][0]["latest_reading"]["value"];
    var icon;
    if (parseFloat(distance) < 30) {
      icon = '/redpin75.png';
    } else {
      icon = '/greenpin75.png';
    }

    var marker = new google.maps.Marker({
      position: siteLatLng,
      map: map,
      title: site["id"].toString(),
      icon: icon,
      html: contentString[i]
    });

    var content = "Some content";

    google.maps.event.addListener(marker, "click", function() {
      infowindow.setContent(this.html);
      infowindow.open(map, this);
    });
  }

}

google.maps.event.addDomListener( window, 'load', initialize );
