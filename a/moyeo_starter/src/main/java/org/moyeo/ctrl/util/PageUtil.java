package org.moyeo.ctrl.util;

import java.util.List;

import org.moyeo.ctrl.model.vo.PageOutVO;

public class PageUtil {
	public static PageOutVO getPageResult(@SuppressWarnings("rawtypes")List resultList, Object so, int totCnt, int pageSize){
		PageOutVO bos = (PageOutVO)so;
		PageOutVO grid = new PageOutVO();
		
		Integer total_cnt = 0;
		Integer total_page = 0;
		Integer cur_page = bos.getCurPage(); 
		Integer rows = bos.getRecordCountPerPage();
		
		if(resultList != null && resultList.size()>0){
			total_cnt = totCnt;
			total_page = total_cnt / rows;
			if(total_cnt % rows > 0){
				total_page++;
			}
		}
		
		grid.setTotalCnt(total_cnt);
		grid.setPageHtml(createPageHtml(cur_page, total_cnt, total_page, pageSize));
		grid.setData(resultList);
		
		return grid;		
	}

	private static String createPageHtml(Integer cur_page, Integer total_cnt, Integer total_page, Integer pageSize){
		StringBuffer html = new StringBuffer();
		html.append("<ul class=\"pop-table-pagination\">");

		int cur_page_group_index = (cur_page - 1) / pageSize;
		int end_page_group_index = (total_page - 1) / pageSize;
		
		boolean hasFirstPageLink = cur_page_group_index > 0;
		if(hasFirstPageLink){
			html.append("<li class=\"active\"><a href=\"#\" class=\"btn-asPaging-first\"><span style=\"display:none;\">1</span></a></a></li>");
		}

		Integer start_page = ((cur_page - 1 ) / pageSize) * pageSize + 1;
		Integer end_page = 0;		
		if(total_page <= 10){
			end_page = total_page;
		}else{
			end_page = start_page + (pageSize-1);
			if(total_page < end_page){
				end_page = total_page;
			}
		}
		
		if(cur_page > 1){
			Integer prev_page = cur_page - 1;
			html.append("<li><a href=\"#\" class=\"btn-asPaging-prev\"><span style=\"display:none;\">"+prev_page+"</span></a></li>");
		}
		
		for(int i=start_page.intValue(); i<= end_page.intValue(); i++){
			if(i == cur_page.intValue()){
				if(i == end_page.intValue()){
					html.append("<li class=\"active\"><a href=\"#\"><span>"+i+"</span></a></li>");
				}else{
					html.append("<li class=\"active\"><a href=\"#\"><span>"+i+"</span></a></li>");
				}
			}else{
				if(i == end_page.intValue()){
					html.append("<li><a href=\"#\"><span>"+i+"</span></a></li>");
				}else{
					html.append("<li><a href=\"#\"><span>"+i+"</span></a></li>");
				}
			}
		}		
		
		// 다음 페이지 --> 현재 페이지 < 전체 페이지
		if(cur_page < total_page){
			Integer next_page = cur_page + 1;
			html.append("<li><a href=\"#\" class=\"btn-asPaging-next\"><span style=\"display:none;\">"+next_page+"</span></a></li>");
		}
		
		// 마지막 페이지
		if(end_page_group_index != cur_page_group_index){
			html.append("<li><a href=\"#\" class=\"btn-asPaging-last\"><span style=\"display:none;\">"+total_page+"</span></a></li>");
		}	
		html.append("</ul>");
		
		return html.toString();
	}	
}
