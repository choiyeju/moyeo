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
<div style="min-height:300px;height:300px;">
	<div style='overflow:auto;max-height:290px;' id ="div_projectlist" >
		<table class="analysis_tbl_row" id="tbl_projectlist">
			<colgroup>
				<col width="10%">
				<col width="22%">
				<col width="50%">
				<col width="10%">
				<col width="8%">
			</colgroup>
			<thead>
				<tr>
					<th><spring:message code="project.code"/></th>
					<th><spring:message code="project.name"/></th>
					<th><spring:message code="project.des"/></th>
					<th><spring:message code="project.date"/></th>
					<th><spring:message code="project.delete"/></th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function() {
});
var project_selectIdx = -1;
// 프로젝트목록을 가져오는 함수 2
function reload_projectlist(response) {
	project_selectIdx = -1;
	$('#tbl_projectlist > tbody').empty();
 	for(var i=0; i<response.body.result.length; i++) {
 		var uuid = response.body.result[i].wrk_uuid;
 		var wrk_des = response.body.result[i].wrk_des;
 		var wrk_nm = response.body.result[i].wrk_nm;
 		if(response.body.result[i].last_mod_dt != undefined) {
 			var last_mod_dt = response.body.result[i].last_mod_dt;
 		} else {
 			var last_mod_dt = response.body.result[i].create_dt;
 		} 
 		$('#tbl_projectlist > tbody:last').append('<tr onClick="HighLightTR(this, \'#c9cc99\',\'cc3333\','+i+');"><td style="white-space:nowrap;text-overflow:ellipsis;overflow:hidden;">'
 			+i+'</td><td>'+wrk_nm+'</td><td>'+wrk_des+'</td><td>'+last_mod_dt+'</td><td><a href="javascript:remove_project(\''+uuid+'\')" class="button">DEL</a></td></tr>');
 	}
}
// 프로젝트 지우기
function remove_project(uuid) {
	jQuery.confirm("선택된 작업을 삭제 하시겠습니까?","삭제", function(bOk){
		if(bOk) {
			$.ajax({ type: "post", url : "./qry", data : 'cmd=SELECT_PROJECT&user_id='+work.user_id+"&uuid="+uuid,
				success : function (response) {
					reload_projectlist(response); // 불러오기
				},
				error: function(xhr,status, error){
					alert("error ! at remove_project()");
				}
			});
		}
	});
}
var trOrgBColor = '#ffffff';
var trOrgTColor = '#000000';
function HighLightTR(target, backColor,textColor, idx) {
	project_selectIdx = idx;
	var tbody = target.parentNode;
	var trs = tbody.getElementsByTagName('tr');
	for ( var i = 0; i < trs.length; i++ ) {
		if ( trs[i] != target ) {
			trs[i].style.backgroundColor = trOrgBColor;
			trs[i].style.color = trOrgTColor;
		} else {
			trs[i].style.backgroundColor = backColor;
			trs[i].style.color = textColor;
		}
	} // endfor i
}
</script>
</body>
</html>