package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import config.ServerInfo;

public class DBConnectionTest3 
{
	
	public static void main(String[] args) 
	{
		
		/*
		 * DB 서버에 대한 정보가 프로그램상에 하드코딩 되어져 있음 ~ ㅎㅎ;;
		 * --> 해결책 : 별도의 모듈에 디비 서버에 대한 정보를 뽑아내서 처리 함
		 * 
		 * */
		try 
		{
			// 1. 드라이버 로딩
			Class.forName(ServerInfo.DRIVER_NAME);
			
			// 2. DB연결
			Connection conn = DriverManager.getConnection(ServerInfo.URL, 
														  ServerInfo.DB_USER,
														  ServerInfo.DB_PASS);						
			System.out.println("DB 연결...");
			
			String query = "UPDATE emp SET dept_title = ?, emp_id = ? WHERE emp_id = ?";
			PreparedStatement st = conn.prepareStatement(query);
			
			st.setString(1, "전략기획팀");
			st.setInt(2, 99);
			st.setInt(3, 1);
			
			int result = st.executeUpdate();

			
			query = "SELECT * FROM emp";
			st = conn.prepareStatement(query);
			ResultSet rs = st.executeQuery();
			while(rs.next())
			{
				System.out.println(rs.getInt("emp_id") + "\t" + rs.getString("emp_name") + "\t" + 
								   rs.getString("dept_title") + "\t" + rs.getDate("hire_date"));
			}
			
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
