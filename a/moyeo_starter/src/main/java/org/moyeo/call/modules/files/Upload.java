package org.moyeo.call.modules.files;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import org.moyeo.call.GeoQuery;
import org.moyeo.call.modules.AbstractModule;


/**
 * org.moyeo.call.modules.files.Upload
 * @author 최진석
 *
 */
public class Upload extends AbstractModule{

	@Override
	public void run(JSONObject resultHeaderObject, JSONObject resultBodyObject) {
	
		HttpServletRequest request = this.getRequest();
		HttpServletResponse response = this.getResponse();
		
		try {
	    	String fileUploadPath = GeoQuery.getProperty("upload.path");

	    	Statement stmt = sqlSession.getConnection().createStatement();
	    	String query = String.format("SELECT * FROM test WHERE id='%s'", parameterObject.getString("id"));
	    	
	    	System.out.println("query :: " + query);
	    	
	    	ResultSet rs = stmt.executeQuery(query);
	    	String orgPath = null;
	    	if (rs.next()) {
	    		orgPath = rs.getString("IMAGE_PATH");
	    	}
	    	
			System.out.println("orgPath :: " + orgPath);
			
			String targetDirectory = String.format(
					"%s%s", 
					fileUploadPath, 
					orgPath
					);

	    	System.out.println("targetDirectory : " + targetDirectory);

	    	File file = new File(targetDirectory);
	    	if (file.exists()) {

	    		ServletContext cntx = request.getServletContext();
				String mime = cntx.getMimeType(targetDirectory);
				if (mime == null) {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					return;
				}
				
				response.setContentType(mime);
			
				response.setContentLength((int) file.length());
		
				FileInputStream in = new FileInputStream(file);
				OutputStream out = response.getOutputStream();
		
				byte[] buf = new byte[1024];
				int count = 0;
				while ((count = in.read(buf)) >= 0) {
					out.write(buf, 0, count);
				}
		
				out.close();
				in.close();
				
				resultObject.put("return.type", "response-end");
			}else {
	        	
				resultHeaderObject.put("process", "fail");
				resultHeaderObject.put("ment", "file is not exists");
			
			}

        } catch(Exception caught) {
        	
        	caught.printStackTrace();
        	
			resultHeaderObject.put("process", "fail");
			resultHeaderObject.put("ment", caught.getMessage());
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
