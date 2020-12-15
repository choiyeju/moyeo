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
 * org.moyeo.call.modules.files.CalcGeometry
 * @author 최진석
 *
 * 지도매트리 공간계산용 쿼리
 */ 
@BusinessMapping(id="CALC_GEOMETRY")
public class CalcGeometry extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {

		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		List<HashMap<String, Object>> returnMap = null;
		JSONObject jobj = new JSONObject();
		if(parameterObject.has("geometry")) {
			if(parameterObject.has("geocmd") && parameterObject.getString("geocmd").equals("isValid")) {
				paramterMap.put("geometry", parameterObject.getString("geometry"));
				returnMap = sqlSession.selectList("org.moyeo.call.sql.geoquery.CalcGeometryIsValid" , paramterMap );
				jobj.put("features", returnMap);
			} else if(parameterObject.has("geocmd") && parameterObject.getString("geocmd").equals("makeValid")) {
				paramterMap.put("geometry", parameterObject.getString("geometry"));
				returnMap = sqlSession.selectList("org.moyeo.call.sql.geoquery.CalcGeometryMakeValid" , paramterMap );
				
				// GeoJSon 형태로 변경하는 소스
				int srid = 4326;
				if(parameterObject.has("srid")) 
					srid = parameterObject.getInt("srid");
				jobj.put("type", "FeatureCollection");
				jobj.put("crs", new JSONObject("{\"type\":\"name\", \"properties\":{name:\"urn:ogc:def:crs:EPSG::"+srid+"\"}}" ));
				ObjectMapper mapper = new ObjectMapper();
				mapper.registerModule(new PostGISModule());
				JSONArray json = new JSONArray();
				for(int i= 0;i< returnMap.size();i++) {
					HashMap<String, Object> geobj = new HashMap<String, Object>();
					HashMap<String, Object> obj = (HashMap<String, Object>)returnMap.get(i);
					try {
						String strjson = mapper.writeValueAsString(obj.get("geom"));
						geobj.put("geometry", new JSONObject(strjson).get("geometry"));
					} catch (JsonProcessingException e) {
						e.printStackTrace();
					}
					obj.remove("geom");
					geobj.put("properties", obj);
					json.put(geobj);
				}
				jobj.put("features", json);
			}
			
		} else {
			if(parameterObject.has("geoquery"))
				paramterMap.put("geoquery", parameterObject.getString("geoquery"));
			if(parameterObject.has("layer")) {
				paramterMap.put("layer", parameterObject.getString("layer"));
				if(parameterObject.has("field"))
					paramterMap.put("field", parameterObject.getString("field"));
				
				if(parameterObject.has("vallist")) {
					paramterMap.put("vallist", parameterObject.getString("vallist"));
					returnMap = sqlSession.selectList("org.moyeo.call.sql.geoquery.CalcGeometryLayerForWorkArea" , paramterMap );
				} else if(parameterObject.has("value")) {
					paramterMap.put("value", parameterObject.getString("value"));
					returnMap = sqlSession.selectList("org.moyeo.call.sql.geoquery.CalcGeometryForLayer" , paramterMap );
				}
			} else {
				returnMap = sqlSession.selectList("org.moyeo.call.sql.geoquery.CalcGeometry" , paramterMap );
			}
			
			// GeoJSon 형태로 변경하는 소스
			jobj.put("type", "FeatureCollection");
			JSONArray json = new JSONArray();
			for(int i= 0;i< returnMap.size();i++) {
				HashMap<String, Object> geobj = new HashMap<String, Object>();
				HashMap<String, Object> obj = (HashMap<String, Object>)returnMap.get(i);
				geobj.put("type", "Feature");
				geobj.put("geometry", new JSONObject(obj.get("jgeom").toString()));
				obj.remove("jgeom");
				json.put(geobj);
			}
			jobj.put("features", json);
		}
		// GeoJSon 형태로 변경하는 소스 끝
		
		String convertJSONString = jobj.toString();

		System.out.println("CalcGeometry.result.JSONArray :: " + convertJSONString);

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
