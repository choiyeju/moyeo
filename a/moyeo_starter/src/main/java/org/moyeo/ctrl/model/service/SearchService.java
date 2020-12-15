package org.moyeo.ctrl.model.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import org.moyeo.ctrl.model.vo.SearchVO;

public interface SearchService {
	@Transactional(readOnly=true)
	public List<SearchVO> list(SearchVO vo);
	
	@Transactional(readOnly=true)
	public Integer listCnt(SearchVO vo);
	
	@Transactional(readOnly=true)
	public String selectOne(SearchVO vo);
}
