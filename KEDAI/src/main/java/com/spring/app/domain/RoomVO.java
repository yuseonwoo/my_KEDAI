package com.spring.app.domain;

public class RoomVO {
	
	private int reservation_seq;
	private String fk_empid;
	private String fk_room_name;
	private String content;
	private String start_time;
	private String end_time;
	private String registerday;
	private int reservation_status;
	
	
	public int getReservation_seq() {
		return reservation_seq;
	}

	public String getFk_empid() {
		return fk_empid;
	}

	public void setFk_empid(String fk_empid) {
		this.fk_empid = fk_empid;
	}

	public String getFk_room_name() {
		return fk_room_name;
	}

	public void setFk_room_name(String fk_room_name) {
		this.fk_room_name = fk_room_name;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getStart_time() {
		return start_time;
	}

	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}

	public String getEnd_time() {
		return end_time;
	}

	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}

	public String getRegisterday() {
		return registerday;
	}

	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}

	public int getReservation_status() {
		return reservation_status;
	}

	public void setReservation_status(int reservation_status) {
		this.reservation_status = reservation_status;
	}

	public void setReservation_seq(int reservation_seq) {
		this.reservation_seq = reservation_seq;
	}
	
	
}
