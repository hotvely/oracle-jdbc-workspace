package com.kh.controller;

import java.sql.SQLException;
import java.util.ArrayList;

import com.kh.model.dao.BookDAO;
import com.kh.model.vo.Book;
import com.kh.model.vo.Member;
import com.kh.model.vo.Rent;

public class BookController 
{
	// dao 객체 생성
	private BookDAO dao = new BookDAO();
	
	
	// 로그인 할 때 데이터 들고 있을 member객체 생성
	private Member member = new Member();
	
	public ArrayList<Book> printBookAll()
	{		
		try 
		{
			return dao.printBookAll();
		} 
		catch (SQLException e) 
		{
			System.out.println("BookController.printBookAll() error");
			e.printStackTrace();
			return null;
		}
	}
	
	public boolean registerBook(Book book)
	{
		
		// 2. 중복되는 데이터가 없다면 dao.registerBook
		try 
		{
			if(dao.registerBook(book) > 0)
			{
				return true;
			}
		} 
		catch (SQLException e) 
		{
			System.out.println("BookController.registerBook() error");
			e.printStackTrace();
		}	
		return false;	
	}
	
	public boolean sellBook(int no)
	{// 책 삭제 ;;;;
		try {
			if(dao.sellBook(no)>0)
				return true;
		} catch (SQLException e) 
		{
			System.out.println("BookCOntroller.sellBook() error");
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean registerMember(Member member)
	{
		try 
		{
			// 회원가입 중복체크는 안에서 합시다 ~~~
			if(dao.registerMember(member) > 0)
			{
				return true;
			}
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		return false;
	}
	
	public Member login(String id, String pass)
	{
		try 
		{
			member = dao.login(id, pass);
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		return member;
	}
	
	public boolean deleteMember()
	{// 회원 탈퇴 기능.. 인데 sql 업데이트문 사용해서 YN 인지 체크 해야 함~
		try 
		{
			if(dao.deleteMember(member.getMemberId(), member.getMemberPwd()) > 0)
				return true;
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean rentBook(int no)
	{
		Book book = null;
		for(Book tempBook : printBookAll())
		{
			if(tempBook.getBkNo() == no) 
			{
				book = tempBook;
				break;
			}
		}			
		Rent rent = new Rent(member, book);
		
		try 
		{
			if(dao.rentBook(rent) > 0)
				return true;
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		
		return false;
	}
	
	public boolean deleteRent(int no)
	{
		try {
			if(dao.deleteRent(no) > 0)
				return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	public ArrayList<Rent> printRentBook()
	{// 본인이 대여한 책 보여주는 거임.
		
		try 
		{
			return dao.printRentBook(member.getMemberId());
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		
		return null;
	}
	
	
	
	
	
	
	
}
