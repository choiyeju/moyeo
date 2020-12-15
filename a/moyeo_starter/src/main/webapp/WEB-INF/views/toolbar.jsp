<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="<c:url value='/resources/framework/jQuery-MiniColors/jquery.minicolors.js' />"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/resources/framework/jQuery-MiniColors/jquery.minicolors.css'/>">
</head>
<body>
<button type="button" class="btn_tool_open"><spring:message code="toolbar.toolopen"/></button>
	
	<!-- Left Controlbar -->
	<div class="map_controlbar line_one">
		<div class="control_btn">
			<button type="button" class="btn_ctr_linetwo" title="<spring:message code="toolbar.open"/>"><spring:message code="toolbar.open"/></button>
			<button type="button" class="btn_ctr_close" title="<spring:message code="toolbar.close"/>"><spring:message code="toolbar.close"/></button>
		</div>
		<div class="control_icons">
			<ul class="ctr_top">
				<li><a href="javascript:mymap.map.setView([37, 128], defaultLvl);" class="btn_ctr_fullscreen" title="<spring:message code="toolbar.fullview"/>"><spring:message code="toolbar.fullview"/></a></li>
				<li><a href="#" class="btn_ctr_layer" title="<spring:message code="toolbar.layershow"/>"><spring:message code="toolbar.layershow"/></a></li>
				<li><a href="#" class="btn_ctr_maptype1" title="<spring:message code="toolbar.selectmap"/>"><spring:message code="toolbar.selectmap"/></a></li>
				<!-- 일반지도 선택 시 btn_ctr_maptype1, 위성지도 선택 시 btn_ctr_maptype2 , OSM 선택 시 btn_ctr_maptype3 -->
				<li><a href="#" class="btn_ctr_panorama" title="<spring:message code="toolbar.roadview"/>"><spring:message code="toolbar.roadview"/></a></li>
			</ul>
			<ul class="ctr_bottom">
<%-- 				<li><a href="javascript:mapCtrlCursor('ico_ctr_workarea_rec',12);" id="ico_ctr_workarea_rec" class="btn_ctr_workarea_rec" title="<spring:message code="toolbar.workarea_rec"/>"><spring:message code="toolbar.workarea_rec"/></a></li>				 --%>
				<li><a href="javascript:mapCtrlCursor('ico_ctr_workarea_select',11);" id="ico_ctr_workarea_select" class="btn_ctr_workarea_select" title="<spring:message code="toolbar.workarea_select"/>"><spring:message code="toolbar.workarea_select"/></a></li>				
				<li><a href="javascript:mapCtrlCursor('ico_ctr_workarea',1);" id="ico_ctr_workarea" class="btn_ctr_workarea" title="<spring:message code="toolbar.workarea"/>"><spring:message code="toolbar.workarea"/></a></li>				
				<li><a href="javascript:mapCtrlCursor('ico_tool_move',0);" id="ico_tool_move" class="btn_ctr_move active" title="<spring:message code="toolbar.move"/>"><spring:message code="toolbar.move"/></a></li>
				<li><a href="javascript:mapCtrlCursor('ico_tool_ruler',4);" id="ico_tool_ruler" class="btn_ctr_ruler" title="<spring:message code="toolbar.dis"/>"><spring:message code="toolbar.dis"/></a></li>
				<li><a href="javascript:mapCtrlCursor('ico_tool_area',3);" id="ico_tool_area" class="btn_ctr_area" title="<spring:message code="toolbar.area"/>"><spring:message code="toolbar.area"/></a></li>
				<li><a href="javascript:mapCtrlCursor('ico_tool_round');" id="ico_tool_round" class="btn_ctr_round" title="<spring:message code="toolbar.circle"/>"><spring:message code="toolbar.circle"/></a></li>
				<li><a href="javascript:where_Construction();" id="ico_tool_draw" class="btn_ctr_draw" title="<spring:message code="toolbar.draw"/>"><spring:message code="toolbar.draw"/></a></li>				

<%-- 				<li><a href="javascript:mapCtrlCursor('ico_tool_select');" id="ico_tool_select" class="btn_ctr_select" title="<spring:message code="toolbar.bnd"/>"><spring:message code="toolbar.bnd"/></a></li> --%>
<%-- 				<li><a href="#" class="btn_ctr_bookmark" title="<spring:message code="toolbar.fav"/>"><spring:message code="toolbar.fav"/></a></li> --%>
<%-- 				<li><a href="javascript:mapCtrlCursor('ico_tool_text')" id="ico_tool_text" class="btn_ctr_text" title="<spring:message code="toolbar.input"/>"><spring:message code="toolbar.input"/></a></li> --%>
<%-- 				<li><a href="#" class="btn_ctr_tooltip" title="<spring:message code="toolbar.tooltip"/>"><spring:message code="toolbar.tooltip"/></a></li> --%>
<%-- 				<li class="more"><a href="#" class="btn_ctr_more" title="<spring:message code="toolbar.more"/>"><spring:message code="toolbar.more"/></a></li> --%>
			</ul>
		</div>
	</div>

	<!-- MapType Layer -->
	<div class="maptype_layer">				
		<ul>
			<li class="roadmap"><spring:message code="toolbar.normalmap"/></li>
			<li class="skymap"><spring:message code="toolbar.satlemap"/></li>
			<li class="osm"><spring:message code="toolbar.osmap"/></li>
		</ul>
	</div>
	<!-- //MapType Layer -->

<script type="text/javascript">
	var editMode = 0; // 0:이동, 1:구역설정, 2:위치도작도, 3:면적재기, 4:거리재기
	// 다음 일반 지도
	$('.maptype_layer .roadmap').click(function() {
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype1');
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype2');
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype3');
		$('.ctr_top li:nth-child(3) a').addClass('btn_ctr_maptype1');
		$('.maptype_layer').hide();
    });

	// 다음 스카이뷰
	$('.maptype_layer .skymap').click(function() {
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype1');
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype2');
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype3');
		$('.ctr_top li:nth-child(3) a').addClass('btn_ctr_maptype2');
		$('.maptype_layer').hide();
    });
	// 오픈 스트리트 맵
	$('.maptype_layer .osm').click(function() {
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype1');
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype2');
		$('.ctr_top li:nth-child(3) a').removeClass('btn_ctr_maptype3');
		$('.ctr_top li:nth-child(3) a').addClass('btn_ctr_maptype3');
		$('.maptype_layer').hide();
    });
	//레이어 탭 펼치기/접기
	$('.btn_ctr_layer').click(function() {
		$('.layer').toggle();
		// 레이어 트리 온오프(layer-panel.jsp)
		if($('.layer').is(':visible')) {
			$('.map_draw').css('left',280);
			$('.workarea_map_draw').css('left',280);
		} else {
			$('.map_draw').css('left',20);
			$('.workarea_map_draw').css('left',20);
		}
    });
	$('.btn_ctr_maptype1').click(function(event) {
		closeMenu('.maptype_layer');
		$('.maptype_layer').toggle();
		// 배경선택 온오프(layer-panel.jsp)
		event.stopPropagation();
    });
	$(".roadmap").click(function() {
		baseLayer = baseLayer_street;
		baseCrs = L.Proj.CRS.Daum;
		mymap.map.addLayer(baseLayer_street);
		mymap.map.removeLayer(baseLayer_osm);
		mymap.map.removeLayer(baseLayer_skyview);
		mymap.map.removeLayer(useLayers);
		changeCrs(baseCrs);
		mymap.map.addLayer(baseLayer_street);
		mymap.map.addLayer(useLayers);
		baseLayer.bringToBack();
	});
	$(".skymap").click(function() {
		baseLayer = baseLayer_skyview;
		baseCrs = L.Proj.CRS.Daum;
		mymap.map.removeLayer(baseLayer_osm);
		mymap.map.removeLayer(baseLayer_street);
		mymap.map.removeLayer(baseLayer_skyview);
		mymap.map.removeLayer(useLayers);
		changeCrs(baseCrs);
		mymap.map.addLayer(baseLayer_skyview);
		mymap.map.addLayer(useLayers);
		baseLayer.bringToBack();
	});
	$(".osm").click(function() {
		baseLayer = baseLayer_osm;
		baseCrs = L.Proj.CRS.OSM;
		mymap.map.removeLayer(baseLayer_osm);
		mymap.map.removeLayer(baseLayer_skyview);
		mymap.map.removeLayer(baseLayer_street);
		mymap.map.removeLayer(useLayers);
		changeCrs(baseCrs);
		mymap.map.addLayer(baseLayer_osm);
		mymap.map.addLayer(useLayers);
		baseLayer.bringToBack();
	});
	//사이드 툴바 컨트롤
	$(".control_btn > button:first-child").click(function (e){
		if($(".control_btn > button").hasClass("btn_ctr_lineone")){
			$(".map_controlbar").animate({"width" : "60px"},300, function(){
				left_w = 60;
				mapResize();
			});
			$(".layer").animate({"left" : "65px"},300);
			$(".maptype_layer").animate({"left" : "50px"},300);
			$(this).find("img").attr("src", "images/ico_arrow_open4.png");
			$(this).removeClass("btn_ctr_lineone");
			$(this).addClass("btn_ctr_linetwo");
			$('.map_controlbar').attr('class', 'map_controlbar line_one')
		}else{
			$(".map_controlbar").animate({"width" : "96px"},300, function(){
				left_w = 96;
				mapResize();
			});
			$(".layer").animate({"left" : "100px"},300);
			$(".maptype_layer").animate({"left" : "14px"},300);
			$(this).find("img").attr("src", "images/ico_arrow_close4.png");
			$(".btn_ctr_linetwo").removeClass("btn_ctr_linetwo");
			$(this).addClass("btn_ctr_lineone");
			$('.map_controlbar').attr('class', 'map_controlbar line_two')
		}
		mapResize();
		e.preventDefault();
	});
	
	//사이드 툴 바 끄기
	$('.btn_ctr_close').click(function() {
		$('.map_controlbar').hide();
		left_w = 0;
		mapResize();
    });	

	//사이드 툴 바 켜기
	$('.btn_tool_open').click(function() {
		$('.map_controlbar').show();
		if($('.map_controlbar').hasClass('line_one')){
			left_w = 60;
			mapResize();
		} else if($('.map_controlbar').hasClass('line_two')){
			left_w = 96;
			mapResize();
		} else {
			left_w = 0;
			mapResize();
		}
    });
	
	//드로우 툴 바 켜기 (라인, 폴리곤, 스냅)
// 	$('.btn_ctr_draw').click(function() {
// 		//console.log("btn_ctr_draw");
// 		$('.map_draw').toggle();
// 		// 레이어 트리 온오프(layer-panel.jsp)
// 		if($('.map_draw').is(':visible')) {
// 			mapCtrlCursor('ico_tool_move',0);
// 			ClearEditStatus();
// 			StartEdit(mymap.map);
// 		} else if(editMode != 1){
// 			////EndEdit();
// 			mapCtrlCursor('ico_tool_move',0);
// 		}
//     });	
// 	$('.draw_close').click(function draw_close() {
// 		//console.log("draw_close");			
// 		$('.map_draw').hide();
// 		if(editMode != 1) {
// 			////EndEdit();
// 			mapCtrlCursor('ico_tool_move',0);
// 		}
//     });
	
	var figure={};
	function initMapTools(){
		var textLayer;
		mymap.map.drawItem = new L.FeatureGroup();
		mymap.map.addLayer(mymap.map.drawItem);
		
		figure.leafletDrawOptions = {
				position : "topleft",
				edit : {
					featureGroup:mymap.map.drawItem
				},
				draw : {
					circle : {
						shapeOptions : {
							fill : true,
							color : "#f06eaa",
							fillOpacity : 0.3,
							fillColor : "#f06eaa"
						}
					},
					rectangle : {
						shapeOptions : {
							fill : true,
							color : "#00FFFF",
							fillOpacity : 0.3,
							fillColor : "#00FFFF"
						}
					}
				}
			};
		figure.drawControl = new L.Control.Draw(figure.leafletDrawOptions);
		figure.distance = L.Control.distanceControl().addTo(mymap.map);
		figure.area = L.Control.areaControl().addTo(mymap.map);
		figure.round = L.Control.circleControl().addTo(mymap.map);
		figure.scale = L.control.scale({
			position : 'bottomleft',
			imperial : false,
			maxWidth : 100
		}).addTo(mymap.map);	
		
		mymap.map.addControl(figure.drawControl);
			
		//거리측정, 면적측정
		mymap.map.on("draw:created", function(e){
			mymap.map.drawItem.addLayer(e.layer);
			var bFind = false;	
		});	
		
		mymap.figure = figure;
	}
	//거리측정
	function ruler(){
		stopmoveinfo = true;
		$(".control_icons li").removeClass("active");
		$(".btn_ctr_ruler").addClass("active");
		mymap.figure.distance.toggle();
		var enabled = mymap.figure.distance.handler.enabled();
		if(enabled){
			if(mymap.figure.area.handler.enabled()) mymap.figure.area.toggle();
			if(mymap.figure.round.handler.enabled()) mymap.figure.round.toggle();
		}else{
			stopmoveinfo = false;
			mymap.figure.area.handler.clearLayers();
			mymap.figure.round.handler.clearLayers();
		}
	}
	
	//면적측정
	function area(){
		console.log( "FUNCTION AREA()" );
		stopmoveinfo = true;
		$(".control_icons li").removeClass("active");
		$(".btn_ctr_area").addClass("active");
		mymap.figure.area.toggle();
		var enabled = mymap.figure.area.handler.enabled();
		if(enabled){
			if(mymap.figure.distance.handler.enabled()) mymap.figure.distance.toggle();
			if(mymap.figure.round.handler.enabled()) mymap.figure.round.toggle();
		}else{
			stopmoveinfo = false;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.round.handler.clearLayers();
		}
	}
	
	//원반경측정
	function round(){
		stopmoveinfo = true;
		$(".control_icons li").removeClass("active");
		$(".btn_ctr_round").addClass("active");
		mymap.figure.round.toggle();
		var enabled = mymap.figure.round.handler.enabled();
		if(enabled){
			if(mymap.figure.distance.handler.enabled()) mymap.figure.distance.toggle();
			if(mymap.figure.area.handler.enabled()) mymap.figure.area.toggle();
		}else{
			stopmoveinfo = false;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.area.handler.clearLayers();
		}
	}
	
	// 툴바 그룹에서 특정 툴바 버튼만 활성화 한다.
	function toolbar_set_active(classid) {
		$('.btn_ctr_workarea_select').removeClass("active");
		$('.btn_ctr_workarea').removeClass("active");
		$('.btn_ctr_move').removeClass("active");
		$('.btn_ctr_ruler').removeClass("active");
		$('.btn_ctr_area').removeClass("active");
		$('.btn_ctr_round').removeClass("active");
		$('.btn_ctr_draw').removeClass("active");
		$('#'+classid).addClass("active");
	}
	
	// 지도제어 라디오 그룹
	function mapCtrlCursor(id, mode) {
		$('.draw_location_close').click(); // => toolbar.jsp 위치도 작도 중이었다면 초기화 한다.
		if(mode != null) editMode = mode;
		toolbar_set_active(id);
		if(mymap.figure.area.handler.enabled()) mymap.figure.area.toggle();
		if(mymap.figure.distance.handler.enabled()) mymap.figure.distance.toggle();
		if(mymap.figure.round.handler.enabled()) mymap.figure.round.toggle();
		stopmoveinfo = false;
		removeLayer(editLayer);
		ClearEditStatus(); //=> cm.edit.function.js 
		if( typeof labelLayer != "undefined" ) { // label 제거
			for( var i=0; i<draw.features.length; i++ ) {
				// 저장 O => 그리기 객체만
				if( draw.features[i].properties.options != undefined ) {
					if( draw.features[i].properties.options.title != undefined ) {
						var options = draw.features[i].properties.options.title;
						var eleId = draw.features[i].properties.id;
						if( options == "Label" && $('#'+eleId).length > 0 ) $( "#"+eleId ).parents()[0].remove();
// 						if( options == "Label" ) $( "#"+eleId ).remove();	
					}	
				}
			}	
		} else {
			// 저장 X => 전부
			$( 'div.leaflet-marker-icon.leaflet-div-icon.leaflet-zoom-animated.leaflet-interactive' ).remove();
		}
		EndEdit();
		workarea_edit_array = [];
		if(workarea_edit_ljson != null)	removeLayer(workarea_edit_ljson);
		$('.leaflet-container').css('cursor','');
		var currZoom = mymap.map.getZoom();
		if(id == "ico_ctr_workarea_select") {
			if(currZoom < 17) {
				currZoom = 17;
				mymap.map.setView(mymap.map.getBounds().getCenter(), currZoom);
			}
			if(workarea_edit_uuid != null) {
				$("#"+workarea_edit_uuid+" >a").css("background","rgba(0, 0, 0, 0) none repeat scroll 0% 0% / auto padding-box border-box"); 
				mymap.map.addLayer(workAreaJson);
				workarea_edit_uuid = null;
			}
			if($('.layer').is(':visible')) {
        		$('.workarea_map_draw').css('left',280);
        	} else {
    			$('.workarea_map_draw').css('left',20);
    		}
			$('.workarea_edit_newobj').hide();
			$('.workarea_edit_select').hide();
			$('.workarea_edit_clip').hide();
			$('.workarea_edit_join').hide();
			$('.workarea_edit_intersection').hide();
			$('.workarea_edit_vertex_remove').hide();
			$('.workarea_edit_valid').hide();
			$('.workarea_edit_vertex').hide();
			$('.workarea_edit_snap').hide();
			$('.workarea_edit_vertex_apply').hide();
			$('.workarea_edit_cancel').hide();

        	$('.workarea_map_draw').show();
        	StartEdit();
			map_edit_select_layervertex();
			$('.leaflet-container').css('cursor','pointer');
			SetSnapMode( 0 ); // => cm.edit.function.js
		} else if(id == "ico_ctr_workarea") {
			if(currZoom < 17) {
				currZoom = 17;
				mymap.map.setView(mymap.map.getBounds().getCenter(), currZoom);
			}
			$(".workarea_map_draw").hide();
			map_edit_select_layervertex();
			StartEdit();
			SetSnapTolerance( 10 ); //=> cm.edit.function.js
			SetSnapMode( 1 ); // => cm.edit.function.js
			CreatePolygon(); // => cm.edit.function.js
		} else if(id == "ico_tool_ruler") {
			stopmoveinfo = true;
			mymap.figure.area.handler.clearLayers();
			mymap.figure.round.handler.clearLayers();
			mymap.figure.distance.toggle();
		} else if(id == "ico_tool_area") {
			stopmoveinfo = true;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.round.handler.clearLayers();
			mymap.figure.area.toggle();
		} else if(id == "ico_tool_round") {
			stopmoveinfo = true;
			mymap.figure.area.handler.clearLayers();
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.round.toggle();
		} else {
		}
		
		$("#"+id).addClass("active");
	}
	//-------------------------------------------------------------------------
	// editCommit  객체 추가 될때
	//-------------------------------------------------------------------------
	function editCommit() {
		console.log("editCommit start ");
		var objInfo = x_edit.CME_GetEditObjectInfo( 0 );
		var object = x_edit.CME_GetObject( objInfo.id );
		
		if (object.options.type == 'Line') {
			if(editMode == 220) { // 단면도 라인
				var label = 'A';
				var polyline = {"type": "Feature","properties": {"showfield": ""}, "geometry": {"type": "LineString","coordinates": []}};
				if(work.natural.cut.lines.length == 2) { // 이미 단면선이 두개 일 경우에는 초기화 하고 처음부터 그린다.
					work.natural.cut.lines = [];
					work.natural.cut.labels = [];
				} else if(work.natural.cut.lines.length == 1) {
					label = 'B';
				}
				work.natural.cut.lines.push(polyline);
				var labels = {"type": "Feature","properties": {"label": ""}, "geometry": {"type": "Point","coordinates": []}};
				var x = object._latlngs[0].lng;
	        	var y = object._latlngs[0].lat;
	        	var pointDest = Proj4js.transform(map_epsg, def_epsg, new Proj4js.Point(x + ',' +y));
	        	polyline.geometry.coordinates.push([pointDest.x, pointDest.y]);
	        	labels.geometry.coordinates.push(x);
	        	labels.geometry.coordinates.push(y);
	        	labels.properties.label = label;
	        	work.natural.cut.labels.push(labels);
	        	
	        	var labels2 = {"type": "Feature","properties": {"label": ""}, "geometry": {"type": "Point","coordinates": []}};
				x = object._latlngs[object.getLatLngs().length-1].lng;
	        	y = object._latlngs[object.getLatLngs().length-1].lat;
	        	pointDest = Proj4js.transform(map_epsg, def_epsg, new Proj4js.Point(x + ',' +y));
	        	polyline.geometry.coordinates.push([pointDest.x, pointDest.y]);
	        	label += '′';
	        	labels2.geometry.coordinates.push(x);
	        	labels2.geometry.coordinates.push(y);
	        	labels2.properties.label = label;
	        	work.natural.cut.labels.push(labels2);
// 	 		    for (var i = 0; i < object.getLatLngs().length; i++) { //object.getLatLngs().length 2
// 	 		    	var labels = {"type": "Feature","properties": {"label": ""}, "geometry": {"type": "Point","coordinates": []}};
// 					var x = object._latlngs[i].lng;
// 		        	var y = object._latlngs[i].lat;
// 		        	var pointDest = Proj4js.transform(map_epsg, def_epsg, new Proj4js.Point(x + ',' +y));
// 		        	if(i > 0) label += '′';
// 		        	polyline.geometry.coordinates.push([pointDest.x, pointDest.y]);
// 		        	labels.geometry.coordinates.push(x);
// 		        	labels.geometry.coordinates.push(y);
// 		        	labels.properties.label = label;
// 		        	work.natural.cut.labels.push(labels);
// 				}
				ClearEditStatus(); // => cm.edit.function.js
				EndEdit(); // => cm.edit.function.js
				$("#draw_location_dan_line").css("background","url('./resources/images/icons_ttbar_line.png') no-repeat center #f0f5fb");
				dan_draw_reflush(); // => loc_natural.jsp
			}
		} else if (object.options.type == 'Polygon') {
			var latlngs = object.getLatLngs();
		    var n_poly = 0;			
		    if(workarea_edit_mode == 3) { // 구역계 편집모드에서의 객체 추가
		    	workarea_edit_newobj(latlngs);
		    } else if(editMode == 1) { // 구역설정 폴리곤
			    var gjson_coords = [[]];
			    for (var i = 0; i < latlngs[ n_poly ].length; i++) {
			        var arr_laglng = latlngs[ n_poly ];
			        var x = arr_laglng[i].lng;
			        var y = arr_laglng[i].lat;
					var pointDest = Proj4js.transform(map_epsg, def_epsg, new Proj4js.Point(x + ',' + y));
					gjson_coords[0].push([pointDest.x,pointDest.y]);
				}
			    gjson_coords[0].push([gjson_coords[0][0][0], gjson_coords[0][0][1]]);
				ClearEditStatus(); // => cm.edit.function.js
				EndEdit(); // => cm.edit.function.js
				javascript:mapCtrlCursor('ico_tool_move',0);
				
				var temparea = newWorkArea([gjson_coords],"<spring:message code='work_root'/> "); // + work.area.num++); // newWorkArea() => userProject.js
				temparea.properties.isVertex = 1;
				isGeoValid(temparea,function(isvalid){
					if(isvalid == 1) {
						removeLayer(workArea2Json);
						initWork(); // 다중구역계 막아둠
						work.area.array.push(temparea);
						if ($.jstree.reference($('#layer_tab2'))) {
							$('#layer_tab2').jstree().delete_node($('#layer_tab2').jstree().get_json());
						}
						rebuildWorkArea(function(success){
							if(success) {
								workAreaPnu = [];
								$('.layer').show(); // => layer-panel.jsp
								activeLayer("layer_tab2");  // => layer-panel.jsp
// 								createWork(temparea.properties.uuid, temparea.properties.name); // => layer-panel.jsp
								initUserTree(); // => layer-panel.jsp
								workAreaRefresh(); // => layer-panel.jsp
							}
						});  // => common.js
					} else {
						$.alert("<spring:message code='areawork_valid_msg'/> ");
					}
				});
			}
		}
		console.log("editCommit end ");
	}
	//-----------------------------------------------------
	
	//-----------------------------------------------------
	// 작도에서 사용할 Leaflet 객체 담을 변수
	var obj = null; 
	
	//draw toolbar on/off
	function where_Construction() {

		if ( $( '.map_draw2' )[0].style[ 'display' ] == "block" ) {
			$( '.map_draw2' ).hide();
			$( '.draw_options' ).hide();
			toolbar_set_active( 'ico_tool_move' );
		} else {
			$( '.workarea_edit_close' ).click(); // main.jsp  구역계 편집중이었다면 초기화 한다.
			toolbar_set_active( 'ico_tool_draw' );
			
			$( '.map_draw2' ).show(); // 그리기 도구 on
			StartEdit( mymap.map ); // 이 함수 내부에서 ClearEditStatus() 호출
			
			disabledCheck(); // 버튼 초기화
			/* 초기화
			obj = null; // 초기화
			ObjectListClear(); // 메모리에 저장된 객체정보, 레이어 삭제
			ClearEditStatus(); // Leaflet object remove
			// 라벨 초기화 
			if( typeof labelLayer != "undefined" ) {
				// 저장한 Label 제외하고 삭제
				for( var i=0; i<draw.features.length; i++ ) {
					if( draw.features[i].properties.options != undefined ) {
						if( draw.features[i].properties.options.title != undefined ) {
							var options = draw.features[i].properties.options.title;
							var eleId = draw.features[i].properties.id;
							if( options == "Label" && $('#'+eleId).length > 0 ) $( "#"+eleId ).parents()[0].remove();
						}	
					}
				}	
			} else {
				// 저장 한 Label이 없다면 전부 삭제
				$( 'div.leaflet-marker-icon.leaflet-div-icon.leaflet-zoom-animated.leaflet-interactive' ).remove();
			}
			// 그리기 임시변수 초기화	
	 		features = [];
	 		draw = {};
	 		draw.type = "FeatureCollection";
	 		draw.features = features;
			*/
		}
	}
	
	// draw toolbar close
	$( '.draw_location_close' ).click(function() {
		$( '.map_draw2' ).hide();
		$( '.draw_options' ).hide();
		toolbar_set_active( 'ico_tool_move' );
		
		ObjectListClear(); // 메모리에 저장된 객체정보, 레이어 삭제
		ClearEditStatus(); // Leaflet object remove
		// 그리기 Label만 삭제 => 레이어x
		for( var i=0; i<draw.features.length; i++ ) {
			if( draw.features[i].properties.options != undefined ) {
				if( draw.features[i].properties.options.title != undefined ) {
					var options = draw.features[i].properties.options.title;
					var eleId = draw.features[i].properties.id;
					if( options == "Label" && $('#'+eleId).length > 0 ) $( "#"+eleId ).parents()[0].remove();
				}	
			}
		}
		// 그리기 임시변수 초기화
		features = [];
 		draw = {};
 		draw.type = "FeatureCollection";
 		draw.features = features;
 		
 		// drawJson
	 	if ( drawJson.point != null) {
	 		var length = drawJson.point.length;
	 		for(var i=0; i<length; i++) {
	 			features.push(drawJson.point[i]);
	 		}
	 	}
		if ( drawJson.poly != null) {
			var length = drawJson.poly.length;
	 		for(var i=0; i<length; i++) {
	 			features.push(drawJson.poly[i]);
	 		} 		
		}
		if ( drawJson.label != null) {
			var length = drawJson.label.length;
	 		for(var i=0; i<length; i++) {
	 			features.push(drawJson.label[i]);
	 		}
		}
	});
	
	// draw toolbar buttons
	function locationmap_Draw(id, mode) {
		$('.draw_options').css('display', 'none'); // 작도 옵션 비가시화
		$( '#lampDefault2' ).css( 'display' , 'none' ) // 상단 색상, 코드 비가시화
		$( '#colorLamp2' ).css( 'display', 'none' ); // 컬러 피커 비가시화
		$( '#lampDefault3' ).css( 'display' , 'none' ) // 상단 색상, 코드 비가시화
		$( '#colorLamp3' ).css( 'display', 'none' ); // 컬러 피커 비가시화
		
		if( mode != null ) editMode = mode;
		var clickMode;

// 		$( '.draw_location_point' ).css( "background","url('./resources/images/icons_ttbar_point.png') no-repeat center" );
// 		$( '.draw_location_line' ).css( "background","url('./resources/images/icons_ttbar_line.png') no-repeat center" );
// 		$( '.draw_location_polygon' ).css( "background","url('./resources/images/icons_ttbar_polygon.png') no-repeat center" );
// 		$( '.draw_location_circle' ).css( "background","url('./resources/images/icons_ttbar_circle.png') no-repeat center" );
// 		$( '.draw_location_box' ).css( "background","url('./resources/images/icons_ttbar_box.png') no-repeat center" );
// 		$( '.draw_location_txt' ).css( "background","url('./resources/images/icons_ttbar_txt.png') no-repeat center" );
           
		//  단면도에서 쓰임
		$( '.draw_location_dan_line' ).css("background","url('./resources/images/icons_ttbar_line.png') no-repeat center");
		$( '.draw_location_dan_remove' ).css("background","url('./resources/images/icons_ttbar_remove.png') no-repeat center");
		
		if( mymap.figure.area.handler.enabled() ) mymap.figure.area.toggle();
		if( mymap.figure.distance.handler.enabled() ) mymap.figure.distance.toggle();
		stopmoveinfo = false;
		var name = id.substr(14, id.length);

		if ( id == "draw_location_objslt" ) { 
			editMode = 20; // 객체 선택
		} else if ( id == "draw_location_objdeslt" ) {
			SetEditMode(0); // 객체 선택 해제
	 	} else if ( id == "draw_location_objdel" ) {
	 		var obj_id = GetSelectObjectID(); //선택된 객체 ID
	 		DeleteObject( obj_id ); // 객체 삭제
	 		
	 		var length = draw.features.length;

	 		for( var i=0; i<length; i++ ) {
	 			if( draw.features[i].properties.id == obj_id ) {
	 				draw.features.splice( i, 1 ); // Json의 i 번째 1개 제거
	 			}
	 		}
	 		disabledCheck();
	 	} else if ( id == "draw_location_point" ) {	
	 		StartEdit( mymap.map );
			editMode = 21;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.area.handler.clearLayers();
			obj = CreatePoint(); // => cm.edit.function.js
			$( "#"+id ).css( "background","url('./resources/images/icons_ttbar_"+name+"_on.png') no-repeat center #f0f5fb" );
		} else if( id == "draw_location_line" ) {
			StartEdit(mymap.map);
			editMode = 22;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.area.handler.clearLayers();
			obj = CreatePolyline(); // => cm.edit.function.js
			$( "#"+id ).css( "background","url('./resources/images/icons_ttbar_"+name+"_on.png') no-repeat center #f0f5fb" );
		} else if( id == "draw_location_dan_line" ) {
			StartEdit(mymap.map);
			editMode = 220;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.area.handler.clearLayers();
			obj = CreatePolyline(); // => cm.edit.function.js
			$( "#"+id ).css( "background","url('./resources/images/icons_ttbar_dan_line_on.png') no-repeat center #f0f5fb" );
		} else if( id == "draw_location_polygon" ) {
			StartEdit( mymap.map );
			editMode = 23;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.area.handler.clearLayers();
			obj = CreatePolygon(); // => cm.edit.function.js
			$( "#"+id ).css( "background","url('./resources/images/icons_ttbar_"+name+"_on.png') no-repeat center #f0f5fb" );
		} else if( id == "draw_location_circle" ) {
			StartEdit(mymap.map);
			editMode = 24;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.area.handler.clearLayers();
			obj = CreateCircle(); // => cm.edit.function.js
			$( "#"+id ).css( "background","url('./resources/images/icons_ttbar_"+name+"_on.png') no-repeat center #f0f5fb" );
		} else if( id == "draw_location_box" ) {
			StartEdit(mymap.map);
			editMode = 25;
			mymap.figure.distance.handler.clearLayers();
			mymap.figure.area.handler.clearLayers();
			obj = CreateRect(); // => cm.edit.function.js
			$( "#"+id ).css( "background","url('./resources/images/icons_ttbar_"+name+"_on.png') no-repeat center #f0f5fb" );
		} else if( id == "draw_location_txt" ) {
			StartEdit(mymap.map);
			editMode = 30; // Label 생성 => cm.edit.function.js
			$( "#"+id ).css( "background","url('./resources/images/icons_ttbar_"+name+"_on.png') no-repeat center #f0f5fb" );
		} else if ( id == "draw_location_undo" ) {
	 		var obj_id = Undo();
	 		if( obj_id != -1 || obj_id != null ) {
	 			var length = draw.features.length;
	 		
				for( var i=0; i<length; i++ ) {
		 			if( draw.features[i].properties.id == obj_id ) {
		 				//저장된 정보에 ID가 있다면 삭제
		 				draw.features.splice( i, 1 ); // Json의 i 번째 1개 제거
		 				length = draw.features.length;
		 			} else {
		 				// undo해서 객체는 넘어왔는데 저장된 정보가 없다 => 복구
		 				obj = x_edit.CME_GetObject( obj_id );
			 			construction( obj );
		 			}
		 		}
	 		}
	 		disabledCheck();
	 	} else if ( id == "draw_location_redo" ) {
	 		// obj return 받고 필요한 작업
	 		var obj_id = Redo();
	 		
	 		if (obj_id != -1){
	 			obj = x_edit.CME_GetObject( obj_id );
	 			construction(obj);
	 		}
	 		disabledCheck();
	 	} else if ( id == "draw_location_remove" || id == "draw_location_dan_remove") {
			ObjectListClear(); // 메모리에 저장된 객체정보, 레이어 삭제
			ClearEditStatus(); // Leaflet object remove
			// 그리기 Label만 삭제 => 레이어x
			for( var i=0; i<draw.features.length; i++ ) {
				if( draw.features[i].properties.options != undefined ) {
					if( draw.features[i].properties.options.title != undefined ) {
						var options = draw.features[i].properties.options.title;
						var eleId = draw.features[i].properties.id;
						if( options == "Label" && $('#'+eleId).length > 0 ) $( "#"+eleId ).parents()[0].remove();
					}	
				}
			}
			// 그리기 임시변수 초기화
			features = [];
	 		draw = {};
	 		draw.type = "FeatureCollection";
	 		draw.features = features;
			
			// drawJson 저장>객체추가>삭제>객체추가>저장 > 삭제한레이어 온 문제
		 	if ( drawJson.point != null) {
		 		var length = drawJson.point.length;
		 		for(var i=0; i<length; i++) {
		 			features.push(drawJson.point[i]);
		 		}
		 	}
			if ( drawJson.poly != null) {
				var length = drawJson.poly.length;
		 		for(var i=0; i<length; i++) {
		 			features.push(drawJson.poly[i]);
		 		} 		
			}
			if ( drawJson.label != null) {
				var length = drawJson.label.length;
		 		for(var i=0; i<length; i++) {
		 			features.push(drawJson.label[i]);
		 		}
			}
	 		disabledCheck();
	 	} else {
			EndEdit(); // => cm.edit.function.js
		}
	}

	// 그리기 도구 저장할 레이어(전역변수)
	var pointLayer = null; var polyLayer = null; var labelLayer = null; 
	var point = null; var poly = null; var label = null;

	function drawSave() {
		console.log( "SAVE AND ADD LAYER" );
		var length = draw.features.length;
		
		//변수 초기화
		point = []; // layer-panel에서 사용 => 전역
		poly = []; // layer-panel에서 사용 => 전역
		label = []; // layer-panel에서 사용 => 전역
		
		for(var i=0; i<length; i++) {
			var type = draw.features[i].geometry.type;
			if( type == "Point" || type == "IconPoint" ) {
				if ( draw.features[i].properties.options.title != undefined ) {
					label.push( draw.features[i] );
				} else {
					point.push( draw.features[i] );	
				}
			} else {
				poly.push( draw.features[i] );
			}
		}
		
		drawJson.point = point;
		drawJson.poly = poly;
		drawJson.label = label;		

		if( pointLayer != null ) mymap.map.removeLayer( pointLayer );
		if( polyLayer != null ) mymap.map.removeLayer( polyLayer );
		if( labelLayer != null ) mymap.map.removeLayer( labelLayer );

		pointLayer = L.geoJson( drawJson.point, {
		    pointToLayer: function ( feature, latlng) {
		    	console.log("Point Options : " + feature.properties.options);
		        return L.circleMarker( latlng, feature.properties.options);
		    }
	    });
		
		polyLayer = L.geoJson( drawJson.poly, {
			title: "draw",
			style: function( feature ) {
					return feature.properties.options;
			}
	    });
		
		labelLayer = L.geoJson( drawJson.label, {
		    pointToLayer: function ( feature, latlng ) {
		        return new L.Marker( latlng, {
				    icon: new L.DivIcon({ // 레이어로 저장한 라벨은 ID를 다르게 생성
				        html: "<button class='my-label' id='" + feature.properties.id + "L'>" + feature.properties.options.value + "</button>"
					    })
				});
		    }
	    });

		//그리기 초기화 후 
		ObjectListClear();
		ClearEditStatus();
		
		// 그리기 레이어 온
		mymap.map.addLayer(pointLayer);
		mymap.map.addLayer(polyLayer);
		mymap.map.addLayer(labelLayer);

		// addLayer한 라벨 속성까지 맞춰주기
		for( var i=0; i<label.length; i++ ) {
			var eleId = label[i].properties.id;
			// 그려져있는 Label 객체 삭제
			if( $('#'+eleId).length > 0 ) $( "#"+eleId ).parents()[0].remove();

			var labelWidth = ($("#"+eleId+"L")[0].innerText.length + 1) * (Number(label[i].properties.options.fontsize.substring(0,2))+1);
    		$("#"+eleId+"L").parent().css( "width", labelWidth );

			// LabelLayer로 올린 레이어 스타일 설정
			$("#"+eleId+"L")[0].style['background-color'] = "rgba(255,255,255,"+label[i].properties.options.back_opacity+")";
			$("#"+eleId+"L")[0].style['border-color'] = "rgba(0,0,0,"+label[i].properties.options.line_opacity+")";
			$("#"+eleId+"L")[0].style['font-size'] = label[i].properties.options.fontsize+"px";
			
		}
		work.where.draw = JSON.parse(JSON.stringify(drawJson));
// 		$("#layer_tab2").jstree("select_node", work.where.draw.uuid);
		disabledCheck();
	}
	
	// 그리기 객체 저장할 변수(전역)
	var features = [];
	var draw = {};

	draw.type = "FeatureCollection";
	draw.features = features; 
	
	// 그리기 객체 최초 저장 => draw
	function construction( obj ) {
		console.log("obj : " + obj);
		disabledCheck();
		/*작도 옵션 초기화*/
// 		$( '.draw_location_objslt' ).css( "background","url('./resources/images/icons_ttbar_objslt.png') no-repeat center" );
// 		$( '.draw_location_objdeslt' ).css( "background","url('./resources/images/icons_ttbar_objdeslt.png') no-repeat center" );
// 		$( '.draw_location_objdel' ).css( "background","url('./resources/images/icons_ttbar_objdel.png') no-repeat center" );
// 		$( '.draw_location_point' ).css( "background","url('./resources/images/icons_ttbar_point.png') no-repeat center" );
// 		$( '.draw_location_line' ).css( "background","url('./resources/images/icons_ttbar_line.png') no-repeat center" );
// 		$( '.draw_location_polygon' ).css( "background","url('./resources/images/icons_ttbar_polygon.png') no-repeat center" );
// 		$( '.draw_location_circle' ).css( "background","url('./resources/images/icons_ttbar_circle.png') no-repeat center" );
// 		$( '.draw_location_box' ).css( "background","url('./resources/images/icons_ttbar_box.png') no-repeat center" );
// 		$( '.draw_location_txt' ).css( "background","url('./resources/images/icons_ttbar_txt.png') no-repeat center" );
// 		$( '.draw_location_undo' ).css( "background","url('./resources/images/icons_ttbar_undo.png') no-repeat center" );
// 		$( '.draw_location_redo' ).css( "background","url('./resources/images/icons_ttbar_redo.png') no-repeat center" );
// 		$( '.draw_location_remove' ).css( "background","url('./resources/images/icons_ttbar_remove.png') no-repeat center" );
// 		$( '.draw_location_save' ).css( "background","url('./resources/images/ico_save.png') no-repeat center" );
        
//         $( '.draw_location_dan_line' ).css( "background","url('./resources/images/icons_ttbar_line.png') no-repeat center" );
// 		$( '.draw_location_dan_remove' ).css( "background","url('./resources/images/icons_ttbar_remove.png') no-repeat center" );
		
		//$( '.selectDash > img' )[0].src = "./resources/images/1.png"; // dash이미지 초기화
		//$( '.selectDash > img' )[1].src = "./resources/images/1.png"; // dash이미지 초기화
		//$( "#opacity" ).val("0.2"); // opacity value초기화
		$( '.draw_options' ).css('display', 'none'); // 작도 옵션창 off
		/*작도 옵션 초기화*/
		
		if( obj != null && obj != "undefined" ) {
			var type = obj.options.type;
			
			var feature = {}; //features에 담을 변수
			var geoTemp = []; // feature에 좌표를 담을 변수
			
			if(type == "IconPoint") {
				type = "Point";
				var x = obj._latlng.lng;
				var y = obj._latlng.lat;
				
				geoTemp.push( x, y );
							
				feature = {
						"type" : "Feature",
						"geometry" : {
							"type" : type,
							"coordinates" : geoTemp
						}, 
						"properties" : {
							"id" : obj.obj_id,
							"options" : {
							    "radius": 5.5,
							    "fillColor": "rgb(0, 0, 255)",
							    "color": "rgb(179, 179, 255)",
							    "weight": 7,
							    "opacity": 1,
							    "fillOpacity": 1

							} 
						}
					};
			console.log("최초 저장 옵션 : " + feature.properties.options);
			    
			} else if( type == "Line" ) {
				
				for (var i = 0; i < obj._latlngs.length; i++) {
					
			        var x = obj._latlngs[i].lng;
			        var y = obj._latlngs[i].lat;
			        
			        geoTemp.push( [ x, y ] );
				}
				
				feature = {
						"type" : "Feature",
						"geometry" : {
						"type" : "LineString",
							"coordinates" : geoTemp
						}, 
						"properties" : {
							"id" : obj.obj_id,
							"options" : ""
						}
					};
				
			} else if ( type == "Polygon" ) {
			    
			    for (var i = 0; i < obj._latlngs[0].length; i++) {
			        var x = obj._latlngs[0][i].lng;
			        var y = obj._latlngs[0][i].lat;
			        
			        geoTemp.push( [ x, y ] );
				}
			    geoTemp.push( [ obj._latlngs[0][0].lng, obj._latlngs[0][0].lat ] )
				
			    feature = {
						"type" : "Feature",
						"geometry" : {
							"type" : type,
							"coordinates" : [ geoTemp ]
						}, 
						"properties" : {
							"id" : obj.obj_id,
							"options" : ""
						}
					};
			} else if ( type == "Rect" ) {
			    type = "Polygon";
				for (var i = 0; i < obj._latlngs[0].length; i++) {
			        var x = obj._latlngs[0][i].lng;
			        var y = obj._latlngs[0][i].lat;
			        
			        geoTemp.push( [ x, y ] );
				}
			    geoTemp.push( [ obj._latlngs[0][0].lng, obj._latlngs[0][0].lat ] )

			    feature = {
						"type" : "Feature",
						"geometry" : {
				    		"type" : type,
							"coordinates" : [ geoTemp ]
						}, 
						"properties" : {
							"id" : obj.obj_id,
							"options" : ""
						}
					};
			} else if ( type == "Circle" ) {
				
				var x = obj._latlng.lng;
				var y = obj._latlng.lat;
				var radius = obj._mRadius;
				
				geoTemp.push( x, y );
				
				var temp = circleToPolygon( geoTemp, radius, 360 );
			    feature = {
						"type" : "Feature",
						"geometry" : {
							"type" : "Polygon",
							"coordinates" : temp.coordinates
						}, 
						"properties" : {
							"id" : obj.obj_id,
							"options" : {
								"radius" : radius
							}
							
						},
					};
			    
			}  else {
				alert( "error ! At construction() " );
			}
			features.push(feature);
		}
		
	}


	//colorRamp 적용 버튼
	$( '#active2' ).click(function () {
		console.log("Color Ramp Active ");
		var obj_id = GetSelectObjectID();
		var obj = x_edit.CME_GetObject( obj_id );

		var type = obj.options.type;
		
		var options = {};
		if( type == "IconPoint" ){
			var color = $( '#pColor' )[0].style[ 'background-color' ];
			
			// 외곽선
			var rgb = hexToRgb(rgbString2hex( color )); // rgb String => rgb Object			
			var r = ( (255 - rgb.r) * 0.7 ) + rgb.r;
			var g = ( (255 - rgb.g) * 0.7 ) + rgb.g;
			var b = ( (255 - rgb.b) * 0.7 ) + rgb.b;
			rgb = "rgb("+Math.round(r)+","+Math.round(g)+","+Math.round(b)+")"; //rgb Object => rgb String
			
			//만들어진 leaflet point 변경
			obj.valueOf()._icon.style.backgroundColor = color;
// 			obj.valueOf()._icon.style.border = '7px solid rgba(255,255,255,0.7)';
// 			obj.valueOf()._icon.style.width = '18px';
// 			obj.valueOf()._icon.style.height = '18px';
			
			console.log("ACTIVE COLOR ==> " + rgb) //==> rgb
			
			// 레이어 저장을 위한 option
			options.fillColor = color;
			options.color =  rgb;
//  		options.border = '7px solid rgba(255,255,255,0.7)';
// 			options.width = '18px';
// 			options.height = '18px';
			
		} else if ( type == "Line" ){
			var color = $( '#lColor' )[0].style[ 'background-color' ];
			var dash = $( '#lDash' ).val();
			var lweight = $( '#lWeight' ).val();
			obj.setStyle( { color:color, weight:lweight, dashArray:dash } );
			
			options.color = color;
			options.weight = lweight;
			options.dashArray = dash;
			
		} else {
			var lColor = $( '#gColor' )[0].style[ 'background-color' ];
			var dash = $( '#gDash' ).val();
			var lweight = $( '#gWeight' ).val();
			var fColor = $( '#fColor' )[0].style[ 'background-color' ];
			var opa = Number( $('#opacity').val() );
			
			obj.options.weight = 3;
			obj.setStyle( { color:lColor, weight:lweight, dashArray:dash, fillColor:fColor, fillOpacity:opa } );
			
			options.color = lColor;
			options.weight = lweight;
			options.dashArray = dash;
			options.fillColor = fColor;
			options.fillOpacity = opa;
		}	

		//변경 후 work.where.draw.feature 업데이트
		drawEdit(obj, options);
		
		$( '.draw_options' ).css( 'display', 'none' );  
		editMode = 0; // 클릭 이벤트 해제(지도 이동)
		SetEditMode( 0 ); // select모드 해제
		
		
	});
	

	//Drag, Vertex Edit 시
	// => 최초 저장 이후 수정(obj 리턴)
	function drawEdit( obj, options ) {
		console.log( "Edit Objecet : " + obj );
		
		if(draw == null) return;
		
		var type = obj.options.type;
		var obj_id = obj.obj_id;
		
		var geoTemp = [];
		
		var length = draw.features.length;
		
		for( var j=0; j<length; j++ ) {
			
			var draw_id = draw.features[j].properties.id;
			
			if( obj_id == draw_id ) {
		
				if( type == "IconPoint" || type == "Point" ) {
					//point는 layer로 올릴때 옵션이 다르다
					var pOptions = {
							"radius": 5.5,
						    "fillColor": options.fillColor,
						    "color": options.color,
						    "weight": 7,
						    "opacity": 1,
						    "fillOpacity": 1
					}
					console.log("DRAW EDIT OPTIONS : " + pOptions);
					var x = obj._latlng.lng;
					var y = obj._latlng.lat;
					
					geoTemp.push( x, y );
					
					draw.features[j].geometry.coordinates = geoTemp; 
					draw.features[j].properties.options = pOptions; 

				} else if( type == "Line" ) {
					
					for( var i = 0; i < obj._latlngs.length; i++ ) {
						
				        var x = obj._latlngs[i].lng;
				        var y = obj._latlngs[i].lat;
				        
				        geoTemp.push( [ x, y ] );
					}
					
					draw.features[j].geometry.coordinates = geoTemp;
					draw.features[j].properties.options = options; 
					
				} else if( type == "Polygon" ) {
					
					for(var i = 0; i < obj._latlngs[0].length; i++) {
				        var x = obj._latlngs[0][i].lng;
				        var y = obj._latlngs[0][i].lat;
				        
				        geoTemp.push( [ x, y ] );
					}
				    geoTemp.push( [ obj._latlngs[0][0].lng, obj._latlngs[0][0].lat ] ); // 폴리곤 닫아주기
				    draw.features[j].geometry.coordinates = [ geoTemp ];
					draw.features[j].properties.options = options; 
					
				} else if ( type == "Circle" ) {
					
					var x = obj._latlng.lng;
					var y = obj._latlng.lat;
					var radius = obj._mRadius;
					
					geoTemp.push( x, y );
					
					options,radius = radius;
					var temp = circleToPolygon( geoTemp, radius, 360 ); // circle > polygon 변환

					draw.features[j].geometry.coordinates = temp.coordinates;
					draw.features[j].properties.options = options; 

				} else if ( type == "Rect" ) {
					
					for( var i = 0; i < obj._latlngs[0].length; i++ ) {
				        var x = obj._latlngs[0][i].lng;
				        var y = obj._latlngs[0][i].lat;
				        
				        geoTemp.push( [x, y] );
					}
				    geoTemp.push( [ obj._latlngs[0][0].lng, obj._latlngs[0][0].lat ] ); // 폴리곤 닫아주기				    
				    draw.features[j].geometry.coordinates = [geoTemp];
					draw.features[j].properties.options = options;

				} else {
					alert( "error ! At drawEdit() " );
				}
			}
			
		}

	}
	
	// 타입별 옵션 창 on/off
	function setStyle(obj) { 
		console.log( obj.options.type + "options on" );
		if(obj != null){
			var type = obj.options.type;
			if( type == "IconPoint" ) {
				$( '#point' ).css( 'display', 'block');
				$( '#line' ).css( 'display', 'none');
				$( '#polygon' ).css( 'display', 'none');
			} else if( type == "Line" ) {
				
				$( '#line' ).css( 'display', 'block');
				$( '#point' ).css( 'display', 'none');
				$( '#polygon' ).css( 'display', 'none');
			} else if( type == "Polygon" ) {
				$( '#polygon' ).css( 'display', 'block');
				$( '#line' ).css( 'display', 'none');
				$( '#point' ).css( 'display', 'none');
			} else if( type == "Circle" ) {
				$( '#polygon' ).css( 'display', 'block');
				$( '#line' ).css( 'display', 'none');
				$( '#point' ).css( 'display', 'none');
			} else if( type == "Rect" ) {
				$( '#polygon' ).css( 'display', 'block');
				$( '#line' ).css( 'display', 'none');
				$( '#point' ).css( 'display', 'none');
			} else {
				console.log( "setStyle() Error ! " );
			}
		}
	}
	
	//
	function editOn(obj) {
		console.log("Edit Mode Start");

		if(obj != null) {
			var obj_id = obj.obj_id;
			var length = draw.features.length;
			
			var dashArray; // 선 모양
			var weight;  // 선 두께
			var color; // 선 색
						 
			var lColor; // 폴리곤의 선 색
			var fColor; // 폴리곤의 채우기 색
			var opa; // 폴리곤의 투명도
			
			for ( var i=0; i<length; i++ ) {
				var draw_id = draw.features[i].properties.id;
				
				if(draw_id == obj_id) {
// 					if( draw.features[i].properties.options != undefined || draw.features[i].properties.options != "" ) {
					if( draw.features[i].properties.options ) {
						dashArray = draw.features[i].properties.options.dashArray;
						weight = draw.features[i].properties.options.weight;
// 						color = draw.features[i].properties.options.color;
						lColor = draw.features[i].properties.options.color;
						fColor = draw.features[i].properties.options.fillColor;
						opa = draw.features[i].properties.options.fillOpacity;	
					}
				}
			}

			$( '.draw_options' ).css( 'display', 'block' );
			
			if ( dashArray == null || dashArray == undefined ) dashArray = 1;
			if ( weight == null || weight == undefined ) weight = 3;
			if ( color == null || color == undefined ) color = "#3388ff";
			if ( lColor == null || lColor == undefined ) lColor ="#3388ff";
			if ( fColor == null || fColor == undefined ) fColor ="#3388ff";
			if ( opa == null || opa == undefined ) opa ="0.2";

			if( obj.options.type == "IconPoint" ) {
				$( '#pColor' )[0].style[ 'background-color' ] = fColor;
			} else if( obj.options.type == "Line" ) {
				$( '#lColor' )[0].style[ 'background-color' ] = lColor;
				$( '#lWeight' ).val(weight);
				$( '#lDash' ).val(dashArray);
				$( '.selectDash > img' )[0].src = "./resources/images/"+dashArray+".png";
			} else {
				$( '#gColor' )[0].style[ 'background-color' ] = lColor;
				$( '#gWeight' ).val(weight);
				$( '#gDash' ).val(dashArray);
				$( '.selectDash > img' )[1].src = "./resources/images/"+dashArray+".png";
				$( '#fColor' )[0].style[ 'background-color' ] = fColor;
				$( '#opacity' ).val(opa);
			}
		}

	}
	
	// 대쉬 이미지 변경
	function dashChange( value, flag ) {
		if ( flag == 'l' ) {
			$( '#lDash' ).val( value );	
		} else if ( flag == 'g' ) {
			$( '#gDash' ).val( value );	
		}
	}
	
	//위치도 작도 lineDash옵션 toggle
	function lineDashToggle() {
		console.log("LineDashToggle");
		
		var obj_id = GetSelectObjectID();
		var obj = x_edit.CME_GetObject( obj_id );
		var type = obj.options.type;
		
		 if ( type == "Line" ){
			 var temp = $( '.draw_options ul' )[0].style[ 'display' ];
			 
			 if( temp == "none" || temp == "" ) {
					$( '.dash .sub' )[0].innerHTML="▲";
					$( '.draw_options ul' )[0].style[ 'display' ] = 'block';
				} else if (temp == "block" ) {
					$( '.dash .sub' )[0].innerHTML="▼";
					$( '.draw_options ul' )[0].style[ 'display' ] = 'none';
				}
				
				$( '.draw_options ul li img').click(function (e) {

					$( '.selectDash > img' )[0].src = e.target.src;
					$( '.dash .sub' )[0].innerHTML="▼";
					$( '.draw_options ul' )[0].style[ 'display' ] = 'none';
				});		
		} else {
			var temp =$( '.draw_options ul' )[1].style[ 'display' ];
			
			if( temp == "none" || temp == "" ) {
				$( '.dash .sub' )[1].innerHTML="▲";
				$( '.draw_options ul' )[1].style[ 'display' ] = 'block';
			} else if (temp == "block" ) {
				$( '.dash .sub' )[1].innerHTML="▼";
				$( '.draw_options ul' )[1].style[ 'display' ] = 'none';
			}
			
			$( '.draw_options ul li img' ).click(function (e) {

				$( '.selectDash > img' )[1].src = e.target.src;
				$( '.dash .sub' )[1].innerHTML="▼";
				$( '.draw_options ul' )[1].style[ 'display' ] = 'none';
			});
		}
	}

	//ColorRamp Settings & Show
	function openColorPick( i ) {
		console.log("ColorRamp Settings & Show");
		var settings;
		// colorPicker Settings
		if( i == 1 ){
			settings = {
					animationSpeed: 0, //새 색상을 탭하거나 클릭 할 때 슬라이더의 애니메이션 속도
				    animationEasing: 'swing', //슬라이더를 애니메이션 할 때
					change : function () {
								console.log("color picker change");
								$( '#color2' ).css( 'background-color' , $(this)[0].value);
								$( '#inputClone2' ).val($(this)[0].value);	
							},
					hide : function () {
								console.log("color picker hide");
							},
					show : function () {
								console.log("color picker show");
							},
				    changeDelay: 200, // 색상선택기를 드래그 시 이벤트가 발생하지 않는 시간. 200정도 적당
				    control: 'saturation', // * 제어 유형, 유효옵션 : hue, brightness, saturation, wheel
				    defaultValue: '#FF0000',
				    format: 'hex',
				    inline: true, //얘가 false면 바로 안켜진다. 근데 text가 없어지네
				    keywords: '',
				    letterCase: 'uppercase', //16진수 코드의 대소문자 유형: uppercase, lowercase
				    opacity: false, // true불투명도 슬라이더를 활성화합니다. (입력 요소의 data-opacity속성을 사용하여 사전 설정 값을 설정)
				    position: 'bottom left',
				    hideSpeed: 0, //색상 선택기를 숨기는 속도
				    showSpeed: 0, //색상 선택기를 표시하는 속도
				    swatchPosition: 'right', //색상 견본을 표시 할 텍스트 필드의 어느 쪽을 결정합니다. 유효한 옵션은 left및 right
				    theme: 'default',
				    position: 'default', //드롭 다운 위치를 설정합니다. default, top, left,와 top left.
				    textfield : true, //텍스트 필드 표시 여부
				    swatches: ['#f44336','#2196f3','#ee00ff','#ffeb3b','#ff9800','#795548','#9e9e9e']
			};
		} else if ( i == 2 ){
			settings = {
				animationSpeed: 0, //새 색상을 탭하거나 클릭 할 때 슬라이더의 애니메이션 속도
			    animationEasing: 'swing', //슬라이더를 애니메이션 할 때
				change : function (v, o) {
							console.log("color picker change2");
							
							$( '#color3' ).css( 'background-color' , v);
							$( '#inputClone3' ).val(v);
							$( '#opacity' ).val(o);
							
						},
				hide : function () {
							console.log("color picker hide");
						},
				show : function () {
							console.log("color picker show");
						},
			    changeDelay: 200, // 색상선택기를 드래그 시 이벤트가 발생하지 않는 시간. 200정도 적당
			    control: 'saturation', // * 제어 유형, 유효옵션 : hue, brightness, saturation, wheel
			    defaultValue: '#FF0000',
			    format: 'hex',
			    inline: true, //얘가 false면 바로 안켜진다. 근데 text가 없어지네
			    keywords: '',
			    letterCase: 'uppercase', //16진수 코드의 대소문자 유형: uppercase, lowercase
			    opacity: true, // true불투명도 슬라이더를 활성화합니다. (입력 요소의 data-opacity속성을 사용하여 사전 설정 값을 설정)
			    position: 'bottom left',
			    hideSpeed: 0, //색상 선택기를 숨기는 속도
			    showSpeed: 0, //색상 선택기를 표시하는 속도
			    swatchPosition: 'right', //색상 견본을 표시 할 텍스트 필드의 어느 쪽을 결정합니다. 유효한 옵션은 left및 right
			    theme: 'default',
			    position: 'default', //드롭 다운 위치를 설정합니다. default, top, left,와 top left.
			    textfield : true, //텍스트 필드 표시 여부
			    swatches: ['#f44336','#2196f3','#ee00ff','#ffeb3b','#ff9800','#795548','#9e9e9e']
		};
		}
		
		if( i == 1 ){
			/* 명칭 변경 */		
			$( 'INPUT.demo2' ).minicolors(settings); // 컬러피커 설정
			$( '.demo2' ).minicolors( 'show' ); // 컬러피커 show	
			
			$( '#lampDefault2' ).css( 'display' , 'block' ) // 상단 색상, 코드 가시화
			$( '#colorLamp2' ).css( 'display', 'block' ); // 컬러 피커 가시화	
		}
		
		if(i == 2) {  
			$( 'INPUT.demo3' ).minicolors(settings); // 컬러피커 설정
			$( '.demo3' ).minicolors( 'show' ); // 컬러피커 show	
			
			$( '#lampDefault3' ).css( 'display' , 'block' ) // 상단 색상, 코드 가시화
			$( '#colorLamp3' ).css( 'display', 'block' ); // 컬러 피커 가시화

		}
		
	}
	
	//Point&Line ColorRamp Active
	$( '#colActBtn' ).click(function () {
		console.log("Point&Line ColorRamp Active");

		$( '#lampDefault2' ).css( 'display' , 'none' ) // 상단 색상, 코드 비가시화
		$( '#colorLamp2' ).css( 'display', 'none' ); // 컬러 피커 비가시화
		$( '#lampDefault3' ).css( 'display' , 'none' ) // 상단 색상, 코드 비가시화
		$( '#colorLamp3' ).css( 'display', 'none' ); // 컬러 피커 비가시화
		
		var obj_id = GetSelectObjectID();
		var obj = x_edit.CME_GetObject( obj_id );
		
		var type = obj.options.type;

		if( type == "IconPoint" ){
			$( '#pColor' )[0].style[ 'background-color' ] = $( '#inputClone2' ).val();
		} else if ( type == "Line" ){
			$( '#lColor' )[0].style[ 'background-color' ] = $( '#inputClone2' ).val();	
		} else {
			$( '#gColor' )[0].style[ 'background-color' ] = $( '#inputClone2' ).val();
		}
		
	});
	
	//Polygon ColorRamp Active
	$( '#colActBtn2' ).click(function (e) {
		console.log("Polygon ColorRamp Active");

		$( '#lampDefault2' ).css( 'display' , 'none' ) // 상단 색상, 코드 비가시화
		$( '#colorLamp2' ).css( 'display', 'none' ); // 컬러 피커 비가시화
		$( '#lampDefault3' ).css( 'display' , 'none' ) // 상단 색상, 코드 비가시화
		$( '#colorLamp3' ).css( 'display', 'none' ); // 컬러 피커 비가시화
		
		$( '#fColor' )[0].style[ 'background-color' ] = $( '#inputClone3' ).val();

	});
	
	function disabledCheck() {
		var drawObject = GetEditObject().length; // 그려진 객체 개수
 		var undoObject = GetUndoIndex(); // undo index => cm.edit.function.js
 		var redoObject = GetRedoIndex(); // redo index => cm.edit.function.js
 		var labelObject = -1;
 		
 		for( var i=0; i<draw.features.length; i++ ) {
			if( draw.features[i].properties.options != undefined ) {
				if( draw.features[i].properties.options.title != undefined ) {
					var options = draw.features[i].properties.options.title;
					var eleId = draw.features[i].properties.id;
					if( options == "Label" && $('#'+eleId).length > 0 ) labelObject = 1;
				}	
			}
		}
		
 		console.log("그려진 객체 카운트 : " + drawObject);
 		console.log("undo 객체 카운트 : " + undoObject);
 		console.log("redo 객체 카운트 : " + redoObject);
 		console.log("label 객체 카운트 : " + labelObject);
 		
		// 버튼 옵션 초기화 -----------------------------------------------------------------------------------------------------------
 		$( '.draw_location_objslt' ).css( "background","url('./resources/images/icons_ttbar_objslt.png') no-repeat center" );
		$( '.draw_location_objdeslt' ).css( "background","url('./resources/images/icons_ttbar_objdeslt.png') no-repeat center" );
		$( '.draw_location_objdel' ).css( "background","url('./resources/images/icons_ttbar_objdel.png') no-repeat center" );
		$( '.draw_location_point' ).css( "background","url('./resources/images/icons_ttbar_point.png') no-repeat center" );
		$( '.draw_location_line' ).css( "background","url('./resources/images/icons_ttbar_line.png') no-repeat center" );
		$( '.draw_location_polygon' ).css( "background","url('./resources/images/icons_ttbar_polygon.png') no-repeat center" );
		$( '.draw_location_circle' ).css( "background","url('./resources/images/icons_ttbar_circle.png') no-repeat center" );
		$( '.draw_location_box' ).css( "background","url('./resources/images/icons_ttbar_box.png') no-repeat center" );
		$( '.draw_location_txt' ).css( "background","url('./resources/images/icons_ttbar_txt.png') no-repeat center" );
		$( '.draw_location_undo' ).css( "background","url('./resources/images/icons_ttbar_undo.png') no-repeat center" );
		$( '.draw_location_redo' ).css( "background","url('./resources/images/icons_ttbar_redo.png') no-repeat center" );
		$( '.draw_location_remove' ).css( "background","url('./resources/images/icons_ttbar_remove.png') no-repeat center" );
		$( '.draw_location_save' ).css( "background","url('./resources/images/ico_save.png') no-repeat center" );
        $( '.draw_location_dan_line' ).css( "background","url('./resources/images/icons_ttbar_line.png') no-repeat center" );
		$( '.draw_location_dan_remove' ).css( "background","url('./resources/images/icons_ttbar_remove.png') no-repeat center" );
		
		$('#draw_location_objslt').attr('disabled', false);
		$('#draw_location_objdeslt').attr('disabled', false);
		$('#draw_location_objdel').attr('disabled', false);
		$('#draw_location_point').attr('disabled', false);
		$('#draw_location_line').attr('disabled', false);
		$('#draw_location_polygon').attr('disabled', false);
		$('#draw_location_circle').attr('disabled', false);
		$('#draw_location_box').attr('disabled', false);
		$('#draw_location_txt').attr('disabled', false);
		$('#draw_location_undo').attr('disabled', false);
		$('#draw_location_redo').attr('disabled', false);
		$('#draw_location_remove').attr('disabled', false);
		$('#draw_location_save').attr('disabled', false);
		// ----------------------------------------------------------------------------------------------------------------------------
		
		if( drawObject == 0 && undoObject == -1 && redoObject == -1 && labelObject == -1 ) {
			$( '.draw_location_objslt' ).css( "background","url('./resources/images/icons_ttbar_objslt.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_objdeslt' ).css( "background","url('./resources/images/icons_ttbar_objdeslt.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_objdel' ).css( "background","url('./resources/images/icons_ttbar_objdel.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_undo' ).css( "background","url('./resources/images/icons_ttbar_undo.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_redo' ).css( "background","url('./resources/images/icons_ttbar_redo.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_remove' ).css( "background","url('./resources/images/icons_ttbar_remove.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_save' ).css( "background","url('./resources/images/ico_save.png') no-repeat center #D8D8D8" );
 			
 			$( '#draw_location_objslt' ).attr('disabled', true);
 			$( '#draw_location_objdeslt' ).attr('disabled', true);
 			$( '#draw_location_objdel' ).attr('disabled', true);
 			$( '#draw_location_undo' ).attr('disabled', true);
 			$( '#draw_location_redo' ).attr('disabled', true);
 			$( '#draw_location_remove' ).attr('disabled', true);
 			$( '#draw_location_save' ).attr('disabled', true);
 			
 			return;
		}
		if( drawObject == 0 && undoObject == -1 && redoObject == -1 && labelObject != -1 ) {
			$( '.draw_location_objslt' ).css( "background","url('./resources/images/icons_ttbar_objslt.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_objdeslt' ).css( "background","url('./resources/images/icons_ttbar_objdeslt.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_objdel' ).css( "background","url('./resources/images/icons_ttbar_objdel.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_undo' ).css( "background","url('./resources/images/icons_ttbar_undo.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_redo' ).css( "background","url('./resources/images/icons_ttbar_redo.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_remove' ).css( "background","url('./resources/images/icons_ttbar_remove.png') no-repeat center " );
 			$( '.draw_location_save' ).css( "background","url('./resources/images/ico_save.png') no-repeat center " );
 			
 			$( '#draw_location_objslt' ).attr('disabled', true);
 			$( '#draw_location_objdeslt' ).attr('disabled', true);
 			$( '#draw_location_objdel' ).attr('disabled', true);
 			$( '#draw_location_undo' ).attr('disabled', true);
 			$( '#draw_location_redo' ).attr('disabled', true);
 			$( '#draw_location_remove' ).attr('disabled', false);
 			$( '#draw_location_save' ).attr('disabled', false);
 			
 			return;
		}
		
 		if ( drawObject == 0 ) { 
 			$( '.draw_location_objslt' ).css( "background","url('./resources/images/icons_ttbar_objslt.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_objdeslt' ).css( "background","url('./resources/images/icons_ttbar_objdeslt.png') no-repeat center #D8D8D8" );
 			$( '.draw_location_objdel' ).css( "background","url('./resources/images/icons_ttbar_objdel.png') no-repeat center #D8D8D8" );
 			
 			$( '#draw_location_objslt' ).attr('disabled', true);
 			$( '#draw_location_objdeslt' ).attr('disabled', true);
 			$( '#draw_location_objdel' ).attr('disabled', true);
 		}
		
		if ( undoObject == -1 ) {
 			$( '.draw_location_undo' ).css( "background","url('./resources/images/icons_ttbar_undo.png') no-repeat center #D8D8D8" );
 			$( '#draw_location_undo' ).attr('disabled', true);
 		}
		
		if ( redoObject == -1 ) {
 			$( '.draw_location_redo' ).css( "background","url('./resources/images/icons_ttbar_redo.png') no-repeat center #D8D8D8" );
 			$( '#draw_location_redo' ).attr('disabled', true);
 		}

	}
	
	// RGB값(String)을 HEX코드(String)로 변환하는 함수
	function rgbString2hex(rgb) {
		rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);	
		return (rgb && rgb.length === 4) ? '#' +
		('0' + parseInt(rgb[1],10).toString(16)).slice(-2) +
		('0' + parseInt(rgb[2],10).toString(16)).slice(-2) +
		('0' + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
	  }
	
	// HEX코드(String)를 RGB값(Object)로 변환하는 함수
	function hexToRgb(hex) {
		  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
		  return result ? {
		    r: parseInt(result[1], 16),
		    g: parseInt(result[2], 16),
		    b: parseInt(result[3], 16)
		} : null;
	}
	</script>
</body>
</html>