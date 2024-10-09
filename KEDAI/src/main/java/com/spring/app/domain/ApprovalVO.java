package com.spring.app.domain;

public class ApprovalVO {
	
	private String approval_no;    			//결재번호 
	private String fk_doc_no;  				// 기안문서번호
	private String fk_empid;        		//결재자사원아이디  
	private String status;     				//결재상태         
	private String approval_comment;        //결재의견   
	private String approval_date;           //결재일자
	private String level_no;                //결재단계
	
	///////////////////////////////////////////tbl_employees////////////////////////////////
	private String name;	// 결재자 이름
	private String sign_img; // 결재자 사인
	private String imgfilename; // 결재자 사인
		
	///////////////////////////////////////////tbl_job////////////////////////////////
	private String job_name;	// 결재자 직급
	
	
	///////////////////////////////////////////tbl_doc////////////////////////////////
	private String doc_status;

	
	public String getDoc_status() {
		return doc_status;
	}
	public void setDoc_status(String doc_status) {
		this.doc_status = doc_status;
	}
	
	public String getApproval_no() {
		return approval_no;
	}
	public void setApproval_no(String approval_no) {
		this.approval_no = approval_no;
	}
	
	public String getFk_doc_no() {
		return fk_doc_no;
	}
	public void setFk_doc_no(String fk_doc_no) {
		this.fk_doc_no = fk_doc_no;
	}
	
	public String getFk_empid() {
		return fk_empid;
	}
	public void setFk_empid(String fk_empid) {
		this.fk_empid = fk_empid;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getApproval_comment() {
		return approval_comment;
	}
	public void setApproval_comment(String approval_comment) {
		this.approval_comment = approval_comment;
	}
	
	public String getApproval_date() {
		return approval_date;
	}
	public void setApproval_date(String approval_date) {
		this.approval_date = approval_date;
	}
	
	public String getLevel_no() {
		return level_no;
	}
	public void setLevel_no(String level_no) {
		this.level_no = level_no;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getJob_name() {
		return job_name;
	}
	public void setJob_name(String job_name) {
		this.job_name = job_name;
	}
	
	public String getSign_img() {
		return sign_img;
	}
	
	public void setSign_img(String sign_img) {
		this.sign_img = sign_img;
	}
	
	public String getImgfilename() {
		return imgfilename;
	}
	public void setImgfilename(String imgfilename) {
		this.imgfilename = imgfilename;
	}
	
	
	/*
	 @Override
	public String toString() {
	return "ApprovalVO{" +
	                "approval_no=" + approval_no +
	                ", fk_doc_no=" + fk_doc_no +
	                ", fk_empid=" + fk_empid +
	                ", status=" + status +
	                ", approval_comment=" + approval_comment +
	                ", approval_date=" + approval_date +
	                ", level_no=" + level_no +
	                ", name=" + name +
	                ", sign_img=" + sign_img +
	                ", job_name=" + job_name +
	                ", doc_status=" + doc_status +
	                '}';
	    }
	*/
	

}
