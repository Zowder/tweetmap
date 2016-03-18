var map;
var infowindow = new google.maps.InfoWindow();
function initialize() {

    var mapProp = {
        center: new google.maps.LatLng(-5.9182125, -35.2284630621634),
        zoom: 7,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    map = new google.maps.Map(document.getElementById("map"), mapProp);
	$(document).ready(function() {
    $.getJSON('pontos.json', function(pontos) {

    	$.each(pontos, function (key, data) {

        var latLng = new google.maps.LatLng(data.Latitude, data.Longitude);

        var marker = new google.maps.Marker({
            position: latLng,
            map: map,
            icon: 'marcador.png',
            title: data.Descricao
        });

        var details = data.Descricao;

        bindInfoWindow(marker, map, infowindow, details);

      });

    });
	});
}

function bindInfoWindow(marker, map, infowindow, strDescription) {
    google.maps.event.addListener(marker, 'click', function () {
        infowindow.setContent(strDescription);
        infowindow.open(map, marker);
    });
}
google.maps.event.addDomListener(window, 'load', initialize);
