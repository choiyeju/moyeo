package org.moyeo.call.modules;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.jdom2.Element;
import org.jdom2.filter.Filters;
import org.jdom2.xpath.XPathExpression;
import org.jdom2.xpath.XPathFactory;
import org.json.JSONObject;

import com.google.gson.Gson;
import org.moyeo.call.GeoQuery;

public abstract class AbstractModule implements Module {

	private static SqlSessionFactory sqlSessionFactory;
	protected JSONObject parameterObject;
	protected JSONObject resultObject;
	private HttpServletRequest request;
	private HttpServletResponse response;
	protected SqlSession sqlSession;

	static {
		String resource = "org/moyeo/call/QueryMappingConfig.xml";
		ClassLoader classLoader = GeoQuery.class.getClassLoader();
		String inputStream = classLoader.getResource(resource).getFile();
		
		try {
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(new FileInputStream(inputStream));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	
    public static SqlSession openSqlSession() {
        return sqlSessionFactory.openSession(true);
    }

	public void init() {
	}
	
	@Override
	public void setParameter(JSONObject param) {
		this.parameterObject = param;
	}
	
	public JSONObject invoke() {

		resultObject = new JSONObject();
		resultObject.put("return.type", "application/json");

		JSONObject resultHeaderObject = new JSONObject();
		resultHeaderObject.put("process", "success");

		JSONObject resultBodyObject = new JSONObject();

		sqlSession = openSqlSession();

		try {
			beforeRun(resultHeaderObject, resultBodyObject); 
			run(resultHeaderObject, resultBodyObject);
			afterRun(resultHeaderObject, resultBodyObject);
		}finally {
			sqlSession.commit();
			sqlSession.close();
		}
		
		resultObject.put("header", resultHeaderObject);
		resultObject.put("body", resultBodyObject);
		
		return resultObject;
	}

	protected JSONObject invokeModule(JSONObject commandObject) {
		try {
			
			return __invokeModule(commandObject);
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	
	protected String getJsonString(Object obj) {
        Gson gson = new Gson();
        return gson.toJson(obj); //convert 
	}

	protected HttpServletRequest getRequest() {
		return this.request;
	}
	
	protected HttpServletResponse getResponse() {
		return this.response;
	}
	
	private JSONObject __invokeModule(JSONObject obj) throws ClassNotFoundException, InstantiationException, IllegalAccessException {
		
		String commandId = obj.getString("cmd");
		AbstractModule tgrModule = (AbstractModule) getClass(commandId).newInstance();
		if (tgrModule == null) return null;
		tgrModule.setParameter(obj);
		return tgrModule.invoke();
		
	}

	@SuppressWarnings("unchecked")
	private Class<Module> getClass(String commandId) throws ClassNotFoundException {

		XPathFactory xpfac = XPathFactory.instance();
		XPathExpression<Element> xp = xpfac.compile(String.format("//business[@id='%s']", commandId), Filters.element());
		Element el = (Element) xp.evaluateFirst(GeoQuery.getDocument());
		
		String targetClassValue = el.getValue();
		if (targetClassValue != null) {
			return (Class<Module>) Class.forName(targetClassValue);
		}else {
			return null;
		}
	}
	abstract protected void beforeRun(JSONObject resultHeaderObject, JSONObject resultBodyObject); 
	
	abstract protected void afterRun(JSONObject resultHeaderObject, JSONObject resultBodyObject);

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}
	
}
