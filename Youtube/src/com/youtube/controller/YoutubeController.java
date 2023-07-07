package com.youtube.controller;

import java.sql.SQLException;
import java.util.ArrayList;

import com.youtube.model.dao.ChannelDAO;
import com.youtube.model.dao.CommentLikeDAO;
import com.youtube.model.dao.MemberDAO;
import com.youtube.model.dao.VideoDAO;
import com.youtube.model.vo.Category;
import com.youtube.model.vo.Channel;
import com.youtube.model.vo.Member;
import com.youtube.model.vo.Video;

public class YoutubeController {
	
	private MemberDAO memberDao = new MemberDAO();
	private ChannelDAO channelDao = new ChannelDAO();
	private VideoDAO videoDao = new VideoDAO();
//	private CommentLikeDAO commentLikeDao = new CommentLikeDAO();
	
	private Member member = null;
	private Channel channel = null;
	
	
	public void ErrorMsg(String funcName, Exception e)
	{
		System.out.println("\n========== ERROR");
		System.out.println(getClass() + funcName + " 내부 SQLException ERROR");
		e.printStackTrace();
		System.out.println("========== ERROR\n");
	}
	
	
	public boolean register (Member member)
	{
		try 
		{
			if(memberDao.register(member) > 0) 
				return true;
		} 
		catch (SQLException e) 
		{
			ErrorMsg(".registe()", e);
		}
		
		return false;
	}
	
	
	public boolean login(String id, String pass)
	{
		try 
		{
			member = memberDao.login(id, pass);
			if(member != null)
				return true;
		}
		catch (SQLException e) 
		{
			ErrorMsg(".login()", e);
		}
		
		return false;
	}
	
	
	
	public boolean addChannel(Channel channel)
	{
		try
		{
			channel.setMember(member);
			
			if(channelDao.addChannel(channel) > 0)
				return true;
		} 
		catch (SQLException e) 
		{
			ErrorMsg(".addChannel()", e);
		}
		return false;
	}
	
	public boolean updateChannel(Channel channel)
	{
		myChannel();
		try 
		{
			if(channelDao.updateChannel(channel) > 0)
				return true;		
		} 
		catch (SQLException e)
		{		
			ErrorMsg(".updateChannel()", e);
		}
		return false;
	}
	
	public boolean deleteChannel() {
		myChannel();
		try
		{
			if(channelDao.deleteChannel(this.channel.getChannelCode()) > 0)
				return true;
		} 
		catch (SQLException e) 
		{
			ErrorMsg(".deleteChannel()", e);
		}
		return false;
	}
	
	
	public Channel myChannel() 
	{
		try
		{
			channel = channelDao.myChannel(this.member.getMemberId());
			// 위 채널 뱉어내는 코드에서 멤버 객체 넣치 않고 뱉었으니까 강제로 추후에 넣어줌.
			channel.setMember(member);			
		} 
		catch (SQLException e) 
		{
			ErrorMsg(".myChannel()", e);
		}
		return channel;
	}
	
	

	public boolean addVideo(Video video) {
		try 
		{
			if(videoDao.addVideo(video)==1) return true;
		} 
		catch (SQLException e) 
		{
			ErrorMsg(".addVideo()", e);
		}
		return false;
	}
	
	public void printAllCategory()
	{
		for(Category category : categoryList()) 
		{
			System.out.println(category);
		}
	}
	
	public ArrayList<Category> categoryList() 
	{
		try 
		{
			return videoDao.categoryList();
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		return null;
	}
	
}
