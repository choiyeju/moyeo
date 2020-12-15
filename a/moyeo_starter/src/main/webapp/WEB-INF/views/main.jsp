<%--
  Class Name : main.jsp 
  Description : 메인화면
  Modification 
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2019.02.01   최진석       
     
    author   : 최진석
    since    : 2019
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code="main.title" /></title>
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/leaflet/leaflet.label.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/leaflet/leaflet.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/leaflet/addon/context-menu/leaflet.contextmenu.min.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/leaflet/addon/draw/leaflet.draw.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/leaflet/addon/zoom-slider/L.Control.Zoomslider.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/leaflet/addon/minimap/Control.MiniMap.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/leaflet/addon/edit/leaflet.editable.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/jquery/jquery-ui.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/jquery/jquery.loadingModal.min.css'/>">
<%-- 	<link type="text/css" rel="stylesheet" href="<c:url value='/resources/framework/mapbox.css'/>"> --%>
	
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/css/style.css'/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/resources/framework/c3/c3.css'/>">
<!-- Load c3.css -->

<script type="text/javascript"	src="<c:url value='/resources/framework/jquery/jquery-3.2.1.min.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/jquery/jquery-ui.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/jquery/jquery.loadingModal.min.js'/>"></script>

<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/geotiff.min.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/leaflet-src.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/leaflet.label.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/leaflet-geotiff.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/leaflet-geotiff-plotty.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/leaflet-geotiff-vector-arrows.js'/>"></script>


<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/addon/L.ImageTransform.js'/>"></script>

<script type="text/javascript" src="<c:url value='/resources/framework/leaflet/addon/draw/leaflet.draw-src.js'/>"></script>

<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/addon/context-menu/leaflet.contextmenu.min.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/addon/zoom-slider/L.Control.Zoomslider.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/addon/leaflet.measurecontrol.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/addon/minimap/Control.MiniMap.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/geo/proj4js.js'/>"></script>

<script type="text/javascript" src="<c:url value='/resources/framework/shp/shp.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/dxf/dxf-parser.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/shp/FileSaver.min.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/shp/shpwrite.js'/>"></script>

<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet-image.js' />"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/d3pie/d3.js' />"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/d3pie/d3pie.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/addon/edit/Leaflet.Editable-src.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/resources/framework/leaflet/addon/edit/L.Path.Drag-0.0.6-src.js'/>"></script>
	
<link type="text/css" rel="stylesheet" href="<c:url value='/resources/framework/leaflet/L.Control.BetterScale.css'/>">
<script type="text/javascript" src="<c:url value='/resources/framework/leaflet/L.Control.BetterScale.js'/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/resources/framework/leaflet/leaflet.compass.css'/>">
<script type="text/javascript" src="<c:url value='/resources/framework/leaflet/leaflet.compass.js'/>"></script>

<script type="text/javascript"	src="<c:url value='/resources/framework/geo/turf.min.js' />"></script>

<%-- 	<script type="text/javascript" src="<c:url value='/resources/js/map.capture-src.js' />"></script> --%>
<script type="text/javascript"	src="<c:url value='/resources/framework/d3.v5.min.js'/>"
	charset="utf-8"></script>
<!-- Load d3.js and c3.js -->
<script type="text/javascript"	src="<c:url value='/resources/framework/c3/c3.min.js'/>"></script>

<script type="text/javascript" src="<c:url value='/resources/framework/export/export.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/framework/export/download2.js'/>"></script>
<%-- 	<script type="text/javascript" src="<c:url value='/resources/framework/html2canvas/html2canvas.js'/>"></script> --%>
<script type="text/javascript" src="<c:url value='/resources/framework/html2canvas/html2canvas.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/framework/html2canvas/es6-promise.auto.js'/>"></script>

<!-- DataTables -->
<link rel="stylesheet"	href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" />
<script	src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"	type="text/javascript"></script>
<script	src="https://cdn.datatables.net/plug-ins/1.10.20/api/processing().js"	type="text/javascript"></script>

<!-- DataTables Excel Download -->
<script	src="https://cdn.datatables.net/buttons/1.6.0/js/dataTables.buttons.min.js"	type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js" type="text/javascript"></script>
<script	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"	type="text/javascript"></script>
<script	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"	type="text/javascript"></script>
<script	src="https://cdn.datatables.net/buttons/1.6.0/js/buttons.html5.min.js"	type="text/javascript"></script>
<!-- DataTables Excel Download END -->
<!-- DataTables END-->
<%-- <script	src="<c:url value='/resources/framework/shp/jszip.min.js'/>"	type="text/javascript"></script> --%>
<script	src="<c:url value='/resources/framework/dxf/dxf_bundle.js'/>"	type="text/javascript"></script>

<!-- =============================================================================================================================== -->
<!-- 사용자 js 파일 인클루드 시작 -->
<script type="text/javascript"	src="<c:url value='/resources/js/common.js' />"></script>
<script type="text/javascript"	src="<c:url value='/resources/js/geocalc.js' />"></script>
<!-- 사용자 js 파일 인클루드 끝 -->
</head>
<body>
	<header class="main_header"></header>
	<!-- Container -->
	<div id="container">
		<div class="contents">
			<!-- Tool Bar -->
			<div class="toolbar-area"></div>
			<div id="map_wrap">
				<div id="mainMap"></div>
				<div class="map_btn">
					<div class="map_zoom">
						<button type="button" class="zoom_out" title="지도축소"
							onclick="zoomOut()">
							<spring:message code="zoomout" />
						</button>
						<button type="button" class="zoom_in" title="지도확대"
							onclick="zoomIn()">
							<spring:message code="zoomin" />
						</button>
					</div>
					<div class="map_scale_slt">
						<span class="selectbox" id="change-scale"></span>
						<ul id="scale">
							<li data-level="22">1 : 118.75</li>
							<li data-level="21">1 : 237.5</li>
							<li data-level="20">1 : 475</li>
							<li data-level="19">1 : 950</li>
							<li data-level="18">1 : 1,900</li>
							<li data-level="17">1 : 3,800</li>
							<li data-level="16">1 : 7,600</li>
							<li data-level="15">1 : 15,200</li>
							<li data-level="14">1 : 30,400</li>
							<li data-level="13">1 : 60,800</li>
							<li data-level="12">1 : 121,600</li>
							<li data-level="11">1 : 243,200</li>
							<li data-level="10">1 : 486,400</li>
							<li data-level="9">1 : 972,800</li>
							<li data-level="8">1 : 1,945,600</li>
							<li data-level="7">1 : 3,891,200</li>
							<li data-level="6">1 : 7,782,400</li>
						</ul>
					</div>
					<button type="button" class="map_rock" onclick="mapfixed();">
						<spring:message code="map.fixed" />
					</button>
				</div>
				<!-- //Map Control Button -->
<!-- 				<button type="button" class="btn_slide_close" -->
<%-- 					title="<spring:message code="side_panel.close"/>"> --%>
<%-- 					<spring:message code="side_panel.close" /> --%>
<!-- 				</button> -->
			</div>
			<!-- //Map Area -->

<!-- 			<div class="side-panel"></div> -->
<!-- 			<div class="layer-panel"></div> -->
		</div>
	</div>
	<!-- //Container -->

<!-- ==================================================================================================================== -->
<!-- js 파일에서 쓰일 문자열 정의 -->
<input type="hidden" id="epsg_confirm"		value="<spring:message code='epsg_confirm'/>" />
<!-- ==================================================================================================================== -->

<script type="text/javascript">
	loading('body','<spring:message code="main.title"/> <spring:message code="main.loading"/>');

	$(".main_header").load("./header", function() {});
	$("#mainMap").load("./map", function() {
		// 메인 지도 핸들링을 위한 스크립트 파일
 		$.getScript( './resources/js/mainMap.js' );
	});
// 	$(".toolbar-area").load("./toolbar", function() {
//  		initMapTools();
//  		$("#ico_tool_move").addClass("active");
// 	});
// 	$(".side-panel").load("./side-panel", function() {
// 	});
// 	$(".layer-panel").load("./layer-panel", function() {
		
// 	});
// 	$(".attribute-panel").load("./attribute", function() {
		
// 	});

	$("#footer").load("./footer.jsp", function() {});
	var defaultLvl = 7;
	var baseSrs = "EPSG:4326";

	$(window).ready(function() {
		$("#scale").children().each(function(){
	    	if($(this).attr("data-level") == defaultLvl) {
	    		$("#change-scale").text($(this).text());
	    		return;
	    	}
	    });
	})
	$(document).ready(function() {
	});
	
// 	$(window).load(function() { 모두 로드된 후에 처리 });

// 	$(document).ready(function() { DOM객체 로드시 처리 });

// 	$(function() { 로딩 될 때 });

	//console.info(currencyFormatDE(1234567.89)) // output 1.234.567,89 €
	function currencyFormatDE(num) {
	  return (
	    num
	      .toFixed(2) // always two decimal digits
	      .replace('.', ',') // replace decimal point character with ,
	      .replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.') + ' €'
	  ); // use . as a separator
	}
	function zeroSet(str, num) {
		if(str.length >= num) return str;
		var newstr = "";
		for(var i = 0; i<(num-str.length);i++)
			newstr += '0';
		return newstr + str;
	}
	
	// 지도 확대
	function zoomIn() {
		var currZoom = mymap.map.getZoom();
		mymap.map.setZoom(currZoom+1);
	}

	// 지도 축소
	function zoomOut() {
		var currZoom = mymap.map.getZoom();
		mymap.map.setZoom(currZoom-1);
	}
	
	$(document).click(function(e){ //문서 body를 클릭했을때
 		if(e.target.className =="side-result"){return false} //내가 클릭한 요소(target)를 기준으로 상위요소에 .share-pop이 없으면 (갯수가 0이라면)
 		$(".side-result").css("display", "none");
 	});
	
	$( ".search-result" ).click( function () {
 		$(".side-result").css("display", "none");
	});

	// 위치고정
	function mapfixed() {
		$(".map_rock").removeClass('is-open');;
		mymap.map.setMaxBounds(mymap.map.getBounds());
		if ($(".map_rock").hasClass('active')){
			$(".map_rock").removeClass('active');
			mymap.map.setMaxBounds([[-180,-85], [180,85]]);
		} else {
			$(".map_rock").addClass('active');
			mymap.map.setMaxBounds(mymap.map.getBounds());
		}
	}
	
	
	/* 지도 축척 펼치기 접기 */
	$('.map_scale_slt').on('click','.selectbox',function(){
	  var parent = $(this).closest('.map_scale_slt');
	  if ( ! parent.hasClass('is-open')){
	    parent.addClass('is-open');
	    $('.map_scale_slt.is-open').not(parent).removeClass('is-open');
	  }else{
	    parent.removeClass('is-open');
	  }
	}).on('click','ul>li',function(){
	  var parent = $(this).closest('.map_scale_slt');
	  parent.removeClass('is-open').find('.selectbox').text( $(this).text() );
	});
	
	// 축척 변경시 지도 레벨 조정
	$(".map_scale_slt ul li").click(function(){
		mymap.map.setZoom($(this).data("level"));
	})
	
	//아이콘 선택시 active클래스 토글
	$(".ctr_top > li > a").click(function(){
	    $(this).toggleClass("active");
	});

	//지도 선택 탭 펼치기/접기
	$('.ctr_top > li:nth-child(3)').click(function() {
		$('.maptype_layer').toggle();
    });	
	
	// 세션 체크 로그인 여부
	$(window).on('load', function () {
		var flag = false;
		$.ajax({ type: "post", url : "./qry",
			data : 'cmd=SESSION_CHECK',
			success : function (data) {
				if( data.header.process != "fail" ) {
					flag = true;
 					var userNm = data.body.result.user_nm;
 					$('.user_name')[0].innerHTML = userNm;
 					work.user_id = data.body.result.user_id;
				} else {
					flag = false;
				}
				loading_close();
			}, error: function(xhr,status, error){
				alert("세션정보 로드 실패");
				loading_close();
			}
		});

		if (flag) {
			$('.ico_user').css('display', 'inline-block');
			$('.user_wrap').find('span.ico_arrow2.show').css('display', 'inline-block');
		} else {
			$( '.ico_user' ).css( 'display', 'none' );
			$( '.ico_arrow2 > show' ).css( 'display', 'none' );
		}
	});
	// 메뉴 누른 이후 다른 곳을 눌렀을때 메뉴를 닫는 함수
	$('body').click(function() {
		closeMenu();
	});
	// 모든 메뉴 닫기
	function closeMenu(not_support) {
		if(not_support != '.menu_list') $('.menu_list').hide(); //=> header.jsp
		if(not_support != '.file_menu') $('.file_menu').hide(); //=> header.jsp
		if(not_support != '.maptype_layer') $('.maptype_layer').hide(); //=> toolbar.jsp
		if(not_support != '.my_info') $('.my_info').hide(); //=> header.jsp
		if(not_support != '.slide_list') $('.slide_list').hide(); // => side-panel.jsp
		if(not_support != '.tool_menu') $('.tool_menu').hide(); // => header.jsp
	}
	// 로케일 문자 반환
	function getMessage(name) {
		return $("#" + name).val();
	}
	</script>
</body>
</html>