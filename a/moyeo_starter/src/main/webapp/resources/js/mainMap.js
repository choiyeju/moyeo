// 1. 맵 핸들링을 위한 최상위 객체(mainMap) 생성 및 파라메터 설정 
var mymap = {
	minZoom : 7,
	maxZoom : 22,
	latlng : new L.LatLng(35.162007, 128.592784), //중심좌표            울진
	//northEast : new L.LatLng(44.099164, 134.077540), // 북동
	//southWest : new L.LatLng(30.697502, 120.728551), // 남서
	//bounds : [[44.099164, 134.077540], [30.697502, 120.728551]],// n,s
	baseLayers : {
		emap : {
		}
	}
};
		
// 2. mainMap의 파라메터를 참조해서 실질적으로 map 객체를 인스턴스화하고, mainMap.map 변수에 할당 
mymap.map = L.map("mapid", {
	crs: L.CRS.EPSG3857,
	//bounds : mymap.bounds,
	//zoomReverse: true, //다음지도는 레벨 13(小축척) -> 레벨 0(大축척)으로 줄어듦
	//zoomOffset: 1,
	minZoom : mymap.minZoom,
	maxZoom : mymap.maxZoom,
	//maxBounds : new L.LatLngBounds(mymap.southWest, mymap.northEast),
	contextmenu : true,
	zoomControl : false,
	zoomsliderControl : false,
	renderer : L.canvas(),
	//renderer: L.svg(),
	preferCanvas: true,
	attributionControl:false,
	//crossOrigin: true,
	//crossOriginCredentials: true,
    editable:true
});

// osm 오픈스트리트맵
var baseLayer_osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png?{foo}'
		, {foo: 'bar', attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'});
baseLayer_osm.options.crs=L.CRS.EPSG3857;
baseLayer_osm.options.maxZoom=20;
baseLayer_osm.options.minZoom=1;
baseLayer_osm.options.zoomOffset=0;

var baseLayer = baseLayer_osm;
var baseCrs = L.CRS.EPSG3857;

mymap.map.addLayer(baseLayer_osm);

var searchLayer = L.geoJson();
var searchStyle = {
	    "color": "#007733",
	    "weight": 5,
	    "opacity": 0.5,
	    fill:false
	};
	mymap.map.setView([37, 128], defaultLvl);
	L.control.compass().addTo(mymap.map);
	L.control.betterscale({position: "bottomright",metric:true,imperial:false}).addTo(mymap.map);

	// 배경레이어 좌표계 전환
	function changeCrs(crs) {
		var center = mymap.map.getCenter();
		mymap.map.options.crs=crs;
		mymap.map.setView(center);
		mymap.map._resetView(mymap.map.getCenter(), mymap.map.getZoom());
	}
	mymap.map.on('zoomend', function(ev) {
		var currZoom = mymap.map.getZoom();
	    $("#scale").children().each(function(){
	    	if($(this).attr("data-level") == currZoom) {
	    		$("#change-scale").text($(this).text());
	    		return;
	    	}
	    });
	});
	mymap.map.on('moveend', function(ev) {
		var cur_zoom = mymap.map.getZoom();
		return;
	});
	
	mymap.map.on('click', function(ev) {
		var popLocation= ev.latlng;
		if(popLocation == null) return;
        //var popup = L.popup().setLatLng(popLocation).setContent('<p>Hello world!<br />This is a nice popup.</p>').openOn(mymap.map);
//        var xy = [];
//        var pointDest = Proj4js.transform(map_epsg, def_epsg, new Proj4js.Point(popLocation.lng + ',' + popLocation.lat));
//		xy.push(pointDest.x.toFixed(5));
//		xy.push(pointDest.y.toFixed(5));
		return;
	});
	
	// 마우스 우버튼 클릭
	mymap.map.on('contextmenu', function(ev) {
		// 객체 그리기 중이면 한스텝 취소
		DeleteDrawingLastVertex();
		return;
	});
	var downkey = 0;
	// KeyDown
	document.addEventListener('keydown', function(event) {
	    const key_code = event.keyCode;
	    // [ESC] Key
	    if (key_code == 27) {
	    }
	    // [ENTER] Key
	    if (key_code == 13) {
	    }
	    // [CTRL] Key
	    if (key_code == 17) {
	    	downkey = key_code;
	    	SetObjectDragEnable( true );
	    } else {
	    	downkey = key_code;
	    }
	    return;
	});
	
	document.addEventListener('keyup', function(event) {
	    const key_code = event.keyCode;
	    // [CTRL] Key
	    if (key_code == 17) {
	    }
	    downkey = 0;
	    return;
	});
	
	document.addEventListener('keypress', function(event) {
	    const key_code = event.keyCode;
	    return;
	});
	
	//GeoJson클릭시 속성보기 이벤트 함수
	function eachFeature(feature, layer) {
	 	layer.on('click', function (e) {
	 	});
//	 	layer.on('mouseover', function (e) {});
//	 	layer.bindPopup(""+feature.properties.showfield, {offset: L.point(1, 6)});
	}
/////////////////////////////////////
 