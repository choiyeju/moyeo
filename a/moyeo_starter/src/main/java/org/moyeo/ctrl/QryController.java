package org.moyeo.ctrl;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.jdom2.Element;
import org.jdom2.filter.Filters;
import org.jdom2.xpath.XPathExpression;
import org.jdom2.xpath.XPathFactory;
import org.json.JSONArray;
import org.json.JSONObject;
import org.moyeo.call.modules.AbstractModule;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class QryController {
	private static final Logger logger = LoggerFactory.getLogger(QryController.class);
	
	@ResponseBody
	@RequestMapping(value = "/qry")
	public void qry(HttpServletResponse response, HttpServletRequest request, @RequestBody String list){
		logger.debug("/qry");
		try {
			JSONObject resultObj = invokeModule(requestBody(request, list), request, response);
			
			if (resultObj.getString("return.type").equals("application/json")){
				response.setCharacterEncoding("UTF-8");
				response.setContentType("application/json");
				response.getWriter().append(resultObj.toString());
				response.getWriter().flush();
			}else if (resultObj.getString("return.type").equals("text/plain")) {
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/plain");
				String resultString = resultObj.toString();
				response.getWriter().append(resultString);
				response.getWriter().flush();
			}else if (resultObj.getString("return.type").equals("response-end")) {
				
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	@ResponseBody
	@RequestMapping(value = "/qry/{cmd}")
	public void qry_cmd(HttpServletResponse response, HttpServletRequest request, @PathVariable ("cmd") String cmd, @RequestBody String list){
		logger.debug("/qry/"+cmd);
		try {
			JSONObject resultObj =  null;
			System.out.println("/qry/"+cmd);
			AbstractModule tgrModule = (AbstractModule) this.getClass(cmd).newInstance();
			if (tgrModule != null) {
				tgrModule.setParameter(requestBody(request, list));
				tgrModule.setRequest(request);
				tgrModule.setResponse(response);
				resultObj =  tgrModule.invoke();
			} else {
				resultObj = new JSONObject();
				resultObj.put("return.type", "application/json");
				JSONObject resultHeaderObject = new JSONObject();
				resultHeaderObject.put("process", "fail");
				JSONObject resultBodyObject = new JSONObject();
				resultObj.put("header", resultHeaderObject);
				resultObj.put("body", resultBodyObject);
			}
			if (resultObj.getString("return.type").equals("application/json")){
				response.setCharacterEncoding("UTF-8");
				response.setContentType("application/json");
				response.getWriter().append(resultObj.toString());
				response.getWriter().flush();
			}else if (resultObj.getString("return.type").equals("text/plain")) {
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/plain");
				String resultString = resultObj.toString();
				response.getWriter().append(resultString);
				response.getWriter().flush();
			}else if (resultObj.getString("return.type").equals("response-end")) {
				
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private JSONObject requestBody(HttpServletRequest request, String list) throws IOException {
		if (ServletFileUpload.isMultipartContent(request)) {
			return processUpload(request);
		}else {
			if (request.getContentType() == null) {
				JSONObject paramJSON = new JSONObject();
				Enumeration<String> tgrEnum = request.getParameterNames();
				while(tgrEnum.hasMoreElements()) {
					String rKey = tgrEnum.nextElement();
					String rValue = request.getParameter(rKey);
					paramJSON.put(rKey, rValue);
				}
				System.out.println(paramJSON.toString());
				return paramJSON;
			}else if (request.getContentType().toLowerCase().contains("application/x-www-form-urlencoded")) {
				String bodyString = list; 
				if(bodyString.equals("")) {
					BufferedReader input = new BufferedReader(new InputStreamReader(request.getInputStream()));
					StringBuilder builder = new StringBuilder();
					String buffer;
					
					while ((buffer = input.readLine()) != null) {
						if (builder.length() > 0) {
							builder.append("\n");
						}
						builder.append(buffer);
					}
					bodyString = builder.toString();
				}
				System.out.println("bodyString: "+bodyString);
				if(bodyString.equals("")) {
					return null;
				}
				String[] jString = null;
				String jtypeString = "";
				if( bodyString.indexOf("{") > -1 ) {
				} else {
					jtypeString += "{";
					jString = bodyString.split("\\&");
					for( int i=0; i<jString.length; i++ ) {
						
						String[] val = jString[i].split("=",2);
						
						jtypeString += val[0]+":\""+val[1]+"\",";
					}
					jtypeString += "}";
					bodyString = jtypeString;
				}
				return new JSONObject(bodyString);
			}else {
				return null;
			}
		}
	}
	private JSONObject invokeModule(JSONObject obj, HttpServletRequest request, HttpServletResponse response) throws ClassNotFoundException, InstantiationException, IllegalAccessException {
		
		System.out.println("cmd :: " + obj.getString("cmd"));

		String commandId = obj.getString("cmd");
		AbstractModule tgrModule = (AbstractModule) this.getClass(commandId).newInstance();
		if (tgrModule == null) return null;
		tgrModule.setParameter(obj);
		tgrModule.setRequest(request);
		tgrModule.setResponse(response);
		
		return tgrModule.invoke();
		
	}

	private JSONObject processUpload(HttpServletRequest request) {

		JSONObject retObj = new JSONObject();
		JSONArray retArray = new JSONArray();
		retObj.put("cmd", "FILE_UPLOAD");
		retObj.put("files", retArray);
		ServletFileUpload upload = new ServletFileUpload(); // from Commons

		try {

			String fileUploadPath = G.Props.getProperty("upload.path"); // 업로드 된 파일이 저장될 실제 경로
			FileItemIterator iter = upload.getItemIterator(request);

			if (iter.hasNext()) {

				String uuid = UUID.randomUUID().toString();
				String[] uuids = uuid.split("-");
				String directory0 = uuids[0].substring(0, 2);
				String directory1 = uuids[1].substring(0, 2);
				String directory2 = uuids[2].substring(0, 2);
				String directory3 = uuids[3].substring(0, 2);
				String directory4 = uuids[4].substring(0, 2);
						
				FileItemStream fileItem = iter.next();

				InputStream in = fileItem.openStream();

				String targetDirectory = String.format(
						"%s/%s/%s/%s/%s/%s/", 
						fileUploadPath, 
						directory0, directory1, directory2, directory3, directory4
						);
				
				File tgrDir = new File(targetDirectory);
				tgrDir.mkdirs();
				String fileExt = fileItem.getName().substring(fileItem.getName().length() - 3);
				fileUploadPath = targetDirectory + uuid + "." + fileExt;
				
				JSONObject fileObj = new JSONObject();
				fileObj.put("fileName", fileItem.getName());
				fileObj.put("saveName", uuid + "." + fileExt);
				fileObj.put("contentType", fileItem.getContentType());
				fileObj.put("fullPath", fileUploadPath);
				retArray.put(fileObj);
				
				File file = new File(fileUploadPath);
				OutputStream outputStream = new FileOutputStream(file);

				int length = 0;
				byte[] bytes = new byte[1024];

				while ((length = in.read(bytes)) != -1) {
					outputStream.write(bytes, 0, length);
				}

				outputStream.close();

				in.close();
			}

		} catch (Exception caught) {
			caught.printStackTrace();
		}

		return retObj;
	}
	
	private Class<?> getClass(String commandId) throws ClassNotFoundException {
		XPathFactory xpfac = XPathFactory.instance();
		String xPathBusiness = String.format("//business[@id='%s']", commandId);
		XPathExpression<Element> xp = xpfac.compile(xPathBusiness, Filters.element());
//		System.out.println(bizDocument.toString());
		Element el = (Element) xp.evaluateFirst(G.getDocument());
		
//		System.out.println(xPathBusiness);
		
		String targetClassValue = el.getValue();
		if (targetClassValue != null) {
			return (Class<?>) Class.forName(targetClassValue);
		}else {
			return null;
		}
	}
}
