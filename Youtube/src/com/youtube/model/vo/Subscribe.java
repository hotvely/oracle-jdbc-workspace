package com.youtube.model.vo;

import java.util.Date;

public class Subscribe {
	private int subsCode;
	private Date subsDate;
	private Member member;
	private Channel channel;
	public Subscribe() {
		// TODO Auto-generated constructor stub
	}
	public Subscribe(int subsCode, Date subsDate, Member member, Channel channel) {
		this.subsCode = subsCode;
		this.subsDate = subsDate;
		this.member = member;
		this.channel = channel;
	}
	
	
	
	
}
