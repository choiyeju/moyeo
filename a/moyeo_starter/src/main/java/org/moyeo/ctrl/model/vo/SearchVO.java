package org.moyeo.ctrl.model.vo;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

public class SearchVO extends PageOutVO{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6048265973834901369L;
	public String toString(){
		return ToStringBuilder.reflectionToString(this, ToStringStyle.MULTI_LINE_STYLE);
	}
	private String searchType;
	private String keyword;
	private String fmynm;
	private Double lon;
	private Double lat;
	private Integer pageIndex=1;
	private Integer pageSize=5;
	private Integer firstIndex;
	private Integer lastIndex;	
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getFmynm() {
		return fmynm;
	}
	public void setFmynm(String fmynm) {
		this.fmynm = fmynm;
	}
	public Double getLon() {
		return lon;
	}
	public void setLon(Double lon) {
		this.lon = lon;
	}
	public Double getLat() {
		return lat;
	}
	public void setLat(Double lat) {
		this.lat = lat;
	}
	public Integer getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(Integer pageIndex) {
		this.pageIndex = pageIndex;
	}
	public Integer getPageSize() {
		return pageSize;
	}
	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}
	public Integer getFirstIndex() {
		return firstIndex;
	}
	public void setFirstIndex(Integer firstIndex) {
		this.firstIndex = firstIndex;
	}
	public Integer getLastIndex() {
		return lastIndex;
	}
	public void setLastIndex(Integer lastIndex) {
		this.lastIndex = lastIndex;
	}
}
