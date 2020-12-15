<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>도시계획 정보 및 공간정보 활용 시스템</title>
<script>
// 	var map_server_url="${url}";
</script>
<style>
</style>
</head>
<body>
	<div class="wrap-loading" id="wrap-loading-area" style="display: none;">
		<div><img src="<c:url value='/resources/images/loading.gif'/>" style="width:110px"/></div>
	</div>	
</body>
<!-- cctv layer popup -->
<script id="cctv-popup-template" type="x-tmpl-mustache">
</script>
<!-- //cctv layer popup -->
</html>