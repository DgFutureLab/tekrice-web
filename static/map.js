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

  // Pop-up info
  var contentString = '<div id="content">' + '<a href="/dashboard"><h1>xxxxxxx01_uuid</h1></a>' + '<div id="bodyContent">' + '</div>';
  var infowindow = new google.maps.InfoWindow({ content: contentString });

  // Initialize map
  var map = new google.maps.Map( document.getElementById('map-canvas'), mapOptions );

  for (var i = 0; i < window.data.length; i++) {
    var image;
    if (window.data[i]["status"] == "ok") {
      image = '/antena-green.png';
    } else {
      image = '/antena-red.png';
    }

    var position = new google.maps.LatLng( window.data[i]["latitude"], window.data[i]["longitude"] );
    var marker   = new google.maps.Marker({
      position: position,
      map: map,
      icon: image
    });
    marker.setMap(map);
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
  }
}
google.maps.event.addDomListener( window, 'load', initialize );
