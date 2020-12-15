<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%-- <meta http-equiv="X-UA-Compatible" content="IE=edge; charset=<?=$g4['charset']?>"/>  --%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link type="text/css" rel="stylesheet" href="<c:url value='/resources/framework/jstree/themes/default/style.css'/>">
	<script type="text/javascript" src="<c:url value='/resources/framework/jstree/jstree.js'/>"></script>

<style>
#layerlank {background:url('./resources/images/icon-layer.gif') no-repeat center;
	position:absolute;width:32px;height:32px;left:225px;top:13px;}
#layerlank:hover {background:url('./resources/images/icon-layer.gif') no-repeat center #7a7f95;}
/* #layerlank:focus {background:url('./resources/images/icon-layer.gif') no-repeat center #507bd8;} */
</style>
<script type="text/javascript">
</script>

</head>
<body>
	<div class="layer">
		<div class="layer_menu">
			<ul class="layer_tabs">
				<li rel="layer_tab1" class="active"><spring:message code="layer_panel.normalayer"/></li>
				<li rel="layer_tab2"><spring:message code="layer_panel.userlayer"/></li>
			</ul>
		</div>
		<ul>
			<li><a href="javascript:layerlankshow();" id="layerlank" title="<spring:message code="layer.lank"/>"></a></li>				
		</ul>
		<div class="layer_cont" id="layer_tab1"></div>
		<div class="layer_cont" id="layer_tab2"></div>
		<div  class="layer_menu" id="layerShowLvl" style="width:100%;height:270px;margin-top:15px;padding:10px;">
			<div id="lank_tree" style="background-color:#fff;height:100%;overflow:auto;"></div>
		</div>
		<div id="legend" style="width:250px;"></div>
	</div>
	<!-- //Layer -->
	<script type="text/javascript">
	$("#layerShowLvl").hide();
	$(".layer_cont").hide();
    $(".layer_cont:first").show();

    $(".layer_tabs li").click(function () {
        $(".layer_tabs li").removeClass("active");
        $(this).addClass("active");
        $(".layer_cont").hide()
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn()
    });
 // 타메뉴에서 호출
    function activeLayer(atab) {
    	$(".layer_tabs li").removeClass("active");
    	if(atab == "layer_tab1") $("#layer_tab2").hide(); else  $("#layer_tab1").hide();
    	$(".layer_tabs li").each(function(i, e){
            if($(this).attr("rel") == atab) {
            	$(this).addClass("active");
            	$("#"+atab).show();
            	return;
            }
        });
    }
 	function layerlankshow() {
 		$('#layerShowLvl').toggle();
 		if($('#layerShowLvl').is(':visible'))
 			$('#layerlank').css("background","url('./resources/images/icon-layer.gif') no-repeat center #507bd8");
 		else $('#layerlank').css("background","url('./resources/images/icon-layer.gif') no-repeat center");
 	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 일반레이어 관리
	// 일반레이어 초기 생성
function loadLayerList() {
	loading();
	$('#layer_tab1').jstree().create_node(null, { "id": "base_layer", "text": "<spring:message code='layer_panel.base_layer'/>", "icon": "./resources/images/ico_rester33.png"
		, "type" : "btn", "li_attr": {"chk": true, "selectEvent":true,"deselect":false}
	});
	$('#layer_tab1').jstree(true).select_node('#base_layer');
    $.ajax({ type: "post", url : "./qry", dataType : 'json', data : 'cmd=SELECT_LAYER_LIST',
	    success : function (response) {
	    	var layerlist = response.body.result;
	    	$.each(layerlist, function(key,fd) {
	    		var LAYER=null, icon = false, LEGEND=null;
				if(fd.ly_type == "l-wms-t") {
					if(fd.cql_filter != "")
	    				LAYER = L.tileLayer.wms(geoserverurl+'wms', {layers: fd.ly_name, styles: fd.ly_url, format: "image/png", transparent: "true", CQL_FILTER:fd.cql_filter, minZoom:fd.minz, maxZoom:fd.maxz });
					else LAYER = L.tileLayer.wms(geoserverurl+'wms', {layers: fd.ly_name, styles: fd.ly_url, format: "image/png", transparent: "true", minZoom:fd.minz, maxZoom:fd.maxz });
	    		} else if(fd.ly_type == "l-wms-s") {
	    			if(fd.cql_filter != "")
	    				LAYER = L.singleTile(geoserverurl+'wms', {layers: fd.ly_name, styles: fd.ly_url, format: "image/png", transparent: "true", CQL_FILTER:fd.cql_filter, minZoom:fd.minz, maxZoom:fd.maxz});
	    			else LAYER = L.singleTile(geoserverurl+'wms', {layers: fd.ly_name, styles: fd.ly_url, format: "image/png", transparent: "true", minZoom:fd.minz, maxZoom:fd.maxz});
	    		} else if(fd.ly_type == "f") {
	    			icon = "./resources/images/ico_folder18.png";
	    		} 
				if(fd.ly_type != "f" && fd.ly_legend != undefined) {
					if(fd.ly_legend == "label") {
						icon = "./resources/images/ico_text33.png";
					} else if(fd.ly_legend == "raster") {
						icon = "./resources/images/ico_raster33.gif";
						LEGEND = geoserverurl+"wms/image?service=image&request=GetLegendGraphic&type=SUB&layer="+fd.ly_name+"&format=image/png&transparent=true&width=33";
					} else {
						icon = geoserverurl+"wms/image?service=image&request=GetLegendGraphic&type=SUB&layer="+fd.ly_name+"&style="+fd.ly_legend+"&format=image/png&transparent=true&width=33";
					}
				}
				var chk = false, devent = false;
				if(fd.ly_type != "f" ) {
					chk = true;
				}
				if(fd.ly_type == 'g') {
					icon = "./resources/images/ico_group17.png";
					devent = true;
				}
	    		if(fd.parent_uuid == undefined || fd.parent_uuid == "") {
	    			$('#layer_tab1').jstree().create_node(null, { "id": fd.uuid, "text": fd.ly_title, "icon": icon
	    				, "type" : "btn"
	    				, "li_attr": {"chk": chk, "selectEvent":true,"devent":devent,"deselect":!chk
	    						, "LAYER":LAYER, "LEGEND":LEGEND}
	    			});
	    		} else {
	    			$('#layer_tab1').jstree().create_node(fd.parent_uuid, { "id": fd.uuid, "text": fd.ly_title, "icon": icon
	    				, "type" : "btn"
	    				, "li_attr": {"chk": chk, "selectEvent":true,"devent":devent,"deselect":!chk
	    						, "LAYER":LAYER, "LEGEND":LEGEND}
	    			});
	    		}
	    		if(fd.visible == '1') {
	    			useLayers.addLayer(LAYER);
   					$('#layer_tab1').jstree(true).select_node('#'+fd.uuid);
    			}
	    	});
	    	loading_close();
	    	$('#layer_tab1').jstree("redraw");
	    },error: function(xhr,status, error){
	    	loading_close();
	    	$('#layer_tab1').jstree("redraw");
	    }
	});

	// 마우스 호버 이벤트
	$('#layer_tab1').on("hover_node.jstree", function (e, data) {
    	$('#legend').empty();
    	$('#legend').css('top',$("#"+data.node.id).position().top+100);
    	if(data.node.li_attr.LEGEND != null) {
    		//console.log(data.node.li_attr.LEGEND);
	    	$("<img>", { src: data.node.li_attr.LEGEND, style: 'float:left;'}).appendTo('#legend');
	    	$('#legend').show();
    	}
	});
	$('#layer_tab1').on("dehover_node.jstree", function (e, data) {
		$('#legend').empty();
    	$('#legend').hide();
	});
}
$("#layer_tab1").on("open_node.jstree", function(e, data) {
	$('#layer_tab1').jstree("redraw");
});
$("#layer_tab1").on("changed.jstree", function(e, data) {
});
$("#layer_tab1").on("select_node.jstree deselect_node.jstree", function(e,data) {
	if(data.node.li_attr.deselect){
// 		console.log("here!~");
		$('#layer_tab1').jstree(true).deselect_node('#'+data.node.id,  "#ffffdd" ,true); //선택 안되게 하기
		return false;
	}			
	
	if(data.node.li_attr.devent) {
// 		console.log(data.node);
		for(var i = 0; i < data.node.children.length;i++) {
			var node = data.node.children[i];
			if(data.node.state.selected)
				$('#layer_tab1').jstree("select_node","#"+node);
			else $('#layer_tab1').jstree("deselect_node","#"+node);
		}
		return;
	}
	if(!data.node.li_attr.selectEvent) {
		data.node.li_attr.selectEvent = true;
		return;
	}
	var id = data.node.id;
	if(id == "base_layer") {
		if(data.node.state.selected) {
			mymap.map.addLayer(baseLayer);
			baseLayer.bringToBack();
// 			baseCrs = baseLayer.options.crs;
		} else {
			mymap.map.removeLayer(baseLayer);
// 			baseCrs = crs5174;
		}
// 		changeCrs(baseCrs);
	} else {
// 		console.log(data.node.id);
// 		if(data.node.li_attr.LAYER == null) return;
		if(data.node.state.selected)
			useLayers.addLayer(data.node.li_attr.LAYER);
		else useLayers.removeLayer(data.node.li_attr.LAYER);
	}
});
// 리드로우시 체크박스 보임 암보임 처리
$("#layer_tab1").on("redraw.jstree", function(e, data) {
	var v =$("#layer_tab1").jstree(true).get_json('#', {'flat': true});
	for (i = 0; i < v.length; i++) {
	    if(!v[i]["li_attr"].chk) 
	    	$('#'+v[i]["id"]).find('.jstree-checkbox:first').hide(); // 체크박스 없애기
	}
});
$(document).ready(function() {
	// 일반 레이어 트리생성
	$("#layer_tab1").jstree({
		"core"    : { 'check_callback': true, "multiple" : true,},
		"plugins" : [ "themes","html_data","ui","crrm" ,"wholerow","checkbox", "changed"], //,"dnd"
    	"types" : {
    		"default" : {
    			"icon" : false,
    		},
    	},"ui": {
//     		"initially_select" : [ "#ref565" ],
//                "select_limit": 1,
//                "selected_parent_close": "select_parent"
    	}
    	,"checkbox": {"three_state" : false /*checkbox가 부모 자식노드 상관없이 체크되도록 */, "keep_selected_style" : true},
    });
// 	loadLayerList();
// 	reflushTree();
});
// 일반레이어 관리 끝	
</script>
</body>
</html>