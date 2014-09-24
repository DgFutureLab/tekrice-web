function initialize() {

  // Map options
  var mapOptions = {
    center: latLng1,
    zoom: 22,
    mapTypeId: google.maps.MapTypeId.SATELLITE
  };

  // Initialize map
  var map = new google.maps.Map( document.getElementById('map-canvas'), mapOptions );

  // Marker settings
  var image1 = '/antena-green.png';
  var latLng1 = new google.maps.LatLng(window.data[0]["latitude"], window.data[0]["longitude"]);
  var marker1 = new google.maps.Marker({
    position: latLng1,
    map: map,
    icon: image1
  });
  marker1.setMap(map);

  var image2 = '/antena-red.png';
  var latLng2 = new google.maps.LatLng(35.1438, 139.9884);
  var marker2 = new google.maps.Marker({
    position: latLng2,
    map: map,
    icon: image2
  });
  marker2.setMap(map);

  // Pop-up info
  var contentString = '<div id="content">' + '<a href="/dashboard"><h1>xxxxxxx01_uuid</h1></a>' + '<div id="bodyContent">' + '</div>';
  var infowindow = new google.maps.InfoWindow({ content: contentString });

  google.maps.event.addListener(marker1, 'click', function() {
    infowindow.open(map, marker1);
  });
  google.maps.event.addListener(marker2, 'click', function() {
    infowindow.open(map, marker2);
  });
}

google.maps.event.addDomListener( window, 'load', initialize );
