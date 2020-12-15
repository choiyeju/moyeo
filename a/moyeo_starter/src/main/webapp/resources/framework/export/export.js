// 엑셀(.xls)내보내기
function fnExcelReport(tableId, filename) {
	//getCsvString(tableId,filename)

    var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
    tab_text = tab_text + '<head><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>';

    tab_text = tab_text + '<x:Name>Sheet</x:Name>';

    tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
    tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';

    tab_text = tab_text + "<table border='1px'>";
    var tHTML = $('#'+tableId).html();
    
    //console.log("tHtml : " + tHTML);
    tHTML = tHTML.replace("hidden","");
    tab_text = tab_text + tHTML;//$('#'+tableId).html();
    tab_text = tab_text + '</table></body></html>';
    var data_type = 'data:application/vnd.ms-excel;charset=euc-kr';
    
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE ");
    
    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
        if (window.navigator.msSaveBlob) {
            var blob = new Blob([tab_text], {
                type: "application/csv;charset=utf-8"
            });
            navigator.msSaveBlob(blob, filename+'.xls');
        }
    } else {
    	var href = data_type + ',%EF%BB%BF' + encodeURIComponent(tab_text);
        //$('#test').attr('href', data_type + ',%EF%BB%BF' + encodeURIComponent(tab_text));
        //$('#test').attr('download', filename+'.xls'); //.csv   .xls
        var a = document.createElement('a');
        a.setAttribute('style', 'display:none');
        a.setAttribute('href', href);
        a.setAttribute('download', filename+'.xls');
        document.body.appendChild(a);
       // console.log("href:"+href);
        a.click()
        a.remove();
    }
 }
var imgArr = [];
//한글(.hwp) 내보내기 
function fnHwpReport(jsonId, filename) {
	//getCsvString(tableId,filename)
    var tab_text = '<%@ page language="java" contentType="application/vnd.hwp;charset=utf-8" pageEncoding="utf-8"%>';
    tab_text += '<html xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:hml="http://www.haansoft.com/HWPML">';
    tab_text = tab_text + '<head><meta http-equiv=Content-Type Content="application/hwp; charset=utf-8"></head><body>';
    var imgSrcArr=[];
    $.each(jsonId, function(key,value){
//    	console.log("key:"+key + "value:"+value);
    	var tableId = key;
	    var cont_box = $('#'+tableId); //stab_cont_box land1_1_stab_cont_box
	    if(key == "where1_1_stab_cont_box") {//위치정보
	    	tab_text += '도로명주소</br>';
	    	var table1 = $('#roadTable').get(0);
	    	var chHTML1 = table1.outerHTML;
	    	chHTML1 = tableReplace(chHTML1);
	    	tab_text +=chHTML1;
	    	tab_text += '</br></br>지번주소</br>';
	    	var table2 = $('#landTable').get(0);
	    	var chHTML2 = table2.outerHTML;
	    	chHTML2 = tableReplace(chHTML2);
	    	//console.log("aTagReplace");
	    	chHTML2 =aTagReplace(chHTML2);
	    	tab_text +=chHTML2;
		}else{
		    $.each(cont_box.children(), function(key, value){
		    	var chHTML = cont_box.children()[key].outerHTML;
		    	if(value.tagName == "TABLE"){
		    		chHTML = tableReplace(chHTML);
		    		tab_text +=chHTML;
		    	}else if(value.tagName == "DIV"){
			        console.log("id:"+value.id+" tagName:"+value.tagName + " className:"+value.className);  //className
		    		var iChild = value.childElementCount;
		    		var bChild =(iChild > 0);
		    		if(bChild){
			    		if(value.className.indexOf("chart") >-1){
			    			var today = new Date().getTime();
			    			var imgNm ="hwpImg_"+value.id+today;
			    			var w =value.offsetWidth;
			    			var h =value.offsetHeight;
			    			var imgsrc='<IMG src=".\\{2}.svg" width="{0}" height="{1}" border="1"/>';
			    			imgsrc = String.format(imgsrc,w,h,imgNm);
			    			tab_text +=imgsrc;
			    			prepareImgDownload(value.id, imgNm);
			    		} else if(value.children[0].tagName =="CANVAS"){
			    			var today = new Date().getTime();
			    			var imgNm ="hwpImg_"+value.id+today;
			    			var w =value.offsetWidth;
			    			var h =value.offsetHeight;
			    			var imgsrc='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
			    			imgsrc = String.format(imgsrc,w,h,imgNm);
			    			console.log(imgsrc);
			    			tab_text +=imgsrc;
			    			prepareImgDownload(value.id, imgNm+".png");
			    		} else if(value.children[0].tagName =="BUTTON"){
			    			console.log("BUTTON");
			    		} else { // else if(value.children[0].tagName =="SPAN"){
			    			 chHTML = chHTML.replace(/input/g,"label");
			    			 chHTML = chHTML.replace(/\<a +\>/g,"");
			    			 chHTML = chHTML.replace(/\<\/a\>/g,""); 
			    			 chHTML = chHTML.replace(/common\.js\*\/\"\>/g,"");
			    			 tab_text += chHTML;
			    		}
		    		}
		    	}else if(value.tagName == "CANVAS"){
		    		var today = new Date().getTime();
	    			var imgNm ="hwpImg_"+value.parentElement.id+today;
	    			var w =value.offsetWidth;
	    			var h =value.offsetHeight;
	    			var imgsrc='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
	    			imgsrc = String.format(imgsrc,w,h,imgNm);
	    			//console.log(imgsrc);
	    			tab_text +=imgsrc;
	    			prepareImgDownload(value.parentElement.id, imgNm+".png");
		    	} else {
		    		 tab_text += chHTML;
		    	}
		    	
		    });
		}
	    tab_text += '</br></br>';
    });
    tab_text += '</body>';
   /* tab_text += '<TAIL><BINDATASTORAGE>';
    for (var i = 0; i < imgSrcArr.length; i++) {
    	var format = '<BINDATA Compress="true" Encoding="Base64" Id="{0}" Size="135">{1}</BINDATA>';
    	tab_text +=String.format(format,i+1,imgSrcArr[i]);
	}
    tab_text += '</BINDATASTORAGE></TAIL>';*/
    tab_text += '</html>';
    var data_type = 'data:application/hwp;charset=utf-8';
    
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE ");
    
    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
        if (window.navigator.msSaveBlob) {
            var blob = new Blob([tab_text], {
                type: "application/hwp;charset=utf-8"
            });
            navigator.msSaveBlob(blob, filename+'.hwp');
        }
    } else {
    	var href = data_type + ',\uFEFF' + encodeURIComponent(tab_text); // %EF%BB%BF \uFEFF  windows-1252 base64,77u/
        var a = document.createElement('a');
        a.setAttribute('style', 'display:none');
        a.setAttribute('href', href);
        a.setAttribute('download', filename+'.hwp');
        document.body.appendChild(a);
        a.click()
        a.remove();
    }
 }
//function fnHwpReport(jsonId, filename) {
//	//getCsvString(tableId,filename)
//    var tab_text = '<%@ page language="java" contentType="application/vnd.hwp;charset=utf-8" pageEncoding="utf-8"%>';
//    tab_text += '<html xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:hml="http://www.haansoft.com/HWPML">';
//    tab_text = tab_text + '<head><meta http-equiv=Content-Type Content="application/hwp; charset=utf-8"></head><body>';
//    var imgSrcArr=[];
//    $.each(jsonId, function(key,value){
//    	console.log("key:"+key + "value:"+value);
//    	var tableId = key;
//	    var cont_box = $('#'+tableId); //stab_cont_box land1_1_stab_cont_box
//	    if(key == "where1_1_stab_cont_box") {//위치정보
//	    	tab_text += '도로명주소</br>';
//	    	var table1 = $('#roadTable').get(0);
//	    	var chHTML1 = table1.outerHTML;
//	    	chHTML1 = tableReplace(chHTML1);
//	    	tab_text +=chHTML1;
//	    	tab_text += '</br></br>지번주소</br>';
//	    	var table2 = $('#landTable').get(0);
//	    	var chHTML2 = table2.outerHTML;
//	    	chHTML2 = tableReplace(chHTML2);
//	    	tab_text +=chHTML2;
//		}else{
//		    $.each(cont_box.children(), function(key, value){
//		    	var chHTML = cont_box.children()[key].outerHTML;
//		        console.log("tagName:"+value.tagName + " className:"+value.className);  //className
//		    	if(value.tagName == "TABLE"){
//		    		chHTML = tableReplace(chHTML);
//		    		tab_text +=chHTML;
//		    	}else if(value.tagName == "DIV"){
//		    		var iChild = value.childElementCount;
//		    		var bChild =(iChild > 0);
//		    		if(bChild){
//			    		if(value.className.indexOf("chart") >-1){
//			    			var chartID = value.id;
//			    			var w =value.offsetWidth;
//			    			var h =value.offsetHeight;
//	//		    			tab_text += canvasSave(chartID,w,h);
//			    			var today = new Date().getTime();
//			    			var imgNm ="hwpImg_"+chartID+today;
//			    			var imgsrc='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
//			    			imgsrc = String.format(imgsrc,w,h,imgNm);
//			    			tab_text +=imgsrc;
//			    			prepareImgDownload(chartID, imgsrc);
//			    			/* 1차 완료;  chart -> img 생성 > 저장
//			    			var imgNm = fnImage(chartID);
//			    			var imgFormat='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
//			    			var imgsrc = String.format(imgFormat,w,h,imgNm);
//			    			tab_text +=imgsrc;
//			    			console.log("img");
//			    			 */
//			    			/*if(iChild > 1 ){
//			    				 2차 완료; hidden img 저장 
//			    				var len = value.children.length-1;//value.children[1].tagName=="IMG"){
//			    				var src = value.children[len].src;
//			    				var imgNm ="hwpImg_"+chartID+(new Date().getTime());
//				    			var imgFormat='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
//				    			var imgsrc = String.format(imgFormat,w,h,imgNm);
//				    			imageSave(src, imgNm); // imageSave() => common.js
//				    			tab_text +=imgsrc;
//				    			
//				    			
//			    				 한글파일에 직접 이미지 생성 (오류)
//			    				imgSrcArr.push(src);
//			    				w =value.children[1].offsetWidth;
//			    				h =value.children[1].offsetHeight;
//			    				var cnt = imgSrcArr.length;
//			    				var imgFormat2= '<PICTURE Reverse="false">'
//			    				+'<SIZE Height="{0}" HeightRelTo="Absolute" Protect="false" Width="{1}" WidthRelTo="Absolute"/>'
//			    				+'<IMAGE BinItem="{2}" Bright="0" Contrast="0" Effect="RealPic"/>';
//			    				+'</PICTURE>';
//			    				var imgsrc2 = String.format(imgFormat2,h,w,cnt);
//			    				//var url = src.replace(/^data:image\/[^;]/, 'data:application/octet-stream');]
//			    				var imgFormat2='<IMAGE src="{2}" width="{0}" height="{1}" border="1"/>';
//			    				var imgsrc2 = String.format(imgFormat2,w,h,src);
//			    				tab_text +=imgsrc2;
//			    			}*/
//			    		} else if(value.children[0].tagName =="CANVAS"){
//			    			var canvasID = value.children[0].id;
//			    			var w =value.offsetWidth;
//			    			var h =value.offsetHeight;
//			    			console.log("CANVAS");
//			    			
//			    			
//			    			if(value.children[0].childElementCount > 0){
//				    			var src = value.children[0].children[0].src;
//			    				var imgNm ="mapImg_"+canvasID+(new Date().getTime());
//				    			var imgFormat='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
//				    			var imgsrc = String.format(imgFormat,w,h,imgNm);
//				    			imageSave(src, imgNm); // imageSave() => common.js
//				    			tab_text +=imgsrc;	
//			    			}else{ //[지도 캡처] 바로 저장 //////////////////////////////////////////////////////////
//	//		    				tab_text += canvasSave(canvasID,w,h);
//			    				var today = new Date().getTime();
//				    			var imgNm ="hwpImg_"+canvasID+today;
//				    			var imgsrc='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
//				    			imgsrc = String.format(imgsrc,w,h,imgNm);
//				    			tab_text +=imgsrc;	
//				    			prepareImgDownload(canvasID, imgsrc);
//			    			}
//			    			
//			    			
//			    		} else if(value.children[0].tagName =="BUTTON"){
//			    			console.log("BUTTON");
//			    		}// else if(value.children[0].tagName =="SPAN"){
//			    		else{
//			    			 chHTML = chHTML.replace(/input/g,"label");
//			    			 chHTML = chHTML.replace(/\<a +\>/g,"");
//			    			 chHTML = chHTML.replace(/\<\/a\>/g,"");
//			    			 tab_text += chHTML;
//			    		}
//		    		}
//		    	}else if(value.tagName == "CANVAS"){
//		    		var canvasID = value.id;
//		    		var w =value.offsetWidth;
//	    			var h =value.offsetHeight;
//	//    			tab_text += canvasSave(canvasID,w,h);
//	    			var today = new Date().getTime();
//	    			var imgNm ="hwpImg_"+canvasID+today;
//	    			var imgsrc='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
//	    			imgsrc = String.format(imgsrc,w,h,imgNm);
//	    			tab_text +=imgsrc;	
//	    			prepareImgDownload(canvasID, imgsrc);
//		    	} else {
//		    		 tab_text += chHTML;
//		    	}
//		    	
//		    });
//		}
//	    tab_text += '</br></br>';
//    });
//    tab_text += '</body>';
//   /* tab_text += '<TAIL><BINDATASTORAGE>';
//    for (var i = 0; i < imgSrcArr.length; i++) {
//    	var format = '<BINDATA Compress="true" Encoding="Base64" Id="{0}" Size="135">{1}</BINDATA>';
//    	tab_text +=String.format(format,i+1,imgSrcArr[i]);
//	}
//    tab_text += '</BINDATASTORAGE></TAIL>';*/
//    tab_text += '</html>';
//    var data_type = 'data:application/hwp;charset=utf-8';
//    
//    var ua = window.navigator.userAgent;
//    var msie = ua.indexOf("MSIE ");
//    
//    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
//        if (window.navigator.msSaveBlob) {
//            var blob = new Blob([tab_text], {
//                type: "application/hwp;charset=utf-8"
//            });
//            navigator.msSaveBlob(blob, filename+'.hwp');
//        }
//    } else {
//    	var href = data_type + ',\uFEFF' + encodeURIComponent(tab_text); // %EF%BB%BF \uFEFF  windows-1252 base64,77u/
//        var a = document.createElement('a');
//        a.setAttribute('style', 'display:none');
//        a.setAttribute('href', href);
//        a.setAttribute('download', filename+'.hwp');
//        document.body.appendChild(a);
//        a.click()
//        a.remove();
//    }
// }
//table tag 변환
function tableReplace(chHTML){
	chHTML = chHTML.replace("<table","<table border='1' ");
	var pStyle = /style="background:#[a-zA-Z0-9]{6};/gi;  //('style="background:','bgcolor="');
	var resultpStyle = chHTML.match(pStyle);
	var pStyle2 = / (style="background-image: url\([^)]+){1}(\)\; background-position:[^\>]+>){1}\<\/td\>/gi;  //style="background-image: url(&quot;http://220.85.161.121/geoserver/starter/wms/image?service=image&amp;request=GetLegendGraphic&amp;layer=g_klis&amp;style=g_klis&amp;format=image/png&amp;transparent=true&amp;width=77&amp;height=29&amp;Rule=자연녹지지역&quot;); background-position: 18% 31%;">
	var resultpStyle2 = chHTML.match(pStyle2);
	//console.log("resultM");
	if(resultpStyle!=null){
		for (var i = 0; i < resultpStyle.length; i++) {
			var pColor = /#[a-zA-Z0-9]{6}/g;
			var style =resultpStyle[i];
			var color = pColor.exec(style);
			var bgcolor = 'bgcolor="{0}" ';
			bgcolor = String.format(bgcolor,color);
			chHTML=chHTML.replace(style,bgcolor+style);
			console.log("bgcolor:"+bgcolor);
		}
	}
	if(resultpStyle2!=null){
		for (var i = 0; i < resultpStyle2.length; i++) {
			var pRule = /Rule=.*\"/g;
			var style =resultpStyle2[i];
			var rules = pRule.exec(style);
			if(rules.length>0){
				var rule = rules[0].replace("Rule=","");
				var iR = rule.indexOf("&");
				if(iR>-1){
					rule = rule.substring(0,iR);
					console.log("rule:"+rule);
					var img =getLegendGraphicSave(rule);
					chHTML=chHTML.replace(style,">"+img+"</td>");
				}
			}
		}
	}
	return chHTML;
}
// a tag 변환
function aTagReplace(chHTML){
	console.log("aTagReplace");
	var pATag = /\<a .*\>[가-힣]*\<\/a\>/g;  //'<a class="btn_info" href="javascript:where_pnu(&quot;1120011400106850703&quot;);">위치</a>'
	var resultATag = chHTML.match(pATag);
	//console.log("resultM");
	if(resultATag!=null){
		for (var i = 0; i < resultATag.length; i++) {
			var aTag =resultATag[i];
			chHTML=chHTML.replace(aTag,"");
			console.log("aTag:"+i+aTag);
		}
	}
	return chHTML;
}
//캔버스 저장
function canvasSave(canvasID,w,h, fn){  // async  await
	var object = $("#"+canvasID).get(0);
	var today = new Date().getTime();
	var imgNm ="hwpImg_"+canvasID+today;
	html2canvas(object,{allowTaint: true,useCORS: true}).then(function(canvas) {
		var DataURL = canvas.toDataURL("image/png");
		console.log(canvasID+"::::::"+DataURL);
		var a = document.createElement("a");
		a.download = imgNm+".png";
	    a.href = DataURL;
	    $(a).click(function(){
//	    	$.fileDownload($(this).prop('href')).done(function () { 
		    a.remove();
//			}).fail(function () { alert('File download failed!');});
	    });
	    a.click();
	});
	var imgsrc='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
	imgsrc = String.format(imgsrc,w,h,imgNm);
	return imgsrc;
}
//geoServer [g_klis] 범례 이미지 저장
function getLegendGraphicSave(rule,w=77,h=30){ 
	var today = new Date().getTime();
	var imgNm ="hwpImg_LegendGraphic_"+rule+today;
	var path = geoserverurl+"wms/image?service=image&request=GetLegendGraphic&layer=g_klis&style=g_klis&format=image/png&transparent=true&width="+w+"&height="+h+"&Rule="+rule;
	console.log(path);
	var x=new XMLHttpRequest();
	x.open("GET", path, true);
	x.responseType = 'blob';
	x.onload=function(e){download(x.response, imgNm+".png", "image/png" ); }
	x.send();
	var imgsrc='<IMG src=".\\{2}.png" width="{0}" height="{1}" border="1"/>';
	imgsrc = String.format(imgsrc,w,h,imgNm);
	return imgsrc;
}

//1000*1000 JSON 속도 TEST
function geojsonTest(){
	var testAreaJson = L.geoJson();
	mymap.map.addLayer(testAreaJson);
	var start = new Date().getTime();
	setTimeout(function(){
	var len = 1000;
	var testArea =[];
	//var testAreaJson = L.geoJson();
	for (var i = 0; i < len; i++) {
		for (var k = 0; k < len; k++) {
			var indx= i*k;
			var json = [{"type": "Feature","properties": {"uuid": "","name": null,"visible": 1,}, "geometry": {"type": "Polygon","coordinates": [[126.22856915360848, 34.501144458414025],[126.23231451177354, 34.50116804963054],[126.2319819785838, 34.49943521737735],[126.22919744763965, 34.499129224944916],[126.22856915360848, 34.501144458414025]]}}];
			testArea.push(json);
		}//"indx":indx,"i":i,"k":k,"test1":"test1test1test1test1test1test1test1test1test1test1","test2":"test2test2test2test2test2test2test2test2test2test2","test3":"test3test3test3test3test3test3test3test3test3test3",
		
	}
	testAreaJson = L.geoJSON(testArea, {
		style: function(feature) {
			return {"fill":true, "color": "#ff0000",   "weight": 1,  "opacity": 1 , "fillOpacity":0.9,"fillColor": "#ff0000"};
		}
	}).addTo(mymap.map);
	var elapsed = new Date().getTime() - start;
	console.log("소요된 시간: " + elapsed +"ms "+elapsed/1000+"s");
	});
	//mymap.map.addLayer(testAreaJson);
}

 function exportTableToCsv(tableId, filename) {
    if (filename == null || typeof filename == undefined)
        filename = tableId;
    filename += ".xls";

    var bom = '\uFEFF';
    var tarr = ["roadTable","landTable"];
    var csvString = "";
for (var i = 0; i < tarr.length; i++) {
	var tableId = tarr[i];
    var table = document.getElementById(tableId);
   
    for (var rowCnt = 0; rowCnt < table.rows.length; rowCnt++) {
        var rowData = table.rows[rowCnt].cells;
        for (var colCnt = 0; colCnt < rowData.length; colCnt++) {
            var columnData = rowData[colCnt].innerHTML;
            if (columnData == null || columnData.length == 0) {
                columnData = "".replace(/"/g, '""');
            }
            else {
                columnData = columnData.toString().replace(/"/g, '""'); // escape double quotes
            }
            csvString = csvString + '"' + columnData + '",';
        }
        csvString = csvString.substring(0, csvString.length - 1);
        csvString = csvString + "\r\n";
    }
}
    csvString = csvString.substring(0, csvString.length - 1);
    csvString = bom+csvString;
    // Deliberate 'false', see comment below
    if (window.navigator && window.navigator.msSaveOrOpenBlob) {

        var blob = new Blob([decodeURIComponent(csvString)], {
            type: 'text/csv;charset=utf-8'
        });
       
        // Crashes in IE 10, IE 11 and Microsoft Edge
        // See MS Edge Issue #10396033: https://goo.gl/AEiSjJ
        // Hence, the deliberate 'false'
        // This is here just for completeness
        // Remove the 'false' at your own risk
        window.navigator.msSaveOrOpenBlob(blob, filename);
        console.log("navigator:"+blob);

    } else if (window.Blob && window.URL) {
        // HTML5 Blob
        var blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });//%EF%BB%BF   \uFEFF  windows-1252 base64,77u/
        var csvUrl = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.setAttribute('style', 'display:none');
        a.setAttribute('href', csvUrl);
        a.setAttribute('download', filename);
        document.body.appendChild(a);
        console.log("Blob:"+csvUrl);
        a.click()
        a.remove();
    } else {
        // Data URI
        var csvData = 'data:application/csv;charset=utf-8' + encodeURIComponent(csvString);
        var blob = new Blob([csvString], { type: 'text/csv;charset=euc-kr' });
        var csvUrl = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.setAttribute('style', 'display:none');
        a.setAttribute('target', '_blank');
        a.setAttribute('href', csvData);
        a.setAttribute('download', filename);
        document.body.appendChild(a);
        a.click()
        a.remove();
        console.log("csvData:"+csvData);
    }
}
 
