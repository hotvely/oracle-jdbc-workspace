package com.youtube.model.dao;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import config.ServerInfo;
import com.youtube.model.vo.Category;
import com.youtube.model.vo.Video;

public class VideoDAO implements VideoDAOTemplate{

	Properties p = new Properties();
	
	public VideoDAO() {
		try 
		{
			p.load(new FileInputStream("src/config/jdbc.properties"));
			Class.forName(ServerInfo.DRIVER_NAME);
		} 
		catch (IOException | ClassNotFoundException e) 
		{
			e.printStackTrace();
		}
	}

	@Override
	public Connection getConnect() throws SQLException {
		Connection conn = DriverManager.getConnection(ServerInfo.URL, ServerInfo.USER, ServerInfo.PASS);
		return conn;
	}

	@Override
	public void closeAll(PreparedStatement st, Connection conn) throws SQLException {
		st.close();
		conn.close();
	}

	@Override
	public void closeAll(ResultSet rs, PreparedStatement st, Connection conn) throws SQLException {
		rs.close();
		closeAll(st, conn);
	}

	@Override
	public int addVideo(Video video) throws SQLException {
		return 0;
	}

	@Override
	public int updateVideo(Video video) throws SQLException {
		return 0;
	}

	@Override
	public int deleteVideo(int videoCode) throws SQLException {
		return 0;
	}

	@Override
	public ArrayList<Video> videoAllList(int videoCode) throws SQLException {
		return null;
	}

	@Override
	public ArrayList<Video> channelVideoList(int channelCode) throws SQLException {
		return null;
	}

	@Override
	public Video viewVideo(int videoCode) throws SQLException {
		return null;
	}

	@Override
	public ArrayList<Category> categoryList() throws SQLException {
		return null;
	}

}
