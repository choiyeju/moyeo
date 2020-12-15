package org.moyeo.util.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.AntPathMatcher;

import egovframework.rte.fdl.cmmn.trace.LeaveaTrace;
import egovframework.rte.fdl.cmmn.trace.handler.DefaultTraceHandler;
import egovframework.rte.fdl.cmmn.trace.handler.TraceHandler;
import egovframework.rte.fdl.cmmn.trace.manager.DefaultTraceHandleManager;

@Configuration
public class EgovConfig {

	public AntPathMatcher antPathMatcher() {
		AntPathMatcher antPathMatcher = new AntPathMatcher();
		return antPathMatcher;
	}
	public TraceHandler[] traceHandlers() {
		TraceHandler[] traceHandlers = new TraceHandler[1];
		traceHandlers[0] = new DefaultTraceHandler();
		return traceHandlers;
	}
	public DefaultTraceHandleManager[] defaultTraceHandleManager(){
		DefaultTraceHandleManager[] defaultTraceHandleManagers = new DefaultTraceHandleManager[1];
		DefaultTraceHandleManager defaultTraceHandleManager = new DefaultTraceHandleManager();
		defaultTraceHandleManager.setReqExpMatcher(antPathMatcher());
		String [] patterns = {"*"};
		defaultTraceHandleManager.setPatterns(patterns);
		defaultTraceHandleManager.setHandlers(traceHandlers());
		defaultTraceHandleManagers[0] = defaultTraceHandleManager;
		return defaultTraceHandleManagers;
	}
	@Bean(name="leaveaTrace")
	public LeaveaTrace LeaveaTrace(){
		LeaveaTrace leaveaTrace = new LeaveaTrace();
		leaveaTrace.setTraceHandlerServices(defaultTraceHandleManager());
		return leaveaTrace;
	}
}
