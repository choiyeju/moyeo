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
@BusinessMapping(id="INSERT_MEMBER")
public class InsertMember extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		paramterMap.put("userId", parameterObject.getString("userId"));
		paramterMap.put("userPw", parameterObject.getString("userPw"));
		paramterMap.put("userNm", parameterObject.getString("userNm"));
		paramterMap.put("userTel", parameterObject.getString("userTel"));
		paramterMap.put("createDate", parameterObject.getString("createDate"));
		paramterMap.put("userPostNum", parameterObject.getString("userPostNum"));
		paramterMap.put("userPhone", parameterObject.getString("userPhone"));
		paramterMap.put("userAdd", parameterObject.getString("userAdd"));
		paramterMap.put("userEmail", parameterObject.getString("userEmail"));
		paramterMap.put("userJob", parameterObject.getString("userJob"));
		paramterMap.put("userJobtit", parameterObject.getString("userJobtit"));
		paramterMap.put("userArea", parameterObject.getString("userArea"));
		int insertResult = sqlSession.update( 
				"org.moyeo.call.sql.intro.insertMember",
				paramterMap);
		
		JSONObject retJson = new JSONObject();
		retJson.append("insert", insertResult);

		if (insertResult == 1) {
			resultBodyObject.put("result", retJson);
		}else{
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", "정보가 없습니다.");
		}	}

	@Override
	protected void beforeRun(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		//resultBodyObject.put("beforeRun", this.getClass().getName());
	}

	@Override
	protected void afterRun(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		//resultBodyObject.put("afterRun", this.getClass().getName());
	}

}
