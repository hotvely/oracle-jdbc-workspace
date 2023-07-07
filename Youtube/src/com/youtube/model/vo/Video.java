package com.youtube.model.vo;

import java.util.Date;

public class Video {
	private int videoCiode;
	private String videoTitle;
	private String videoDesc;
	private Date videoDate;
	private int videoVies;
	private String videoUrl;
	private String videoPhoto;
	private Category category;
	private Channel channel;
	private Member member;
	public Video() {
		// TODO Auto-generated constructor stub
	}
	public Video(int videoCiode, String videoTitle, String videoDesc, Date videoDate, int videoVies, String videoUrl,
			String videoPhoto, Category category, Channel channel, Member member) {
		this.videoCiode = videoCiode;
		this.videoTitle = videoTitle;
		this.videoDesc = videoDesc;
		this.videoDate = videoDate;
		this.videoVies = videoVies;
		this.videoUrl = videoUrl;
		this.videoPhoto = videoPhoto;
		this.category = category;
		this.channel = channel;
		this.member = member;
	}
	
	
	
	
}
