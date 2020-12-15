package org.moyeo.ctrl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.Reader;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.jdom2.Document;
import org.jdom2.input.SAXBuilder;
import org.springframework.stereotype.Service;

import org.json.JSONArray;
import org.json.JSONObject;

@Service
public class G {
	private static String OS = System.getProperty("os.name").toLowerCase();
	public static Properties Props = null;
	private static Document bizDocument = null;
	private static Document permissionDoc = null;
	public static SqlSessionFactory sqlSessionFactory;
	public static Document getDocument() {
    	return bizDocument;
    }

    public static Document getPermissionDocument() {
    	return permissionDoc;
    }
    
    public static String getProperty(String key) {
    	return Props.getProperty(key);
    }
    
    private static SqlSessionFactory instance; // 필드와 생성자 모두 프라이빗 처리로 외부 접근 막는다.
    public static SqlSessionFactory getInstance() {
      Reader reader=null;
      try {
       
        reader=Resources.getResourceAsReader("org/moyeo/call/QueryMappingConfig.xml");
        instance=new SqlSessionFactoryBuilder().build(reader);
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        try {
          if(reader != null) reader.close();
        } catch (Exception e2) {
          e2.printStackTrace();
        }
      }
      return instance;
    }

	@PostConstruct
    public void init() {
    	ClassLoader classLoader = G.class.getClassLoader();
		SAXBuilder builder = new SAXBuilder();
		try {
	    	bizDocument = builder.build(new File(classLoader.getResource("org/moyeo/call/BusinessMapping.xml").getFile()));
	    	System.out.println(bizDocument.toString());
	    	Props = new Properties();
	    	Props.load(classLoader.getResource("org/moyeo/call/system.properties").openStream());
	    	String filepath = Props.getProperty("system.filepath"); // 해당 서버의 절대경로에 있는 시스템 프로퍼티 파일을 가져온다.
	    	if(isWindows()) {
	    		filepath = Props.getProperty("system.win.filepath");
	    	}
	    	File file = new File(filepath);
	    	if(file.exists()) { // 파일이 있다면 해당 파일 설정으로 진행
		    	FileReader resources= new FileReader(filepath);
		    	Props.load(resources);
	    	}
			sqlSessionFactory = getInstance();
	    } catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

    }
    
    /*
     *  mapsvr 등록 오픈api key
     */
	public static int insertOpenApi(HashMap<String, Object> paramterMap) {
		int nRet = 0;
		SqlSession sqlSession = null;
		try {
			sqlSession = G.sqlSessionFactory.openSession(true);
			nRet = sqlSession.update("org.moyeo.call.sql.mapsvr.insertOpenApi" , paramterMap );
		} finally {
			sqlSession.commit();
			sqlSession.close();
		}
		return nRet;
	}
	/*
     *  mapsvr 업데이트 오픈api key
     */
	public static int updateOpenApi(HashMap<String, Object> paramterMap) {
		int nRet = 0;
		SqlSession sqlSession = null;
		try {
			sqlSession = G.sqlSessionFactory.openSession(true);
			nRet = sqlSession.update("org.moyeo.call.sql.mapsvr.updateOpenApi" , paramterMap );
		} finally {
			sqlSession.commit();
			sqlSession.close();
		}
		return nRet;
	}
    /*
     *  mapsvr 키 유효성 체크 함수
     */
    public static boolean getKeyValid(String sKey) throws SQLException {
    	boolean bRet = false;
    	HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		paramterMap.put("key", sKey);
		/*
		String _domain = java.net.InetAddress.getLoopbackAddress().getHostName();
		System.out.println(">>>>> domain : " + _domain);
		try {
			System.out.println("kys 1 : " + java.net.InetAddress.getLocalHost());
			System.out.println("kys 1 : " + java.net.InetAddress.getLocalHost());
			System.out.println("kys 2 : " + java.net.InetAddress.getLocalHost().getHostAddress());
			System.out.println("kys 3 : " + java.net.InetAddress.getLocalHost().getHostName());
			System.out.println("kys 4 : " + java.net.InetAddress.getLocalHost().getAddress());
			System.out.println("kys 5 : " + java.net.InetAddress.getLoopbackAddress());
			System.out.println("kys 6 : " + java.net.InetAddress.getLoopbackAddress().getHostName());
			System.out.println("kys 7 : " + java.net.InetAddress.getLoopbackAddress().getAddress());
			System.out.println("kys 8 : " + java.net.InetAddress.getLoopbackAddress().getHostAddress());
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		*/
		/*try {
			URL aURL = new URL("http://example.com:80/docs/books/tutorial/index.html?name=networking#DOWNLOADING");
			System.out.println("protocol = " + aURL.getProtocol()); //http
			 System.out.println("authority = " + aURL.getAuthority()); //example.com:80
			 System.out.println("host = " + aURL.getHost()); //example.com
			 System.out.println("port = " + aURL.getPort()); //80
			 System.out.println("path = " + aURL.getPath()); //  /docs/books/tutorial/index.html
			 System.out.println("query = " + aURL.getQuery()); //name=networking
			 System.out.println("filename = " + aURL.getFile()); ///docs/books/tutorial/index.html?name=networking
			 System.out.println("ref = " + aURL.getRef()); //DOWNLOADING
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}*/
		//map.put("domain", _domain);
		List<HashMap<String, Object>> returnMap = null;
		SqlSession sqlSession = null;
		try {
			sqlSession = G.sqlSessionFactory.openSession(true);
			returnMap = sqlSession.selectList("org.moyeo.call.sql.mapsvr.getKeyValid" , paramterMap );
			if (returnMap.size() <= 0){
				bRet = false;
			}else {
//				Map listMap = (Map)list.get(0);
//				listMap = comUtil.convertUpperByKey(listMap);
//				String strID = returnMap.get(0).get("API_OAPI_KEY").toString();
				bRet = true;
			}
		} finally {
			sqlSession.commit();
			sqlSession.close();
		}
		return bRet;
    }
  //20171128 ki : map 데이터를 받아 key를 대문자로 변환
  	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map convertUpperByKey(Map _origin){
  		Map ret = new HashMap();
 		Iterator<String> keys = _origin.keySet().iterator();
  	 	while ( keys.hasNext() ) {
  	 	    String key = keys.next();
  	 	    //System.out.println("#1 => key : " + key +" / value : " + _origin.get(key));
  	 	   ret.put(key.toString().toUpperCase(), _origin.get(key));
  	 	}  
  		return ret;
  	}
  	
  	//20171128 ki : hashmap 데이터를 받아 key를 대문자로 변환
  	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static HashMap convertUpperByKey(HashMap _origin){
  		Map ret = new HashMap();
  	 	Iterator<String> keys = _origin.keySet().iterator();
  	 	while ( keys.hasNext() ) {
  	 	    String key = keys.next();
  	 	    //System.out.println("#1 => key : " + key +" / value : " + _origin.get(key));
  	 	   ret.put(key.toString().toUpperCase(), _origin.get(key));
  	 	}  
  		return (HashMap) ret;
  	}
  	
  	//20171128 ki : jsonarray 데이터를 받아 key를 대문자로 변환
  	public static JSONArray convertUpperByKey(JSONArray _origin){
  		JSONArray ret = new JSONArray();
  		for (int i = 0; i < _origin.length(); i++) {
  		    JSONObject json = _origin.getJSONObject(i);
  		    JSONObject retJson = new JSONObject();
  		    Iterator<String> keys = json.keys();

  		    while (keys.hasNext()) {
  		        String key = keys.next();
  		        //System.out.println("Key :" + key + "  Value :" + json.get(key));
  		        retJson.put(key.toString().toUpperCase(), json.get(key));
  		    }
  		    ret.put(retJson);
  		}
  		return ret;
  	}
  	
    public static String toStr(Object oTarget) {
    	String 	sTarget;
    	if(oTarget != null && oTarget != ""){
    		sTarget = oTarget.toString();
    		//System.out.println("sTarget 1 : " + sTarget);
    	}else{
    		sTarget = "";
    		//System.out.println("sTarget 2 : " + sTarget);
    	}
        return sTarget;
    }
    
    public static int toInt(Object oTarget) {
    	String 	sTarget = null;
    	if (oTarget != null)
    		sTarget = oTarget.toString();
        return intNullChk(sTarget, 0);
    }
    
    /**
     * NULL값 처리
     * @param strTarget
     * @param intConv
     * @return Integer
     */
    public static int intNullChk(String strTarget, int intConv) {
        int 	returnValue = 0;

        try {
	        if (strTarget == null || ("").equals(strTarget.trim()) || ("null").equals(strTarget))
	                returnValue = intConv;
	        else returnValue = Integer.parseInt(strTarget.trim());
        } catch (NumberFormatException e) {
        	returnValue = intConv;
        }

        return returnValue;
    }
  	
  	//20180307 ki : list 데이터를 받아 key를 대문자로 변환
  	@SuppressWarnings("rawtypes")
	public static List convertUpperByKey(List _origin){
  		List<Map> ret = new ArrayList<Map>();
  		for(int i=0; i<_origin.size(); i++){
  			ret.add(convertUpperByKey((Map)_origin.get(i)));
  		}
  		return (List) ret;
  	}
  	
  	/**
	 * Request객체 맵 생성
	 * @param request
	 * @return HashMap<String, Object>
	 */
	public static HashMap<String, Object> getRequestMap(HttpServletRequest request) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			Map<?, ?> parameter = request.getParameterMap();
			
			
			if (parameter == null) return null;
			
			Iterator<?> it = parameter.keySet().iterator();
			Object paramKey = null;
			String[] paramValue = null;

			while (it.hasNext()) { 
				paramKey = it.next();
				paramValue = (String[]) parameter.get(paramKey);

				String strKey = paramKey.toString();
				if (paramValue.length > 1 ) {
					map.put(strKey, request.getParameterValues(paramKey.toString()));
				} else {
					map.put(strKey, (paramValue[0] == null) ? "" : paramValue[0].trim());
				}
			}	
			return map; 
		} catch (Exception e){
			return null;
		}
	}
	
	public static String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("X-Forwarded-For");
//	    logger.info("> X-FORWARDED-FOR : " + ip);

	    if (ip == null) {
	        ip = request.getHeader("Proxy-Client-IP");
//	        logger.info("> Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
//	        logger.info(">  WL-Proxy-Client-IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
//	        logger.info("> HTTP_CLIENT_IP : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
//	        logger.info("> HTTP_X_FORWARDED_FOR : " + ip);
	    }
	    if (ip == null) {
	        ip = request.getRemoteAddr();
//	        logger.info("> getRemoteAddr : "+ip);
	    }
//	    logger.info("> Result : IP Address : "+ip);

	    return ip;
	}
	
	public static boolean isWindows() {
		  
        return (OS.indexOf("win") >= 0);
  
    }
  
    public static boolean isMac() {
  
        return (OS.indexOf("mac") >= 0);
  
    }
  
    public static boolean isUnix() {
  
        return (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") > 0 );
  
    }
  
    public static boolean isSolaris() {
  
        return (OS.indexOf("sunos") >= 0);
  
    }
}
