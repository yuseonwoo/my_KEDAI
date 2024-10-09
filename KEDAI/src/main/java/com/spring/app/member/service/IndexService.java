package com.spring.app.member.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.BoardVO;

public interface IndexService {

	// 사원수 조회하기
	int memberTotalCountJSON();
	
	// 게시글수 조회하기
	int boardTotalCountJSON();

	// 게시판 글 조회하기
	List<BoardVO> boardListJSON(String category_code);

	// 식단표 조회하기
	BoardVO boardMenuJSON();

	// 특정 사원에게 특정 점수만큼 포인트를 감소하기 
	int pointMinus(Map<String, String> paraMap);
	
}
