package org.moyeo.call.modules.init;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import org.moyeo.call.modules.AbstractModule;
import org.moyeo.call.modules.BusinessMapping;

/**
 * org.moyeo.call.modules.init.SessionCheck
 * @author 최진석
 *
 * 세션 체크
 */ 
@BusinessMapping(id="SESSION_CHECK")
public class SessionCheck extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {

		HttpSession session = this.getRequest().getSession();
		HashMap<String, Object> paramterMap = new HashMap<String, Object>();
		
		paramterMap.put("userId", session.getAttribute("userId"));
		paramterMap.put("userNm", session.getAttribute("userNm"));
		paramterMap.put("CHK", session.getAttribute("LOGIN_CHK"));
		
		HashMap<String, Object> returnMap = sqlSession.selectOne("org.moyeo.call.sql.init.sessionCheck" , paramterMap );
		
		String convertJSONString = getJsonString(returnMap);

		if (convertJSONString.equals("null")) {
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", "세션이 만료되었습니다.");
			resultBodyObject.put("userNm", "guest");
		}else{
			resultBodyObject.put("result", new JSONObject(convertJSONString));
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