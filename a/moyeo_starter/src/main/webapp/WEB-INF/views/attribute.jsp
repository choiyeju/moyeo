<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>
td {
   mso-number-format:"\@";
}


</style>
</head>
<body>
	<!-- Bottom Slide Contents -->
	<div id="Slide_contents_Bottom">
		<div class="att_header">
			<div class="att_slt">
				<span class="att_title" id="att_title1"><spring:message code="att_title"/></span>
			</div>
			<div class="stit_btn">
			<button type="button" id="att_export" class="att_btn_info"><spring:message code="export.csv"/></button><button type="button" id="att_close" class="att_btn_info"><spring:message code="close"/></button>
			</div>
		</div>
		<div class="att_cont">
			<div class="att_cont_scr">
				<table class ="att_tbl_row" id="attributeDataTable">
					<tr><td><spring:message code="emptyTable"/></td></tr>
				</table>
			</div>
		</div>
		<iframe id="excelArea" style="display:none"></iframe>
	</div>
	<!-- //Bottom Slide Contents -->
 <script type="text/javascript">
 var m_bEmptyTable = true; //데이터 유무
 var att_title = '<spring:message code="att_title"/>';
 $("#att_close").click(function(e){
	 closeAttribute();
 });
 $("#att_export").click(function(e){
	if(m_bEmptyTable){
		alert('<spring:message code="emptyTable"/>');
	}else{
		csvExport();
	}
 });
 /*
 * 지도화면 크기 변경 함수
 */
 function attMapResize() {
 	if($("#Slide_contents_Bottom").is(':visible')){ // 사이드 패널 보일때
 		$("#map_wrap").css("height", "60%");
 		mymap.map.invalidateSize(true);
 	}else{ // 사이트 패널 안보일때
 		$("#map_wrap").css("height", "100%");
 		mymap.map.invalidateSize(true);
 	}
 }
 
 //속성 닫기
function closeAttribute(){
	 $(".attribute-panel").css( "display" ,  "none" );
	 $( "#Slide_contents_Bottom" ).css( "display" ,  "none" );
	 $('#attributeDataTable').empty();
		attMapResize();
	    $("#att_title1").text(att_title);
		//console.log("closeAttribute");
}

//속성 데이터 세팅
function loadAttribute(json){
	var selector = '#attributeDataTable';
	$(selector).empty();
	 if (typeof json == 'undefined'||json == null||json.length==0){
		 m_bEmptyTable = true;
		 $(selector).append('<tbody><tr><td><spring:message code="emptyTable"/></td></tr></tbody>');
		 return;
	 }
	 m_bEmptyTable = false;	 
	 setTimeout(function(){
	 	buildHtmlTable(json,selector);
	 });	 
}

// json -> table 
function buildHtmlTable(json,selector) {
  var columns = addAllColumnHeaders(json, selector);

  for (var i = 0; i < json.length; i++) {
    var rowHash = json[i].properties;
    var row$ = $('<tr/>');
    if (typeof rowHash == 'undefined'){
    	rowHash = json[i];
    }
    for (var colIndex = 0; colIndex < columns.length; colIndex++) {
    	var colNm = columns[colIndex];
      	var cellValue = rowHash[colNm];
      	if (typeof cellValue == 'undefined'||cellValue == null) cellValue = "";
      	if(colNm.toUpperCase() == 'PNU'){
    	  	row$.append($('<td/>').html("'"+cellValue+"'"));  
//     	  	row$.append($("<td/>").html(cellValue));  
      	}else{
    	  	row$.append($('<td/>').html(cellValue));
      	}
       //style='mso-number-format: "@";'
    	}
    	var tbody$ = $('<tbody/>');
    	tbody$.append(row$);
    	$(selector).append(tbody$);
  	}
}

// columns 저장(all records)
function addAllColumnHeaders(json, selector) {
  var columnSet = [];
  var headerTr$ = $('<tr/>');

  for (var i = 0; i < json.length; i++) {
    var rowHash = json[i].properties;
    if (typeof rowHash == 'undefined'){
    	rowHash = json[i];
    }
    for (var key in rowHash) {
      if ($.inArray(key, columnSet) == -1) {
        columnSet.push(key);
        headerTr$.append($('<th/>').html(key));
      }
    }
  }
  var thead$ = $('<thead/>');
  thead$.append(headerTr$);
  $(selector).append(thead$);

  return columnSet;
}
function csvExport(){
	var title = $("#att_title1").text();
	fnExcelReport('attributeDataTable',title);
	//exportTableToCsv('attributeDataTable', '속성보기');
}
var workLandAttColumName ={
		"pnu":"PNU",	"id_code_nm":"토지소재지명",	"regstr_se_nm":"대장구분",	"mnnm":"본번",	"slno":"부번",	"lndcgr_nm":"지목",	"area":"공부면적(㎡)",	"in_area":"대상지면적(㎡)",		"posesn_se_nm":"소유자성명",	"std_dt":"기준일",	"pbintf_pclnd":"개별공시지가(원)",	"pbintf_de":"공시일자(공시지가)",	"std_year":"기준년도(공시지가)",	"std_mt":"기준월(공시지가)",	"std_land_at":"표준지여부(공시지가)",	"last_updt_dt":"데이터기준일자(공시지가)",	"all_area":"계산면적",	"in_area":"편입면적"
}

//[토지정보]표출 내용으로 변환(한글화 및 순서 변경)
//works : work.land.array
//flag: 컬럼 표출 여부 
//"live": 생활권   / "code" : klis분류 명칭 / "shape" : 토지형상 명칭 / "contact" : 접도 여부 
//"usage" : 법률분석 > 허용용도 / "fix": 법률분석 > 정비사업 / "river":수리수문
//workJson: 메뉴별 workJson
//field: 구분 필드명 
//conType: data 조건 타입[ range, text, id ]  
// unit: 단위
// lang: languge
// resulstColText : [검토결과] 컬럼명 법률에서만 사용 
function attWorkLandColumn(works, flag, workJson, field, conType, unit, lang, resutColText){
	var array =[];

	for (var i = 0; i < works.length; i++) {
		var item = works[i].properties;
	
		var isVisible = true;
		var color;

		if (typeof item == 'undefined'){
			item = works[i];
	    }
		var target=item[field];
		//visible 확인
		if (typeof workJson != 'undefined' && workJson != null){
			if(workJson.data.length == 0) return array;
			isVisible = getVisible(workJson, target, conType, unit, function (rColor){
				color = rColor;
			});
			//color = getDataColor(workJson);
		}
		if(isVisible){		
			//console.log("isVisible");
			var bAreaEqual = setApplyArea(item, true);//(item.apply_area == item.area); // 적용면적 == 공부면적 
			var applyArea = Math.round(Number(item.apply_area)*10)/10;
			//var area = bAreaEqual? item.area : inArea;
			var state=bAreaEqual?"":"부분편입";
			//var landType = getLandType(item.land_type_cd); // getLandType => land_info.jsp
			
			var pJson; 
			
			if (lang == "eng") {
				pJson = {"pnu":EmptyCheck(item.pnu),	"id_code_nm":EmptyCheck(item.id_code_nm),	"regstr_se_nm":EmptyCheck(item.regstr_se_nm),	"mnnm":EmptyCheck(Number(item.pnu.substring(11,15))),	"slno":EmptyCheck(Number(item.pnu.substring(15,19))),	"lndcgr_nm":EmptyCheck(item.lndcgr_nm),	"area_":EmptyCheck(item.area),	"apply_area":applyArea
						,	"posesn_se_nm":EmptyCheck(item.posesn_se_nm),	"std_dt":EmptyCheck(item.std_dt),	"pbintf_pclnd":EmptyCheck(item.pbintf_pclnd),	"pbintf_de":EmptyCheck(item.pbintf_de),	"std_year":EmptyCheck(item.std_year),	"std_mt":EmptyCheck(item.std_mt)
						,	"std_land_at":EmptyCheck(item.std_land_at),	"last_updt_dt":EmptyCheck(item.last_updt_dt),	"all_area":EmptyCheck(item.all_area),"in_area":EmptyCheck(item.in_area),	"state":state //, "토지형상":landType
						, "geometry" : works[i].geometry, "color" : color
						};
				if(flag == "live"){
					pJson["live"] = EmptyCheck(item.live);
				}else if(flag == "code"||flag == "river"){
					pJson["ucode"] = EmptyCheck(item.ucode);
					pJson["uname"] = EmptyCheck(item.uname);
					//pJson[item.ucode] = EmptyCheck(item.ucode);
					if(field=="gubun_nm"){
						pJson["gubun_nm"] = EmptyCheck(item.gubun_nm);
					}else if(field=="uname_mnum"){ //입지 > 시설
						pJson["uname_mnum"] = EmptyCheck(item.uname_mnum);
					}
				}else if(flag == "shape"){
					pJson["land_shapetype_nm"] = EmptyCheck(item.landShapeType_NM);
				}else if(flag == "contact"){
					pJson["touch_rateType_nm"] = EmptyCheck(item.touchRateType_NM);
					pJson["touch_length"] = EmptyCheck(item.touchLength);
				}else if(field == "land_type_cd"){
					var temp = EmptyCheck(target); // 명칭으로 수정
					if(temp!=g_noValue) temp = getLandType(temp);//=> userProject.js 
					pJson["land_type_cd"] = temp; 
				}else if(flag == "usage"){
					//$("#att_title1").text("상세보기");
					pJson["law_all_allowCode_nm"] = EmptyCheck(item["law_all_allowCode_NM"]);
					pJson["law_allowcode_nm"] = EmptyCheck(item["law_allowCode_NM"]);
					pJson["law_text"] = EmptyCheck(item["law_text"]);
				}else if( flag =="fix"){
					pJson["land_shapetype_nm"] = EmptyCheck(item.landShapeType_NM);
				}else if( flag =="jayeondo"){
					var colData = natural_colorcode("5", 0, Number(item.eco_lv), item.eco_lv, g_noValueColor); // => loc_natural.jsp
				pJson["eco_lv"] = EmptyCheck(colData.groupCol);
					pJson["able"]=EmptyCheck(item.able);
				}else if( flag =="limsangdo"){
					if(field=="frtp_cd"){ //식생
						pJson["frtp_cd"] = EmptyCheck(item.frtp_cd);
						var colData = natural_colorcode("6", 0, Number(item.frtp_cd), item.frtp_cd, g_noValueColor); // => loc_natural.jsp
						pJson["frtp_cd_nm"] = EmptyCheck(colData.groupCol);
					}else if (field == "agcls_cd"){ //영급
						var young = EmptyCheck(item.agcls_cd);
						var colData = natural_colorcode("7", 0, young, young, g_noValueColor); // => loc_natural.jsp
						pJson["agcls_cd"] = EmptyCheck(colData.groupCol); //EmptyCheck(item.agcls_cd);
						pJson["able"]=EmptyCheck(item.able);//추가
					}
				}else if( flag =="uses"||flag =="around"){
					pJson["uname"] = EmptyCheck(item.mn_use_nm);
				}else if( flag =="pibok"){ //피복 
					pJson["l2_code"] = EmptyCheck(item.l2_code);
					pJson["l2_name"]=EmptyCheck(item.l2_name);
				}
			} else {
				pJson = {"PNU":EmptyCheck(item.pnu),	"소재지":EmptyCheck(item.id_code_nm),	"대장구분":EmptyCheck(item.regstr_se_nm),	"본번":EmptyCheck(Number(item.pnu.substring(11,15))),	"부번":EmptyCheck(Number(item.pnu.substring(15,19))),	"지목":EmptyCheck(item.lndcgr_nm),	"공부 면적(㎡)":EmptyCheck(item.area),	"대상지  면적(㎡)":applyArea
						,	"소유자":EmptyCheck(item.posesn_se_nm),	"기준일":EmptyCheck(item.std_dt),	"개별공시지가(원)":EmptyCheck(item.pbintf_pclnd),	"공시일자(공시지가)":EmptyCheck(item.pbintf_de),	"기준년도(공시지가)":EmptyCheck(item.std_year),	"기준월(공시지가)":EmptyCheck(item.std_mt)
						,	"표준지여부(공시지가)":EmptyCheck(item.std_land_at),	"데이터기준일자(공시지가)":EmptyCheck(item.last_updt_dt),	"계산면적(㎡)":EmptyCheck(item.all_area)==''?'':item.all_area.toFixed(4),"편입면적(㎡)":EmptyCheck(item.in_area)==''?'':item.in_area.toFixed(4),	"편입상태":state //, "토지형상":landType
						};
				if(flag == "live"){
					pJson["생활권"] = EmptyCheck(item.live);
				}else if(flag == "code"|| flag=="river"){
					pJson["klis분류 코드"] = EmptyCheck(item.ucode);
					pJson["klis분류 명칭"] = EmptyCheck(item.uname);
					if(field=="gubun_nm"){
						pJson["구분 명칭"] = EmptyCheck(item.gubun_nm);
					}else if(field=="uname_mnum"){ //입지 > 시설
						pJson["klis분류 명칭_시설번호"] = EmptyCheck(item.uname_mnum);
					}else if(flag=="river"){
						//pJson["포함면적"] = EmptyCheck(item.in_area);
					}
					//pJson[item.ucode] = EmptyCheck(item.ucode);
				}else if(flag == "shape"){
					pJson["토지형상"] = EmptyCheck(item.landShapeType_NM);
				}else if(flag == "contact"){
					pJson["접도"] = EmptyCheck(item.touchRateType_NM);
					pJson["접도된 길이"] = EmptyCheck(item.touchLength);
				}else if(field == "land_type_cd"){
					var temp = EmptyCheck(target); // 명칭으로 수정
					if(temp!=g_noValue) temp = getLandType(temp);//=> userProject.js 
					pJson["기본정보 토지형상"] = temp; 
				}else if(flag == "usage"){
					$("#att_title1").text("상세보기");
					if(typeof resutColText == "undefined" ||resutColText == '' ) resutColText="검토결과";
					pJson[resutColText] = EmptyCheck(item["law_all_allowCode_NM"]);
					pJson["상세검토"] = EmptyCheck(item["law_allowCode_NM"]);
					pJson["단서조항"] = EmptyCheck(item["law_text"]);
				}else if( flag =="fix"){
					$("#att_title1").text('<spring:message code="tab.land"/>' +" 보기");
					pJson["토지형상"] = EmptyCheck(item.landShapeType_NM);
				}else if( flag =="jayeondo"){
					var colData = natural_colorcode("5", 0, Number(item.eco_lv), item.eco_lv, g_noValueColor); // => loc_natural.jsp
					pJson["등급"] = EmptyCheck(colData.groupCol);
					pJson["개발가능 여부"]=EmptyCheck(item.able);//추가
				}else if( flag =="limsangdo"){
					if(field=="frtp_cd"){ //식생
						pJson["임상코드"] = EmptyCheck(item.frtp_cd);
						var colData = natural_colorcode("6", 0, Number(item.frtp_cd), item.frtp_cd, g_noValueColor); // => loc_natural.jsp
						pJson["임상명칭"] = EmptyCheck(colData.groupCol);
					}else if (field == "agcls_cd"){ //영급
						var young = EmptyCheck(item.agcls_cd);
						var colData = natural_colorcode("7", 0, young, young, g_noValueColor); // => loc_natural.jsp
						pJson["영급"] = EmptyCheck(colData.groupCol); //EmptyCheck(item.agcls_cd);
						pJson["개발가능 여부"]=EmptyCheck(item.able);//추가
					}
				}else if( flag =="uses"||flag =="around"){
					pJson["주 용도 코드 명칭"] = EmptyCheck(item.mn_use_nm);
				}else if( flag =="pibok"){ //피복 
					pJson["피복 분류 코드"] = EmptyCheck(item.l2_code);
					pJson["피복 분류 코드 명칭"]=EmptyCheck(item.l2_name);
				}
			}
			array.push(pJson);
		}
	}
	return array;
}
//[건축물정보]표출 내용으로 변환(한글화 및 순서 변경)
//works : work.building.attrs
//flag: 컬럼 표출 여부 
// "hosu": 호수   / "nohudo" : 노후_불량건축물 판단  /"contact": 접도율 
// "fix": 법률분석> 정비사업
//workJson: 메뉴별 workJson
//field: 구분 필드명 
//conType: data 조건 타입[ range, text, id ]  
// unit: 단위
function attworkBuildingColumn(works,flag, workJson, field, conType, unit, lang){
	var array =[];
	console.log(works);
	var seq = 0;
	for (var i = 0; i < works.length; i++) {
		var item = works[i].properties;
		var isVisible = true;
		if (typeof item == 'undefined'){
			item = works[i];
	    }
		var target=item[field];
		//visible 확인
		if (typeof workJson != 'undefined' && workJson != null){
			if(workJson.data.length == 0) return array;
			isVisible = getVisible(workJson, target, conType, unit, function (rColor){
				color = rColor;
			});
		}
		if(isVisible){
			var pJson;
			seq+=1;
 			if (lang == "eng") {
 				pJson = {"bd_mng_id":EmptyCheck(item.bd_mng_id), "PNU":EmptyCheck(item.pnu),	"ledger_nm":EmptyCheck(item.ledger_nm),	"ledger_type_nm":EmptyCheck(item.ledger_type_nm),	"sp_sgg_nm":EmptyCheck(item.sp_sgg_nm),	"sp_emd_nm":EmptyCheck(item.sp_emd_nm),	"mnnm":EmptyCheck(Number(item.mnnm)),	"slno":EmptyCheck(Number(item.slno))
						,	"block":EmptyCheck(item.block),	"lot":EmptyCheck(item.lot),	"bd_nm":EmptyCheck(item.bd_nm),	"emd_nm":EmptyCheck(item.emd_nm),	"land_ar":EmptyCheck(item.land_ar),	"bd_ar":EmptyCheck(item.bd_ar),	"bd_coverage":EmptyCheck(item.bd_coverage)
						,	"tot_fl_ar":EmptyCheck(item.tot_fl_ar)
						,	"fl_ar_ratio_tot_ar":EmptyCheck(item.fl_ar_ratio_tot_ar)
						,	"fl_ar_ratio":EmptyCheck(item.fl_ar_ratio),	"constr_nm":EmptyCheck(item.constr_nm),	"etc_constr":EmptyCheck(item.etc_constr),	"mn_use_nm":EmptyCheck(item.mn_use_nm),	"etc_use":EmptyCheck(item.etc_use),	"sedae_cnt":EmptyCheck(item.sedae_cnt)
						,	"gagu_cnt":EmptyCheck(item.gagu_cnt),	"num_of":EmptyCheck(item.num_of),	"gr_fl_num":EmptyCheck(item.gr_fl_num),	"ugr_fl_num":EmptyCheck(item.ugr_fl_num),	"height":EmptyCheck(item.height),	"per_dt":EmptyCheck(item.per_dt),	"st_con_dt":EmptyCheck(item.st_con_dt),	"use_per_dt":EmptyCheck(item.use_per_dt)
						,	"per_type_nm":EmptyCheck(item.per_type_nm),	"calc_date":EmptyCheck(item.calc_date), "geometry" : works[i].geometry, "color" : color
					};
				if(flag == "hosu"){
					pJson["hosucount"] = EmptyCheck(item.hosuCount);
				}else if(flag == "nohudo"){
					pJson["decrepitstate_nm"] = EmptyCheck(item.decrepitState_NM);
				}else if(flag == "contact"){
					pJson["touchratetype_nm"] = EmptyCheck(item.touchRateType_NM);
					pJson["touchlength"] = EmptyCheck(item.touchLength);
				}else if(flag == "fix"){
					pJson["decrepitstate_nm"] = EmptyCheck(item.decrepitState_NM);
					pJson["hosucount"] = EmptyCheck(item.hosuCount);
					pJson["touchratetype_nm"] = EmptyCheck(item.touchRateType_NM);
				}
 			}else{//"순번":seq,
				pJson = {"건축물관리대장 번호":EmptyCheck(item.bd_mng_id), "PNU":EmptyCheck(item.pnu),	"대장구분":EmptyCheck(item.ledger_nm),	"대장종류":EmptyCheck(item.ledger_type_nm),	"시군구명":EmptyCheck(item.sp_sgg_nm),	"법정동명":EmptyCheck(item.sp_emd_nm),	"본번":EmptyCheck(Number(item.mnnm)),	"부번":EmptyCheck(Number(item.slno))
						,	"블록":EmptyCheck(item.block),	"로트":EmptyCheck(item.lot),	"건물명":EmptyCheck(item.bd_nm),	"동명칭":EmptyCheck(item.emd_nm),	"대지면적(㎡)":EmptyCheck(item.land_ar),	"건축면적(㎡)":EmptyCheck(item.bd_ar),	"건폐율(%)":EmptyCheck(item.bd_coverage)
						,	"연면적(㎡)":EmptyCheck(item.tot_fl_ar)
						,	"용적율산정연면적(㎡)":EmptyCheck(item.fl_ar_ratio_tot_ar)
						,	"용적율(%)":EmptyCheck(item.fl_ar_ratio),	"주구조":EmptyCheck(item.constr_nm),	"기타구조":EmptyCheck(item.etc_constr),	"주용도":EmptyCheck(item.mn_use_nm),	"기타용도":EmptyCheck(item.etc_use),	"세대수":EmptyCheck(item.sedae_cnt)
						,	"가구수":EmptyCheck(item.gagu_cnt),	"호수(호)":EmptyCheck(item.num_of),	"지상층수":EmptyCheck(item.gr_fl_num),	"지하층수":EmptyCheck(item.ugr_fl_num),	"높이(m)":EmptyCheck(item.height),	"허가일":EmptyCheck(item.per_dt),	"착공일":EmptyCheck(item.st_con_dt),	"사용승인일":EmptyCheck(item.use_per_dt)
						,	"허가번호 구분 코드 명":EmptyCheck(item.per_type_nm),	"경과연도":EmptyCheck(item.calc_date)
					};
				if(flag == "hosu"){
					pJson["호수"] = EmptyCheck(item.hosuCount);
				}else if(flag == "nohudo"){
					pJson["노후_불량건축물 판단"] = EmptyCheck(item.decrepitState_NM);
				}else if(flag == "contact"){
					pJson["접도"] = EmptyCheck(item.touchRateType_NM);
					pJson["접도된 길이"] = EmptyCheck(item.touchLength);
				}else if(flag == "fix"){
					$("#att_title1").text('<spring:message code="tab.building"/>' +" 보기");
					pJson["노후_불량건축물 판단"] = EmptyCheck(item.decrepitState_NM);
					pJson["호수"] = EmptyCheck(item.hosuCount);
					pJson["접도"] = EmptyCheck(item.touchRateType_NM);
				}
 			}
				array.push(pJson);
		}

 }
	//console.log(array);	
	return array;
}
//[표고/경사/향] 표출 내용으로 변환(한글화 및 순서 변경)
//works : work.natural[dem/slope/aspect].array
function attWorkRasterColumn(works, flag, workJson, field, conType, unit, lng){
	var array =[];
	for (var i = 0; i < works.length; i++) {
		var item = works[i].properties;
		if (typeof item == 'undefined'){
			item = works[i];
	    }
		var target=item[field];
		//visible 확인
		if (typeof workJson != 'undefined' && workJson != null){
			if(workJson.data.length == 0) return array;
			if(flag=="aspect"){conType='range_text';}
			isVisible = getVisible(workJson, target, conType, unit, function (rColor){
				color = rColor;
			});
		}
		if(isVisible){
			if(lng == "eng") {
				var pJson = {"no":EmptyCheck(item.no),	"area_":EmptyCheck(item.area),
							"color" : color, "geometry": works[i].geometry};
				
				//"표고":EmptyCheck(item.elev),	"경사":EmptyCheck(item.slope),	"향":EmptyCheck(item.aspect)};	
					if(flag=="dem"){
						pJson["elev"]=EmptyCheck(item.elev);
						pJson["able"]=EmptyCheck(item.able);
					} else if(flag=="slope"){
						pJson["slope"]=EmptyCheck(item.slope);
						pJson["able"]=EmptyCheck(item.able);
					} else if(flag=="aspect"){
						pJson["aspect"]=EmptyCheck(item.aspect);
					}
					array.push(pJson);	
			} else {
				var pJson = {"no":EmptyCheck(item.no),	"면적":EmptyCheck(item.area)};	
				//"표고":EmptyCheck(item.elev),	"경사":EmptyCheck(item.slope),	"향":EmptyCheck(item.aspect)};	
					if(flag=="dem"){
						pJson["표고"]=EmptyCheck(item.elev);
						pJson["개발가능 여부"]=EmptyCheck(item.able); // 추가
					} else if(flag=="slope"){
						pJson["경사"]=EmptyCheck(item.slope);
						pJson["개발가능 여부"]=EmptyCheck(item.able); // 추가
					} else if(flag=="aspect"){
						pJson["향"]=EmptyCheck(item.aspect);
					}
					
					array.push(pJson);	
			}
			
		}
	}
	return array;
}
function EmptyCheck(text){
	if(text=='undefined'){
		return '';
	}else {return text;}
}
//활성화 여부 확인
function getVisible(workJson, target, conType, unit, colorFn){
	//console.log("활성화 여부 확인");
	var isVisible = false;
	var resultColor="";//활성화된 색상 값
	var isIndexOf = false; //데이터 검색 (IndexOf 사용 여부)
	//visible 확인
	if(conType=='range'){ // 구간
		var iGroupCol = Number(target);
		$.each(workJson.ranges, function(key, value){
			var start = value.val1; var end = value.val2;
			var endtext = "";
			 if(typeof iGroupCol == "undefined"|| iGroupCol == null|| isNaN(iGroupCol)){
			    	target = g_noValue;
			    }
			if(Number(start) <= 0) {
				endtext = " 미만";
				if(iGroupCol < end) {
					target = end + unit +endtext;
					return false;
				}
			} else if(end == -999) {
				endtext = " 이상";
				if(iGroupCol >= start) {
					target = start+unit +endtext;
					return false;
				}
			} else {
				if(iGroupCol < Number(end)) {
					target = start + "~" + end+unit +endtext;
					return false;
				}
			}
		});
	}else if(conType=='range_comma'){ // 구간
		var iGroupCol = Number(target);
		$.each(workJson.ranges, function(key, value){
			var start = value.val1; var end = value.val2;
			var endtext = "";
			 if(typeof iGroupCol == "undefined"|| iGroupCol == null|| isNaN(iGroupCol)){
			    	target = g_noValue;
			    }
			if(Number(start) <= 0) {
				endtext = " 미만";
				if(iGroupCol < end) {
					target = numComma(end) + unit +endtext;
					return false;
				}
			} else if(end == -999) {
				endtext = " 이상";
				if(iGroupCol >= start) {
					target = numComma(start)+unit +endtext;
					return false;
				}
			} else {
				if(iGroupCol < Number(end)) {
					target = numComma(start) + "~" + numComma(end)+unit +endtext;
					return false;
				}
			}
		});
	} else if(conType=='land_type_cd') { // 토지형상
		target = getLandType(target);
	} else if(conType=='gr_fl_num'){ // 층수현황
		var iGroupCol = Number(target);
		$.each(workJson.ranges, function(key, value){
			var start = value.val1; var end = value.val2;
			var endtext = "";
			var gap = Number(value.val2)-Number(value.val1);
			var isFLNum1 = (gap==1);
			 if(typeof iGroupCol == "undefined"|| iGroupCol == null|| isNaN(iGroupCol)){
			    	target = g_noValue;
			    }
			if(Number(start) <= 0) {
				endtext = " 미만";
				if(iGroupCol < end) {
					if(isFLNum1){ //층수 현황, 구간값 1 
						target = g_noValue;
				       // groutargetpCol ="1"+unit;
				        //return false;
					}else{
						target = end + unit +endtext;
						return false;
					}
				}
			} else if(end == -999) {
				endtext = " 이상";
				if(iGroupCol >= start) {
					target = start+unit +endtext;
					return false;
				}
			} else {
				if(iGroupCol < Number(end)) {
					if(isFLNum1){ //층수 현황, 구간값 1 
						target =iGroupCol+unit;
				        return false;
					}else{
						endtext = " 미만";
						target = start + "~" + end+unit +endtext;
						return false;
					}
				}
			}
		});
		/* var start = 1; var end= 5; var gap= Number(1);
		var iGroupCol = Number(target);
		if(typeof iGroupCol == "undefined"|| iGroupCol == null || isNaN(iGroupCol)){
	    	target = g_noValue;
	    }
		if(iGroupCol < start){
			target =g_noValue;
    	}else if(iGroupCol >= 5){
    		target ="5"+ unit +" 이상";
    	}else{
    		target =iGroupCol.toString();
    	} */
	}else if(conType=='range0'){ // 구간
		var iGroupCol = Number(target);
		$.each(workJson.ranges, function(key, value){
			var start = value.val1; var end = value.val2;
			var endtext = "";
			if(iGroupCol == 0 || isNaN(iGroupCol)){
				target =g_noValue;
			}else if(Number(start) <= 0) {
				endtext = " 미만";
				if(iGroupCol < end) {
					target = end + unit +endtext;
					return false;
				}
			} else if(end == -999) {
				endtext = " 이상";
				if(iGroupCol >= start) {
					target = start+unit +endtext;
					return false;
				}
			} else {
				if(iGroupCol < Number(end)) {
					target = start + "~" + end+unit +endtext;
					return false;
				}
			}
		});
	}else if(conType=='range_text'){ // 향
		var iGroupCol = Number(target);
		$.each(workJson.ranges, function(key, value){
			var start = value.val1; var end = value.val2;
			if(start <= 0) {
				if(iGroupCol < end) {
					target = value.text;
					return false;
				}
			} else if(end == -999) {
				endtext = " 이상";
				if(iGroupCol >= start) {
					target = value.text;
					return false;
				}
			} else {
				if(iGroupCol < end) {
					target = value.text;
					return false;
				}
			}
		});
	} else if(conType == 'jayeondo'){ // 생태자연도
		var colData = natural_colorcode("5", 0, Number(target), target, g_noValueColor); // => loc_natural.jsp
		target = colData.groupCol;
	} else if(conType == 'frtp_cd'){ // 식생(임상별)
		var colData = natural_colorcode("6", 0, Number(target), target, g_noValueColor); // => loc_natural.jsp
		target = colData.groupCol;
	} else if(conType == 'agcls_cd'){ // 식생(영급별)
		var colData = natural_colorcode("7", 0, Number(target), target, g_noValueColor); // => loc_natural.jsp
		target = colData.groupCol;
	}else if(conType == 'shape'){ // 토지형상
		var value0= '<spring:message code="shape.0"/>';//기타
		var value1= '<spring:message code="shape.1"/>';//일반
		var value2= '<spring:message code="shape.2"/>';//과소필지
		var value3= '<spring:message code="shape.3"/>';//부정
		var value4= '<spring:message code="shape.4"/>';//세장
		//var value34= value3+" "+value4; //value3+'•'+value4
		//value34=value34.replace(" ","\•");
		//console.log(value34);
		if(target==value1){// 일반
			return false;
		}else if(target==value3||(target==value4)){ // 부정 세장
			isIndexOf = true;
		}else if(typeof target == 'undefined' ||  target == 'undefined' || target == null){ // 기타
			target= value0;
		}
	}else if(conType == 'contact'){ // 접도율
		var value0= '<spring:message code="contact.0"/>';//기타
		var value1= '<spring:message code="contact.1"/>';//접도
		var value2= '<spring:message code="contact.2"/>';//비접도 
		if(target!=value0 &&target!=value1 &&target!=value2){
			return false;
		}
	}else if(conType == 'hosu'){ // 호수밀도
		var num = Number(target);
		var value0= '<spring:message code="hosu.0"/>';//기타
		if(isNaN(num) || typeof num == 'undefined'){
			target =value0;
		}else if(num>=4){
			target = "4호 이상";
		}else if(num > 0){
			target +="호";
		}else {
			target ="1호";
		}
	}else if(conType == 'nohudo'){ // 노후도
		var value0= '<spring:message code="nohudo.3"/>';//기타
		var value1= '<spring:message code="nohudo.1"/>';//양호
		var value2= '<spring:message code="nohudo.2"/>';//노후 
		if(target!=value0 &&target!=value1 &&target!=value2){
			return false;
		}
	}else{ // text
		if(typeof target == 'undefined' ||  target == 'undefined' ){
			target = g_noValue;
		}
	}
	var datas = getJsonGroup(workJson.data, target,isIndexOf);
	if(datas!=null){
		isVisible = (datas.visible == 1);
		resultColor=datas.color;
		if(typeof colorFn != 'undefined'){
			colorFn(resultColor);
		}
	}else{
		console.log(target);
	}
	return isVisible;
}
//// 도시계획정보 속성 조회
// "usage":용도지역, 지구, 구역, 시설 데이터
// "perm": 개발행위허가, 지구단위계획구역
// devzone:개발구역정보
// regulation: 공적규제정보
// live:생활권
function searchAttrData(flag,fn,field){
	var resultJson=null;
	//console.log("SELECT_USAGE_GEOM_ATTR_LIST");
	var geostr = geojson2wkt(workArea[0]);
	//var NE = mymap.map.getBounds()._northEast;
	//var SW = mymap.map.getBounds()._southWest;
	var cmd = 'SELECT_PLAN_INFO_GEOM_ATTR_LIST';
	if(flag=="jayeondo"||flag=="limsangdo"||flag=="river"||flag=="pibok"){
		cmd = 'SELECT_JAYEONDO_INFO_ATTR_LIST';
	}else if(flag=="uses"||flag=="around"){
		cmd = 'SELECT_LANDBUIDING_INFO_ATTR_LIST'; 
	}else{ //flag=="usage"||flag=="perm"||flag=="devzone"||flag=="regulation"||flag=="live"
		cmd = 'SELECT_PLAN_INFO_GEOM_ATTR_LIST';
	}//
	var bnd = getBnd(workArea[0].geometry);
	var params = 'cmd='+cmd+ '&geomString=SRID=5174;'+geostr+"&minx="+(bnd.minx-1)+"&miny="+(bnd.miny-1)+"&maxx="+(bnd.maxx+1)+"&maxy="+(bnd.maxy+1)//+"&minx="+SW.lng+"&miny="+SW.lat+"&maxx="+NE.lng+"&maxy="+NE.lat
	+"&flag="+flag+'&pnulist='+(work.land.pnulist);
	if(flag=="usage"){ // 기본정보
		//params +='&buffer='+ work.plan.usage.buffer;
	}else if(flag=="lusage"){ // 입지분석
		//params +='&buffer='+ work.locplan.lusage.buffer;
	}else if(flag=="river"){ // 수리수문
		params +='&buffer='+ work.natural.river.buffer;
	}else if(flag=="around"){ // 주변건물현황
		params +='&buffer='+ work.landbd.around.buffer;
	}
	//console.log(params);
	$.ajax({ type: "post", url :"./qry" , dataType : 'json',
	    data : params,
	    success : function (response) {
	    	resultJson = response.body.result.features;
	    	if(flag=="jayeondo") resultJson = setAttrAnlayzer_env(resultJson, "ck_natural5", work.natural.jayeondo.field);
	    	else if(flag=="limsangdo"&& field == work.natural.limsangdo_agcls.field) resultJson = setAttrAnlayzer_env(resultJson, "ck_natural7", field);
	    	if(fn != null) fn(true, resultJson);
	    },error: function(xhr,status, error){
	    	if(fn != null) fn(false,JSON.stringify(xhr));
	    }
	});
}
//속성 [개발가능 여부]  설정
//생태자연도, 식생(영급) 
// workJson_arr : json
// ckID : 개발가능지 분석 check 그룹 id 
// field: 분석 필드명 
function setAttrAnlayzer_env(workJson_arr, ckID, field){
	// 분석기를 생성합니다.
	var analy = getCheckValue(ckID);//ck_natural5
	var analyzer = new EnvAnalyzer(analy);
	if(analyzer ==null ) return workJson_arr;
	for(var i = 0; i <workJson_arr.length;i++) {
		var item =workJson_arr[i];
		var value = item.properties[field];
		if(typeof value=='undefined') value = etcOtherValue;
	//지정된 해발고도가 개발가능한지 여부를 확인합니다.
		var isAvailable = analyzer.isAvailable(value);
		var groupCol = isAvailable? "가능":"불가";
		item.properties["able"] = groupCol; // 개발가능 여부 구분 
	}
	return workJson_arr;
}
 </script>
 </body>
</html>