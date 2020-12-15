<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.awt.Image" %>
<%@ page import="java.awt.Graphics2D" %>
<%@ page import="java.awt.Color" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.*" %>
<%
	System.out.println("url mapping");
	String strFilePath = "c:\\test\\";
	
	// ex => http://localhost:8030/CmWorld/index.jsp
	// getContextPath => /CmWorld
	// getContextURL => http://localhost:8030/CmWorld/index.jsp
	
	String contextPath = request.getContextPath(); // ex:
	String contextURL = request.getRequestURL().toString();
	String[] temp = contextURL.split( contextPath );
	
	contextPath = temp[0] + contextPath;
	
/*	System.out.println("contextPath: "+contextPath);
	System.out.println("contextURL: "+contextURL);
	System.out.println("temp: "+Arrays.toString(temp));
	System.out.println("contextPath: "+contextPath);
*/	
	// jsp?baseUrl=http://daum.xxx&tiles=/1/1/1.png&leftOrigin=-50&topOrigin=-35&width=1531&height=981&tileSize=256
	String strBaseUrl = request.getParameter("baseUrl");
	String strTiles = request.getParameter("tiles");
	String strSelectRect = request.getParameter("select");
	String strLeftOrigin = request.getParameter("leftOrigin");
	String strTopOrigin = request.getParameter("topOrigin");
	String strWidth = request.getParameter("width");
	String strHeight = request.getParameter("height");
	String strTileSize = request.getParameter("tileSize");
	String isYFirst = request.getParameter("yFirst").toUpperCase();
	String isReverseYAxis = request.getParameter("reverseYAxis").toUpperCase();
	String strFileExt = request.getParameter("fileExt");
	String strSaveFileName = request.getParameter("saveFileName");
// 	System.out.println("strBaseUrl: "+strBaseUrl);

	strBaseUrl = (strBaseUrl == null) ? "" : strBaseUrl;
	strTiles = (strTiles == null) ? "" : strTiles;
	strSelectRect = (strSelectRect == null) ? "" : strSelectRect;
	strLeftOrigin = (strLeftOrigin == null) ? "" : strLeftOrigin;
	strTopOrigin = (strTopOrigin == null) ? "" : strTopOrigin;
	strWidth = (strWidth == null) ? "" : strWidth;
	strHeight = (strHeight == null) ? "" : strHeight;
	strTileSize = (strTileSize == null) ? "" : strTileSize;
	isYFirst = (isYFirst == null) ? "" : isYFirst;
	isReverseYAxis = (isReverseYAxis == null) ? "" : isReverseYAxis;
	strFileExt = (strFileExt == null) ? "" : strFileExt;
	strSaveFileName = (strSaveFileName == null) ? "" : strSaveFileName;
	
	int nLeftOrigin = Integer.parseInt( strLeftOrigin );
	int nTopOrigin = Integer.parseInt( strTopOrigin );
	int nWidth = Integer.parseInt( strWidth );
	int nHeight = Integer.parseInt( strHeight );
	int nTileSize = Integer.parseInt( strTileSize );

// 	System.out.println("nWidth: "+nWidth);
// 	System.out.println("nHeight: "+nHeight);
// 	System.out.println("nLeftOrigin: "+nLeftOrigin);
// 	System.out.println("nTopOrigin: "+nTopOrigin);

	//
	String[] strTilesArray = null;
	if (strTiles != "") {
		strTilesArray = strTiles.split(",");
	}
	
	int rect_x1 = 0;
	int rect_y1 = 0;
	int rect_x2 = 0;
	int rect_y2 = 0;
	
	//
	String[] strRectArray = null;
	if (strSelectRect != "") {
	
		strRectArray = strSelectRect.split(",");
	
		rect_x1 = Integer.parseInt( strRectArray[0] );
		rect_y1 = Integer.parseInt( strRectArray[1] );
		rect_x2 = Integer.parseInt( strRectArray[2] );
		rect_y2 = Integer.parseInt( strRectArray[3] );
	
		if (rect_x1 < 0) rect_x1 = 0;
		if (rect_y1 < 0) rect_y1 = 0;
	
		if (rect_x2 >= nWidth) rect_x2 = nWidth - 1;
		if (rect_y2 >= nHeight) rect_y2 = nHeight - 1;
	}
	
	int minXTile = 99999999;
	int minYTile = 99999999;
	int maxXTile = -99999999;
	int maxYTile = -99999999;
	
	String strLevel = "";
	
	for (int i = 0; i < strTilesArray.length; i++) {
	
		//System.out.println(strTilesArray[i]);
		String strTile = strTilesArray[i].substring(0, strTilesArray[i].indexOf(".")); // Remove File Extension
		//System.out.println(strTile);
		String[] strTileParse = strTile.split("/");
		//System.out.println(strTileParse[1]+"   "+strTileParse[2]);
	
		int lIdx = 0, yIdx = 1, xIdx = 2;
		if (!isYFirst.equals("Y")) {
			lIdx = 0;
			xIdx = 1;
			yIdx = 2;
		}
	
		if (strTileParse[0].equals("")) {
			lIdx++; xIdx++; yIdx++;
		}
	
		if (i == 0)
			strLevel=strTileParse[lIdx];
	
		int nY = Integer.parseInt( strTileParse[yIdx] );
		int nX = Integer.parseInt( strTileParse[xIdx] );
	
		if (minXTile > nX) minXTile = nX;
		if (maxXTile < nX) maxXTile = nX;
		if (minYTile > nY) minYTile = nY;
		if (maxYTile < nY) maxYTile = nY;
	}
	
	////System.out.println("minX=" + minXTile + " maxXTile=" + maxXTile + " minYTile=" + minYTile + " maxYTile=" + maxYTile);
	
	BufferedReader in = null;
	//Image image = null;
	
	BufferedImage mergedImage = new BufferedImage(nWidth, nHeight, BufferedImage.TYPE_INT_RGB);
	Graphics2D graphics = (Graphics2D) mergedImage.getGraphics();
	
	try {
	
		String tileUrl = "";
		int xCnt = 0;
	
		for (int xIdx = minXTile; xIdx <= maxXTile; xIdx++) {
	
			int yCnt = 0;
			if (!isReverseYAxis.equals("Y")) {
	
				for (int yIdx = maxYTile; yIdx >= minYTile; yIdx--) {
	
					if (isYFirst.equals("Y"))
						tileUrl = strBaseUrl + "/" + strLevel + "/" + yIdx + "/" + xIdx + "." + strFileExt;
					else
						tileUrl = strBaseUrl + "/" + strLevel + "/" + xIdx + "/" + yIdx + "." + strFileExt;
	
					////System.out.println(tileUrl);
	
					// URL url = new URL("https://map1.daumcdn.net/map_2d/1906plw/L3/1966/865.png"); // URL (Get map tile image)
					URL url = new URL(tileUrl);
					HttpURLConnection connection = (HttpURLConnection)url.openConnection();
	
					// OSM (client 세부 설정이 없으면 요청을 거절해서 이렇게 처리함)
					connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36");
	
					// drawImage
					InputStream ins = connection.getInputStream();
					Image image = ImageIO.read( ins );
					graphics.setBackground(Color.WHITE);
					graphics.drawImage(image, xCnt * nTileSize + nLeftOrigin, yCnt * nTileSize + nTopOrigin, null);
	
					yCnt++;
				}
			}
			else {
	
				for (int yIdx = minYTile; yIdx <= maxYTile; yIdx++) {
	
					if (isYFirst.equals("Y"))
				  		tileUrl = strBaseUrl + "/" + strLevel + "/" + yIdx + "/" + xIdx + "." + strFileExt;
					else
						tileUrl = strBaseUrl + "/" + strLevel + "/" + xIdx + "/" + yIdx + "." + strFileExt;
	
					////System.out.println(tileUrl);
	
					//URL url = new URL("https://map1.daumcdn.net/map_2d/1906plw/L3/1966/865.png");
					URL url = new URL(tileUrl);
					HttpURLConnection connection = (HttpURLConnection)url.openConnection();
	
					// OSM (client 세부 설정이 없으면 요청을 거절해서 이렇게 처리함)
					connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36");
	
					// drawImage
					InputStream ins = connection.getInputStream();
					Image image = ImageIO.read( ins );
					graphics.setBackground(Color.WHITE);
					graphics.drawImage(image, xCnt * nTileSize + nLeftOrigin, yCnt * nTileSize + nTopOrigin, null);
	
				  	yCnt++;
				}
			}
	
			xCnt++;
		}
	
		strSaveFileName = strFilePath + strSaveFileName;
	
		if (rect_x1 == 0 && rect_y1 == 0 && rect_x2 == 0 && rect_y2 == 0) {
	
			ImageIO.write(mergedImage, "png", new File(strSaveFileName));
		}
		else {
	
			int ww = Math.abs( rect_x2 - rect_x1 );
			int hh = Math.abs( rect_y2 - rect_y1 );
	
			BufferedImage croppedImage = mergedImage.getSubimage(rect_x1, rect_y1, ww, hh);
			ImageIO.write(croppedImage, "png", new File(strSaveFileName));
		}
	
		//---------------------------------------------------------------------------
		// Test
		//---------------------------------------------------------------------------
	
		/*
		URL url = new URL("https://map1.daumcdn.net/map_2d/1906plw/L3/1966/865.png");
		image = ImageIO.read(url);
		HttpURLConnection con = (HttpURLConnection)url.openConnection();
		con.setRequestMethod("GET");
		in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
		String line; while((line = in.readLine()) != null) {
		//	System.out.println(line);
		}
		*/
	
	}
	catch (Exception e) {
		//System.err.println( e.getMessage() );
		e.printStackTrace();
	}
	finally {
	
	   if (in != null) {
		   try {
			   in.close();
		   }
		   catch(Exception e) {
			   System.err.println( e.getMessage() );
		   }
	   }
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="<c:url value='/resources/js/map.capture-src.js' />"></script>
</head>
<body>
gg
</body>
</html>