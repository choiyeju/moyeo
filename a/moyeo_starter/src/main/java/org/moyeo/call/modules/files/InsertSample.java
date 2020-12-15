package org.moyeo.call.modules.files;

import java.util.HashMap;

import org.json.JSONObject;

import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;


/**
 * org.moyeo.call.modules.files.InsertSample
 * @author 최진석
 *
 */
@BusinessMapping(id="INSERT_SAMPLE")
public class InsertSample extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		paramterMap.put("id", parameterObject.getString("id"));
		paramterMap.put("title", parameterObject.getString("title"));
		paramterMap.put("status", parameterObject.getString("status"));
		int insertResult = sqlSession.update( 
				"org.moyeo.call.sql.samplequery.insertSample",
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
