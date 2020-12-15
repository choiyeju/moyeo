package org.moyeo.call.modules.files;

import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;

/**
 * org.moyeo.call.modules.files.SelectSample
 * @author 최진석
 *
 */ 
@BusinessMapping(id="SELECT_SAMPLE")
public class SelectSample extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {

		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		if(parameterObject.has("status"))
			paramterMap.put("status", parameterObject.getString("status"));
		if(parameterObject.has("title"))
			paramterMap.put("title", parameterObject.getString("title"));
		
		if(parameterObject.has("offset"))
			paramterMap.put("offset", parameterObject.getInt("offset"));
			
		List<HashMap<String, Object>> returnMap = sqlSession.selectList( 
			"org.moyeo.call.sql.samplequery.selectSample" , 
			paramterMap );
		List<HashMap<String, Object>> returnCnt = sqlSession.selectList( 
				"org.moyeo.call.sql.samplequery.selectSampleCnt" , 
				paramterMap );
		
		JSONArray json = new JSONArray(returnMap);
		String convertJSONString = json.toString();

		if (convertJSONString.equals("null")) {
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", "");
		}else{
//			resultHeaderObject.put("process", "success");
			resultBodyObject.put("result", json);
			resultBodyObject.put("resultCnt", returnCnt.get(0));
		}
	}

	@Override
	protected void beforeRun(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		//resultBodyObject.put("beforeRun", this.getClass().getName());
	}

	@Override
	protected void afterRun(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		//resultBodyObject.put("afterRun", this.getClass().getName());
	}

}
