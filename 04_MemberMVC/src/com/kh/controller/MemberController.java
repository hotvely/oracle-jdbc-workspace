package com.kh.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import com.kh.model.dao.MemberDAO;
import com.kh.model.vo.Member;

public class MemberController {

	private MemberDAO dao = new MemberDAO();
	private Properties p = new Properties();
	
	public MemberController()
	{
		try 
		{
			p.load(new FileInputStream("src/config/jdbc.properties"));
		} 
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
	}
	
	public boolean joinMembership(Member m) {

		// id가 없다면 회원가입 후 true 반환
		// 있으면 false 값 반환
		
		try
		{
//			if(dao.getMember(m.getId()) == null)
//			{
//				dao.registerMember(m);
//			}
			Connection conn = dao.getConnect();
			PreparedStatement st;
			String query;
			
			conn.setAutoCommit(false);
			
			query = p.getProperty("jdbc.sql.checkdupl_id");
			st = conn.prepareStatement(query);
			st.setString(1, m.getId());
			ResultSet rs = st.executeQuery();
			if (rs.next()) 
			{
				
//				conn.rollback(savepoint);
				System.out.println("회원 정보가 있으므로 회원추가 실패했습니다.");
				return false;
			}
			else
			{
				dao.registerMember(m);
				conn.setAutoCommit(true);
				return true;
			}
		} 
		catch (SQLException e) 
		{
//			System.out.println("중복되는 회원이 존재해서.. 회원가입 실패 !!");
			e.printStackTrace();
			return false;
		}

	}
	
	public String login(String id, String password) {

		// 로그인 성공하면 이름 반환
		// 실패하면 null 반환
		Member tempMember = null;
		try 
		{		
			tempMember = dao.getMember(id);
			if(tempMember != null && tempMember.getId().equals(id) 
								  && tempMember.getPassword().equals(password))
			{
				return tempMember.getName();
			}
		} 
		catch (SQLException e) 
		{
			System.out.println("아이디 혹은 비밀번호 다시 확인하세요.");
//			e.printStackTrace();
		}
		return null;
	}
	
	public boolean changePassword(String id, String oldPw, String newPw) {

		// 로그인 했을 때 null이 아닌 경우
		// 비밀번호 변경 후 true 반환, 아니라면 false 반환
		Member tempMember = null;
		if(login(id, oldPw) == null)
			return false;
		
		try 
		{
			tempMember = dao.getMember(id);
			if(tempMember.getPassword().equals(oldPw))
			{
				tempMember.setPassword(newPw);
				dao.updatePassword(tempMember);
				return true;
			}
		} 
		catch (SQLException e) 
		{
			System.out.println("비밀번호 변경 실패 !!");
//			e.printStackTrace();
		}
		return false;
	}
	
	public void changeName(String id, String name) {

		// 이름 변경!
		Member tempMember = null;
		
		try 
		{
			tempMember = dao.getMember(id);
			tempMember.setName(name);
			dao.updateName(tempMember);
		} 
		catch (SQLException e) 
		{
			System.out.println("이름 변경 실패");
//			e.printStackTrace();
		}
	}


}