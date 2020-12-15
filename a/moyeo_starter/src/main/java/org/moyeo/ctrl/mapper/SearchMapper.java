package org.moyeo.ctrl.mapper;

import java.util.List;

import org.moyeo.ctrl.model.vo.SearchVO;

public interface SearchMapper {
	public List<SearchVO> find(SearchVO vo);
	public Integer findCnt(SearchVO vo);
	public String findPosition(SearchVO vo);
}
