package com.spring.app.domain;

import org.springframework.web.multipart.MultipartFile;

public class BoardVO {

	private String board_seq;     
	private String fk_category_code;  
	private String fk_empid;          
	private String name;              
	private String subject;           
	private String content;           
	private String pwd;               
	private String read_count;        
	private String registerday;       
	private String status;            
	private String groupno;           
	private String fk_seq;            
	private String depthno;           
	private String orgfilename;       
	private String filename;          
	private String filesize;

	// select 용
	private String previousseq;     // 이전글번호
	private String previoussubject; // 이전글제목
	private String nextseq;         // 다음글번호
	private String nextsubject;     // 다음글제목
	
	private String category_name;
	
	// form 태그에서 type="file" 인 파일을 받아서 저장되는 필드
	private MultipartFile attach;
	
	///////////////////////////////////////////////////////////////	
	
	// getters & setters
	public String getBoard_seq() {
		return board_seq;
	}
	
	public void setBoard_seq(String board_seq) {
		this.board_seq = board_seq;
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
	
	public String getGroupno() {
		return groupno;
	}
	
	public void setGroupno(String groupno) {
		this.groupno = groupno;
	}
	
	public String getFk_seq() {
		return fk_seq;
	}
	
	public void setFk_seq(String fk_seq) {
		this.fk_seq = fk_seq;
	}
	
	public String getDepthno() {
		return depthno;
	}
	
	public void setDepthno(String depthno) {
		this.depthno = depthno;
	}
	
	public String getOrgfilename() {
		return orgfilename;
	}
	
	public void setOrgfilename(String orgfilename) {
		this.orgfilename = orgfilename;
	}
	
	public String getFilename() {
		return filename;
	}
	
	public void setFilename(String filename) {
		this.filename = filename;
	}
	
	public String getFilesize() {
		return filesize;
	}
	
	public void setFilesize(String filesize) {
		this.filesize = filesize;
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

	public MultipartFile getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	
}
