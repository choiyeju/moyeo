// 로딩 화면 띄우기
function loading(divid, msg, cnt) {
	if(divid == null) divid = 'body';
	if(cnt != null)
		loadingCnt = cnt;
	else loadingCnt = 1;
	if(msg != null)
		$(".jquery-loading-modal__text").html(msg);
	$(divid).loadingModal({text: msg},'show');
}

var loadingCnt = 1;
var loadingNum = 0;
//로딩 화면 닫기
function loading_close(divid) {
	if(divid == null) divid = 'body';
	loadingNum++;
//	console.log(loadingNum+":"+loadingCnt);
	if(loadingCnt <= loadingNum) {
		$(divid).loadingModal('hide');
		loadingCnt = 1;
		loadingNum = 0;
	}
}

function isIE() {
var agent = navigator.userAgent.toLowerCase();
	if ( (navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)) {
	     // ie일 경우
		return true;
	}else{
	     // ie가 아닐 경우
		return false;
	}
}

// JSon clone 처리
function jsonClone(json) {
	return JSON.parse(JSON.stringify(json));
}

//작업 UUID => 레이어 추가 기능(addLayer()) 실행 시 실행 
function generateUUID() { // Public Domain/MIT
    var d = new Date().getTime();
    if (typeof performance !== 'undefined' && typeof performance.now === 'function'){
        d += performance.now(); //use high-precision timer if available
    }
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = (d + Math.random() * 16) % 16 | 0;
        d = Math.floor(d / 16);
        return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
    });
//	function s4() {
//	      return ((1 + Math.random()) * 0x10000 | 0).toString(16).substring(1);
//	    }
//	    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

// chart c3
// 차트그리기
var g_fontFamily="돋움체"; // 한글 깨짐 방지를 위한 글꼴 설정 
function chartLine(id, data, unit='℃', _xgrid){
	$("#"+id).empty();
	if(typeof data =='undefined' || data == null) {return;}
	else if(data.length == 0 ) {return;}
	var axisX ={"type": 'category'};
	var xgrid = {};

	if(typeof _xgrid =='undefined' || _xgrid == null){
		axisX ={"type": 'category'}
	}else {
		axisX={"type": 'indexed'};
		xgrid = {"lines": _xgrid};
	}
	var chart = c3.generate ({
	    bindto: '#'+id,
	    data: {
	      x: 'x', // x축 이름 
	      columns: data,
	      labels: true
	    },
	    axis: {
	    	x: axisX, 
	    	/*
	    	{
	             type: 'category' //'category' this needed to load string x value
	         },*/
	        y: {
	          label: {
	            text: unit,
	            position: 'outer-top'
	          },
	          tick: {
	        	  //count:10,
	        	  format:function(x){return parseInt(x)}
	            // format: d3.format("$,") // ADD
	          }
	        }
	    },
	      tooltip: {
	          show: false
	      },
	      grid:{
	    	  x: xgrid,
	    	  y:{show:true}
	      },
	      onrendered :function(){
	    	  //console.log("chartLine >> onrendered  ");
	    	  if($("#"+ id +" > svg > g .c3-chart-lines").length !=0){
	    		  $("#"+ id +" > svg > g .c3-chart-lines").prop("style").fill="none";	
		    	  $("#"+ id +" > svg > g .c3-xgrid-lines").prop("style").fill="none";//구역계 선 스타일 설정
		    	  $("#"+ id +" > svg > g .c3-xgrid-lines").prop("style").stroke="red";//구역계  선 스타일 설정	 
		    	  $.each($("#"+ id +" > svg > g text"), function(key,value) {
		    		  value.style.fontFamily=g_fontFamily;
		    	  });	   
		    	  $("#"+ id +" > img").remove();
	    	  }
//	    	  prepareImgServer(id); 
	      }
	    
	
	});
	chart.flush();
}
//이미지(src)  저장
function imageSave(src, name){
	var a = document.createElement("a");
	a.download = name+".png";
    a.href = src;
    a.click();
    a.remove();
}
var isChartLineBar = 0;
function chartLineBar(id, data, barDataName){
	$(id).empty();
	isChartLineBar = 0;
	if(typeof data =='undefined' || data == null) {return;}
	else if(data.length == 0 ) {return;}
	
	var chart = c3.generate ({
	    bindto: '#'+id,
	  /*  padding: {
	        top: 5,
	        right: 30,
	        bottom: 5,
	        left: 30,
	    },*/
	    data: {
	      x: 'x', // x축 이름 
	      columns: data,
	      labels: true,
	      axes: {
	          [barDataName]: 'y2'
	        },
	      types: {
	    	  [barDataName]: 'bar'
	        }
	    },
	    axis: {
	    	x: { 
	    		type: 'category' // this needed to load string x value
	    		/*label: {
	            text: '월',
	            position: 'outer-middle'
	    		}*/
	    	},
	        y: {
	          label: {
	            text: '평균기온(℃)',
	            position: 'outer-top'
	          },
	          tick: {
	            // format: d3.format("$,") // ADD
	          }
	        },
	        y2: {
	          show: true,
	          label: {
	            text: barDataName+'(mm)',
	            position: 'outer-top'
	          }
	        }
	      },
	      tooltip: {
	          show: false
	      },
	      grid:{
	    	  y:{show:true}
	      },
	      onrendered :function(){
	    	 // console.log("chartLineBar >> onrendered  ");
	    	  if($("#"+ id +" > svg > g .c3-chart-lines").length !=0){
		    	  $("#"+ id +" > svg > g .c3-chart-lines").prop("style").fill="none";	
		    	  $("#"+ id +" > svg > g .c3-legend-item").prop("style").font="돋움";	//표고
		    	  $("#"+ id +" > svg > g text").prop("style").font="돋움";	//표고
		    	  $.each($("#"+ id +" > svg > g text"), function(key,value) {
		    		  value.style.fontFamily=g_fontFamily;
		    	  });	    		 
		    	  $("#"+id+" > img").remove();
//	    	  prepareImgServer(id); 
	    	  }
	      }
	});
	chart.flush();
}
//chart d3pie
//차트 그리기
function chartCircle(id, cdata){
	$(id).empty();
	if(typeof cdata =='undefined' || cdata == null) {return;}
	else if(cdata.length == 0 ) {return;}
	
	var numCommaLabelFormatter = function (context) {
	    var label = context.label;
	    // if it's a single bird seen, add an exclamation mark to the outer label
	    if (context.section === 'outer') {
	    	label = numComma(label);
	    }else if(context.section === 'inner'){
	    	label = label.toFixed(2);
	    }

	    return label;
	};

	var pie = new d3pie(id, {
		"type": 'pie',
        "size": {
            "canvasHeight": 500,//510,
            "canvasWidth": 500,//400,
            "pieOuterRadius": "55%",
            "pieInnerRadius": "0%"
        },
        "data": {
            "sortOrder": "value-asc",
            "content": cdata,
            "smallSegmentGrouping": {
            	"enabled": true,
            	"value": 1, // 표출 최소값
            	"label": "Other" // (1% 이하) 
            }
        },
        "labels": {
        	formatter: numCommaLabelFormatter,
            "outer": {
                "pieDistance": 32,
                "format": "label",  //label / value /percentage/label-value1/label-value2 /label-percentage1/ label-percentage2
                "font": g_fontFamily //내보내기 시 한글깨짐방지
            },
            "inner": {
                "hideWhenLessThanPercentage": 3, //비율이 3 이하일 경우 inner label 숨김 
                "format": "value"
            },
            "mainLabel": {
                "fontSize": 15,
                "font": g_fontFamily //내보내기 시 한글깨짐방지
            },
            "percentage": {
                "color": "#000000", //"#ffffff",
                "decimalPlaces": 0 // 소수점 자리수
            },
            "value": {
                "color": "#000000",
                "fontSize": 13,
                "font": g_fontFamily //내보내기 시 한글깨짐방지
            },
            "lines": {
                "enabled": true,
                "style":"curved" // curved / straight
            },
            "truncation": {
                "enabled": true,
                "truncateLength":25
            }
        },
        "tooltips": {
            "enabled": false,
            "type": "placeholder", //caption / placeholder
            "string": "{label}: {value}%"
        },
        "effects": {
            "pullOutSegmentOnClick":{
                "effect": "none", // none / linear / bounce / elastic / back
                "speed": 300,
                "size": 8
            }
        },
        "misc": {
        	"colors":{
        		background: null,
        		segmentStroke: "#000000" // 선 색깔 설정 
        	},
            "gradient": {
                "enabled": false,
                "percentage": 100
            }, "canvasPadding": {
    			top: 5,
    			right: 5,
    			bottom: 5,
    			left: 5
    		},"pieCenterOffset": {
    			x: 0,
    			y: -60
    		},
    		"cssPrefix": null
        },
    	header: {
    		location: "pie-center",
    		titleSubtitlePadding: 0
    	},
        "callbacks": {
        	onload: function(){
//        		prepareImgServer(id);
        		},
    		onMouseoverSegment: null,
    		onMouseoutSegment: null,
    		onClickSegment: null
        }
    });
}


//캡쳐한 이미지 다운로드.
function prepareImgDownload(id, filename) {
	var canvas = $("#"+id).children("canvas")[0];
//	console.log(canvas);
	var link = document.createElement('a');
	link.download = filename;
	if(typeof canvas == "undefined") {
		var svg =  $("#"+id).children("svg")[0];
		var xml = new XMLSerializer().serializeToString(svg);
	
		// make it base64
//		var svg64 = window.btoa(encodeURIComponent(xml));
//		link.setAttribute('href', 'data:image/png;base64,'+svg64);
		link.setAttribute('href', 'data:image/svg+xml,'+encodeURIComponent(xml));
	} else {
		link.setAttribute('href', canvas.toDataURL("image/png").replace("image/png", "image/octet-stream"));
	} 
	link.click();
}

// 차트 캡쳐 
function chartCapture(id) {
	$(id).empty(); //document.getElementById("mapid")
	html2canvas($("#mapid")[0]).then(function(canvas) {
		alert(canvas.toDataURL());
		$(id).append(canvas);
		var height = $(id).children("canvas").height();
		var width = $(id).children("canvas").width();
		$(id).children("canvas").css("width","100%"); ///.attr('style', 'height:100% !important');
		var width2 = $(id).children("canvas").width();
		var height2 = height * (width2/width);
		$(id).children("canvas").css("height",height2);
//		prepareImgServer(id); //잠시 막아둠..
    });
}
//지도화면 캡쳐 버튼
function mapCapture(id) {
	$(id).empty();
	leafletImage(mymap.map, function (err, canvas) {
		console.log(err);
		$(id).append(canvas);
		var height = $(id).children("canvas").height();
		var width = $(id).children("canvas").width();
		$(id).children("canvas").css("width","100%");
		var width2 = $(id).children("canvas").width();
		var height2 = height * (width2/width);
		$(id).children("canvas").css("height",height2);
//		prepareImgServer(id); //잠시 막아둠..
	});
}
// 지도화면 캡쳐 버튼
function mapCaptureSelf(id) {
	$(id).empty();
	var canvas = document.createElement('canvas');
	var ctx = canvas.getContext('2d');
	var width = canvas.width = mymap.map.getSize().x;
	var height = canvas.height = mymap.map.getSize().y;
	var psize = 256, startx=0, starty=0;
	var canvasID ="canvas_"+(id.replace("#","")); 
	canvas.id = canvasID; //id 설정
	
	mymap.map.eachLayer(function(layer){
		if (layer instanceof L.TileLayer) {
//			console.log(layer);
			var isCanvasLayer = (L.TileLayer.Canvas && layer instanceof L.TileLayer.Canvas);
			var bounds = mymap.map.getPixelBounds(),
            zoom = mymap.map.getZoom(),
            tileSize = layer.options.tileSize;

			var tileBounds = L.bounds(
					bounds.min.divideBy(tileSize)._floor(),
					bounds.max.divideBy(tileSize)._floor()),
					tiles = [],
					j, i;

			for (j = tileBounds.min.y; j <= tileBounds.max.y; j++) {
				for (i = tileBounds.min.x; i <= tileBounds.max.x; i++) {
					tiles.push(new L.Point(i, j));
				}
			}
			var len = tiles.length;
//			var tilePos= [];
			for (var i = 0; i < len; i++) {
				var tilePoint = tiles[i];
//			tiles.forEach(function (tilePoint) {
				const originalTilePoint = tilePoint.clone();
				if (layer._adjustTilePoint) {
					layer._adjustTilePoint(tilePoint);
				}
				var tilePos = originalTilePoint.scaleBy(new L.Point(tileSize, tileSize)).subtract(bounds.min);
				if (isCanvasLayer) {
					var tile = layer._tiles[originalTilePoint.x + ':' + originalTilePoint.y+":"+1];
					ctx.drawImage(tile, tilePos.x, tilePos.y, psize, psize);
				} else {
					try {
						let img = new Image;
						let x = tilePos.x;
						let y = tilePos.y;
						img.onload = function () {
							ctx.drawImage(img, x, y, psize, psize);
			        	}
			        	img.setAttribute('crossorigin', 'anonymous'); // works for me
						img.src = layer.getTileUrl(originalTilePoint);
					} catch (e) {
						console.log(e);
					}
				}
				
			}//for tiles end
        } else if (layer instanceof L.SingleTile) {
//        	console.log(layer);
        	var img = new Image;
        	img.onload = function () {
        		ctx.drawImage(img, 0,0);
        	}
        	img.setAttribute('crossorigin', 'anonymous'); // works for me
        	img.src = layer._image.src;
        } //else console.log(layer);
		var firstCanvas = mymap.map._panes.overlayPane.getElementsByTagName('canvas').item(0);
        if (firstCanvas) { 
			var bounds = mymap.map.getPixelBounds(),
            origin = mymap.map.getPixelOrigin();
	        var pos = L.DomUtil.getPosition(firstCanvas).subtract(bounds.min).add(origin);
	        try {
	            ctx.drawImage(firstCanvas, pos.x, pos.y, canvas.width - (pos.x * 2), canvas.height - (pos.y * 2));
	        } catch(e) {
	            console.error('Element could not be drawn on canvas', firstCanvas); // eslint-disable-line no-console
	        }
        }
	});
	$(id).append(canvas);
//	$(id).children("canvas")[0].onrendered =function(){  
//		console.log("canvas.onrendered");
//		prepareImgServer(canvasID);
//	}; //img 추가
	var height = $(id).children("canvas").height();
	var width = $(id).children("canvas").width();
	$(id).children("canvas").css("width","100%");
	var width2 = $(id).children("canvas").width();
	var height2 = height * (width2/width);
	$(id).children("canvas").css("height",height2);
//	prepareImgServer(canvasID);
}
// 숫자 3자리마타 콤마 찍기
function numComma(x) {
	try {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	} catch(e){
		return x;
	}
}
// 랜덤하게 컬러값 생성하기
function getRandomColor() {
  var letters = '0123456789ABCDEF';
  var color = '#';
  for (var i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}
//function formatNumber(num) {
//	  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
//	}
function currencyFormat(num, chum) {
	if(chum != null) chum = '';
	return num.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,'); // 00.00 소수점 2자리 강제
}


// 메세지 띄우기
jQuery.alert = function (msg,title) {
    var $alertBox = $.parseHTML('<div id="alertBox"></div>');
    $("body").append($alertBox);
    if(title == null) title = "Warnings";
    $($alertBox).css("z-index",9999);
    $($alertBox).dialog({
        open: $($alertBox).append(msg),
        title: title, moveToTop: true, autoOpen: true, modal: true, resizable:false,
        buttons: {
            OK: function () {
                $($alertBox).dialog("close");
            }
        }
    });
};
// 질문 띄우기
jQuery.confirm = function (msg,title, fn) {
    var $confirmBox = $.parseHTML('<div id="confirmBox"></div>');
    $("body").append($confirmBox);
    if(title == null) title = "Confirm";
    $($confirmBox).css("z-index",9999);
    $($confirmBox).dialog({
        open: $($confirmBox).append(msg),
        title: title, moveToTop: true, autoOpen: true, width:'auto', modal: true,resizable:false,
        buttons: {
            YES: function () {
                $($confirmBox).dialog("close");
                fn(true);
            },
            NO: function () {
                $($confirmBox).dialog("close");
                fn(false);
            }
        }
    });
};



//정렬 기능
//json, key, valueType(int||string), asc(true:오름차순, false:내림차순)
//isCase: 예외 정렬 처리 시 true 
// >> 도로 하위 정렬, 도로:[광,대,중,소], 학교:[대,고,중,초,유치원], 공원:[근린,어린이,소]  
function sortJson(element, prop, propType, asc, isCase) {
	  switch (propType) {
	    case "int":
	      element = element.sort(function (a, b) {    	  
	        if (asc) {
	          return (parseFloat(a[prop]) > parseFloat(b[prop])) ? 1 : ((parseFloat(a[prop]) < parseFloat(b[prop])) ? -1 : 0);
	        } else {
	          return (parseFloat(b[prop]) > parseFloat(a[prop])) ? 1 : ((parseFloat(b[prop]) < parseFloat(a[prop])) ? -1 : 0);
	        }
	      });
	      break;
	    default:
	      element = element.sort(function (a, b) {
	      try{
	    	  var s1 = "";
	    	  var s2 = "";
	      
	    	  s1 = compareText(a[prop],isCase);
	    	  s2 = compareText(b[prop],isCase);
		 			
			 if (asc) {
		          return (s1 > s2) ? 1 : ((s1 < s2) ? -1 : 0);
		        } else {
		          return (s2 > s1) ? 1 : ((s2 < s1) ? -1 : 0);
		        }	    	  
	      } catch (ex){
	    	  console.log(ex);
	      }
	    });
	  }
	}
// 정렬- 예외 처리
// 2020.01.21 시설 위계는 [텍스트] 오름차순 정렬로 변경 요청(메일 수신)
function compareText(text,isCase){
	var s1 ="";
	var road ="도로"; var school="학교"; var park="공원";
	if(typeof text == "undefined" || text == null){ //|| text == ""){
	    s1 = "";
	  }else if(text==g_noValue){
		s1="힣"+noValue;
	  }/*else if(text.indexOf("광로")>-1 && isCase){
		  s1=road+"1"+text;
	  }else if(text.indexOf("대로")>-1 && isCase){
		  s1=road+"2"+text
	  }else if(text.indexOf("중로")>-1 && isCase){
		  s1=road+"3"+text
	  }else if(text.indexOf("소로")>-1 && isCase){
		  s1=road+"4"+text;
	  }else if(text.indexOf("대학")>-1 && isCase){
		  s1=school+"0"+text;
	  }else if(text.indexOf("고등학")>-1 && isCase){
		  s1=school+"1"+text;
	  }else if(text.indexOf("중학")>-1 && isCase){
		  s1=school+"2"+text;
	  }else if(text.indexOf("초등학")>-1 && isCase){
		  s1=school+"3"+text;
	  }else if(text.indexOf("유치원")>-1 && isCase){
		  s1=school+"4"+text;
	  }else if((text.indexOf("근린공")>-1||text.indexOf("근린 공")>-1) && isCase){
		  s1=park+"1"+text;
	  }else if((text.indexOf("어린이공")>-1||text.indexOf("어린이 공")>-1) && isCase){
		  s1=park+"2"+text;
	  }else if(text.indexOf("소공원")>-1 && isCase){
		  s1=park+"3"+text;
	  }*/else {
		s1 =text.toLowerCase();	 		 
	  }
	return s1;
}
// 색상추출 (그라데이션)
// 시작 색상, 끝색상, 추출 갯수
function gradient(startColor, endColor, steps) {
    var start = {
            'Hex'   : startColor,
            'R'     : parseInt(startColor.slice(1,3), 16),
            'G'     : parseInt(startColor.slice(3,5), 16),
            'B'     : parseInt(startColor.slice(5,7), 16)
    }
    var end = {
            'Hex'   : endColor,
            'R'     : parseInt(endColor.slice(1,3), 16),
            'G'     : parseInt(endColor.slice(3,5), 16),
            'B'     : parseInt(endColor.slice(5,7), 16)
    }
    diffR = end['R'] - start['R'];
    diffG = end['G'] - start['G'];
    diffB = end['B'] - start['B'];

    stepsHex  = new Array();
    stepsR    = new Array();
    stepsG    = new Array();
    stepsB    = new Array();

    for(var i = 0; i <= steps; i++) {
            stepsR[i] = start['R'] + ((diffR / steps) * i);
            stepsG[i] = start['G'] + ((diffG / steps) * i);
            stepsB[i] = start['B'] + ((diffB / steps) * i);
            stepsHex[i] = '#' + pad(Math.round(stepsR[i]).toString(16), 2) 
			            + pad(Math.round(stepsG[i]).toString(16), 2) 
			            + pad(Math.round(stepsB[i]).toString(16), 2);
    }
    return stepsHex;
}
//HEX -> RGB
//color : #ff0000
function hex2RGB(color) {
  var start = {
          'Hex'   : color,
          'R'     : parseInt(color.slice(1,3), 16),
          'G'     : parseInt(color.slice(3,5), 16),
          'B'     : parseInt(color.slice(5,7), 16)
  }
 
  return start;
}
//RGB -> HEX
//r:255 g:255 b:255
function RGB2hex(r,g,b) {
	return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
}

// 자리수 맞추기 1-> 01 
function pad(n, width) {
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
}


function selectExProject(wrk_uuid) {
	var flag;
	console.log("wrk_uuid : " + wrk_uuid);
	$.ajax({ type: "post", url : "./qry", async:false,
		data : 'cmd=SELECT_EX_PROJECT&wrk_uuid='+wrk_uuid,
		success : function (response) {
			console.log( response );
			//resultHeaderObject 확인 => process, fail
			if( response.body.result.length == 1 ) {
				flag=true;
			} else {
				console.log("LENGTH : " + response.body.result.length);
				flag=false;
			}
		},
		error: function(xhr,status, error){
			alert("error ! at selectExProject()");
		}
	});
	return flag;
}

function replacer(key,value){
	// JSON to String 시 호출 => work.where.LJSON => null
	if(key == "LJSON") {
		return null;
	}
	return value;
}
//레이어 맵에 추가
function addLayer(jsonlayer, array, fn, title) {
	if(jsonlayer != null)
		mymap.map.removeLayer(jsonlayer);
	jsonlayer = L.geoJson(array, {
		title: title,
		style: fn,
	    onEachFeature: eachFeature
    }).addTo(mymap.map);
	return jsonlayer;
}
//레이어 맵에 추가
function addProjLayer(jsonlayer, array, fn, title) {
	if(jsonlayer != null)
		mymap.map.removeLayer(jsonlayer);
	jsonlayer = L.Proj.geoJson(array, {
		title: title,
		style: fn,
	    onEachFeature: eachFeature
    }).addTo(mymap.map);
	return jsonlayer;
}

/**
 * 숫자체크
 * @param obj
 * @returns {Boolean}
 */
function onlyNumber(obj) {
 if(/[^-0123456789.,]/g.test(obj)) {
  //alert("숫자가 아닙니다.\n0-9의 정수만 허용합니다.");
  obj.value = "";
  return '-';
 }
 return obj;
}

//숫자만 추출
function onlyNum(str){
    var res;
    res = str.replace(/[^0-9]/g,"");
    return res;
}

function objToString (obj) {
    var str = '';
    for (var p in obj) {
        if (obj.hasOwnProperty(p)) {
            str += p + '::' + obj[p] + '\n';
        }
    }
    return str;
}

// x1 y1, x2 y2, ... --> array: [x1 y1][x2 y2]
function parseCoordList( str_data ) {
	
	var ret_str = [];
	
	var inx_s = 0;
	var inx_f = str_data.indexOf(',');
	
	while (inx_f != -1) {
		
		var s_coord = str_data.substr(inx_s, (inx_f - inx_s))
		//console.log( s_coord );
		ret_str.push( s_coord );
		
		inx_s = inx_f + 1;
		inx_f = str_data.indexOf(',', inx_f + 1);
	}
	
	var s_coord = str_data.substr( inx_s );
	//console.log( s_coord );
	
	ret_str.push( s_coord );
	
	return ret_str;
}

//x1 y1 --> array: [x][y]
function parseCoord( str_data ) {
	
	var ret_str = [];
	
	var inx_f = str_data.indexOf(' ');
	
	if (inx_f != -1) {
		
		var xx = str_data.substr(0, inx_f);		
		var yy = str_data.substr(inx_f + 1);
		
		ret_str.push( xx );
		ret_str.push( yy );
	}
	
	return ret_str;
}

//String.format
String.format = function() {
	var theString = arguments[0];

	// start with the second argument (i = 1)
	for (var i = 1; i < arguments.length; i++) {
	var regEx = new RegExp("\\{" + (i - 1) + "\\}", "gm");
	theString = theString.replace(regEx, arguments[i]);
	}

	return theString;
	}
//hwp 내보내기
function hwpExport(jsonPrefix, all){
	var idArr={};
	var mName="";
	$.each(jsonPrefix, function(key,value){
		//console.log("key:"+key + "value:"+value);
		var prefix = key; //land
		var idPrefix =prefix+"_";
		//mName+=("_" + value); //기본정보
		$(".label_check2 input:checkbox[id^='" + idPrefix + "']").each(function(key, value){
			if(value.checked || all){
				var menuName = $(this).parent("span").children("label").text();
				var id = value.value;
				idArr[id]=menuName;
				//mName+=("_" + menuName);
			}
		});
	});
	var obj_length = Object.keys(idArr).length;
	//console.log(obj_length +">>"+idArr);
	if(obj_length>0){
		var fName = all? "종합 검토서":"검토서" + mName;
		fnHwpReport(idArr, fName); // fnHwpReport => export.js
	}else{
		alert("선택된 항목이 없습니다.");
	}
}
//check box disable  
// prefixArr : [where1,building1]
// type : '1'
// 비활성화 여부 :true
function hwpExportCheck(prefixArr, type, isDisabled){
	var idArr={};
	var mName="";
	$.each(prefixArr, function(key,value){
		var prefix = value; //land
		var idPrefix =prefix+"_";
		var isAll = (type==null);
		var typeText = isAll? "":"[id$='"+type+"']"; // id가 typed으로 끝나는 엘리먼트들 접근
		$(".label_check2 input:checkbox[id^='" + idPrefix + "']"+typeText).each(function(key, value){
			value.disabled = isDisabled;
			if(isDisabled){
				value.checked = !isDisabled;
			}
		});
	});
}

// 문자열에 숫자가 있는지 확인하는 함수
function isNumeric(n) {
	return !isNaN(parseFloat(n)) && isFinite(n);
}

// JSON 객체 비교 함수 생성
//Object.prototype.equals = function(x) {
//	// 인자값의 Type이 object가 아닐경우 false를 리턴한다.
//	if(typeof x !== "object") return false;
//	// Type을 String으로 변환한다.
//	var arr1 = JSON.stringify(this);
//	var arr2 = JSON.stringify(x);
//
//	return (arr1 === arr2);
//}