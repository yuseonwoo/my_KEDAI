package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.BoardVO;
import com.spring.app.domain.CategoryVO;

public interface BoardDAO {

	// 카테고리 목록 조회하기
	List<CategoryVO> category_select();

	// tbl_board 테이블에서 groupno 컬럼의 최대값 알아오기
	int getGroupnoMax();
	
	// 파일첨부가 없는 글쓰기
	int add(BoardVO bvo);
	
	// 파일첨부가 있는 글쓰기
	int add_withFile(BoardVO bvo);
	
	// 특정 사원에게 특정 점수만큼 포인트를 증가하기 
	void pointPlus(Map<String, String> paraMap);

	// 총 게시물 건수(totalCount) 구하기
	int getTotalCount(Map<String, String> paraMap);

	// 글목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	List<BoardVO> boardListSearch_withPaging(Map<String, String> paraMap);

	// 검색어 입력 시 자동글 완성하기 
	List<String> wordSearchShow(Map<String, String> paraMap);

	// 글 조회수 증가와 함께 글 1개를 조회하기
	BoardVO getView(Map<String, String> paraMap);

	// 글조회수 1 증가하기
	int increase_readCount(String board_seq);

	// 파일첨부가 없는 1개의 글 수정하기
	int edit(BoardVO bvo);

	// 파일첨부가 있는 1개의 글 수정하기
	int edit_withFile(BoardVO bvo);

	// 1개의 글 삭제하기
	int del(String board_seq);

}
