package org.moyeo.call.modules.init;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;


import org.json.JSONArray;
import org.json.JSONObject;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;

/**
 * org.moyeo.call.modules.files.SelectLandIntersectionList
 * @author 최진석
 *
 * 계획 구역내의 필지을 계획구역으로 Intersection 해서 가져온다
 */ 
@BusinessMapping(id="SELECT_MEMBER")
public class SelectMember extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		
		if(parameterObject.has("userId"))
			paramterMap.put("userId", parameterObject.getString("userId"));
		
		List<HashMap<String, Object>> returnMap = sqlSession.selectList( 
			"org.moyeo.call.sql.intro.selectMember", paramterMap );
		
		List<HashMap<String, Object>> returnCnt = sqlSession.selectList( 
		"org.moyeo.call.sql.intro.selectMember", paramterMap );
		
		
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
