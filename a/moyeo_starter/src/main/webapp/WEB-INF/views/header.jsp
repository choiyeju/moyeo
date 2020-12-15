<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/JavaScript" src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<!-- 다음 API사용시 주석 해제 -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=836e538f9a81b71509554edccc4ebbfe&libraries=services"></script>

</head>
<body>
	<div id="header">
		<!-- GNB -->
		<h1 class="home"><a href="javascript:goIntro();" title="Home">Home</a></h1>
		<div class="gnb">
			<a href="#" class="menu_slt"><spring:message code="menu_slt"/><span class="ico_arrow_show"></span></a>
			<ul class="menu_list">
				<li rel="tab1"><a href="javascript:menuSelect('tab1');"><spring:message code="menu.default"/></a></li>
			</ul>
		</div>
		<!-- //GNB -->

		<!-- Search -->
		<div class="top_search">
			<form name="form" id="form_roadaddr" method="post">
				<input type="text" style="display:none;" name="currentPage" value="1"/> <!-- 요청 변수 설정 (현재 페이지. currentPage : n > 0) -->
				<input type="text" style="display:none;" name="countPerPage" value="10"/> <!-- 요청 변수 설정 (페이지당 출력 개수. countPerPage 범위 : 0 < n <= 100) -->
				<input type="text" style="display:none;" name="resultType" value="json"/> <!-- 요청 변수 설정 (검색결과형식 설정, json) --> 
				<input type="text" style="display:none;" name="confmKey" value="U01TX0FVVEgyMDE5MDUxMDEwMTkxMjEwODcyMTk="/> <!-- 요청 변수 설정 (승인키) -->
				<input type="text" name="keyword" class="inp_sch_address" onkeydown="enterSearch();"placeholder='<spring:message code="search.input"/>' title='<spring:message code="search.input"/>'/>
				<input type= "button" class="btn_sch" onClick="enterSearch(true);" value="검색">
			</form>
		</div>
		<!-- //Search -->
		<!-- DAUM Search API -->
		<input id="postcode1" type="text" value="" style="width:50px;" readonly/>
		<input id="postcode2" type="text" value="" style="width:50px;" readonly/>
		<input id="zonecode" type="text" value="" style="width:50px;" readonly/>
		<input id="sample5_address" type="hidden" value="" style="width:50px;" readonly/>
		<!-- //DAUM Search API -->
		<br/>
		<input type="text" id="address" value="" style="width:240px;" readonly/>

		<input type="text" id="address_etc" value="" style="width:200px;"/>
		
		<div style="display:none;">
			<form name="form_addrXY" id="form" method="post">
				<input type="text" name="resultType" value="json"/> <!-- 요청 변수 설정 (검색결과형식 설정, json) --> 
				<input type="text" name="confmKey" value="TESTJUSOGOKR"/><!-- 요청 변수 설정 (승인키) -->
				<input type="text" name="admCd" value=""/> <!-- 요청 변수 설정 (행정구역코드) -->
				<input type="text" name="rnMgtSn" value=""/><!-- 요청 변수 설정 (도로명코드) --> 
				<input type="text" name="udrtYn" value=""/> <!-- 요청 변수 설정 (지하여부) -->
				<input type="text" name="buldMnnm" value=""/><!-- 요청 변수 설정 (건물본번) --> 
				<input type="text" name="buldSlno" value=""/><!-- 요청 변수 설정 (건물부번) -->
			</form>
		</div>
			
		<!-- Button -->
<!-- 		<div class="top_btn"> -->
<!-- 			<a href="javascript:saveWork()" class="save" title="저장">저장</a> -->
<%-- 			<a href="javascript:loadDxf();" class="import" title="<spring:message code="loadfile"/>" ><spring:message code="loadfile"/></a> --%>
<%-- 			<a href="javascript:initDrawObj()" class="refresh" title="<spring:message code="init"/>"><spring:message code="init"/></a> --%>
<!-- 		</div> -->
		<!-- //Button -->

		<div class="top_user_info">
			<a href="#" class="user_wrap"><span class="ico_arrow2 show" style="display:none;"></span><span class="ico_user" style="display:none;"></span><span class="user_name">Login</span></a>
			<div class="my_info">
				<ul class="my_info_list">
					<li><a href="#">권한설정</a></li>
					<li><a href="#">정보수정</a></li>
					<li onclick="logOut();"><a href="#">로그아웃</a></li>
				</ul>
			</div>
		</div>
		<!-- //User -->

	</div>
	<!-- //Header -->
	<input id="file-field" type="file" style="display:none" accept=".dxf,.zip"/>
<!-- 다음 API사용시 주석 해제 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
/* Top GNB Layer */
$('.menu_slt').click(function(event) {
	closeMenu('.menu_list');
	$('.menu_list').toggle();
	event.stopPropagation();
});

var header = {total_page:null};

// 시군구 읍면동 리 찾기
function getSggEmdRi(curpage) {
	var keyword = $("#form_roadaddr").children("input[name=keyword]").val();
	if(keyword == "") return; // 검색어 없으면 리턴
	loading("Loading...");
	header.total_page = null;
// 	daumAdrrAPI(); // 시도 검색을 안할때
	keyword = keyword.replace('서울시','서울특별시');
	keyword = keyword.replace('부산시','부산광역시');
	keyword = keyword.replace('세종시','세종특별자치시');
// 	keyword = keyword.replace('제주시','제주특별자치도');
	keyword = keyword.replace('제주도','제주특별자치도');
// 	keyword = keyword.replace('광주시','광주광역시');
	keyword = keyword.replace('대구시','대구광역시');
	keyword = keyword.replace('인천시','인천광역시');
	keyword = keyword.replace('대전시','대전광역시');
	
	keyword = keyword.replace('경남','경상남도');
	keyword = keyword.replace('경북','경상북도');
	keyword = keyword.replace('전남','전라남도');
	keyword = keyword.replace('전북','전라북도');
	keyword = keyword.replace('충남','충청남도');
	keyword = keyword.replace('충북','축청북도');
	keyword = keyword.replace('강원','강원도');
	keyword = keyword.trim();
// 	console.log(keyword);
	if(!keyword.endsWith("1") && !keyword.endsWith("2") && !keyword.endsWith("3") && !keyword.endsWith("4")
			&& !keyword.endsWith("5") && !keyword.endsWith("6") && !keyword.endsWith("7")&& !keyword.endsWith("8")&& !keyword.endsWith("9")&& !keyword.endsWith("0")) {
		if(curpage == null || curpage == "undefined") {
			curpage= 1;
		}
		$("#form_roadaddr").children("input[name=currentPage]").val(curpage);
		$.ajax({type: "post", url : "./qry",	dataType : 'json', async: false,
		    data : 'cmd=SELECT_KEYWORD_SEARCH&keyword='+encodeURI(keyword)+'&curpage='+curpage,
		    success : function (response) {
// 		    	console.log(response.body.result);
		    	var length = response.body.result.features.length;
		    	var cnt = response.body.resultCnt.cnt;
		    	if (length > 0){
		    		var html = "";
					header.total_page = cnt /10 +1;
		    		for(var i=0; i<length; i++) {
		    			var addr = response.body.result.features[i].properties.keyword;
		    			var cd = response.body.result.features[i].properties.cd;
// 			    		console.log(addr + ":::" + cd);
						html += "<li>";
						html += "<a class=\"search-table-row\" style=\"cursor:pointer;\">";
						html += "<input type=\"hidden\" name='where_cd' class='pnu' value='"+cd+"' />"; // X 좌표
						html += "<p class=\"searchNm\">"+addr  +"</p>"; // 도로명 주소
						html += "</a>";
						html += "</li>";	
					}
		    		$("#search-result").html(html);
		    		endMySearchProcess();
		    		loading_close();
		    	} else {
		    		daumAdrrAPI();
		    	}
		    	
		    }, error: function(){
		    	console.log( "SELECT_KEYWORD_SEARCH" );
		    	daumAdrrAPI();
		    }
		});
	} else {
		daumAdrrAPI();
	}
}

function daumAdrrAPI(curpage) {
	var keyword = $("#form_roadaddr").children("input[name=keyword]").val();
	if(curpage == null || curpage == "undefined") {
		curpage= 1;
	}
	$("#form_roadaddr").children("input[name=currentPage]").val(curpage);
	if(!isNumeric(keyword.substring(keyword.length-1))) {
		daumRestApi_keyword(keyword, curpage, function(data){
			if (data.documents.length > 0) {
				endSearchProcess(data);
				loading_close();
			} else {
				$.ajax({url: 'https://dapi.kakao.com/v2/local/search/address.json?query=' + keyword + '&size=10&page=' + curpage,
			    	headers: {'Authorization': 'KakaoAK 836e538f9a81b71509554edccc4ebbfe'},	type: 'GET',
				}).done(function(data1) {
					$("#search-result").empty();
					var html = "";
					if(data1.documents.length > 0){
// 						console.log(data1.documents[0]);
						header.total_page = data1.meta.pageable_count /10 +1;
						for(var i=0; i<data1.documents.length; i++) { // 이걸 10으로하면?
							html += "<li>";
							html += "<a class=\"search-table-row\" style=\"cursor:pointer;\">";
							html += "<input type=\"hidden\" name='x' class='x' value='"+data1.documents[i].x+"' />"; // X 좌표
							html += "<input type=\"hidden\" name='y' class='y' value='"+data1.documents[i].y+"' />"; // Y 좌표
							html += "<input type=\"hidden\" name='address_name' value='"+data1.documents[i].address_name+"' />"; // 주소
							if(data1.documents[i].road_address != null) {
								html += "<p class=\"searchNm\" style='word-break: break-all;white-space: normal ;' >"+data1.documents[i].road_address.address_name+'&nbsp;'+data1.documents[i].road_address.building_name+"</p>"; // 도로명 주소
							}
							html += "<p class=\"searchNm\ style='word-break: break-all;white-space: normal ;'>"+data1.documents[i].address_name+"</p>"; // 지번 주소
							html += "</a>";
							html += "</li>";	
						}
						$("#search-result").html(html);
						endSearchProcess(data1);
				    	loading_close();
					} else {
// 						san_jibun(keyword, curpage, function(){
							endSearchProcess();
							loading_close();
// 						});
					}
				});	
			}
		});
	} else {
		$.ajax({url: 'https://dapi.kakao.com/v2/local/search/address.json?query=' + keyword + '&size=10&page=' + curpage,
	    	headers: {'Authorization': 'KakaoAK 836e538f9a81b71509554edccc4ebbfe'},	type: 'GET',
		}).done(function(data1) {
			$("#search-result").empty();
			var html = "";
			if(data1.documents.length > 0){
// 				console.log(data1.documents[0]);
				header.total_page = data1.meta.pageable_count /10 +1;
				for(var i=0; i<data1.documents.length; i++) { // 이걸 10으로하면?
					html += "<li>";
					html += "<a class=\"search-table-row\" style=\"cursor:pointer;\">";
					html += "<input type=\"hidden\" name='x' class='x' value='"+data1.documents[i].x+"' />"; // X 좌표
					html += "<input type=\"hidden\" name='y' class='y' value='"+data1.documents[i].y+"' />"; // Y 좌표
					html += "<input type=\"hidden\" name='address_name' value='"+data1.documents[i].address_name+"' />"; // 주소
					if(data1.documents[i].road_address != null) {
						html += "<p class=\"searchNm\" style='word-break: break-all;white-space: normal ;' >"+data1.documents[i].road_address.address_name+'&nbsp;'+data1.documents[i].road_address.building_name+"</p>"; // 도로명 주소
					}
					html += "<p class=\"searchNm\" style='word-break: break-all;white-space: normal ;' >"+data1.documents[i].address_name+"</p>"; // 지번 주소
					html += "</a>";
					html += "</li>";	
				}
				$("#search-result").html(html);
				endSearchProcess(data1);
		    	loading_close();
			} else {
				daumRestApi_keyword(keyword, curpage, function(data){
					if (data.documents.length > 0) {
						endSearchProcess(data);
					} else {
						endSearchProcess();
					}
					loading_close();
				});
			}
		});	
	}
}
// 다음 rest api  함수
function daumRestApi_keyword(keyword, curpage, fn) {
	$.ajax({url: 'https://dapi.kakao.com/v2/local/search/keyword.json?query=' + keyword + '&size=10&page=' + curpage,
    	headers: {'Authorization': 'KakaoAK 836e538f9a81b71509554edccc4ebbfe'},	type: 'GET',
	}).done(function(data) {
		$("#search-result").empty();
		var html = "";
		if(data.documents.length > 0){
// 			console.log(data.documents[0]);
			header.total_page = data.meta.pageable_count /10 +1;
			for(var i=0; i<data.documents.length; i++) { // 이걸 10으로하면?
				html += "<li>";
				html += "<a class=\"search-table-row\" style=\"cursor:pointer;\">";
				html += "<input type=\"hidden\" name='x' class='x' value='"+data.documents[i].x+"' />"; // X 좌표
				html += "<input type=\"hidden\" name='y' class='y' value='"+data.documents[i].y+"' />"; // Y 좌표
				html += "<input type=\"hidden\" name='address_name' value='"+data.documents[i].address_name+"' />"; // 주소
				html += "<p class=\"searchNm\" style='word-break: break-all;white-space: normal ;' >"+data.documents[i].road_address_name+'&nbsp;'+data.documents[i].place_name+"</p>"; // 도로명 주소
				html += "<p class=\"searchNm\" style='word-break: break-all;white-space: normal ;' >"+data.documents[i].address_name+"</p>"; // 지번 주소
				html += "</a>";
				html += "</li>";	
			}
			$("#search-result").html(html);
			if(fn != null) fn(data);
		} else if (data.documents.length == 0 && keyword.startsWith("산")) {
			san_jibun(keyword, curpage, function(){
				endSearchProcess();
				if(fn != null) fn(data);
			});
		} else {
			html += "<li>";
			html += "<a href=\"#\">";
			html += '<span style=\"padding-left: 10px;\"><spring:message code="search.empty.msg"/></span>';
			html += "</a>";
			html += "</li>";
			$("#search-result").html(html);
			if(fn != null) fn(data);
		}
	});
}
// 산지번 검색  함수
function san_jibun(keyword,curpage,fn) {
	var flag = false;
	if(!keyword.includes('산')) {
		if(fn != null) fn();
		return;
	}
	keyword = keyword.replace(/(\s*)/g,""); // 공백제거
	if( keyword.includes('리') ) {
		keyword = keyword.split('리');
		keyword[0] += "리"
		flag = true;
	} else if (keyword.includes('동')) {
		keyword = keyword.split('동');
		keyword[0] += "동"
		flag = true;
	} else if (keyword.includes('읍')) {
		keyword = keyword.split('읍');
		keyword[0] += "읍"
		flag = true;
	} else if (keyword.includes('면')) {
		keyword = keyword.split('면');
		keyword[0] += "면"
		flag = true;
	} 
	var id_code_nm;
	var lnm_lndcgr_smbol;
	
	if(flag) {
		id_code_nm = '%'+keyword[0]+'%';
		lnm_lndcgr_smbol = keyword[1]+'%';
	} else { 
		id_code_nm = "";
		lnm_lndcgr_smbol = keyword+'%';
	}
	var html = "";
	$.ajax({type: "post", url : "./qry",	dataType : 'json', async: false,
	    data : 'cmd=SELECT_PNU_FOR_LANDINFO&id_code_nm='+id_code_nm+'&lnm_lndcgr_smbol='+lnm_lndcgr_smbol+'&curpage='+curpage,
	    success : function (response) {
	    	var length = response.body.result.features.length;
	    	var cnt = response.body.resultCnt.cnt;
	    	
	    	if ( length == 0 && cnt != 0 ) {
				jQuery.alert("검색결과가 너무 많습니다. 지역명과 같이 검색해 주세요. <br>" + 
						"ex) 손곡리 산 6-1");
			} else if (length > 0){
				header.total_page = cnt /10 +1;
	    		for(var i=0; i<length; i++) {
		    		
	    			var addr = response.body.result.features[i].properties.id_code_nm;
		    		var jibun = response.body.result.features[i].properties.mnnm;
		    		var lndcgrNm = response.body.result.features[i].properties.lndcgr_nm;
		    		var pnu =  response.body.result.features[i].properties.pnu;
		    		
					html += "<li>";
					html += "<a class=\"search-table-row\" style=\"cursor:pointer;\">";
					html += "<input type=\"hidden\" name='pnu' class='pnu' value='"+pnu+"' />"; // X 좌표
					html += "<p class=\"searchNm\" >"+addr + '&nbsp;' + jibun + '&nbsp;' + lndcgrNm +"</p>"; // 도로명 주소
					html += "</a>";
					html += "</li>";	
				}
	    		$("#search-result").html(html);
	    	} else if ( length == 0 ) {
	    		html += "<li>";
				html += "<a href=\"#\">";
				html += '<span style=\"padding-left: 10px;\"><spring:message code="search.empty.msg"/></span>';
				html += "</a>";
				html += "</li>";
				$("#search-result").html(html);
	    	}
	    	if(fn != null) fn();
	    }, error: function(){
	    	console.log( "SELECT_LNM_LNDCGR_ERROR" );
	    	if(fn != null) fn();
	    }
	});
}
// 시도 시군구 검색결과후를 처리하는 함수
function endMySearchProcess(data) {
	var cur_page = $("#form_roadaddr").children("input[name=currentPage]").val()*1;
	var pageSize = 10;
	
	var htmlStr = "";
	htmlStr += "<ul class=\"pop-table-pagination\">";
	var cur_page_group_index = (cur_page - 1) / pageSize;
	var end_page_group_index = (header.total_page - 1) / pageSize;
	
	if(cur_page_group_index > 0){
		htmlStr += "<li class=\"active\"><a href=\"#\" class=\"btn-asPaging-first\"><span style=\"display:none;\">1</span></a></a></li>";
	}
	
	var start_page = ((cur_page - 1 ) / pageSize) * pageSize + 1;
	var end_page = 0;		
	if(header.total_page <= 10){
		end_page = header.total_page;
	}else{
		end_page = start_page + (pageSize-1);
		if(header.total_page < end_page){
			end_page = header.total_page;
		}
	}
	
	if(cur_page > 1){
		var prev_page = cur_page - 1;
		htmlStr += "<li><a href=\"javascript:getSggEmdRi("+prev_page+")\" class=\"btn-asPaging-prev\"><span style=\"display:none;\">"+prev_page+"</span></a></li>";
	}
	for(var i = 1; i< end_page; i++) {
		if(i == cur_page){
			if(i == end_page){
				htmlStr += "<li class=\"active\"><a href=\"javascript:getSggEmdRi("+i+")\"><span>"+i+"</span></a></li>";
			}else{
				htmlStr += "<li class=\"active\"><a href=\"javascript:getSggEmdRi("+i+")\"><span>"+i+"</span></a></li>";
			}
		}else{
			if(i == end_page){
				htmlStr += "<li><a href=\"javascript:getSggEmdRi("+i+")\"><span>"+i+"</span></a></li>";
			}else{
				htmlStr += "<li><a href=\"javascript:getSggEmdRi("+i+")\"><span>"+i+"</span></a></li>";
			}
		}
	}

	// 다음 페이지 --> 현재 페이지 < 전체 페이지
	if(cur_page < header.total_page){
		var next_page = cur_page + 1;
		htmlStr += "<li><a href=\"javascript:getSggEmdRi("+next_page+")\" class=\"btn-asPaging-next\"><span style=\"display:none;\">"+next_page+"</span></a></li>";
	}
	
	// 마지막 페이지
	if(end_page_group_index != cur_page_group_index){
		htmlStr += "<li><a href=\"javascript:getSggEmdRi("+header.total_page+")\" class=\"btn-asPaging-last\"><span style=\"display:none;\">"+header.total_page+"</span></a></li>";
	}	
	htmlStr += "</ul>";
// 	console.log(htmlStr);
	$("#search-pagination").html(htmlStr);
	if($('.side-result').is(':hidden')) {
		$(".side-result").show();
	}
// 	$("#search-result").children("li").addClass("active");
	$(".search-table-row").click(function(e){
// 		$("#search-result").children("li").removeClass("active");
		$(".side-result").hide();
		loading();
		var cd = $(e.currentTarget).find("input[name=where_cd]").val();
		$.ajax({ type: "post", url : "./qry", dataType : 'json',
		    data : 'cmd=SELECT_KEYWORD_SEARCH&cd='+cd,
		    success : function (response) {
		    	if( response.body.result.features[0] != null) {
					workArea2Json.clearLayers();
					workArea2Json.addData(response.body.result.features[0]);
					workArea2Json.setStyle(workArea2Style);
			
					mymap.map.addLayer(workArea2Json);
					fitBounds(workArea2Json.getBounds());
		    	}
		    	loading_close();
		    },error: function(xhr,status, error){
				loading_close();
		    }
		});				
	});
}
// 다음 API 검색결과후를 처리하는 함수
function endSearchProcess(data) {
	var cur_page = $("#form_roadaddr").children("input[name=currentPage]").val()*1;
	var pageSize = 10;
	
	var htmlStr = "";
	htmlStr += "<ul class=\"pop-table-pagination\">";
	var cur_page_group_index = (cur_page - 1) / pageSize;
	var end_page_group_index = (header.total_page - 1) / pageSize;
	
	if(cur_page_group_index > 0){
		htmlStr += "<li class=\"active\"><a href=\"#\" class=\"btn-asPaging-first\"><span style=\"display:none;\">1</span></a></a></li>";
	}
	
	var start_page = ((cur_page - 1 ) / pageSize) * pageSize + 1;
	var end_page = 0;		
	if(header.total_page <= 10){
		end_page = header.total_page;
	}else{
		end_page = start_page + (pageSize-1);
		if(header.total_page < end_page){
			end_page = header.total_page;
		}
	}
	
	if(cur_page > 1){
		var prev_page = cur_page - 1;
		htmlStr += "<li><a href=\"javascript:daumAdrrAPI("+prev_page+")\" class=\"btn-asPaging-prev\"><span style=\"display:none;\">"+prev_page+"</span></a></li>";
	}
	for(var i = 1; i< end_page; i++) {
		if(i == cur_page){
			if(i == end_page){
				htmlStr += "<li class=\"active\"><a href=\"javascript:daumAdrrAPI("+i+")\"><span>"+i+"</span></a></li>";
			}else{
				htmlStr += "<li class=\"active\"><a href=\"javascript:daumAdrrAPI("+i+")\"><span>"+i+"</span></a></li>";
			}
		}else{
			if(i == end_page){
				htmlStr += "<li><a href=\"javascript:daumAdrrAPI("+i+")\"><span>"+i+"</span></a></li>";
			}else{
				htmlStr += "<li><a href=\"javascript:daumAdrrAPI("+i+")\"><span>"+i+"</span></a></li>";
			}
		}
	}

	// 다음 페이지 --> 현재 페이지 < 전체 페이지
	if(cur_page < header.total_page){
		var next_page = cur_page + 1;
		htmlStr += "<li><a href=\"javascript:daumAdrrAPI("+next_page+")\" class=\"btn-asPaging-next\"><span style=\"display:none;\">"+next_page+"</span></a></li>";
	}
	
	// 마지막 페이지
	if(end_page_group_index != cur_page_group_index){
		htmlStr += "<li><a href=\"javascript:daumAdrrAPI("+header.total_page+")\" class=\"btn-asPaging-last\"><span style=\"display:none;\">"+header.total_page+"</span></a></li>";
	}	
	htmlStr += "</ul>";
	
	$("#search-pagination").html(htmlStr);
	
// 	if($('.side-result').is(':hidden')) {
		$(".side-result").show();
// 	}
	
	$(".search-table-row").click(function(e){
		$("#search-result").children("li").removeClass("active");
		if (data!= null && data.documents.length > 0) {
			var xx = $(e.currentTarget).find("input[name=x]").val();
			var yy = $(e.currentTarget).find("input[name=y]").val();
			var bunjis = ($(e.currentTarget).find("input[name=address_name]").val()+"").split(" "); //data.documents[0].address_name.split(" ");
			console.log(bunjis);
			var geostr = "POINT(" + xx + " " + yy + ")";
			mymap.map.setView([yy, xx], 19);
			loading();
			$.ajax({ type: "post", url : "./qry", dataType : 'json',
			    data : 'cmd=POINT_IN_POLYGON&geomString=SRID=4326;'+geostr,
			    success : function (response) {
					for(var i = 0;i<response.body.result.length;i++) {
						var fd = response.body.result[i];
						//console.log(fd.properties.lnm_lndcgr_smbol +":" + bunjis[bunjis.length-1]);
						var str = 	fd.properties.lnm_lndcgr_smbol;
						console.log("비교 : " + str.substring(0,str.length-1).trim() +" < == >" + bunjis[bunjis.length-1]);
						if(str.substring(0,str.length-1).trim() == bunjis[bunjis.length-1]) {
							workArea2[0] = fd;
							workArea2Json.clearLayers();
							workArea2Json.addData(workArea2);
							workArea2Json.setStyle(workArea2Style);
							mymap.map.addLayer(workArea2Json);
							fitBounds(workArea2Json.getBounds());
							loading_close();
							return;
						}
					}
					for(var i = 0;i<response.body.result.length;i++) {
						var fd = response.body.result[i];
						//console.log(fd.properties.lnm_lndcgr_smbol +":" + bunjis[bunjis.length-1]);
// 						console.log(str.substring(0,str.length-1).trim() +":" + bunjis[bunjis.length-1]);
						var str = fd.properties.lnm_lndcgr_smbol;
						if(str.substring(1,str.length-1).trim() == bunjis[bunjis.length-1]) {
// 						if(fd.properties.lnm_lndcgr_smbol.indexOf(bunjis[bunjis.length-1]) > -1) {
// 							console.log(fd);
							workArea2[0] = fd;
							workArea2Json.clearLayers();
							workArea2Json.addData(workArea2);
							workArea2Json.setStyle(workArea2Style);
							mymap.map.addLayer(workArea2Json);
							fitBounds(workArea2Json.getBounds());
							loading_close();
							return;
						}
					}
					loading_close();
			    },error: function(xhr,status, error){
					console.log(xhr);
					loading_close();
			    }
			});				
		} else if (data.documents.length == 0) {
			var pnu = $(e.currentTarget).find("input[name=pnu]").val();
			getAddrXY(pnu);
						
		} else {
			alert("data.documents.length : " + data.documents.length);
		}
	});
}
// 지번 좌표 찾아서 지도이동하기
function getAddrXY(pnu, fn) {
	console.log("PNU : " + pnu);
	$.ajax({type: "post", url : "./qry",	dataType : 'json',
	    data : 'cmd=SELECT_GEOM&pnu='+pnu,
	    success : function (response) {
	    	//사용자데이터 초기화
			clearWorkData(); // => common.js
			permissionMenu(); // => common.js
	    	if( response.body.result.features[0] != null) {
		    	var point = response.body.result.features[0].properties.point_;
		    	var polygon = [];
		    	
		    	for(var i = 0; i<response.body.result.features[0].geometry.coordinates[0][0].length; i++) {
		    		polygon[i] = response.body.result.features[0].geometry.coordinates[0][0][i];
		    	}
	
				//var xy = point.substring(6, (point.length-1));
				//var splitXY = xy.split(" ");
				//var lat = splitXY[1]; var lng = splitXY[0];
	
				workArea2[0]["geometry"] = { // => userProject.js
						"type": "MultiPolygon",
						"coordinates" : [[polygon]]
				};
				
// 				console.log("POLYGON XY : " + polygon);
				workArea2Json.clearLayers();
				workArea2Json.addData(workArea2);
				workArea2Json.setStyle(workArea2Style);
		
				mymap.map.addLayer(workArea2Json);
				mymap.map.setView(workArea2Json.getBounds().getCenter(), 18);
		    } else {
		    	$.alert("위치를 찾을수 없습니다.");
				workArea2Json.clearLayers();
				mymap.map.setView([37, 128], defaultLvl);
		    }
	    	if(fn != null) fn();
	    	loading_close();
	    }, error: function(){
	    	if(fn != null) fn("SELECT_GEOM_ERROR");
	    }
	});
}


function enterSearch(btrue) {
	var evt_code = (window.netscape) ? ev.which : event.keyCode;
	var keyword = $("#form_roadaddr").children("input[name=keyword]").val();
	if (evt_code == 13 || (btrue!=null && btrue)) {
		event.keyCode = 0;  
 		getSggEmdRi(); //jsonp사용시 enter검색
	}
	event.stopPropagation();
}

/*
 * 기본정보화면 띄우기
 */
function menuSelect(menu) {
	if(!$("#Slide_contents").is(':visible')){
		$("#Slide_contents").show();
		mapResize(); // common.js
	}
	$(".menu_list").hide();
	activeTab1 = menu; //=>side-panel.jsp
	activeMenu(); //=>side-panel.jsp
}

/* Top User Layer */

// $('.user_wrap').click(function(event) {
// 	closeMenu('.my_info');
// 	$('.my_info').toggle();
// 	event.stopPropagation();
// });

$('.ico_arrow2').click(function(event) {
	closeMenu('.my_info');
	$('.my_info').toggle();
	event.stopPropagation();
});

$('.show ico_user').click(function(event) {
	closeMenu('.my_info');
	$('.my_info').toggle();
	event.stopPropagation();
});



/* Top File Layer */ 
$('.smenu_top.file').click(function(event) {
	closeMenu('.file_menu');
	$('.file_menu').toggle();
	event.stopPropagation();
});

/* Top Tool Layer */
$('.smenu_top.tool').click(function(event) {
	closeMenu('.tool_menu');
	$('.tool_menu').toggle();
	event.stopPropagation();
});



// 맵위의 거리, 면적측정결과 초기화 (화면에서 삭제)
function initDrawObj() {

	if(mymap.figure.distance.handler._enabled){
		mymap.figure.distance.handler.disable();
		//figure.distance.handler.clearLayers();
		$(".btn_ctr_ruler").removeClass("active");
	}
	if(mymap.figure.area.handler._enabled){
		mymap.figure.area.handler.disable();
		//figure.area.handler.clearLayers();
		$(".btn_ctr_area").removeClass("active");
	}
	removeLayer(workArea2Json);
	mymap.map.drawItem.clearLayers();
	
	$(".leaflet-tooltip.my-label-distance").remove();
	$(".leaflet-tooltip.area-value").remove();
	
	// Clear Edit Object
	ClearEditStatus();
}


// dxf 파일 불러오기
function loadDxf() {
	$("#file-field").val("");
	$("#file-field").click(); //accept=".jpg, .png, .jpeg, .gif, .bmp, .tif, .tiff|image/*"
// 	loadJuso(); //구역계삭제 > 검색 > 구역계선택 시 주소테이블 Destroy현상
}
// 	var change_cnt = 0;
$("#file-field").change(function() {
// 	if(change_cnt > 0) return;
// 	change_cnt++;
	var fileitem;
	if(isIE()) {
		if(this.files.item.size() < 1) return false;		
		fileitem = this.files.item(0);
		console.log('size: '+this.files.item.size());
	} else {
		if(this.files.length < 1) return false;		
		fileitem = this.files[0];
		console.log('length: '+this.files.length);
	}
	if(fileitem.name.lastIndexOf('.dxf') > -1 || fileitem.name.lastIndexOf('.zip') > -1) {
		var $sel = $('<select style="font-size:13px;">');
		$(projArr).each(function() { // projArr => common.js
			$sel.append($("<option>").attr('value',this.val).text(this.text));
		});
		$.confirm($sel,'<spring:message code="epsg_confirm"/>', function(bYes, epsgcode) {
			if(bYes) {
				loading("Loading....");
				initWork(true); // 멀티 폴리곤(다중구역계) 분석서버에서 지원 안함
				workArea2Json.clearLayers();
				ClearEditStatus(); // => cm.edit.function.js
				EndEdit(); // => cm.edit.function.js
				javascript:mapCtrlCursor('ico_tool_move',0);
				var epsgsou = new Proj4js.Proj("EPSG:"+$sel.val()); //.defs["EPSG:"+$sel.val()]; //
				var gjson_coords = [];
				work.area.array = [];
				var reader = new FileReader();
				if(fileitem.name.lastIndexOf('.zip') > -1) {
					reader.readAsArrayBuffer(fileitem);
					reader.onload = function(e) {
						shp(e.target.result).then(function(geojson){
							try {
								if(geojson.features[0].geometry.type == "Polygon") {
									var gj = '{"type":"MultiPolygon","coordinates":'+'['+JSON.stringify(geojson.features[0].geometry.coordinates)+']'+'}';
									geojson.features[0].geometry = JSON.parse(gj);
								}
								var polygon2 = null;
								for(var i = 0;i<geojson.features[0].geometry.coordinates[0].length;i++) {
									for(var j = 0;j<geojson.features[0].geometry.coordinates[0][i].length;j++) {
										var coordi = geojson.features[0].geometry.coordinates[0][i][j];
										var goords = [];
										goords.push([]);
										$.each(coordi, function() {
											if(epsgsou.srsProjNumber != def_epsg.srsProjNumber) {
										        var pointDest = Proj4js.transform(epsgsou, def_epsg, new Proj4js.Point(this[0] + ',' +this[1]));
										        goords[0].push([pointDest.x,pointDest.y]);
											} else {
												goords[0].push([this[0],this[1]]);
											}
										});
										var pos = goords[0].length-1;
										if(polygon2 != null) {
											if(polygonInPolygon(goords[0], polygon2)) {
												gjson_coords[gjson_coords.length-1].push(goords[0]);
											} else {
												polygon2 = goords[0];
												gjson_coords.push(goords);
											}
										} else {
											polygon2 = goords[0];
											gjson_coords.push(goords);
										}
									}
								}
								var temparea = newWorkArea(gjson_coords,"<spring:message code='work_root'/>"); // + work.area.num); // newWorkArea() => userProject.js
								console.log(temparea);
								temparea.properties.isVertex = 1;
								work.area.array.push(temparea);
								rebuildWorkArea(function(bok) {
									if(bok) {
										initUserTree(); // => layer-panel.jsp
										$('.layer').show(); // => layer-panel.jsp
										activeLayer("layer_tab2");  // => layer-panel.jsp
										workAreaRefresh();
									} else
										loading_close();
								}); // => common.js
							} catch(e) {
			 					loading_close();
								$.alert("File Open Fail.");
							}
						});
					}
				} else {
					reader.readAsText(fileitem);
					reader.onload = function(e) {
						try {
							var fileText = e.target.result;
							var parser = new DxfParser();
							var dxf = null;
							try {
								dxf = parser.parseSync(fileText);
							} catch(err) {
								$("#file-field").val("");
								$.alert('dxf Format <spring:message code="fail_loadFile"/>');
								console.error(err.stack);
								return true;
							}
							var polygon2 = null;
							for(var i = 0;i<dxf.entities.length;i++) {
								var goords = [];
								goords.push([]);
								$.each(dxf.entities[i].vertices, function() {
									if(epsgsou.srsProjNumber != def_epsg.srsProjNumber) {
								        var pointDest = Proj4js.transform(epsgsou, def_epsg, new Proj4js.Point(this.x + ',' +this.y));
								        goords[0].push([pointDest.x,pointDest.y]);
									} else {
										goords[0].push([this.x,this.y]);
									}
								});
								var pos = goords[0].length-1;
								if(goords[0][0][0] != goords[0][pos][0] || goords[0][0][1] != goords[0][pos][1]){
// 									console.log(goords[0][0][0]+":"+ goords[0][0][1]);
									goords[0].push([goords[0][0][0], goords[0][0][1]]);
								}
								if(polygon2 != null) {
									if(polygonInPolygon(goords[0], polygon2)) {
										gjson_coords[gjson_coords.length-1].push(goords[0]);
									} else {
										polygon2 = goords[0];
										gjson_coords.push(goords);
									}
								} else {
									polygon2 = goords[0];
									gjson_coords.push(goords);
								}
							}
// 							console.log(JSON.stringify(gjson_coords));
							var temparea = newWorkArea(gjson_coords,"<spring:message code='work_root'/>"); // + work.area.num); // newWorkArea() => userProject.js
							console.log(temparea);
							temparea.properties.isVertex = 1;
							work.area.array.push(temparea);
							rebuildWorkArea(function(bok) {
								if(bok) {
									initUserTree(); // => layer-panel.jsp
									$('.layer').show(); // => layer-panel.jsp
									activeLayer("layer_tab2");  // => layer-panel.jsp
									workAreaRefresh();
								} else
									loading_close();
							}); // => common.js
						} catch(e) {
		 					loading_close();
							$.alert("File Open Fail.");
						}
					};
				}
				
				$("#file-field").val("");
			} else {
				$("#file-field").val("");
			}
		});
	} else {
		$("#file-field").val("");
		$.alert('<spring:message code="not_supported_loadFile"/>');
		return;
	}
});

//로그아웃 시
function logOut(){

	$.ajax({ type: "post", url : "./qry", async: false,
		data : 'cmd=SESSION_DESTROY',
		success : function () {
			console.log( "DESTROY SESSION ");						
			alert('로그아웃 되었습니다.');
		},
		error: function(xhr,status, error){
			alert("세션제거 실패");
		}
	});
		//document.location.href = "/";
		location.reload();
}

$('.top_user_info').click(function() {
	var userNm = $('.user_name')[0].innerHTML;

	if ( userNm == "Login" )  {
		document.location.href = "/login.jsp";	
	} else {
		closeMenu('.my_info');
		$('.my_info').toggle();
		event.stopPropagation();
	}
	
});

function goIntro() {
	document.location.href = '/';	
}

//프로젝트 불러오기
function loadProject() {
	var user_id = work.user_id;
// 	console.log( "USER_ID : " + user_id );
	
	$.ajax({ type: "post", url : "./qry",
		data : 'cmd=SELECT_PROJECT&user_id='+user_id,
		success : function (response) {
// 			console.log("RESPONSE : " + response);
			drawLoadProject(response); // 불러오기
		},
		error: function(xhr,status, error){
			alert("error ! at loadProject()");
		}
	});

}

// 작업 목록을 불러오는 함수
function drawLoadProject(response) {
	var title = '<spring:message code="project.title"/>';
	if( $( '#alertBox' ) ) { //초기화
		$( 'div' ).remove( '#alertBox' );
	}
	var $alertBox = $.parseHTML( '<div id="alertBox"></div>' );
 	$( "body" ).append($alertBox);
  	$($alertBox).css("z-index",999);
  	$($alertBox).dialog({
		open: $($alertBox).load("./popup/projectlist", function() {
			reload_projectlist(response);
		}), // jquery Include?
		title: title, moveToTop: true, autoOpen: true, modal: true,	resizable: true, width: "800px",
		buttons: {
			OK: function() {
				if(project_selectIdx > -1) {
					var datas = response.body.result[project_selectIdx];
					$.ajax({ type: "post", url : "./qry",
						data : 'cmd=SELECT_PROJECT&all=y&uuid='+datas.wrk_uuid,
						success : function (response) {
							removeGeoJsonLayerAll();
				 			removeLayer(workAreaJson);
				 			workArea = [];
				 			clearWorkData();
//		 		 			console.log(response.body.result[project_selectIdx]);
				 			var wrk_body = response.body.result[0].wrk_body;
				 			wrk_body = decodeURI(wrk_body).replace(/\+/g," ");
				 			work = JSON.parse(wrk_body); 
				 			work.building.attrs = [];
				 			$.each(work.building.array, function(key, value) {
				 				work.building.attrs.push(value.properties);
				 			});
				 			$("#work_des").val(response.body.result[0].wrk_des);
				 			//---------------------------------------
				 			drawJson = JSON.parse(JSON.stringify(work.where.draw));
				 			if( pointLayer != null ) mymap.map.removeLayer( pointLayer );
				 			if( polyLayer != null ) mymap.map.removeLayer( polyLayer );
				 			if( labelLayer != null ) mymap.map.removeLayer( labelLayer );

				 			pointLayer = L.geoJson( drawJson.point, {
				 			    pointToLayer: function ( feature, latlng) {
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
				 			//---------------------------------------
				 			bStarted = false;
				 			reloadWork(); // => layer-panel.jsp
						},
						error: function(xhr,status, error){
							alert("error ! at loadProject()");
						}
					});
				}
				$($alertBox).dialog("close");
			}
		}
	});	
}

// 프로젝트 다른이름으로 저장
function saveAsProject() {
	
	if(work.area.array.length == 0) {
		jQuery.alert( "구역계가 설정되어 있지 않습니다. 구역계를 먼저 설정해 주세요." );
	} else if ($('#work_des').val() == "") {
		jQuery.alert( "작업내용을 입력해 주세요." );
	} else {
		$('#work_title').remove();
		var title = "다른 이름으로 저장";
		var $msg = $('<input type="text" class="inp_memo" id="work_title" placeholder="저장할 파일명을 입력해 주세요." title="저장할 파일명을 입력해 주세요.">');
				
		$.confirm($msg, title, function(yes, no) {
			
			if(yes) { // yes 클릭
				var wrk_uuid = work.uuid;
				var flag = selectExProject(wrk_uuid);
				
				console.log( "flag : " + flag + ", type : " + typeof flag );
				if( flag ) { 
// 					console.log( "기존데이터 o => 기존 데이터에 새UUID로 같은내용 엎어치고" );
					var owrk_uuid = work.uuid;
					var nwrk_uuid = generateUUID();
				
					console.log( "OLD UUID : " + owrk_uuid + ", NEW UUID : " + nwrk_uuid );
					$.ajax({ type: "post", url : "./qry", async:false,
						data : 'cmd=INSERT_EX_PROJECT&nwrk_uuid='+nwrk_uuid+"&owrk_uuid="+owrk_uuid,
						success : function () {
							console.log("기존 정보 UPDATE")
						},
						error: function(xhr,status, error){
							alert( "error ! at saveAsProject()" );
						}
					});
					
					var wrk_nm = $('#work_title').val();
					var wrk_des = work.des = $('#work_des').val();
					var user_id = work.user_id;
					
					var json2String = JSON.stringify(work, replacer);
					var wrk_body = encodeURI(json2String);

					$.ajax({ type: "post", url : "./qry", async:false,
						data : 'cmd=INSERT_NEW_PROJECT&wrk_uuid='+owrk_uuid+"&wrk_nm="+wrk_nm+"&wrk_des="+wrk_des+"&wrk_body="+wrk_body+"&user_id="+user_id,
						success : function () {
							alert("저장 완료");
							
							work.title = wrk_nm;
							renameLayer(work.uuid, work.title);
						},
						error: function(xhr,status, error){
							alert( "error ! at saveAsProject()" );
						}
					});
					
				} else { 
					var wrk_uuid = work.uuid;
					var wrk_nm = $( '#work_title' ).val();
					var wrk_des = $( '#work_des' ).val();
					var user_id = work.user_id;
					
					var json2String = JSON.stringify(work, replacer);
					var wrk_body = encodeURI(json2String); 

					$.ajax({ type: "post", url : "./qry",
						data : 'cmd=INSERT_NEW_PROJECT&wrk_uuid='+wrk_uuid+"&wrk_nm="+wrk_nm+"&wrk_des="+wrk_des+"&wrk_body="+wrk_body+"&user_id="+user_id,
						success : function () {
							alert("저장 완료");
							
							work.title = wrk_nm;
							renameLayer(work.uuid, work.title);
						},
						error: function(xhr,status, error){
							alert("error ! at saveAsProject()");
						}
					});
				} 
			} else { // no 클릭
				console.log('NO : ' + no);
			}
		});
	}
}
//새로시작 
function initWork(bnew){
	if(bnew != null && bnew) {
		work.land.pnulist = ""; // 초기화
	}
	
	removeLayer(workArea2Json);
	removeLayer(workAreaJson);
	if(delLJSON != null) removeLayer(delLJSON);
	if( pointLayer != null ) mymap.map.removeLayer( pointLayer );
	if( polyLayer != null ) mymap.map.removeLayer( polyLayer );
	if( labelLayer != null ) mymap.map.removeLayer( labelLayer );
	workArea = [];
	$("#work_des").val("");
	removeGeoJsonLayerAll();
	if ($.jstree.reference($('#layer_tab2'))) {
		$('#layer_tab2').jstree().delete_node($('#layer_tab2').jstree().get_json());
	}
	bStarted = true;
	if($(".map_draw2").is(':visible')) {
		$( '.draw_location_close' ).click();
	}
	if($(".workarea_map_draw").is(':visible')) {
// 		workarea_edit_array = [];
// 		editPnuList = [];
// 		workarea_edit_sel_objs = [];
		removeLayer(workarea_edit_ljson);
		if(editMode == 11) {
		} else {
			if(workarea_edit_uuid != null)
				$("#"+workarea_edit_uuid+" >a").css("background","rgba(0, 0, 0, 0) none repeat scroll 0% 0% / auto padding-box border-box"); 
			mymap.map.addLayer(workAreaJson);
			workarea_edit_uuid = null;
		}
		removeLayer(editLayer);
		$('.leaflet-container').css('cursor','');
		SetSnapMode( 0 ); // => cm.edit.function.js
		$(".workarea_map_draw").hide();
		workarea_edit_sel_objs = [];
		if(workarea_edit_sel_ljson != null) removeLayer(workarea_edit_sel_ljson);
		workarea_edit_init(); //=> main.jsp
		toolbar_set_active("ico_tool_move"); // => toolbar.jsp
	}
	clearWorkData(); // => layer-panel.jsp
	initUserWork(); // => userProject.js
//	initUserTree(); // => layer-panel.jsp
	initDrawObj(); // => header.jsp
	activeTab1 = "tab1"; //=>side-panel.jsp
	activeTab = "tab1_cont1";  //=>side-panel.jsp
	permissionMenu();
	activeMenu();  //=>side-panel.jsp
	applyMap();
}
</script>
</body>
</html>