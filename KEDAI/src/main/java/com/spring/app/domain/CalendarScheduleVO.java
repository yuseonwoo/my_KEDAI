package com.spring.app.domain;

public class CalendarScheduleVO {

	private String scheduleno;    // 일정관리 번호
	private String cal_startdate;     // 시작일자
	private String cal_enddate;       // 종료일자
	private String cal_subject;       // 제목
	private String cal_color;         // 색상
	private String cal_place;         // 장소1
	private String cal_joinuser;      // 공유자	
	private String cal_content;       // 내용	1
	private String fk_smcatgono;  // 캘린더 소분류 번호
	private String fk_lgcatgono;  // 캘린더 대분류 번호
	private String fk_empid;	   // 캘린더 일정 작성자 유저아이디
	
	public String getScheduleno() {
		return scheduleno;
	}
	public void setScheduleno(String scheduleno) {
		this.scheduleno = scheduleno;
	}
	public String getCal_startdate() {
		return cal_startdate;
	}
	public void setCal_startdate(String cal_startdate) {
		this.cal_startdate = cal_startdate;
	}
	public String getCal_enddate() {
		return cal_enddate;
	}
	public void setCal_enddate(String cal_enddate) {
		this.cal_enddate = cal_enddate;
	}
	public String getCal_subject() {
		return cal_subject;
	}
	public void setCal_subject(String cal_subject) {
		this.cal_subject = cal_subject;
	}
	public String getCal_color() {
		return cal_color;
	}
	public void setCal_color(String cal_color) {
		this.cal_color = cal_color;
	}
	public String getCal_place() {
		return cal_place;
	}
	public void setCal_place(String cal_place) {
		this.cal_place = cal_place;
	}
	public String getCal_joinuser() {
		return cal_joinuser;
	}
	public void setCal_joinuser(String cal_joinuser) {
		this.cal_joinuser = cal_joinuser;
	}
	public String getCal_content() {
		return cal_content;
	}
	public void setCal_content(String cal_content) {
		this.cal_content = cal_content;
	}
	public String getFk_smcatgono() {
		return fk_smcatgono;
	}
	public void setFk_smcatgono(String fk_smcatgono) {
		this.fk_smcatgono = fk_smcatgono;
	}
	public String getFk_lgcatgono() {
		return fk_lgcatgono;
	}
	public void setFk_lgcatgono(String fk_lgcatgono) {
		this.fk_lgcatgono = fk_lgcatgono;
	}
	public String getFk_empid() {
		return fk_empid;
	}
	public void setFk_empid(String fk_empid) {
		this.fk_empid = fk_empid;
	}  
}
