package org.moyeo.ctrl.model.vo;

import java.io.Serializable;
import java.util.List;

public class PageOutVO implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 8272949713872665964L;
	@SuppressWarnings("rawtypes")
	private List data=null;
	private String pageHtml;
	private Integer totalCnt;
	private Integer curPage;
	private int recordCountPerPage;
	public List<?> getData() {
		return data;
	}
	public void setData(List<?> data) {
		this.data = data;
	}
	public String getPageHtml() {
		return pageHtml;
	}
	public void setPageHtml(String pageHtml) {
		this.pageHtml = pageHtml;
	}
	public Integer getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(Integer totalCnt) {
		this.totalCnt = totalCnt;
	}
	public Integer getCurPage() {
		return curPage;
	}
	public void setCurPage(Integer curPage) {
		this.curPage = curPage;
	}
	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}
	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}
}
