package com.spring.app.domain;

public class RoomMainVO {
  private int roomMainSeq;
    private String roomMainName;
    private String roomMainDetail;
    
    
    public String getRoomMainDetail() {
		return roomMainDetail;
	}

	public void setRoomMainDetail(String roomMainDetail) {
		this.roomMainDetail = roomMainDetail;
	}

	// Getters and Setters
    public int getRoomMainSeq() {
        return roomMainSeq;
    }

    public void setRoomMainSeq(int roomMainSeq) {
        this.roomMainSeq = roomMainSeq;
    }

    public String getRoomMainName() {
        return roomMainName;
    }

    public void setRoomMainName(String roomMainName) {
        this.roomMainName = roomMainName;
    }
}