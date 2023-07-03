package transaction;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.util.*;

import config.ServerInfo;

public class TransactionTest2 
{
	

	public static void main(String[] args) 
	{
		Scanner sc = new Scanner(System.in);
		try 
		{
			// 1. DRIVER LOADING
			Class.forName(ServerInfo.DRIVER_NAME);

			// 2. Connection Database
			Connection conn = DriverManager.getConnection(ServerInfo.URL, ServerInfo.DB_USER, ServerInfo.DB_PASS);
			System.out.println("DB Connection...");
			conn.setAutoCommit(true);
			
			PreparedStatement st1 = conn.prepareStatement("SELECT * FROM bank");
			ResultSet rs = st1.executeQuery();
			System.out.println("==================은행조회=================");
			while(rs.next())
			{
				System.out.println(
						rs.getString("name") + " / " +
						rs.getString("bankname") + " / " + 
						rs.getInt("balance"));
			}
			
			System.out.println("=========================================");
			/*
			 * 민소 -> 도경 : 50만원씩 이체.
			 * 이 관련 모든 쿼리를 하나로 묶는다. 단일 트랜잭션으로.
			 * setAutocommit(), commit(), rollback().. 등을 사용해서.
			 * 민소님 잔액이 -가 되면 취소가 되어야 함 ~
			 * */
			System.out.println("50만원 이체를 실행합니다.");
			conn.setAutoCommit(false);
			Savepoint savepoint = conn.setSavepoint("Cancle");


			
			// 1번 방법
//			String checkMoneyQuery = "SELECT balance FROM bank WHERE name = ?";
//			PreparedStatement cmqSt = conn.prepareStatement(checkMoneyQuery);
//			cmqSt.setString(1,"김민소");
//			ResultSet cmqRs = cmqSt.executeQuery();
//			int minsoMoney = 0;
//			if(cmqRs.next())
//			{
//				minsoMoney = cmqRs.getInt(1);
//			}
//			
//			cmqSt.setString(1, "김도경");
//			cmqRs = cmqSt.executeQuery();
//			int dokyungMoney = 0;
//			if(cmqRs.next())
//			{
//				dokyungMoney = cmqRs.getInt(1);
//			}			
//			String query1 = "UPDATE bank SET balance = ? WHERE name = ?";			
//			st2.setInt(1, minsoMoney - 500000 );
//			st2.setString(2, "김민소");
//			st2.executeUpdate();
//			
//			st2.setInt(1, dokyungMoney + 500000);
//			st2.setString(2, "김도경");
//			st2.executeUpdate();
//			if(minsoMoney <= 0)
//			{
//				System.out.println("돈없어서 이체 안대여~");
//				conn.rollback(savepoint);
//			}
//			else
//			{
//				conn.setAutoCommit(true);
//				System.out.println("이체 성공 해써염~");
//			}
			
			// 2번 방법
			String query1 = "UPDATE bank SET balance = balance + ? WHERE name = ?";
			PreparedStatement st2 = conn.prepareStatement(query1);
			int money = 500000;
			st2.setInt(1, -money);
			st2.setString(2, "김민소");
			st2.executeUpdate();
			
			st2.setInt(1, money);
			st2.setString(2, "김도경");
			st2.executeUpdate();
			
			String getMoneyCheck = "SELECT balance FROM bank WHERE name = ?";
			PreparedStatement st3 = conn.prepareStatement(getMoneyCheck);
			st3.setString(1, "김민소");
			ResultSet result = st3.executeQuery();
			if(result.next() && result.getInt(1) < 0)
			{
				System.out.println("이체가 실패했습니다.");
				conn.rollback(savepoint);
			}
			else
			{
				System.out.println("이체완료 되었습니다.");
				conn.setAutoCommit(true);
			}

			
			rs = st1.executeQuery();
			
			
			
			System.out.println("\n\n==================이체확인=================");
			System.out.println("==================은행조회=================");
			while(rs.next())
			{
				System.out.println(
						rs.getString("name") + " / " +
						rs.getString("bankname") + " / " + 
						rs.getInt("balance"));
			}
			
			System.out.println("=========================================");
			
			// 자원 반납 ~ !!
			st1.close();
			st2.close();
			st3.close();			
			conn.close();
			
		} 
		catch (ClassNotFoundException e) 
		{
			e.printStackTrace();
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		
		
	}

}
