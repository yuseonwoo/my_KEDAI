package com.spring.app.domain;

public class RoomSubVO {
	   private int roomSubSeq;
	    private int roomMainSeq;
	    private String roomSubName;
	    private String roomSub_detail;
	    private int room_status;

	    // Getters and Setters
	    public int getRoomSubSeq() {
	        return roomSubSeq;
	    }

	    public void setRoomSubSeq(int roomSubSeq) {
	        this.roomSubSeq = roomSubSeq;
	    }

	    public int getRoomMainSeq() {
	        return roomMainSeq;
	    }

	    public void setRoomMainSeq(int roomMainSeq) {
	        this.roomMainSeq = roomMainSeq;
	    }

	    public String getRoomSubName() {
	        return roomSubName;
	    }

	    public void setRoomSubName(String roomSubName) {
	        this.roomSubName = roomSubName;
	    }

		public String getRoomSub_detail() {
			return roomSub_detail;
		}

		public void setRoomSub_detail(String roomSub_detail) {
			this.roomSub_detail = roomSub_detail;
		}

		public int getRoom_status() {
			return room_status;
		}

		public void setRoom_status(int room_status) {
			this.room_status = room_status;
		}
	    
	    
	}
