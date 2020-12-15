package org.moyeo.call.modules.init;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

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
 * 로그인 및 세션정보 업데이트
 */ 
@BusinessMapping(id="LOGIN_MEMBER")
public class LoginMember extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
		
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		
		paramterMap.put("userId", parameterObject.getString("userId"));
		paramterMap.put("userPw", parameterObject.getString("userPw"));
		


		HashMap<String, Object> returnMap = sqlSession.selectOne( 
				"org.moyeo.call.sql.intro.loginMember" , paramterMap );
		
		String convertJSONString = getJsonString(returnMap);
		
		
		if (convertJSONString.equals("null")) {
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", "등록된 사용자가 아닙니다. 관리자에게 문의해 주세요.");
		}else{
			HttpSession session = this.getRequest().getSession();

			resultBodyObject.put("result", new JSONObject(convertJSONString));
			
			session.setAttribute("LOGIN_CHK", true);
			session.setAttribute("userId", (String)returnMap.get("user_id"));
			session.setAttribute("userNm", (String)returnMap.get("user_nm"));
			
			System.out.println("ID : "+(String)returnMap.get("user_id")+" NAME : "+(String)returnMap.get("user_nm"));
  
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
