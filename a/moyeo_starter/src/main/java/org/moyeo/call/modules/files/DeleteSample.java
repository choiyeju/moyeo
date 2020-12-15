package org.moyeo.call.modules.files;

import java.util.HashMap;

import org.json.JSONObject;

import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;

/**
 * org.moyeo.call.modules.files.DeleteSample
 * @author 최진석
 *
 */
@BusinessMapping(id="DELETE_SAMPLE")
public class DeleteSample extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		paramterMap.put("id", parameterObject.getString("id"));
		int deleteResult = sqlSession.update( 
				"org.moyeo.call.sql.samplequery.deleteSample",
				paramterMap);
		
		JSONObject retJson = new JSONObject();
		retJson.append("delete", deleteResult);

		if (deleteResult == 1) {
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
