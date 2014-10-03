function initialize() {

  var lat1 = window.data[0]["latitude"];
  var lng1 = window.data[0]["longitude"];
  var latLng1 = new google.maps.LatLng( lat1, lng1 );

  // Map options
  var mapOptions = {
    center: latLng1,
    zoom: 22,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  };

  // Initialize map
  var map = new google.maps.Map( document.getElementById('map-canvas'), mapOptions );

  var contentString = new Array(window.data.length);
  var positionArray = new Array(window.data.length);
  var markerArray   = new Array(window.data.length);

  for (var i = 0; i < window.data.length; i++) {
    console.log(i.toString());
    // Pop-up info
    contentString[i] = '<div class="content">'
      + '<a href="/dashboard/nodes/2"><h1>uuid_02</h1></a>'
      + '<div class="bodyContent">'
      + i.toString()
      + '</div>'
      + '</div>';

    var image;
    if (window.data[i]["status"] == "ok") {
      image = '/antena-green.png';
    } else {
      image = '/antena-red.png';
    }

    positionArray[i] = new google.maps.LatLng( window.data[i]["latitude"], window.data[i]["longitude"] );
    markerArray[i] = new google.maps.Marker({
      position: positionArray[i],
      map: map,
      icon: image
    });
    markerArray[i].setMap(map);
  }

  // Needs refactoring into loop, but not possible for some reason
  google.maps.event.addListener(markerArray[0], 'click', function() {
    var infowindow = new google.maps.InfoWindow({ content: contentString[0] });
    infowindow.open(map, markerArray[0]);
  });
  google.maps.event.addListener(markerArray[1], 'click', function() {
    var infowindow = new google.maps.InfoWindow({ content: contentString[1] });
    infowindow.open(map, markerArray[1]);
  });
  google.maps.event.addListener(markerArray[2], 'click', function() {
    var infowindow = new google.maps.InfoWindow({ content: contentString[2] });
    infowindow.open(map, markerArray[2]);
  });
  google.maps.event.addListener(markerArray[3], 'click', function() {
    var infowindow = new google.maps.InfoWindow({ content: contentString[3] });
    infowindow.open(map, markerArray[3]);
  });

}
google.maps.event.addDomListener( window, 'load', initialize );
