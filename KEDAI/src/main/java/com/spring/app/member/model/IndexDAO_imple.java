package com.spring.app.member.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.BoardVO;

@Repository
public class IndexDAO_imple implements IndexDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	@Override
	public int memberTotalCountJSON() {
		int totalCount = sqlsession.selectOne("index.memberTotalCountJSON");
		return totalCount;
	}
	
	@Override
	public int boardTotalCountJSON() {
		int totalCount = sqlsession.selectOne("index.boardTotalCountJSON");
		return totalCount;
	}

	@Override
	public List<BoardVO> boardListJSON(String category_code) {
		List<BoardVO> boardList = sqlsession.selectList("index.boardListJSON", category_code);
		return boardList;
	}

	@Override
	public BoardVO boardMenuJSON() {
		BoardVO bvo = sqlsession.selectOne("index.boardMenuJSON");
		return bvo;
	}

	@Override
	public int pointMinus(Map<String, String> paraMap) {
		int n = sqlsession.update("index.pointMinus", paraMap);
		return n;
	}

}
