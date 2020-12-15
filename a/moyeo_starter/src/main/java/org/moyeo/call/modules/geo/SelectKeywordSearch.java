package org.moyeo.call.modules.geo;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;

/**
 * org.moyeo.call.modules.geo.SelectKeywordSearch
 * @author 최진석
 *
 */ 
@BusinessMapping(id="SELECT_KEYWORD_SEARCH")
public class SelectKeywordSearch extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {

		List<HashMap<String, Object>> returnMap = null;
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		if(parameterObject.has("cd")) {
			paramterMap.put("cd", parameterObject.getString("cd"));
			returnMap = sqlSession.selectList( "org.moyeo.call.sql.geoquery.SelectCdGeometry" , paramterMap );
		} else {
			try {
				paramterMap.put("keyword", URLDecoder.decode(parameterObject.getString("keyword"), "UTF-8"));
			} catch (UnsupportedEncodingException | JSONException e) {
				e.printStackTrace();
			}
	
			if(parameterObject.has("curpage")) {
				paramterMap.put("curpage", parameterObject.getInt("curpage"));
			}
			returnMap = sqlSession.selectList( "org.moyeo.call.sql.geoquery.SelectKeywordSearch" , paramterMap );
			List<HashMap<String, Object>> returnCnt = sqlSession.selectList( "org.moyeo.call.sql.geoquery.SelectKeywordSearchCnt" , paramterMap );
			resultBodyObject.put("resultCnt", returnCnt.get(0));
		}
		// GeoJSon 형태로 변경하는 소스
		JSONObject jobj = new JSONObject();
		jobj.put("type", "FeatureCollection");
		JSONArray json = new JSONArray();
		for(int i= 0;i< returnMap.size();i++) {
			HashMap<String, Object> geobj = new HashMap<String, Object>();
			HashMap<String, Object> obj = (HashMap<String, Object>)returnMap.get(i);
			geobj.put("type", "Feature");
			if(obj.containsKey("geom")) {
				geobj.put("geometry", new JSONObject(obj.get("geom").toString()));
				obj.remove("geom");
			}
			geobj.put("properties", obj);
			json.put(geobj);
		}
		jobj.put("features", json);
		// GeoJSon 형태로 변경하는 소스 끝
		String convertJSONString = jobj.toString();

		System.out.println("SelectKeywordSearch.result.JSONArray :: " + convertJSONString);

		if (convertJSONString.equals("null")) {
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", "");
		}else{
			resultBodyObject.put("result", jobj);
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
