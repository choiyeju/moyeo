package org.moyeo.ctrl;


import javax.servlet.http.HttpServletRequest;

import org.moyeo.ctrl.model.service.SearchService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MapController {
	private static final Logger logger = LoggerFactory.getLogger(MapController.class);
	@Autowired
	SearchService searchService;
	
	@ResponseBody
	@RequestMapping(value = "/main")
	public ModelAndView main(ModelAndView model, HttpServletRequest request){
		logger.debug("/main.jsp");
		model.setViewName("main");
		return model;
	}
	@ResponseBody
	@RequestMapping(value = "/map")
	public ModelAndView map(ModelAndView model, HttpServletRequest request){
		logger.debug("/map.jsp");
		model.setViewName("map");
		return model;
	}
	@ResponseBody
	@RequestMapping(value = "/header")
	public ModelAndView header(ModelAndView model, HttpServletRequest request){
		logger.debug("/header.jsp");
		model.setViewName("header");
		return model;
	}
	@ResponseBody
	@RequestMapping(value = "/toolbar")
	public ModelAndView toolbar(ModelAndView model, HttpServletRequest request){
		logger.debug("/toolbar.jsp");
		model.setViewName("toolbar");
		return model;
	}
	@ResponseBody
	@RequestMapping(value = "/footer")
	public ModelAndView footer(ModelAndView model, HttpServletRequest request){
		logger.debug("/footer.jsp");
		model.setViewName("footer");
		return model;
	}
	@ResponseBody
	@RequestMapping(value = "/layer-panel")
	public ModelAndView layer_panel(ModelAndView model, HttpServletRequest request){
		logger.debug("/layer-panel.jsp");
		model.setViewName("layer-panel");
		return model;
	}
	@ResponseBody
	@RequestMapping(value = "/side-panel")
	public ModelAndView side_panel(ModelAndView model, HttpServletRequest request){
		logger.debug("/side-panel.jsp");
		model.setViewName("side-panel");
		return model;
	}
}
