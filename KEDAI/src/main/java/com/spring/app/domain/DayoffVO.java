package com.spring.app.domain;

public class DayoffVO {
	
	private String dayoff_no;	// 신청서시퀀스
	private String fk_doc_no;	//기안문서번호
	private String dayoff_type;	//연차종류(반차휴가)
	private String startdate;	//휴가시작일
	private String enddate;	//휴가종료일
	private String start_half;	//휴가시작일반차(만약하루만연차일경우여기에반차가생김)0미해당1오전2오후
	private String end_half;	//휴가종료일반차0미해당1오전2오후
	private String offdays;
	
	
	public String getOffdays() {
		return offdays;
	}
	public void setOffdays(String offdays) {
		this.offdays = offdays;
	}
	
	public String getDayoff_no() {
		return dayoff_no;
	}
	public void setDayoff_no(String dayoff_no) {
		this.dayoff_no = dayoff_no;
	}
	public String getFk_doc_no() {
		return fk_doc_no;
	}
	public void setFk_doc_no(String fk_doc_no) {
		this.fk_doc_no = fk_doc_no;
	}
	public String getDayoff_type() {
		return dayoff_type;
	}
	public void setDayoff_type(String dayoff_type) {
		this.dayoff_type = dayoff_type;
	}
	public String getStartdate() {
		return startdate;
	}
	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}
	public String getStart_half() {
		return start_half;
	}
	public void setStart_half(String start_half) {
		this.start_half = start_half;
	}
	public String getEnd_half() {
		return end_half;
	}
	public void setEnd_half(String end_half) {
		this.end_half = end_half;
	}

	
	
}
