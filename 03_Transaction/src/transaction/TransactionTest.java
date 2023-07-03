package transaction;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;

import config.ServerInfo;

public class TransactionTest 
{

	public static void main(String[] args) 
	{
		try 
		{
			// 1. DRIVER LOADING
			Class.forName(ServerInfo.DRIVER_NAME);

			// 2. Connection Database
			Connection conn = DriverManager.getConnection(ServerInfo.URL, ServerInfo.DB_USER, ServerInfo.DB_PASS);
			System.out.println("DB Connection...");
			
			// 트랜잭션의 시작...!!!
			conn.setAutoCommit(false);
			
			
			// 3. PreparedStatement
			String query1 = "INSERT INTO customer(name, age, address) VALUES(?, ?, ?)";
			PreparedStatement st = conn.prepareStatement(query1);
			
			// 4. run Query
			st.setString(1, "김경미");
			st.setInt(2, 18);
			st.setString(3, "서울 특별시 강남구");
			int result = st.executeUpdate();
			
			
			//세이브 포인트 지정..???
			Savepoint savepoint = conn.setSavepoint("A"); 
			String query2 = "SELECT * FROM customer WHERE name = ?";
			PreparedStatement st2 = conn.prepareStatement(query2);
			st2.setString(1, "홍수민");
			ResultSet rs = st2.executeQuery();
			if(rs.next())
			{
				conn.rollback(savepoint);
				System.out.println("회원 정보가 있으므로 rollback 합니다.");
			}
			else
			{
				conn.commit();
				System.out.println("회원 정보가 없으므로 commit 해서 추가 합니다.");
			}
			// 트랜잭션 처리를 원상복구함.
//			conn.setAutoCommit(true);
			
//			System.out.println(result + "명 추가 ~!!");
			
			if(result == 1)
			{
				conn.commit();
			}
			else
			{
				conn.rollback();
			}
			
			
			
			// 자원 반납 ~ !!
			st.close();
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
