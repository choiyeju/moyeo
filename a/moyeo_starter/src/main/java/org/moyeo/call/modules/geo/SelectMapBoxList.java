package org.moyeo.call.modules.geo;

import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.postgis.geojson.PostGISModule;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;

/**
 * org.moyeo.call.modules.files.SelectMapBoxList
 * @author 최진석
 *
 * 지도 영역의 지정 테이블목록을 가져온다
 */ 
@BusinessMapping(id="SELECT_MAPBOX_LIST")
public class SelectMapBoxList extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {

		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		String table = parameterObject.getString("table");
		int srid = parameterObject.getInt("srid");
		paramterMap.put("table", table);
		paramterMap.put("srid", srid);
		paramterMap.put("minx", parameterObject.getFloat("minx"));
		paramterMap.put("miny", parameterObject.getFloat("miny"));
		paramterMap.put("maxx", parameterObject.getFloat("maxx"));
		paramterMap.put("maxy", parameterObject.getFloat("maxy"));
		List<HashMap<String, Object>> returnMap = sqlSession.selectList( 
			"org.moyeo.call.sql.geoquery.SelectMapBoxList" , 
			paramterMap );

		// GeoJSon 형태로 변경하는 소스
		JSONObject jobj = new JSONObject();
		ObjectMapper mapper = new ObjectMapper();
		mapper.registerModule(new PostGISModule());
		jobj.put("type", "FeatureCollection");
		jobj.put("crs", new JSONObject("{\"type\":\"name\", \"properties\":{name:\"urn:ogc:def:crs:EPSG::"+srid+"\"}}" ));
		
		JSONArray json = new JSONArray();
		for(int i= 0;i< returnMap.size();i++) {
			HashMap<String, Object> geobj = new HashMap<String, Object>();
			HashMap<String, Object> obj = (HashMap<String, Object>)returnMap.get(i);
			geobj.put("type", "Feature");
			geobj.put("id", table+"."+i);
			if(table.equals("g_land")) {
				try {
					String strjson = mapper.writeValueAsString(obj.get("geom"));
					geobj.put("geometry", new JSONObject(strjson).get("geometry"));
				} catch (JsonProcessingException e) {
					e.printStackTrace();
				}
			}
			obj.remove("geom");
			
			geobj.put("properties", obj);
			json.put(geobj);
		}
		jobj.put("features", json);
		// GeoJSon 형태로 변경하는 소스 끝
		
		String convertJSONString = jobj.toString();

		System.out.println("SelectMapBoxList.result.JSONArray :: " + convertJSONString);

		if (convertJSONString.equals("null")) {
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", "");
		}else{
//			resultHeaderObject.put("process", "success");
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
