package com.spring.app.domain;

public class CommunityVO {

	private String community_seq;
	private String fk_category_code;
	private String fk_empid;
	private String name;
	private String subject;
	private String content;
	private String pwd;
	private String read_count;
	private String registerday;
	private String status;
	private String comment_count;
	
	// select 용
	private String previousseq;     // 이전글번호
	private String previoussubject; // 이전글제목
	private String nextseq;         // 다음글번호
	private String nextsubject;     // 다음글제목
	
	private String category_name;
	private String nickname;
	private String imgfilename;
	private String fk_community_seq;
	private String like_count;
	
	///////////////////////////////////////////////////////////////	
	
	// getters & setters
	public String getCommunity_seq() {
		return community_seq;
	}
	
	public void setCommunity_seq(String community_seq) {
		this.community_seq = community_seq;
	}
	
	public String getFk_category_code() {
		return fk_category_code;
	}
	
	public void setFk_category_code(String fk_category_code) {
		this.fk_category_code = fk_category_code;
	}
	
	public String getFk_empid() {
		return fk_empid;
	}
	
	public void setFk_empid(String fk_empid) {
		this.fk_empid = fk_empid;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getSubject() {
		return subject;
	}
	
	public void setSubject(String subject) {
		this.subject = subject;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public String getPwd() {
		return pwd;
	}
	
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	
	public String getRead_count() {
		return read_count;
	}
	
	public void setRead_count(String read_count) {
		this.read_count = read_count;
	}
	
	public String getRegisterday() {
		return registerday;
	}
	
	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}

	public String getComment_count() {
		return comment_count;
	}

	public void setComment_count(String comment_count) {
		this.comment_count = comment_count;
	}

	public String getPreviousseq() {
		return previousseq;
	}

	public void setPreviousseq(String previousseq) {
		this.previousseq = previousseq;
	}

	public String getPrevioussubject() {
		return previoussubject;
	}

	public void setPrevioussubject(String previoussubject) {
		this.previoussubject = previoussubject;
	}

	public String getNextseq() {
		return nextseq;
	}

	public void setNextseq(String nextseq) {
		this.nextseq = nextseq;
	}

	public String getNextsubject() {
		return nextsubject;
	}

	public void setNextsubject(String nextsubject) {
		this.nextsubject = nextsubject;
	}

	public String getCategory_name() {
		return category_name;
	}

	public void setCategory_name(String category_name) {
		this.category_name = category_name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getImgfilename() {
		return imgfilename;
	}

	public void setImgfilename(String imgfilename) {
		this.imgfilename = imgfilename;
	}

	public String getFk_community_seq() {
		return fk_community_seq;
	}

	public void setFk_community_seq(String fk_community_seq) {
		this.fk_community_seq = fk_community_seq;
	}

	public String getLike_count() {
		return like_count;
	}

	public void setLike_count(String like_count) {
		this.like_count = like_count;
	}
	
}