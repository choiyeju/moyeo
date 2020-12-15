var geocalc = {};
function isMarkerInsidePolygon(marker, poly) {
    var inside = false;
    var x = marker.getLatLng().lat, y = marker.getLatLng().lng;
    for (var ii=0;ii<poly.getLatLngs().length;ii++){
        var polyPoints = poly.getLatLngs()[ii];
        for (var i = 0, j = polyPoints.length - 1; i < polyPoints.length; j = i++) {
            var xi = polyPoints[i].lat, yi = polyPoints[i].lng;
            var xj = polyPoints[j].lat, yj = polyPoints[j].lng;

            var intersect = ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
            if (intersect) inside = !inside;
        }
    }
    return inside;
}

geocalc.postWPS_rasCorpCoverage = function(surl, layername, wktstring, fn) {
	var NE = workAreaJson.getBounds()._northEast;
	var SW = workAreaJson.getBounds()._southWest;
//	var map_bound_coords = [NE.lng+" "+NE.lat, NE.lng+" "+SW.lat,  SW.lng+" "+SW.lat,  SW.lng+" "+NE.lat,   NE.lng+" "+NE.lat];	
	var params= '<?xml version="1.0" encoding="UTF-8"?>'
		+ '<wps:Execute version="1.0.0" service="WPS" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/wps/1.0.0" xmlns:wfs="http://www.opengis.net/wfs" xmlns:wps="http://www.opengis.net/wps/1.0.0" xmlns:ows="http://www.opengis.net/ows/1.1" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" xmlns:wcs="http://www.opengis.net/wcs/1.1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/wps/1.0.0 http://schemas.opengis.net/wps/1.0.0/wpsAll.xsd">'
		+ '<ows:Identifier>ras:CropCoverage</ows:Identifier>'
		+ '<wps:DataInputs>'
		+ '	<wps:Input>'
		+ '		<ows:Identifier>coverage</ows:Identifier>'
		+ '		<wps:Reference mimeType="image/tiff" xlink:href="http://geoserver/wcs" method="POST">' //"http://geoserver/wcs"  '+geoserverurl +'wcs
		+ '			<wps:Body>'
		+ '				<wcs:GetCoverage service="WCS" version="1.1.1">'
		+ '					<ows:Identifier>'+layername+'</ows:Identifier>'
		+ '						<wcs:DomainSubset>'
		+ '							<ows:BoundingBox crs="http://www.opengis.net/gml/srs/epsg.xml#4326">'
		+ '								<ows:LowerCorner>'+SW.lng+" "+SW.lat+'</ows:LowerCorner><ows:UpperCorner>'+NE.lng+" "+NE.lat+'</ows:UpperCorner>'
		+ '							</ows:BoundingBox>'
		+ '						</wcs:DomainSubset>'
		+ '					<wcs:Output format="image/tiff"/>'
		+ '				</wcs:GetCoverage>'
		+ '			</wps:Body>'
		+ '		</wps:Reference>'
		+ '	</wps:Input>'
		+ '	<wps:Input>'
		+ '		<ows:Identifier>cropShape</ows:Identifier>'
		+ '		<wps:Data>'
		+ '			<wps:ComplexData mimeType="application/wkt">'
		+ '				<![CDATA['+wktstring+']]>'
		+ '			</wps:ComplexData>'
		+ '		</wps:Data>'
		+ '	</wps:Input>'
		+ '</wps:DataInputs>'
		+ '<wps:ResponseForm>'
		+ '	<wps:RawDataOutput mimeType="image/tiff">'
		+ '		<ows:Identifier>result</ows:Identifier>'
		+ '	</wps:RawDataOutput>'
		+ '</wps:ResponseForm>'
		+ '</wps:Execute>';
	console.log(params);
	var ajax = $.ajax({type: 'POST',  url : surl, data :params,
		contentType: "text/xml",
//	    dataType: "xml",
//	    xhrFields:{
//            responseType: 'blob'
//        },
	    success : function (data) {
	    	if(fn != null) fn(data);
	    },error: function(xhr,status, error){
	    	alert(error+" 에러 관리자에게 문의하세요.\n"+xhr);
	    }
	});
}
geocalc.postWPS_geoIntersection = function(surl, layername, wktstring, returntype, fn) {
	var NE = workAreaJson.getBounds()._northEast;
	var SW = workAreaJson.getBounds()._southWest;
	var params= '<?xml version="1.0" encoding="UTF-8"?>'
		+ '<wps:Execute version="1.0.0" service="WPS" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/wps/1.0.0" xmlns:wfs="http://www.opengis.net/wfs" xmlns:wps="http://www.opengis.net/wps/1.0.0" xmlns:ows="http://www.opengis.net/ows/1.1" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc" xmlns:wcs="http://www.opengis.net/wcs/1.1.1" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/wps/1.0.0 http://schemas.opengis.net/wps/1.0.0/wpsAll.xsd">'
		+ '<ows:Identifier>gs:Clip</ows:Identifier>'
		+ '<wps:DataInputs>'
		+ '	<wps:Input>'
		+ '		<ows:Identifier>features</ows:Identifier>'
		+ '		<wps:Reference mimeType="text/xml" xlink:href="http://geoserver/wfs" method="POST">'
		+ '			<wps:Body>'
		+ '				<wfs:GetFeature service="WFS" version="1.0.0" outputFormat="GML2" xmlns:starter="moyeo">'
		+ '					<wfs:Query typeName="starter:'+layername+'" srsName="EPSG:4326">' // 
		+ '						<ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">'
		+ '							<ogc:BBOX>'
		+ '								<gml:Envelope srsName="EPSG:4326" xmlns:gml="http://www.opengis.net/gml">'
		+ '									<gml:lowerCorner>' +  SW.lng + ' ' + SW.lat + '</gml:lowerCorner><gml:upperCorner>' + NE.lng + ' ' + NE.lat + '</gml:upperCorner>'
		+ '								</gml:Envelope>'
		+ '							</ogc:BBOX>'
		+ '						</ogc:Filter>'
		+ '					</wfs:Query>'
		+ '				</wfs:GetFeature>'
		+ '			</wps:Body>'
		+ '		</wps:Reference>'
		+ '	</wps:Input>'
		+ '	<wps:Input>'
		+ '		<ows:Identifier>clip</ows:Identifier>'
		+ '		<wps:Data>'
		+ '			<wps:ComplexData mimeType="application/wkt">'
		+ '				<![CDATA['+wktstring+']]>'
		+ '			</wps:ComplexData>'
		+ '		</wps:Data>'
		+ '	</wps:Input>'
		+ '</wps:DataInputs>'
		+ '<wps:ResponseForm>'
		+ '	<wps:RawDataOutput mimeType="'+returntype+'">'
		+ '		<ows:Identifier>result</ows:Identifier>'
		+ '	</wps:RawDataOutput>'
		+ '</wps:ResponseForm>'
		+ '</wps:Execute>';
	console.log(params);
	var ajax = $.ajax({type: 'POST',  url : geoserverurl +"wps", data :params,
		contentType: "text/xml",
//	    dataType: "xml",
//	    jsonpCallback : 'getJson',
	    success : function (response) {
//	    	alert(response);
	    	if(fn != null) fn(response);
	    },error: function(xhr,status, error){
	    	alert("Error - "+error+"  관리자에게 문의하세요.\n"+JSON.stringify(xhr));
	    }
	});
}

gutils.getGeoFileDown = function (geoserverurl, layername, work_uuid, user_id, outformat, epsg) {
	var str = geoserverurl+"wfs?service=WFS&version=2.0&request=GetFeature&outputFormat="
		+outformat+"&typeName="+layername+"&cql_filter=work_uuid='"+work_uuid+"' AND user_id='"+user_id+"'&SrsName=EPSG%3A"+epsg+"&";
	console.log("STR : " + str);
	location.href=str;
	//<a href="'+geoserverurl+'wfs?service=WFS&version=1.1.0&request=GetFeature&outputFormat=json&typeName=g_land&cql_filter=INTERSECTS(geom,'+wktstring+')&SrsName=EPSG%3A4326&" target="_blank" style="color:#d8d9da; text-decoration:none;">
}

gutils.getGeoFileDown_SHP = function (url, layername, work_uuid, user_id, outformat, epsg, souepsg) {
	var strUrl = /*url + */"./ShpExport";
	if(souepsg == null) souepsg = 4326;
	var params = "outputFormat: " + outformat + "&typeName=" + layername + "&work_uuid=" + work_uuid + "&user_id=" + user_id + "&SouSrs=" + souepsg + "&SrsName=" + epsg+"&encoding_type=euc-kr";
	console.log("STR : " + strUrl);
	
	/*
	$.ajax({ type: "post", url: strUrl, data: params,
	    success : function (response) {
//	    	console.log(response.body.result);
	    	////if(fn != null) fn(response.body.result.features[0].isvalid);
	    },error: function(xhr,status, error){
	    	//if(fn != null) fn(false,'<spring:message code="fail.geocalc"/>');
	    }
	});*/
	
	location.href = strUrl + "?" + params;
}


gutils.edit = {vertex : []};


// bbox 기능 
// [x1,y1,x2,y2]
function isBBox(bbox, tar) {
	if(bbox[0] > tar[2] || bbox[1] > tar[3]) return false;
	if(bbox[2] < tar[0] || bbox[3] < tar[1]) return false;
	console.log(bbox + ":"+tar);
	return true;
}
// 바운더리에 포함된 버텍스 지우기
function deleteVertex4Bbox(feature, bbox) {
	if(feature.geometry.type == "MultiPolygon") {
	 	for(var ii = feature.geometry.coordinates.length-1;ii>=0;ii--) {
	 		var values = feature.geometry.coordinates[ii];
	 		for(var i = values.length-1; i>= 0 ;i--) {
	 			var value = values[i];
	 			for(var j = value.length-1; j>=0; j--) {
	 				if(isBBox(bbox, [value[j][0], value[j][1],value[j][0], value[j][1]])) {
	 					value.splice(j, 1);
	 				}
	 			}
			}
	 	}
	} else {
		for(var i = feature.geometry.coordinates.length-1; i>= 0 ;i--) {
			var value = feature.geometry.coordinates[i];
			for(var j = value.length-1; j>=0; j--) {
				if(isBBox(bbox, [value[j][0], value[j][1],value[j][0], value[j][1]])) {
					value.splice(j, 1);
 				}
			}
		}
	}
	nonClosedRings(feature);
}
// 버텍스 그리기 
function drawVertex(feature, map, fn) {
	if(map == null) map = mymap.map;
	var vertexStyle = [];
	if(feature.geometry.type == "MultiPolygon") {
    	for(var ii = feature.geometry.coordinates.length-1;ii>=0;ii--) {
    		var values = feature.geometry.coordinates[ii];
    		for(var i = values.length-1; i>= 0 ;i--) {
    			var value = values[i];
    			for(var j = 0; j < value.length; j++) {
    				var obj = L.circle([value[j][1], value[j][0]], 3, {fillColor:'#fff', color: 'blue', weight: 2, opacity: 1}).addTo(map);
    				vertexStyle.push(obj);
    			}
    		}
		}
	} else {
		for(var i = feature.geometry.coordinates.length-1; i>= 0 ;i--) {
			var value = feature.geometry.coordinates[i];
			for(var j = 0; j < value.length; j++) {
				var obj = L.circle([value[j][1], value[j][0]], 3, {fillColor:'#fff', color: 'blue', weight: 2, opacity: 1}).addTo(map);
				vertexStyle.push(obj);
			}
		}
	}
	return vertexStyle;
}
// 버텍스 지우기
function removeDrawVertex(vertexStyle) {
	$.each(vertexStyle, function(key, value){
//		value.clearLayers();
		mymap.map.removeLayer(value);
	});
}

//공간 계산하기
function calcGeometry(calc, sou, tar, fn, buffer) {
	var geostr = "cmd=CALC_GEOMETRY&geoquery="+calc+"('"+geojson2wkt(sou)+"'::geometry)";
	if(tar != null) {
		if(buffer != null)
			geostr = "cmd=CALC_GEOMETRY&geoquery=t_Multi(st_collectionextract(ST_makevalid("+calc+"('"+geojson2wkt(sou)+"'::geometry,'"+geojson2wkt(tar)+"'::geometry, "+buffer+")),3))";
		else geostr = "cmd=CALC_GEOMETRY&geoquery=St_Multi(st_collectionextract(ST_makevalid("+calc+"('"+geojson2wkt(sou)+"'::geometry,'"+geojson2wkt(tar)+"'::geometry)),3))";
	}
	$.ajax({ type: "post", url : "./qry", dataType : 'json', data : geostr, 
	    success : function (response) {
	    	if(fn != null) fn(true, response.body.result);
	    },error: function(xhr,status, error){
	    	if(fn != null) fn(false,'<spring:message code="fail.geocalc"/>');
	    }
	});
}
function calcGeometryUnion(calc, sou, tararr, fn) {
	var geostr = "cmd=CALC_GEOMETRY&geoquery=St_Multi(st_collectionextract(ST_makevalid("+calc+"(Array['"+geojson2wkt(sou)+"'::geometry";
	$.each(tararr, function(key,value){
		geostr += ",'"+geojson2wkt(value)+"'::geometry";
	});
	geostr += "])),3))";
	$.ajax({ type: "post", url : "./qry", dataType : 'json', data : geostr, 
	    success : function (response) {
	    	if(fn != null) fn(true, response.body.result);
	    },error: function(xhr,status, error){
	    	if(fn != null) fn(false,'<spring:message code="fail.geocalc"/>');
	    }
	});
}
function calcGeometrySelUnion(calc, tararr, fn) {
	var geostr = "cmd=CALC_GEOMETRY&geoquery="+calc+"(Array['"+geojson2wkt(tararr[0])+"'::geometry";
	for(var i =1;i<tararr.length;i++) {
		geostr += ",'"+geojson2wkt(tararr[i])+"'::geometry";
	}
	geostr += "])";
	$.ajax({ type: "post", url : "./qry", dataType : 'json', data : geostr, 
	    success : function (response) {
	    	if(fn != null) fn(true, response.body.result);
	    },error: function(xhr,status, error){
	    	if(fn != null) fn(false,'<spring:message code="fail.geocalc"/>');
	    }
	});
}
// 도형 무결성 체크
function isGeoValid(gjson, fn) {
	var geostr = "cmd=CALC_GEOMETRY&geocmd=isValid&geometry="+geojson2wkt(gjson);
	$.ajax({ type: "post", url : "./qry", dataType : 'json', data : geostr, 
	    success : function (response) {
//	    	console.log(response.body.result);
	    	if(fn != null) fn(response.body.result.features[0].isvalid);
	    },error: function(xhr,status, error){
	    	if(fn != null) fn(false,'<spring:message code="fail.geocalc"/>');
	    }
	});
}
// 다각형 면적구하기
function geojsonArea(feature) { 
	var area = 0;         // Accumulates area in the loop
	if(feature.geometry.type == "MultiPolygon") {
		$.each(feature.geometry.coordinates, function(key,value) {
			area += holePolygonArea(value);
		});
	} else {
		area = holePolygonArea(feature.geometry.coordinates);
	}
	return area;
}

// 시계 반시계 체크
function isClockwise(values) {
    var sum = 0.0;
    for (var i = 0; i < values.length; i++) {
        var v1 = values[i];
        var v2 = values[(i + 1) % values.length];
        sum += (v2[0] - v1[0]) * (v2[1] + v1[1]);
    }
    return sum > 0.0;
}
//도넛모양 다각형 면적구하기
function holePolygonArea(coordinates) { 
	var area = 0;         // Accumulates area in the loop
	$.each(coordinates, function(key,coordinate) {
//		if(isClockwise(coordinate)) {
			area += polygonArea(coordinate);
//		} else 
//			area -= polygonArea(coordinate);
	});
 	return area;
}
//다각형 면적구하기
function polygonArea(values) {
	var area = 0;         // Accumulates area in the loop
	var j = values.length-1;
	for (var i=0; i<values.length; i++) {
		area = area +  (values[i][0]+values[j][0]) * (values[j][1]-values[i][1]); 
	    j = i;  //j is previous vertex to i
	}
	if(area < 0) area *= -1;
 	return area/2;
}

// 폴리곤 클로즈 링 보정 - polygon 
function  nonClosedRings4polygon(coordinates) {
	if(coordinates.length <= 0 || coordinates[0].length <= 0) {
		return;
	}
	if(coordinates[0][0] != coordinates[coordinates.length-1][0]
		&& coordinates[0][1] != coordinates[coordinates.length-1][1])
		coordinates.push([coordinates[0][0], coordinates[0][1]]);
}
// 폴리곤 클로즈 링 보정 - GeoJson
function  nonClosedRings(feature) {
	if(feature.geometry.type == "MultiPolygon") {
    	$.each(feature.geometry.coordinates, function(key,values) {
    		for(var i = values.length-1; i>= 0 ;i--) {
    			nonClosedRings4polygon(values[i]);
    		}
		});
	} else {
		for(var i = feature.geometry.coordinates.length-1; i>= 0 ;i--) {
			nonClosedRings4polygon(feature.geometry.coordinates[i]);
		}
	}
}
// 세점의 각도 구하는 공식
function fnDegree(c, a, b, bAbs) {
	var o1 = Math.atan((a.y-c.y)/(a.x-c.x));
	var o2 = Math.atan((b.y-c.y)/(b.x-c.x));
	if(bAbs == null) bAbs = true;
	if(bAbs)
		return Math.abs( (o1-o2) * 180/Math.PI );
	else return (o1-o2) * 180/Math.PI;
}
//같은 좌표 제거
function removeCompPoint4Polygon(coordinates, nfloor) {
	if(nfloor == null) nfloor = 9;
	var valueA, valueB;
	console.log("동일좌표 제거 스타트");
	for(var i = coordinates.length-1; i> 0 ;i--) {
		valueA = coordinates[i];
		for(var j = 1;j < i;j++) {
			valueB = coordinates[j];
			// 일치할경우
			if(valueA[0].toFixed(nfloor) == valueB[0].toFixed(nfloor) && valueA[1].toFixed(nfloor) == valueB[1].toFixed(nfloor)) {
//				console.log("D:"+valueA[0].toFixed(5)+","+valueA[1].toFixed(5)+":"+valueB[0].toFixed(5)+","+valueB[1].toFixed(5)+":"+degree);
				coordinates.splice(i, 1);
				continue;
			}
		}
	}
}
// 각도가0.5 이하면 기준포인트를 제거 하는 함수 - 폴리곤
function removeDegreePoint4Polygon(coordinates, chum) {
	if(coordinates.length < 3) return;
	if(chum == null) chum = 0.5;
	var valueC, valueA, valueB;
	var bReplay = false;
//	console.log("디그리 스타트");
	for(var i = coordinates.length-1; i>= 0 ;i--) {
		valueC = coordinates[i];
		if(i == 0)
			valueA = coordinates[coordinates.length-1];
		else valueA = coordinates[i-1];
		if(i < coordinates.length-1)
			valueB = coordinates[i+1];
		else valueB = coordinates[0];
		
		// 일치할경우
		if(valueA[0].toFixed(9) == valueB[0].toFixed(9) && valueA[1].toFixed(9) == valueB[1].toFixed(9)) {
//			console.log("D1:"+valueC[0].toFixed(5)+","+valueC[1].toFixed(5)+":"+valueA[0].toFixed(5)+","+valueA[1].toFixed(5)+":"+valueB[0].toFixed(5)+","+valueB[1].toFixed(5)+":"+degree);
			coordinates.splice(i, 1);
			bReplay = true;
			continue;
		}
		
		var degree = fnDegree({x:valueC[0], y:valueC[1]},{x:valueA[0], y:valueA[1]},{x:valueB[0], y:valueB[1]});
		if(isNaN(degree) || Math.abs(degree) <= chum) {
			bReplay = true;
//			console.log("D2:"+valueC[0].toFixed(5)+","+valueC[1].toFixed(5)+":"+valueA[0].toFixed(5)+","+valueA[1].toFixed(5)+":"+valueB[0].toFixed(5)+","+valueB[1].toFixed(5)+":"+degree);
			coordinates.splice(i, 1);
		} else {
//			console.log("L:"+valueC[0].toFixed(5)+":"+valueC[1].toFixed(5)+":"+valueA[0].toFixed(5)+":"+valueA[1].toFixed(5)+":"+valueB[0].toFixed(5)+":"+valueB[1].toFixed(5)+":"+degree);
		}
	}
	if(bReplay) { // 각도 작은것 없을때까지 재귀한다.
		removeDegreePoint4Polygon(coordinates, chum);
	}
//	console.log(coordinates);
}
// 각도가 0.5이하면 기준포이트를 제거 하는 함수 - GeoJson
function removeDegreePoint(feature, chum) {
	if(chum == null) chum = 0.5;
	if(feature.geometry.type == "MultiPolygon") {
    	$.each(feature.geometry.coordinates, function(key,values) {
			console.log("폴리곤 "+key);
    		for(var i = values.length-1; i>= 0 ;i--) {
    			console.log("파츠 "+i);
    			removeCompPoint4Polygon(values[i], 5);
    			removeDegreePoint4Polygon(values[i], chum);
    			console.log(values[i]);
    		}
		});
	} else {
		for(var i = feature.geometry.coordinates.length-1; i>= 0 ;i--) {
			removeCompPoint4Polygon(feature.geometry.coordinates[i], 5);
			removeDegreePoint4Polygon(feature.geometry.coordinates[i], chum);
		}
	}
}
// 빈개체 제거
function removeEmptyObj(feature) {
	if(feature == null) return;
	if(feature.geometry.type == "MultiPolygon") {
    	for(var ii = feature.geometry.coordinates.length-1;ii>=0;ii--) {
    		var values = feature.geometry.coordinates[ii];
    		if(values.length == 0) {
    			feature.geometry.coordinates.splice(ii, 1);
    		}
		}
	} else {
		for(var i = feature.geometry.coordinates.length-1; i>= 0 ;i--) {
			var value = feature.geometry.coordinates[i];
			if(value.length == 0) {
    			feature.geometry.coordinates.splice(i, 1);
    		}
		}
	}
}
// 1보다 면적이 작은 폴리곤을 제거하는 함수
function removeSmallArea(feature, chum) {
	if(chum == null) chum = 1;
	if(feature == null) return;
	if(feature.geometry.type == "MultiPolygon") {
    	for(var ii = feature.geometry.coordinates.length-1;ii>=0;ii--) {
    		var values = feature.geometry.coordinates[ii];
    		for(var i = values.length-1; i>= 0 ;i--) {
    			var value = values[i];
    			var area = polygonArea(value);
    			if(Math.abs(area) <= chum) {
    				values.splice(i, 1);
    			}
    		}
    		if(values.length == 0) {
    			feature.geometry.coordinates.splice(ii, 1);
    		}
		}
	} else {
		for(var i = feature.geometry.coordinates.length-1; i>= 0 ;i--) {
			var value = feature.geometry.coordinates[i];
			var area = polygonArea(value);
			if(Math.abs(area) <= chum) {
				feature.geometry.coordinates.splice(i, 1);
			}
		}
	}
}
//레이어 와 필드 지정 목록을 공간연산하여 가져오기
function calcGeometryLayer4wrokarea(calc, gjson, fn, options) {
	var geostr = "cmd=CALC_GEOMETRY&layer="+options.layers+"&field="+options.fields+"&vallist="+options.vallist+"&geoquery="+calc+"("+options.geomfield+")";
	$.ajax({ type: "post", url : "./qry", dataType : 'json',
	    data : geostr, 
	    success : function (response) {
	    	if(fn != null) fn(true, response.body.result);
	    },error: function(xhr,status, error){
	    	if(fn != null) fn(false,'<spring:message code="fail.geocalc"/>');
	    }
	});
}
//레이어 지정 공간 계산하기
function calcGeometry4layer(calc, gjson, fn, options) {
	var geostr = "cmd=CALC_GEOMETRY&layer="+options.layers+"&field="+options.fields+"&value="+options.values+"&geoquery="+calc+"(ST_SETSRID('"+geojson2wkt(gjson)+"'::geometry,"+options.epsg+"), geom)";
	$.ajax({ type: "post", url : "./qry", dataType : 'json',
	    data : geostr, 
	    success : function (response) {
	    	if(fn != null) fn(true, response.body.result);
	    },error: function(xhr,status, error){
	    	if(fn != null) fn(false,'<spring:message code="fail.geocalc"/>');
	    }
	});
}
// 4326 geojson의 좌표를 def_epsg로 조정 
function map2def(array) {
	for(var i = 0; i < array.length;i++) {
		if(array[i].geometry.type == "MultiPolygon") {
			$.each(array[i].geometry.coordinates, function(key,value) {
				$.each(value, function(key1,value1) {
					$.each(value1, function(key2,value2) {
						var pointDest = Proj4js.transform(map_epsg, def_epsg, new Proj4js.Point(value2[0] + ',' + value2[1]));
						value2[0] = pointDest.x.toFixed(5);
						value2[1] = pointDest.y.toFixed(5);
//						console.log(value2);
					});
				});
			});
		} else {
			$.each(array[i].geometry.coordinates, function(key,value) {
				$.each(value, function(key1,value1) {
					var pointDest = Proj4js.transform(map_epsg, def_epsg, new Proj4js.Point(value1[0] + ',' + value1[1]));
					value1[0] = pointDest.x.toFixed(5);
					value1[1] = pointDest.y.toFixed(5);
				});
			});
		}
	}
}

// geojson [0] 개체를 가지고 좌표변환한다. 리턴값 없음
function geojsonTransform(gjson, sou,tar) {
//	var bfloor = false;
//	if(tar == Proj4js.defs["EPSG:5174"]) {
//		bfloor = true;
//	}
//	console.log(sou);
	if(gjson.geometry.type == "MultiPolygon") {
		$.each(gjson.geometry.coordinates, function(key,value) {
			$.each(value, function(key1,value1) {
				$.each(value1, function(key2,value2) {
					var pointDest = Proj4js.transform(sou, tar, new Proj4js.Point(value2[0] + ',' + value2[1]));
//					if(bfloor) {
//						value2[0] = pointDest.x.toFixed(5);
//						value2[1] = pointDest.y.toFixed(5);
//					} else {
//					console.log(value2);
						value2[0] = pointDest.x;
						value2[1] = pointDest.y;
//					}
//						console.log(pointDest);
				});
			});
		});
	} else if(gjson.geometry.type == "Polygon") {
		$.each(gjson.geometry.coordinates, function(key,value) {
			$.each(value, function(key1,value1) {
				var pointDest = Proj4js.transform(sou, tar, new Proj4js.Point(value1[0] + ',' + value1[1]));
//				if(bfloor) {
//					value1[0] = pointDest.x.toFixed(5);
//					value1[1] = pointDest.y.toFixed(5);
//				} else {
					value1[0] = pointDest.x;
					value1[1] = pointDest.y;
//				}
			});
		});
	} else if(gjson.geometry.type == "LineString") {
		$.each(gjson.geometry.coordinates, function(key,value) {
			var pointDest = Proj4js.transform(sou, tar, new Proj4js.Point(value[0] + ',' + value[1]));
//			if(bfloor) {
//				value[0] = pointDest.x.toFixed(5);
//				value[1] = pointDest.y.toFixed(5);
//			} else {
				value[0] = pointDest.x;
				value[1] = pointDest.y;
//			}
		});
	}
	return gjson;
}

// 지도좌표의 영역을 가져온다.
function getBnd(geometry) {
	var bnd = {minx: 9999999999,miny: 9999999999, maxx:-9999999999, maxy:-999999999};
	if(geometry.type == "MultiPolygon") {
		$.each(geometry.coordinates, function(key,value) {
			$.each(value, function(key1,value1) {
				$.each(value1, function(key2,value2) {
					if(bnd.minx > value2[0]) bnd.minx = value2[0];
					if(bnd.miny > value2[1]) bnd.miny = value2[1];
					if(bnd.maxx < value2[0]) bnd.maxx = value2[0];
					if(bnd.maxy < value2[1]) bnd.maxy = value2[1];
				});
			});
		});
	} else if(geometry.type == "Polygon") {
		$.each(geometry.coordinates, function(key,value) {
			$.each(value, function(key1,value1) {
				if(bnd.minx > value1[0]) bnd.minx = value1[0];
				if(bnd.miny > value1[1]) bnd.miny = value1[1];
				if(bnd.maxx < value1[0]) bnd.maxx = value1[0];
				if(bnd.maxy < value1[1]) bnd.maxy = value1[1];
			});
		});
	} else if(geometry.type == "LineString") {
		$.each(geometry.coordinates, function(key,value) {
			if(bnd.minx > value[0]) bnd.minx = value[0];
			if(bnd.miny > value[1]) bnd.miny = value[1];
			if(bnd.maxx < value[0]) bnd.maxx = value[0];
			if(bnd.maxy < value[1]) bnd.maxy = value[1];
		});
	}
	return bnd;
}
//map좌표를 def_epsg로 조정 해서 가져온다.
function getMap2def(array) {
	var newarr = JSON.parse(JSON.stringify(array));
	if(newarr.hasOwnProperty("geometry")) {  // 베열이 아닐때
		geojsonTransform(newarr, map_epsg, def_epsg);
	} else { // 
		for(var i = 0; i < newarr.length;i++) {
			geojsonTransform(newarr[i], map_epsg, def_epsg);
		}
	}
	return newarr;
}
//def좌표를 map_epsg로 조정 해서 가져온다.
function getDef2map(array) {
	var newarr = JSON.parse(JSON.stringify(array));
	if(newarr.hasOwnProperty("geometry")) {  // 베열이 아닐때
		geojsonTransform(newarr, def_epsg, map_epsg);
	} else { // 
		for(var i = 0; i < newarr.length;i++) {
			geojsonTransform(newarr[i], def_epsg, map_epsg);
		}
	}
	return newarr;
}
//geojson을 wkt형식으로
function geojson2wkt(geojson, epsg_sou, epsg_tar) {
	var ret = '';
	if(geojson == null) geojson = workArea[0];
	var bfloor = false;
	if(epsg_tar == Proj4js.defs["EPSG:5174"] 
		|| (epsg_tar == null && def_epsg == Proj4js.defs["EPSG:5174"])) {
		bfloor = true;
	}
	if(geojson.geometry.type == 'Point') {
		ret = "Point(";
		if(epsg_sou != null) {
			var pointDest = Proj4js.transform(epsgsou, epsgtar, new Proj4js.Point(geojson.geometry.coordinates[0] + ',' +geojson.geometry.coordinates[1]));
			if(bfloor)
				ret += pointDest.x.toFixed(5) + " " + pointDest.y.toFixed(5);
			else ret += pointDest.x + " " + pointDest.y;
		} else {
			if(bfloor)
				ret += geojson.geometry.coordinates[0].toFixed(5) + " " + geojson.geometry.coordinates[1];
			else ret += geojson.geometry.coordinates[0] + " " + geojson.geometry.coordinates[1];
		}
		ret += ")";
	} else 
	if(geojson.geometry.type == 'LineString') {
		ret = "LineString(";
		$.each(geojson.geometry.coordinates, function(key, value) {
			if(!ret.endsWith("(")) ret += ",";
			if(epsg_sou != null) {
				var pointDest = Proj4js.transform(epsgsou, epsgtar, new Proj4js.Point(value[0] + ',' +value[1]));
				if(bfloor)
					ret += pointDest.x.toFixed(5) + " " + pointDest.y.toFixed(5);
				else ret += pointDest.x + " " + pointDest.y;
			} else {
				if(bfloor)
					ret += value[0].toFixed(5) + " " + value[1];
				else ret += value[0] + " " + value[1];
			}
		});
		ret += ")";
	} else if(geojson.geometry.type == 'Polygon') {
		ret = "POLYGON(";
		$.each(geojson.geometry.coordinates, function(key, value) {
			if(ret.endsWith(")")) ret += ",";
			ret += "(";
			$.each(value, function(key1, value1) {
				if(!ret.endsWith("(")) ret += ",";
				if(epsg_sou != null) {
					var pointDest = Proj4js.transform(epsgsou, epsgtar, new Proj4js.Point(value1[0] + ',' +value1[1]));
					if(bfloor)
						ret += pointDest.x.toFixed(5) + " " + pointDest.y.toFixed(5);
					else ret += pointDest.x + " " + pointDest.y;
				} else {
					if(bfloor)
						ret += value1[0].toFixed(5) + " " + value1[1];
					else ret += value1[0] + " " + value1[1];
				}
			});
			ret += ")";
		});
		ret += ")";
	} else if(geojson.geometry.type == 'MultiPolygon') {
		ret = "MULTIPOLYGON(";
		$.each(geojson.geometry.coordinates, function(key,value) {
			if(ret.endsWith(")")) ret += ",";
			ret += "(";
			$.each(value, function(key1,value1) {
				if(!ret.endsWith("(")) ret += ",";
				ret += "(";
				$.each(value1, function(key2,value2) {
					if(!ret.endsWith("(")) ret += ",";
					if(epsg_sou != null) {
						var pointDest = Proj4js.transform(epsgsou, epsgtar, new Proj4js.Point(value2[0] + ',' +value2[1]));
						if(bfloor)
							ret += pointDest.x.toFixed(5) + " " + pointDest.y.toFixed(5);
						else ret += pointDest.x + " " + pointDest.y;
					} else {
						if(bfloor)
							ret += value2[0].toFixed(5) + " " + value2[1];
						else ret += value2[0] + " " + value2[1];
					}
				});
				ret += ")";
			});
			ret += ")";
		});
		ret += ")";
	}
//	console.log(ret);
	return ret;
}
// geojson polygon을 multipolygon으로
function toMultiPolygon(geojson) {
	if(geojson.geometry.type == "MultiPolygon") return geojson;
	geojson.geometry.type = "MultiPolygon";
	var temp = geojson.geometry.coordinates;
	geojson.geometry.coordinates = [];
	geojson.geometry.coordinates.push(temp);
	return geojson;
}
// geojson을 wkt형식으로
function getWorkArea2TransFormString(sou, tar) {
	var epsgsou = new Proj4js.Proj("EPSG:"+sou);
	var epsgtar = new Proj4js.Proj("EPSG:"+tar);
	var gjson_coords = [[]];
	var ban = tar == 4316?9:5;
	var geostr = "MULTIPOLYGON(";
	$.each(workArea[0].geometry.coordinates, function() {
		var parent = this;
		if(geostr.endsWith(")")) geostr += ",";
		geostr += "((";
		$.each(parent, function() {
			if(!geostr.endsWith("(")) geostr += ",";
			var pointDest = Proj4js.transform(epsgsou, epsgtar, new Proj4js.Point(this[0] + ',' +this[1]));
			geostr += pointDest.x.toFixed(ban) + " " + pointDest.y.toFixed(ban);
		});
		geostr += "))";
	});
	geostr += ")";
	return geostr
}
function XMLToString(oXML) {
	//code for IE
	 if (window.ActiveXObject) {
		 var oString = oXML.xml; return oString;
	 } 
	 // code for Chrome, Safari, Firefox, Opera, etc.
	 	else {
	 		return (new XMLSerializer()).serializeToString(oXML);
	 	}
 }
function StringToXML(oString) {
	 //code for IE
	 if (window.ActiveXObject) { 
	 var oXML = new ActiveXObject("Microsoft.XMLDOM"); oXML.loadXML(oString);
	 return oXML;
	 }
	 // code for Chrome, Safari, Firefox, Opera, etc. 
	 else {
	 return (new DOMParser()).parseFromString(oString, "text/xml");
	 }
	}


function fitBounds(bound) {
	mymap.map.fitBounds(bound);
	var bnd = mymap.map.getBounds();
	if(bound._southWest.lng.toFixed(2) < bnd._southWest.lng.toFixed(2) || bound._southWest.lat.toFixed(2) < bnd._southWest.lat.toFixed(2)
			|| bound._northEast.lng.toFixed(2) > bnd._northEast.lng.toFixed(2) || bound._northEast.lat.toFixed(2) > bnd._northEast.lat.toFixed(2)) {
		setTimeout(function(){
			var bnd = mymap.map.getBounds();
			if(bound._southWest.lng < bnd._southWest.lng || bound._southWest.lat < bnd._southWest.lat
					|| bound._northEast.lng > bnd._northEast.lng || bound._northEast.lat > bnd._northEast.lat) {
				setViewCust(bound)
			}
		}, 200);
	}
}
function setViewCust(bound) {
	mymap.map.setView(mymap.map.getCenter(), mymap.map.getZoom()-1);
	setTimeout(function(){
		var bnd = mymap.map.getBounds();
		if(bound._southWest.lng < bnd._southWest.lng || bound._southWest.lat < bnd._southWest.lat
				|| bound._northEast.lng > bnd._northEast.lng || bound._northEast.lat > bnd._northEast.lat) {
			setViewCust(bound);
		}
	}, 200);
}
// 지도제이슨 구조를 만들어 리턴한다.
function makeGeoJson(obj,srid) {
	if(srid == null) srid = 5174;
	var geojson = {"type": "FeatureCollection", "crs": {"type": "name", "properties": {"name": "urn:ogc:def:crs:EPSG::"+srid}}, "features": obj};
	return geojson;
}
var scalesttt = [];

var factorttt = 131072;
for (var i = 0; i < 25; i++) {
	scalesttt.push((1.0 / factorttt * Math.pow(2, i)));
}

//Korea Central Belt
//[전지구 좌표계]
//*Bessel 1841 경위도
//EPSG:4004, EPSG:4162 (Korean 1985)
//+proj=longlat +ellps=bessel +no_defs +towgs84=-145.907,505.034,685.756,-1.162,2.347,1.592,6.342
//
//*GRS80 경위도
//EPSG:4019, EPSG:4737 (Korean 2000)
//+proj=longlat +ellps=GRS80 +no_defs
//
//[UTM]
//*UTM52N (WGS84)
//EPSG:32652
//+proj=utm +zone=52 +ellps=WGS84 +datum=WGS84 +units=m +no_defs
//
//*UTM51N (WGS84)
//EPSG:32651
//+proj=utm +zone=51 +ellps=WGS84 +datum=WGS84 +units=m +no_defs


Proj4js.defs["EPSG:4326"] = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs";
Proj4js.defs["EPSG:900913"] = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs";
Proj4js.defs["EPSG:5178"] = "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";
Proj4js.defs["EPSG:5179"] = "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";

Proj4js.defs["EPSG:2096"] = "+proj=tmerc +lat_0=38 +lon_0=129 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";
Proj4js.defs["EPSG:2097"] = "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";
Proj4js.defs["EPSG:2098"] = "+proj=tmerc +lat_0=38 +lon_0=125 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";

Proj4js.defs["EPSG:5173"] = "+proj=tmerc +lat_0=38 +lon_0=125.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";
Proj4js.defs["EPSG:5174"] = "+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";
Proj4js.defs["EPSG:5175"] = "+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=550000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";
Proj4js.defs["EPSG:5176"] = "+proj=tmerc +lat_0=38 +lon_0=129.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43";
Proj4js.defs["EPSG:5177"] = "+proj=tmerc +lat_0=38 +lon_0=131.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-146.43,507.89,681.46";

Proj4js.defs["EPSG:5180"] = "+proj=tmerc +lat_0=38 +lon_0=125 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:5181"] = "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:5182"] = "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=550000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:5183"] = "+proj=tmerc +lat_0=38 +lon_0=129 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:5184"] = "+proj=tmerc +lat_0=38 +lon_0=131 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs";

Proj4js.defs["EPSG:5185"] = "+proj=tmerc +lat_0=38 +lon_0=125 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:5186"] = "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:5187"] = "+proj=tmerc +lat_0=38 +lon_0=129 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:5188"] = "+proj=tmerc +lat_0=38 +lon_0=131 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m +no_defs";
Proj4js.defs["EPSG:3857"] = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs";
var projArr = [
	{val : 5174, text: '[EPSG:5174] :  [보정된 오래된 지리원 표준]중부원점(Bessel) – KLIS에서 중부지역에 사용중'}
	  ,{val : 5173, text: '[EPSG:5173] :  [보정된 오래된 지리원 표준]서부원점(Bessel) – KLIS에서 서부지역에 사용중'}
	  ,{val : 5175, text: '[EPSG:5175] :  [보정된 오래된 지리원 표준]제주원점(Bessel) – KLIS에서 제주지역에 사용중'}
	  ,{val : 5176, text: '[EPSG:5176] :  [보정된 오래된 지리원 표준]동부원점(Bessel) – KLIS에서 동부지역에 사용중'}
	  ,{val : 5177, text: '[EPSG:5177] :  [보정된 오래된 지리원 표준]동해(울릉)원점(Bessel) – KLIS에서 울릉지역에 사용중'}

	  ,{val : 4326, text: '[EPSG:4326] : WGS84 : 경위도 -> GPS가 사용하는 좌표계'}
	  ,{val : 900913, text: '[EPSG:900913] : Google Mercator - 구글지도/빙지도/야후지도/OSM 등 에서 사용중인 좌표계'}
	  ,{val : 5178, text: '[EPSG:5178] :  UTM-K (Bessel) – 새주소지도에서 사용 중'}
	  ,{val : 5179, text: '[EPSG:5179] :  UTM-K (GRS80) - 네이버지도에서 사용중인 좌표계'}
	  
	  ,{val : 2096, text: '[EPSG:2096] : [보정안된 오래된 지리원 표준]동부원점(Bessel)'}
	  ,{val : 2097, text: '[EPSG:2097] : [보정안된 오래된 지리원 표준]중부원점(Bessel)'}
	  ,{val : 2098, text: '[EPSG:2098] : [보정안된 오래된 지리원 표준]서부원점(Bessel)'}
	  

	  ,{val : 5180, text: '[EPSG:5180] :  [타원체 바꾼 지리원 표준]서부원점(GRS80)'}
	  ,{val : 5181, text: '[EPSG:5181] :  [타원체 바꾼 지리원 표준]중부원점(GRS80), 다음지도에서 사용중인 좌표계'}
	  ,{val : 5182, text: '[EPSG:5182] :  [타원체 바꾼 지리원 표준]제주원점(GRS80)'}
	  ,{val : 5183, text: '[EPSG:5183] :  [타원체 바꾼 지리원 표준]동부원점(GRS80)'}
	  ,{val : 5184, text: '[EPSG:5184] :  [타원체 바꾼 지리원 표준]동해(울릉)원점(GRS80)'}
	  
	  ,{val : 5185, text: '[EPSG:5185] :  [현재 국토지리정보원 표준]서부원점(GRS80)'}
	  ,{val : 5186, text: '[EPSG:5186] :  [현재 국토지리정보원 표준]중부원점(GRS80)'}
	  ,{val : 5187, text: '[EPSG:5187] :  [현재 국토지리정보원 표준]동부원점(GRS80)'}
	  ,{val : 5188, text: '[EPSG:5188] :  [현재 국토지리정보원 표준]동해(울릉)원점(GRS80)'}
	  ,{val : 3857, text: '[EPSG:3857] : 환경평가등급도'}
	];

function toRadians(angleInDegrees) {
	return angleInDegrees * Math.PI / 180;
}

function toDegrees(angleInRadians) {
	return angleInRadians * 180 / Math.PI;
}

function offset(c1, distance, bearing) {
	var lat1 = toRadians(c1[1]);
	var lon1 = toRadians(c1[0]);
	var dByR = distance / 6378137; // distance divided by 6378137 (radius of the earth) wgs84
	var lat = Math.asin(
		Math.sin(lat1) * Math.cos(dByR) +
		Math.cos(lat1) * Math.sin(dByR) * Math.cos(bearing));
	var lon = lon1 + Math.atan2(
			Math.sin(bearing) * Math.sin(dByR) * Math.cos(lat1),
			Math.cos(dByR) - Math.sin(lat1) * Math.sin(lat));
	
	return [toDegrees(lon), toDegrees(lat)];
}
function circleToPolygon(center, radius, numberOfSegments) {
	var n = numberOfSegments ? numberOfSegments : 32;
	var flatCoordinates = [];
	var coordinates = [];
	for (var i = 0; i < n; ++i) {
		flatCoordinates.push.apply(flatCoordinates, offset(center, radius, 2 * Math.PI * i / n));
	}
	
	flatCoordinates.push(flatCoordinates[0], flatCoordinates[1]);

	for (var i = 0, j = 0; j < flatCoordinates.length; j += 2) {
		coordinates[i++] = flatCoordinates.slice(j, j + 2);
	}

	return {
		type: 'Polygon',
		coordinates: [coordinates.reverse()]
	};
}

// 포인트가 폴리곤에 포함하는지 여부
function ptInPolygon(pt, polygon) {
    var x = pt[0], y = pt[1];
    var inside = false;
    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
        var xi = polygon[i][0], yi = polygon[i][1];
        var xj = polygon[j][0], yj = polygon[j][1];
        var intersect = ((yi > y) != (yj > y))
            && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
    }
    return inside;
}
//폴리곤1이 폴리곤2에 포함하는지 여부
function polygonInPolygon(polygon1, polygon2) {
    for (var i = 0; i < polygon1.length;i++) {
    	if(ptInPolygon(polygon1[i],polygon2) == false) {
    		return false;
    	}
    }
    return true;
}