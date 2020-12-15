package org.moyeo.ctrl.model.service;

import java.util.List;

import org.moyeo.ctrl.mapper.SearchMapper;
import org.moyeo.ctrl.model.vo.SearchVO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service
public class SearchServiceImpl extends EgovAbstractServiceImpl implements SearchService{
	@Autowired
	SqlSession sqlSession;
	@Override
	public List<SearchVO> list(SearchVO vo) {
		boolean bJibun=false;
		String searchWord=vo.getKeyword().replaceAll("[+-]?\\d+", "");
		if("".equals(searchWord)){
			// 숫자 입력 시 도로명 주소명으로 건물 검색
			vo.setSearchType("roadName");
			bJibun=true;
		}
		List<SearchVO> search = sqlSession.getMapper(SearchMapper.class).find(vo);
		if(search.isEmpty()){
			if(bJibun){
				// 도로명 주소로 건물명 검색 후 데이터가 존재 하지 않을 때 지번명으로 건물 검색
				vo.setSearchType("aLotNumber");
				search = sqlSession.getMapper(SearchMapper.class).find(vo);
			}
			if(search.isEmpty()){
				if(searchWord.indexOf("로")>0 || searchWord.indexOf("길 ")>0){
					vo.setSearchType("roadName");
				}else{
					vo.setSearchType("aLotNumber");
				}
				search = sqlSession.getMapper(SearchMapper.class).find(vo);
			}
		}
		return search;
	}
	@Override
	public Integer listCnt(SearchVO vo) {
		boolean bJibun=false;
		String searchWord=vo.getKeyword().replaceAll("[+-]?\\d+", "");
		if("".equals(searchWord)){
			// 숫자 입력 시 도로명 주소명으로 건물 검색
			vo.setSearchType("roadName");
			bJibun=true;
		}
		int searchCnt=sqlSession.getMapper(SearchMapper.class).findCnt(vo);
		if(searchCnt==0){
			if(bJibun){
				// 도로명 주소로 건물명 검색 후 데이터가 존재 하지 않을 때 지번명으로 건물 검색
				vo.setSearchType("aLotNumber");
				searchCnt=sqlSession.getMapper(SearchMapper.class).findCnt(vo);
			}
			if(searchCnt==0){
				if(searchWord.indexOf("로")>0 || searchWord.indexOf("길")>0){
					vo.setSearchType("roadName");
				}else{
					vo.setSearchType("aLotNumber");
				}
				searchCnt=sqlSession.getMapper(SearchMapper.class).findCnt(vo);
			}
		}
		return searchCnt;
	}
	@Override
	public String selectOne(SearchVO vo) {
		return sqlSession.getMapper(SearchMapper.class).findPosition(vo);
	}
}
