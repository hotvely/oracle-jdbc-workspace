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
import com.youtube.model.vo.Member;
import com.youtube.model.vo.Subscribe;


public class MemberDAO implements MemberDAOTemplate{

	Properties p = new Properties();
	
	public MemberDAO() {
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
	public int register(Member member) throws SQLException {
		
		Connection conn = null;
		PreparedStatement st = null;		
		String query = null;
		
		conn = getConnect();
		query = p.getProperty("register");
		st = conn.prepareStatement(query);
		st.setString(1, member.getMemberId());
		st.setString(2, member.getMemberPassword());
		st.setString(3, member.getMemberNickName());
		
		int result = st.executeUpdate();
		closeAll(st, conn);
		
		return result;
	}

	@Override
	public Member login(String id, String password) throws SQLException {
		
		Connection conn = null;
		PreparedStatement st = null;		
		String query = null;
		Member member = null;
		
		conn = getConnect();
		query = p.getProperty("login");
		st = conn.prepareStatement(query);
		st.setString(1, id);
		st.setString(2, password);
		
		ResultSet rs = st.executeQuery();
		if(rs.next())
		{
			member = new Member( rs.getString("MEMBER_ID"), 
										rs.getString("MEMBER_PASSWORD"), 
										rs.getString("MEMBER_NICKNAME"),
										rs.getString("MEMBER_EMAIL"),
										rs.getString("MEMBER_PHONE"),	
										rs.getString("MEMBER_GENDER"),
										rs.getString("MEMBER_AUTHORITY"));
					
		}
		
		return member;
	}

	@Override
	public int addSubscribe(Subscribe subscribe) throws SQLException {
		return 0;
	}

	@Override
	public int deleteSubscribe(int subsCode) throws SQLException {
		return 0;
	}

	@Override
	public ArrayList<Subscribe> mySubscribeList(String memberId) throws SQLException {
		return null;
	}

}
