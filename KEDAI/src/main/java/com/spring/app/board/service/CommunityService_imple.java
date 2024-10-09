package com.spring.app.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.board.model.CommunityDAO;
import com.spring.app.domain.CommentVO;
import com.spring.app.domain.CommunityCategoryVO;
import com.spring.app.domain.CommunityFileVO;
import com.spring.app.domain.CommunityVO;

@Service
public class CommunityService_imple implements CommunityService {

	@Autowired
	private CommunityDAO dao;

	// 커뮤니티 카테고리 목록 조회하기
	@Override
	public List<CommunityCategoryVO> category_select() {
		List<CommunityCategoryVO> categoryList = dao.category_select();
		return categoryList;
	}

	// 글번호 채번해오기
	@Override
	public int getCseqOfCommunity() {
		int community_seq = dao.getCseqOfCommunity();
		return community_seq;
	}

	// 글쓰기
	@Override
	public int add(CommunityVO cvo) {
		int n = dao.add(cvo);
		return n;
	}

	// tbl_community_file 테이블에 첨부파일 등록하기
	@Override
	public int community_attachfile_insert(Map<String, Object> paraMap) {
		int attach_insert_result = dao.community_attachfile_insert(paraMap);
		return attach_insert_result;
	}

	// 총 게시물 건수(totalCount) 구하기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = dao.getTotalCount(paraMap);
		return totalCount;
	}

	// 글목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	@Override
	public List<CommunityVO> communityListSearch_withPaging(Map<String, String> paraMap) {
		List<CommunityVO> communityList = dao.communityListSearch_withPaging(paraMap);
		return communityList;
	}

	// 검색어 입력 시 자동글 완성하기
	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = dao.wordSearchShow(paraMap);
		return wordList;
	}

	// 글 조회수 증가와 함께 글 1개를 조회하기
	@Override
	public CommunityVO getView(Map<String, String> paraMap) {
		CommunityVO cvo = dao.getView(paraMap);
		
		String login_empid = paraMap.get("login_empid");
		
		if(login_empid != null && cvo != null && !login_empid.equals(cvo.getFk_empid())) {
			int n = dao.increase_readCount(cvo.getCommunity_seq());
		
			if(n == 1) {
				cvo.setRead_count(String.valueOf(Integer.parseInt(cvo.getRead_count())+1));
			}
		}
		
		return cvo;
	}

	// 글 조회수 증가는 없고 단순히  글 1개만 조회하기
	@Override
	public CommunityVO getView_noIncrease_readCount(Map<String, String> paraMap) {
		CommunityVO cvo = dao.getView(paraMap);
		return cvo;
	}
	
	// 첨부파일 조회하기
	@Override
	public List<CommunityFileVO> getAttachFileList(String fk_community_seq) {
		List<CommunityFileVO> attachFileList = dao.getAttachFileList(fk_community_seq);
		return attachFileList;
	}
	
	// 첨부파일 다운로드 받기
	@Override
	public CommunityFileVO getFilename(Map<String, String> paraMap) {
		CommunityFileVO cfvo = dao.getFilename(paraMap);
		return cfvo;
	}
	
	// 커뮤니티 첨부파일 삭제하기
	@Override
	public int community_attachfile_delete(String community_seq) {
		int attach_delete_result = dao.community_attachfile_delete(community_seq);
		return attach_delete_result;
	}	
	
	// 커뮤니티 글 수정하기
	@Override
	public int edit(CommunityVO cvo) {
		int n = dao.edit(cvo);
		return n;
	}
	
	// 커뮤니티 글 삭제하기
	@Override
	public int del(String fk_community_seq) {
		int n = dao.del(fk_community_seq);
		return n;
	}

	// 댓글쓰기(Transaction 처리)
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int addComment(CommentVO commentvo) throws Throwable {
		
		int n1 = 0, n2 = 0, result = 0;
		
		// 댓글쓰기(tbl_comment 테이블에 insert)
		n1 = dao.addComment(commentvo);

		if(n1 == 1) {
			// tbl_board 테이블에 commentCount 컬럼이 1 증가(update)
			n2 = dao.updateCommentCount(commentvo.getFk_community_seq());
		}
		
		if(n2 == 1) {
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("empid", commentvo.getFk_empid());
			paraMap.put("point", "50");
			
			// tbl_employees 테이블의 point 컬럼의 값을 50점 증가(update)
			result = dao.updateMemberPoint(paraMap);
		}
		
		return result;
	}

	// 댓글 내용들을 페이징 처리하기
	@Override
	public List<CommentVO> getCommentList_Paging(Map<String, String> paraMap) {
		List<CommentVO> commentList = dao.getCommentList_Paging(paraMap);
		return commentList;
	}

	// 페이징처리 시 보여주는 순번을 나타내기 위한 것
	@Override
	public int getCommentTotalCount(String fk_community_seq) {
		int totalCount = dao.getCommentTotalCount(fk_community_seq);
		return totalCount;
	}

	// 댓글 수정하기(Ajax 로 처리)
	@Override
	public int updateComment(Map<String, String> paraMap) {
		int n = dao.updateComment(paraMap);
		return n;
	}

	// 댓글 삭제하기(Ajax 로 처리 & Transaction 처리)
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public int deleteComment(Map<String, String> paraMap) throws Throwable {
		int n = dao.deleteComment(paraMap.get("comment_seq"));
		
		int m = 0;
		if(n == 1) { // 댓글삭제 시 tbl_community 테이블에 comment_count 컬럼이 1감소(update)
			m = dao.updateCommentCount_decrease(paraMap.get("fk_community_seq"));
		}
		
		return n*m;
	}

	// 좋아요 누르기
	@Override
	public int likeAdd(Map<String, String> paraMap) {
		int n = dao.likeAdd(paraMap);
		return n;
	}

	// 좋아요 취소하기
	@Override
	public int likeMinus(Map<String, String> paraMap) {
		int n = dao.likeMinus(paraMap);
		return n;
	}

}
