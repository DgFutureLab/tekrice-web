function initialize() {
  // Set position
  var latLng = new google.maps.LatLng(35.143816, 139.9882407);

  // Map options
  var mapOptions = {
    center: latLng,
    zoom: 22,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  };

  // Initialize map
  var map = new google.maps.Map( document.getElementById('map-canvas'), mapOptions );

  // Marker settings
  var image1 = '/antena-green.png';
  var marker1 = new google.maps.Marker({
    position: latLng,
    map: map,
    icon: image1
  });
  marker1.setMap(map);

  /*
  var image2 = '/antena-red.png';
  var latLng_red = new google.maps.LatLng(35.00, 139.00);
  var marker2 = new google.maps.Marker({
    position: latLng_red,
    map: map,
    icon: image2
  });
  marker2.setMap(map);
  */

  // Pop-up info
  var contentString = '<div id="content">' + '<a href="/dashboard"><h1>xxxxxxx01_uuid</h1></a>' + '<div id="bodyContent">' + '</div>';
  var infowindow = new google.maps.InfoWindow({ content: contentString });

  google.maps.event.addListener(marker1, 'click', function() {
    infowindow.open(map, marker1);
  });
}

google.maps.event.addDomListener( window, 'load', initialize );
