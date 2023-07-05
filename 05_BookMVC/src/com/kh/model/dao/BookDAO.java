package com.kh.model.dao;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import com.kh.model.vo.Book;
import com.kh.model.vo.Member;
import com.kh.model.vo.Rent;

import config.ServerInfo;

public class BookDAO implements BookDAOTemplate {

	private Properties p = new Properties();

	
	public BookDAO()
	{
		try 
		{
			p.load(new FileInputStream("src/config/jdbc.properties"));
			Class.forName(ServerInfo.DRIVER_NAME);
		} 
		catch (IOException | ClassNotFoundException e) 
		{	
			System.out.println("book dao, 'properties load' or 'driver load' error");
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
	public ArrayList<Book> printBookAll() throws SQLException {
		
		ArrayList<Book> books = new ArrayList<>();
		
		Connection conn = getConnect();
		String query = p.getProperty("TB_BOOK_SELECT_ALL");
		PreparedStatement st = conn.prepareStatement(query);

		ResultSet rs = st.executeQuery();
		
		while(rs.next())
		{
			books.add(new Book(rs.getInt("BK_NO"), rs.getString("BK_TITLE"), rs.getString("BK_AUTHOR")));
		}
		
		// 메모리해제
		closeAll(rs, st, conn);
		return books;
	}

	@Override
	public int registerBook(Book book) throws SQLException {
					
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;
		ResultSet rs = null;
		
		query = p.getProperty("TB_BOOK_SELECT_AUTHOR");
		st = conn.prepareStatement(query);
		st.setString(1, book.getBkTitle());
		rs = st.executeQuery();
		if(rs.next())
		{// 내가 입력한 책이름이 db에 들어 있을떄.
			if(book.getBkAuthor().equals(rs.getString(1)))
			{// 작가 까지 중복되는건 완벽하게 중복되는 책이라는 의미.
				closeAll(rs, st, conn);
				return 0;
			}
		}
		
		//위 if문에서 걸러서 나온다 -> 작가 까지 같은 책이 db에 들어있지 않다.		
		query = p.getProperty("TB_BOOK_INSERT");
		st = conn.prepareStatement(query);
		st.setString(1, book.getBkTitle());
		st.setString(2, book.getBkAuthor());
		int result = st.executeUpdate();;
		closeAll(rs, st, conn);
		return result;
				
	}

	@Override
	public int sellBook(int no) throws SQLException {
		
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;
		
		query = p.getProperty("TB_BOOK_DELETE");
		st = conn.prepareStatement(query);
		st.setInt(1, no);
		
		int result =  st.executeUpdate();
		closeAll(st, conn);
		return result;		
	}

	@Override
	public int registerMember(Member member) throws SQLException {
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;
		
		query = p.getProperty("TB_MEMBER_SELECT_ALL_WITH_MEMBER_ID");
		st = conn.prepareStatement(query);
		st.setString(1, member.getMemberId());
		ResultSet rs = st.executeQuery();
		if(rs.next())
		{// 내가 입력한 아이디가 db에 들어 있을떄.
			closeAll(rs, st, conn);
			return 0;
		}
		else
		{// db에 없으면.
			query = p.getProperty("TB_MEMBER_INSERT");
			st = conn.prepareStatement(query);
			st.setString(1, member.getMemberId());
			st.setString(2, member.getMemberPwd());
			st.setString(3, member.getMemberName());
			
			int result = st.executeUpdate();
			closeAll(rs, st, conn);			
			return result;
		}
		
	}

	@Override
	public Member login(String id, String password) throws SQLException {
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;
		
		query = p.getProperty("TB_MEMBER_SELECT_ALL_WITH_MEMBER_ID");
		st = conn.prepareStatement(query);
		st.setString(1, id);
		ResultSet rs = st.executeQuery();
		if(rs.next())
		{
 			if(rs.getString("STATUS").charAt(0) == 'N' && rs.getString("MEMBER_PWD").equals(password))
 			{ 			
 				System.out.println("로그인 성공");
 				
 				Member tempMember = new Member(rs.getInt("MEMBER_NO"), id, password, rs.getString("MEMBER_NAME"),
 						rs.getString("STATUS").charAt(0), new java.util.Date(rs.getDate("ENROLL_DATE").getTime()));
 				closeAll(rs, st, conn);
 				return tempMember;
 			}
 			else
 			{
 				System.out.println("비밀번호 틀림 or 탈퇴한회원임");
 				closeAll(rs, st, conn); 				
 				return null;
 			}
		}
		
		closeAll(rs, st, conn);			
		System.out.println("아이디 안맞음");
		return null;
	}

	@Override
	public int deleteMember(String id, String password) throws SQLException {
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;
		
		if(login(id,password) == null)
			return 0;
		
		query = p.getProperty("TB_MEMBER_UPDATE_STATUS");
		st = conn.prepareStatement(query);
		st.setString(1, "Y");
		st.setString(2, id);
		
		closeAll(st, conn);
		return st.executeUpdate();		
	}

	@Override
	public int rentBook(Rent rent) throws SQLException {
		
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;
		
		
		query = p.getProperty("TB_RENT_INSERT");
		st = conn.prepareStatement(query);
		st.setInt(1, rent.getMember().getMemberNo());
		st.setInt(2, rent.getBook().getBkNo());
		int result = st.executeUpdate();
		closeAll(st, conn);
				
		return result;
	}

	@Override
	public int deleteRent(int no) throws SQLException {
		
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;
		
		
		query = p.getProperty("TB_RENT_DELETE");
		st = conn.prepareStatement(query);
		st.setInt(1, no);		
		int result = st.executeUpdate();
		closeAll(st, conn);
		return result;
	}

	@Override
	public ArrayList<Rent> printRentBook(String id) throws SQLException 
	{
		ArrayList<Rent> tempRentList = new ArrayList<>();
		
		Connection conn = getConnect();
		String query = null;
		PreparedStatement st = null;

		ResultSet rs = null;
		ResultSet rs2 = null;
		
		//-- 실행코드
		query = p.getProperty("TB_RENT_SELECT_WITH_MEMBER_ID");
		st = conn.prepareStatement(query);
		st.setString(1, id);
		rs = st.executeQuery();
		int rentNo,rent_mem_no,rent_book_no = 0;
		while(rs.next())
		{
			rentNo = rs.getInt("RENT_NO");
			rent_mem_no = rs.getInt("RENT_MEM_NO");
			rent_book_no = rs.getInt("RENT_book_NO");
			
			query = p.getProperty("TB_MEMBER_SELECT_ALL_WITH_MEMBER_NO");
			st = conn.prepareStatement(query);
			st.setInt(1, rent_mem_no);
			rs2 = st.executeQuery();
			

			
			Member tempMem = null;
			if(rs2.next())
			{
				tempMem = new Member(rs2.getInt("MEMBER_NO"),
						rs2.getString("MEMBER_ID"),
						rs2.getString("MEMBER_PWD"),
						rs2.getString("MEMBER_NAME"), 
						rs2.getString("STATUS").charAt(0), 
						new java.util.Date(rs2.getDate("ENROLL_DATE").getTime()));

			}
			
			query = p.getProperty("TB_BOOK_SELECT_ALL_WITH_BK_NO");
			st = conn.prepareStatement(query);
			st.setInt(1, rent_book_no);
			rs2 = st.executeQuery();	
			
			Book tempBook = null;
			if(rs2.next())
			{
				tempBook = new Book(
						rs2.getInt("BK_NO"),
						rs2.getString("BK_TITLE"),
						rs2.getString("BK_AUTHOR"));
			}
			
			
			tempRentList.add(new Rent(rentNo, 
					  tempMem, 
					  tempBook, 
					  new java.util.Date(rs.getDate("RENT_DATE").getTime())));

			
			rs2.close();
		}


		closeAll(rs, st, conn);
		
		return tempRentList;
	}

}
