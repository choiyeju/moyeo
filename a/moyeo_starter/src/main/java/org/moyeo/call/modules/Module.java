package org.moyeo.call.modules;

import org.json.JSONObject;

public interface Module {

	void setParameter(JSONObject obj);

	void run(JSONObject resultHeaderObject, JSONObject resultBodyObject);
	
}
