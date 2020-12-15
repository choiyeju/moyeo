package org.moyeo.call.modules.geo;

import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;

/**
 * org.moyeo.call.modules.geo.SelectLayerList
 * @author 최진석
 *
 */ 
@BusinessMapping(id="SELECT_LAYER_LIST")
public class SelectLayerList extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {

		List<HashMap<String, Object>> returnMap = null;
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		returnMap = sqlSession.selectList( "org.moyeo.call.sql.geoquery.SelectLayerList" , paramterMap );
		JSONArray json = new JSONArray(returnMap);
		String convertJSONString = json.toString();
		System.out.println("SelectLayerList.result.JSONArray :: " + convertJSONString);

		if (convertJSONString.equals("null")) {
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", "");
		}else{
			resultBodyObject.put("result", json);
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
