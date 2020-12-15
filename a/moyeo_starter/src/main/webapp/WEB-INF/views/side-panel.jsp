<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<!-- Right Slide Contents -->
	<div id="Slide_contents">
		<div class="slide_menu">
			<div class="slide_slt">
				<span class="slide_title"><spring:message code="menu.default"/></span>
				<ul class="slide_list">
					<li rel="tab1" id="defaultMenu"><spring:message code="menu.default"/></li> <!-- 기본정보 -->
					<li rel="tab2" class="disabled"><spring:message code="memu.ibji"/></li> <!-- 입지분석 -->
					<li rel="tab3" class="disabled"><spring:message code="memu.law"/></li> <!-- 법률분석 -->
					<li rel="tab" class="disabled"><spring:message code="memu.theme"/></li> <!-- 테마분석 -->
					<li rel="tab" class="disabled"><spring:message code="memu.demand"/></li> <!-- 수요분석 -->
					<li rel="tab" class="disabled"><spring:message code="memu.cost"/></li> <!-- 개략사업비분석 -->
					<li rel="tab" class="disabled"><spring:message code="memu.total"/></li> <!-- 종합분석정보 -->
				</ul>
			</div>
			<div class="tab_menu" id="tab1">
				<ul class="tabs">
					<li rel="tab1_cont1" class="active"><spring:message code="tab.poi"/></li><!-- 위치정보 -->
					<li rel="tab1_cont2"><spring:message code="tab.land"/></li><!-- 토지정보 -->
					<li rel="tab1_cont3"><spring:message code="tab.building"/></li><!-- 건축물정보 -->
					<li rel="tab1_cont4"><spring:message code="tab.urban"/></li><!-- 도시계획정보 -->
					<li rel="tab1_cont5"><spring:message code="tab.total"/></li><!-- 종합정보 -->
				</ul>
			</div>
			<div class="tab_menu" id="tab2">
				<ul class="tabs">		
					<li rel="tab2_cont1" ><spring:message code="tab.analysis.natural"/></li><!-- 자연환경분석 -->
					<li rel="tab2_cont2"><spring:message code="tab.analysis.land"/></li><!-- 토지건물분석 -->
					<li rel="tab2_cont3"><spring:message code="tab.analysis.plan"/></li><!-- 도시계획분석 -->
					<li rel="tab2_cont4" class="disabled"><spring:message code="tab.analysis.traffic"/></li><!-- 환경교통재해 -->
					<li rel="tab2_cont5" class="active"><spring:message code="tab.analysis.total"/></li><!-- 종합정보 -->
				</ul>
			</div>
			<div class="tab_menu" id="tab3">
				<ul class="tabs w6">		
					<li rel="tab3_cont1" ><spring:message code="tab.law.restriction"/></li><!-- 행위제한분석 -->
					<li rel="tab3_cont2" class="disabled"><spring:message code="tab.law.detail"/></li><!-- 세부규제분석 -->
					<li rel="tab3_cont3"><spring:message code="tab.law.urban"/></li><!-- 도시개발분석 -->
					<li rel="tab3_cont4" class="disabled"><spring:message code="tab.law.reimpact"/></li><!-- 재영향법분석 -->
					<li rel="tab3_cont5" class="disabled"><spring:message code="tab.law.qa"/></li><!-- 질의회신분석 -->
					<li rel="tab3_cont6" class="active"><spring:message code="tab.law.total"/></li><!-- 종합정보 -->
				</ul>
			</div>
		</div>
		
		<!-- 기본정보  -->
		<!-- Tab_Contents: 위치정보 -->
		<div class="slide_cont" id="tab1_cont1"></div>

		<!-- Tab_Contents: 토지정보 -->
		<div class="slide_cont" id="tab1_cont2"></div>

		<!-- Tab_Contents: 건축물정보 -->
		<div class="slide_cont" id="tab1_cont3"></div>

		<!-- Tab_Contents: 도시계획정보 -->
		<div class="slide_cont" id="tab1_cont4"></div>

		<!-- Tab_Contents: 종합정보 -->
		<div class="slide_cont" id="tab1_cont5"></div>
		
		
		<!-- 입지정보 -->
		<!-- Tab_Contents: 자연환경분석 -->
		<div class="slide_cont" id="tab2_cont1"></div>

		<!-- Tab_Contents: 토지건물분석 -->
		<div class="slide_cont" id="tab2_cont2"></div>

		<!-- Tab_Contents: 도시계획분석 -->
		<div class="slide_cont" id="tab2_cont3"></div>

		<!-- Tab_Contents: 환경교통재해 -->
		<div class="slide_cont" id="tab2_cont4"></div>

		<!-- Tab_Contents: 종합분석 -->
		<div class="slide_cont" id="tab2_cont5"></div>
		
		<!-- 법률분석 -->
		<!-- Tab_Contents: 행위제한분석 -->
		<div class="slide_cont" id="tab3_cont1"></div>
		
		<!-- Tab_Contents: 세부규제분석 -->
		<div class="slide_cont" id="tab3_cont2"></div>
		
		<!-- Tab_Contents: 도시개발분석 -->
		<div class="slide_cont" id="tab3_cont3"></div>
		
		<!-- Tab_Contents: 재영향법분석 -->
		<div class="slide_cont" id="tab3_cont4"></div>
		
		<!-- Tab_Contents: 질의회신분석 -->
		<div class="slide_cont" id="tab3_cont5"></div>
		
		<!-- Tab_Contents: 종합분석 -->
		<div class="slide_cont" id="tab3_cont6"></div>
	</div>
	<!-- //Right Slide Contents -->
 <script type="text/javascript">

 var activeTab1 = "tab1";
//tab_menu
 $(".tab_menu").hide();
 $(".tab_menu:first").show();
 
// 자체 호출
$(".slide_list li").click(function () {
    activeTab1 = $(this).attr("rel");
	if((work.land.array.length < 1 || bStarted) && activeTab1 != "tab1") {
// 		alert('d');
		activeTab1 = "tab1"; //=>side-panel.jsp
		activeTab = "tab1_cont1";  //=>side-panel.jsp			
		$.alert('<spring:message code="msg.no.area.selected"/>');
		activeMenu();  //=>side-panel.jsp */
		return false;
	}
    $(".slide_list li").removeClass("active");
    $(this).addClass("active");
    $(".tab_menu").hide();
    $("#" + activeTab1).fadeIn();
    closeAttribute(); //속성 닫기 
    if(activeTab1 == "tab1")
    	activeTab = "tab1_cont1";
    else if(activeTab1 == "tab2")
   	 	activeTab = "tab2_cont1";
    else if(activeTab1 == "tab3")
   	 	activeTab = "tab3_cont1";
    activeSub();
});
// 타메뉴에서 호출
function activeMenu() {
	$(".slide_list li").removeClass("active");
	$(".tab_menu").hide();
	$("#" + activeTab1).fadeIn();
	$(".slide_list li").each(function(i, e){
        if($(this).attr("rel") == activeTab1) {
        	$(this).addClass("active");
        	$('.slide_title').text( $(this).text() ); 
        	return;
        }
    });
	if(activeTab1 == "tab1")
     	activeTab = "tab1_cont1";
    else if(activeTab1 == "tab2")
    	activeTab = "tab2_cont1";
    else if(activeTab1 == "tab3")
   	 	activeTab = "tab3_cont1";
    activeSub();
}

//slide_tab
$(".slide_cont").hide();
$(".slide_cont:first").show();


var activeTab = "tab1_cont1";
function activeSub() {
	if(activeTab != "tab1_cont1") {
		activeTab1 = "tab1"; //=>side-panel.jsp
		activeTab = "tab1_cont1";  //=>side-panel.jsp			
		$.alert('<spring:message code="msg.no.area.selected"/>');
		activeMenu();  //=>side-panel.jsp */
		return;
	}
    $(".tabs li").removeClass("active");
    $('.tabs li').each(function(i, e){
        if($(this).attr("rel") == activeTab) {
        	$(this).addClass("active");
        	return;
        }
    });
    $(".slide_cont").hide();
    $("#" + activeTab).fadeIn();
    loadWork();
}

$(".tabs li").click(function () {
	activeTab = $(this).attr("rel");
	if(activeTab != "tab1_cont1") {
		activeTab1 = "tab1"; //=>side-panel.jsp
		activeTab = "tab1_cont1";  //=>side-panel.jsp			
		$.alert('<spring:message code="msg.no.area.selected"/>');
		activeMenu();  //=>side-panel.jsp */
		return;
	}
    $(".tabs li").removeClass("active");
    $(this).addClass("active");
    $(".slide_cont").hide();
    $("#" + activeTab).fadeIn();
    closeAttribute(); //속성 닫기
    $('#lineToolBar').hide();//linetoolbar 닫기
    loadWork();
});

function loadWork() {
	$('.menu_list li').each(function(i, e){
        if($(this).attr("rel") != 'tab')
        	$(this).removeClass("disabled");
    });
	$('.slide_list li').each(function(i, e){
        if($(this).attr("rel") != 'tab')
        	$(this).removeClass("disabled");
    });
	if(activeTab1 == "tab1") { // 기본정보
		if(activeTab == "tab1_cont1") {
			if(typeof loadJuso !="undefined"){
 				loadJuso(); // => where_info.jsp
			}
		} else if(activeTab == "tab1_cont2") {
			loadLand(); // => land_info.jsp
		} else if(activeTab == "tab1_cont3") {
			loadBuilding(); // => building_info.jsp
		} else if(activeTab == "tab1_cont4") {
			loadPlan(); // => plan_info.jsp
		} else if(activeTab == "tab1_cont5") {
			loadTotal(); // => total_info.jsp //종합정보
		}
	} else if(activeTab1 == "tab2") { // 입지분석
		if(activeTab == "tab2_cont1") { // 자연환경분석
			loadNatural(); // => side-panel/loc_natural.jsp
		} else if(activeTab == "tab2_cont2") { // 토지건물분석
			loadLandbd(); // => side-panel/loc_landbd.jsp
		} else if(activeTab == "tab2_cont3") { // 도시계획분석
			loadLplan(); // => side-panel/loc_plan.jsp
		} else if(activeTab == "tab2_cont5") {
			loadLtotal(); // => loc_total_info.jsp //종합분석
		}
	} else if(activeTab1 == "tab3") { // 법률분석
		if(activeTab == "tab3_cont1") { // 행위제한분석
			loadLawRestriction(); // => side-panel/law_restriction.jsp
		} else if(activeTab == "tab3_cont2") { // 세부규제분석
			//loadLawDetail(); // => side-panel/law_restriction.jsp
		} else if(activeTab == "tab3_cont3") { // 도시개발분석
			loadLawUrban(); // => side-panel/law_restriction.jsp
		} else if(activeTab == "tab3_cont4") { // 재영향법분석
			//loadLawReimpact(); // => side-panel/law_restriction.jsp
		} else if(activeTab == "tab3_cont5") { // 질의회신분석
			//loadLawQA(); // => side-panel/law_restriction.jsp
		} else if(activeTab == "tab3_cont6") { // 종합분석
			//loadLawtotal(); // => side-panel/law_total.jsp
		}
	}
}

/* Right Menu Select */
$('.slide_slt').on('click','.slide_title',function(){
	closeMenu('.slide_list'); // => common.js
//   	var parent = $(this).closest('.slide_slt');
//   	if ( ! parent.hasClass('is-open')){
//     	parent.addClass('is-open');
//     	$('.slide_slt.is-open').not(parent).removeClass('is-open');
//   	}else{
//     	parent.removeClass('is-open');
//   	}
	$('.slide_list').toggle();
  	event.stopPropagation();
}).on('click','ul>li',function(){
  	var parent = $(this).closest('.slide_slt');
  	parent.removeClass('is-open').find('.slide_title').text( $(this).text() );
});

//오른쪽 사이드 패널 펼치기/접기
var right_w = $("#Slide_contents").width();
var left_w = 60;
$(".btn_slide_close").click(function(e){  //=> main.jsp
// 	console.log("right_w : "+right_w); //---------------------------- 콘솔
	if($("#Slide_contents").is(':visible')){
// 		console.log("show"); //---------------------------- 콘솔
		$("#Slide_contents").hide();
// 		$(".side-panel").hide();
	}else{
// 		console.log("hide"); //---------------------------- 콘솔
		$("#Slide_contents").show();
// 		$(".side-panel").show();
	}
	mapResize(); // main.jsp
	e.preventDefault();
});
/*
* 지도화면 크기 변경 함수
*/
function mapResize() {
	if($("#Slide_contents").is(':visible')){ // 사이드 패널 보일때
		$("#map_wrap").css("left", left_w+"px").css("width", "100%").css("width", $("#map_wrap").width()-right_w-left_w);
		mymap.map.invalidateSize(true);
		$(".btn_slide_close").removeClass("btn_slide_open");
	}else{ // 사이트 패널 안보일때
		$("#map_wrap").css("left", left_w+"px").css("width", "100%").css("width", $("#map_wrap").width()-left_w);
		mymap.map.invalidateSize(true);
		$(".btn_slide_close").addClass("btn_slide_open");
	}
}

//조건분석 띄우기
function condAnalysis(deps1, deps2, deps3, flag, target, options, fn){
    var title;
    var keyword = ""; // Json Key Name
 	// deps1 => 기본정보 1, 입지분석 2
 	// deps2 => 위칭정보:자연환경 1, 토지정보:토지건물분석 2, 건축물정보:도시계획분석 3, 도시계획분석 4, 종합정보 5
 	// deps3 => 지목현황 1, 

    if(title == null) {
    	if ( flag == 2 || flag == 3 ) { // 구간 조건 타이틀
    		title = "<spring:message code='analysis.gubun.range'/>"; 
    	} else { // 명칭 조건 타이틀
    		title = "<spring:message code='analysis.gubun.name'/>";
    	}
    }

	if( $( '#alertBox' ) ) { //초기화
		$( 'div' ).remove( '#alertBox' );
	}
	var data = "";
	var $alertBox = $.parseHTML( '<div id="alertBox"></div>' );
  	$( "body" ).append($alertBox);
  
  	$($alertBox).css("z-index",999);
  	$($alertBox).dialog({
		open: $($alertBox).load("./side-panel/analysis", function() {
			if( flag == 1) { // 명칭
				$( "#nomal" ).css( "display" ,  "inline-block" );
				$( "#interval" ).css( "display" , "none" );
			} else if ( flag == 2 ) { //구간- 구간조정
				$( "#interval" ).css("display", "inline-block");
				$( "#nomal" ).css("display", "none");
			}  else if ( flag == 3 ) { //구간
				$( "#interval" ).css("display", "inline-block");
				$( "#nomal" ).css("display", "none");
			}
			else {
				console.log("error at dialog_Analysis()! flag : "+flag);
			}
			setTable(flag, target, deps1, deps2, deps3, options);
		}), // jquery Include?
		title: title,	moveToTop: true,	autoOpen: true,	modal: true,	resizable:false,	width: "600px",
		buttons: {
			OK: function() {
				var msg = validationCheck(flag);
				if(msg == ""){
					$($alertBox).dialog("close");
					data = tableToJson(flag);
					if(fn != null) fn(data);
				}else{
					alert(msg);
				}
				
			}
		}
	});	
}
// 구간 validation check
function validationCheck(flag){
	var msg = "";
	if(flag=="2"){
		var rows = $("#interval_Tbl > tbody > tr");
		var tempRow = null;
		console.log("구간 validation check");
		var length = rows.length;
		$.each(rows, function(key, value){
			var $colMin = value.children[1];
			var $colMax = value.children[2];
			var iMin = Number($colMin.children[0].value.replace(/,/gi,""));
			if(isNaNCheck(iMin)) return  msg +=(key+1)+'행:'+'<spring:message code="error.isNaN"/>'+ "\n"; // => analysis.jsp
			if($colMax.children.length>0 ){
			    var iMax = Number($colMax.children[0].value.replace(/,/gi,""));
			    if(isNaNCheck(iMax)) return msg +=(key+1)+'행:'+'<spring:message code="error.isNaN"/>'+ "\n"; // => analysis.jsp
				if(iMax <= iMin){
					msg +=(key+1)+'행:'+'<spring:message code="error.minmax"/>' + "\n";
				}	
			}else {
				var $tempRow = rows[key-1];
				if(typeof $tempRow != 'undefined'){
					var prevMax =Number($tempRow.children[2].children[0].value.replace(/,/gi,""));
					if(iMin < prevMax){
						msg +='<spring:message code="error.max"/>' + "\n";
					}
				}					
			}
		});
	}
	return msg;
}

function setTable(flag, target, deps1, deps2, deps3, options) {
	if(flag == 1) {	//명칭 조건
		$.each(target, function(key, value){
			if(value.visible==1) {
				var group=value.group;
				var code="";
				if(options=="text"){
					group=value.text;
					code=value.group;
				}				
				$('#nomal_Tbl > tbody:last').append('<tr><td style="background:'+value.color+';"></td><td>'+group+'</input></td><td>'+code+'</td></tr>');
				//$('#nomal_Tbl > tbody:last').append('<tr><td style="background:'+value.color+';"></td><td><input type="text" value='+group+'></input></td><td>'+code+'</td></tr>');
			}
		});
	} else if (flag == 2) { //구간 조건- 구간조정
		$( '#maxValue' ).val(options.max);
		$( '#minValue' ).val(options.min);
		$.each(target, function(key,value){
			if(value.val2 == -999) {
				/*if(activeLand1Tab == "land1_cont4") {
					value.val1 = value.val1.toFixed(0);
				}*/
				intervalTblAppendRow(true, 1, value.color, numComma(value.val1), ""); // => analysis.jsp
			} else {
				/*
				if(activeLand1Tab == "land1_cont4") {
					value.val1 = value.val1.toFixed(0);
					value.val2 = value.val2.toFixed(0);
				}*/
				intervalTblAppendRow(true, 2, value.color, numComma(value.val1), numComma(value.val2),value.interval); // => analysis.jsp
			}
		});
	} else if (flag == 3) { //구간 조건
		$( '#maxValue' ).val(options.max);
		$( '#minValue' ).val(options.min);
		$.each(target, function(key,value){
			if(value.val2 == -999) {
				if(activeLand1Tab == "land1_cont4") {
					value.val1 = value.val1.toFixed(0);
				}
				intervalTblAppendRow(false, 1, value.color, numComma(value.val1), ""); // => analysis.jsp
			} else {
				if(activeLand1Tab == "land1_cont4") {
					value.val1 = value.val1.toFixed(0);
					value.val2 = value.val2.toFixed(0);
				}
				intervalTblAppendRow(false, 2, value.color, numComma(value.val1), numComma(value.val2),value.interval);// => analysis.jsp
			}
		});
	} 
}

function tableToJson(flag) {
	var table = '';
	var headers = '';
	if( flag == 1) { // 명칭
		table = $( "#nomal_Tbl" );
		headers = [ "color", "key", "code" ];
	} else if ( flag == 2 ) { //구간	- 구간조정
		table = $( "#interval_Tbl" );
		headers = [ "color", "val1", "val2", "interval" ];
	} else if ( flag == 3 ) { //구간	
		table = $( "#interval_Tbl" );
		headers = [ "color", "val1", "val2", "interval" ];
	} else {
		console.log( "error at tableToJson()! flag : " + flag );
	}

	var data = [];
/* 
    for( var i=0; i<table[0].rows[0].cells.length; i++ ) {
        headers[i] = table[0].rows[0].cells[i].innerHTML.toLowerCase().replace( / /gi,'' );
        console.log( "HEADERS : " + headers[i] );
    }
*/
	if( flag == 1 ) {
		for(var i=1; i<table[0].rows.length; i++) {
	        var tableRow = table[0].rows[i];
	        var rowData = {};
	        for(var j=0; j<tableRow.cells.length; j++) {
	        	if( j == 0 ) {
	        		var hex = tableRow.cells[j].style.background;
	        		hex = hex.replace('rgb', '');
	        		hex = hex.replace('(', '');
	        		hex = hex.replace(')', '');
	    			hex = hex.split(',');
	    			var r = Number(hex[0]); var g = Number(hex[1]); var b = Number(hex[2]);
	        		hex = RGB2hex(r,g,b);
	        		rowData[headers[j]] = hex;
	        	} else if ( j == 1 ) {
	        		var name = getColumnData(tableRow.cells[j],"",true);//tableRow.cells[j].children[0].value;
	        		rowData[headers[j]] = name;
	        	} else if ( j == 2 ) {
	        		rowData[headers[j]] = tableRow.cells[j].innerHTML;
	        	} else console.log( "error at tableToJson ! j : " + j );
	        }
	        data.push( rowData );
	    }	
	} else if ( flag == 2 ) {//구간조정
		for(var i=1; i<table[0].rows.length; i++) {
	        var tableRow = table[0].rows[i];
	        var rowData = {};
	        
       		var hex = tableRow.children[0].style.background;
       		hex = hex.replace('rgb', '');
       		hex = hex.replace('(', '');
       		hex = hex.replace(')', '');
   			hex = hex.split(',');
   			var r = Number(hex[0]); var g = Number(hex[1]); var b = Number(hex[2]);
   			rowData.color = RGB2hex(r,g,b);
   			 // 최소
   			rowData.val1 = getColumnData(tableRow.children[1],"0"); // => analysis.jsp
   			// 최대값
   			rowData.val2 = getColumnData(tableRow.children[2],"-999"); // => analysis.jsp
   			// 구간범위
   			rowData.interval = getColumnData(tableRow.children[3],"0"); // => analysis.jsp
	       
 	        console.log(rowData);
	        data.push( rowData );
	    }
	} else if ( flag == 3 ) {//구간
		for(var i=1; i<table[0].rows.length; i++) {
	        var tableRow = table[0].rows[i];
	        var rowData = {};
	        for(var j=0; j<tableRow.children.length; j++) {
//         		console.log(tableRow.children[0].style.background+":"+tableRow.children[1].innerHTML+":"+tableRow.children[2].innerHTML+":"+tableRow.children[3].innerHTML);
	        	if( j == 0 ) { // 컬러값
	        		var hex = tableRow.children[0].style.background;
	        		hex = hex.replace('rgb', '');
	        		hex = hex.replace('(', '');
	        		hex = hex.replace(')', '');
	    			hex = hex.split(',');
	    			var r = Number(hex[0]); var g = Number(hex[1]); var b = Number(hex[2]);
	    			rowData.color = RGB2hex(r,g,b);
	        	} else if ( j == 1 ) { // 명칭
	        		var val1 = tableRow.children[1].innerHTML.replace(/,/gi,"");
	        		if(val1 == "") val1 = "0";
	        		rowData.val1 = Number(val1);	        	
	        	} else if ( j == 2 ) { // 최소값
	        		var val2 = tableRow.children[2].innerHTML.replace(/,/gi,"");
	        		if(val2 == "") val2 = "-999";
	        		rowData.val2 = Number(val2);
	        	} else if ( j == 3 ) { // 최대값
	        		var interval = tableRow.children[3].innerHTML.replace(/,/gi,"");
	        		if(interval == "") interval = "0";
	        		rowData.interval = Number(interval);
	        	} else console.log( "error at tableToJson ! j : " + j );
	        }
// 	        console.log(rowData);
	        data.push( rowData );
	    }
	}
    return data;
}
//속성 보기
function openAttribute(data){
		$(".attribute-panel").css( "display" ,  "block" );
		$( "#Slide_contents_Bottom" ).css( "display" ,  "block" );
		loadAttribute(data);   // loadAttribute  => attribute.jsp
}

</script>
</body>
</html>