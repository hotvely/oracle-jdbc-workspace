package com.youtube.model.dao;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import config.ServerInfo;
import com.youtube.model.vo.Channel;

public class ChannelDAO implements ChannelDAOTemplate{
	
	
	private Properties p = new Properties();
	
	

	public ChannelDAO() {		
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
	public int addChannel(Channel channel) throws SQLException {
		
		Connection conn = null;
		PreparedStatement st = null;		
		String query = null;
		
		conn = getConnect();
		query = p.getProperty("addChannel");
		st = conn.prepareStatement(query);
		st.setString(1, channel.getChannelName());
		st.setString(2, channel.getMember().getMemberId());
		
		int result = st.executeUpdate();
		closeAll(st, conn);
		
		return result;
	}

	@Override
	public int updateChannel(Channel channel) throws SQLException {
		
		Connection conn = null;
		PreparedStatement st = null;		
		String query = null;
		
		conn = getConnect();
		query = p.getProperty("updateChannel");
		st = conn.prepareStatement(query);
		st.setString(1, channel.getChannelName());
		st.setInt(2, channel.getChannelCode());
		
		int result = st.executeUpdate();
		closeAll(st, conn);
		
		return result;
	}

	@Override
	public int deleteChannel(int channelCode) throws SQLException {
		
		Connection conn = null;
		PreparedStatement st = null;		
		String query = null;
		
		conn = getConnect();
		query = p.getProperty("deleteChannel");
		st = conn.prepareStatement(query);
		st.setInt(1, channelCode);
		
		int result = st.executeUpdate();
		closeAll(st, conn);
		
		return result;
	}

	@Override
	public Channel myChannel(String memeberId) throws SQLException {
		
		Connection conn = null;
		PreparedStatement st = null;		
		String query = null;
		
		conn = getConnect();
		query = p.getProperty("myChannel");
		st = conn.prepareStatement(query);
		st.setString(1, memeberId);
		ResultSet rs = st.executeQuery();
		
		Channel channel = new Channel();
		if(rs.next())
		{
			channel.setChannelCode(rs.getInt("CHANNEL_CODE"));
			channel.setChannelName(rs.getString("CHANNEL_NAME"));
//			channel.setMember();
			
		}
		closeAll(rs, st, conn);
		
		return channel;
	}

}
