package com.youtube.model.vo;

import java.util.Date;

public class CommentLike {
	private int commLikeCode;
	private Date commLikeDate;
	private int commentCode;
	private Member member;
	
	public CommentLike() {
		// TODO Auto-generated constructor stub
	}

	public CommentLike(int commLikeCode, Date commLikeDate, int commentCode, Member member) {
		this.commLikeCode = commLikeCode;
		this.commLikeDate = commLikeDate;
		this.commentCode = commentCode;
		this.member = member;
	}
	
	
	
	
	
}
