package jdbc;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import config.ServerInfo;

public class DBConnectionTest4 
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
			Properties p = new Properties();
			p.load(new FileInputStream("src/config/jdbc.properties"));
			
			
			
			// 1. 드라이버 로딩
			Class.forName(ServerInfo.DRIVER_NAME);
			
			// 2. DB연결
			Connection conn = DriverManager.getConnection(ServerInfo.URL, 
														  ServerInfo.DB_USER,
														  ServerInfo.DB_PASS);						
			System.out.println("DB 연결...");
			
			// 3. Statement 객체 생성 - DELETE
			String query = p.getProperty("jdbc.sql.delete");
			PreparedStatement st = conn.prepareStatement(query);
			
			// 4. 쿼리문 실행
			st.setInt(1, 2);
			int result = st.executeUpdate();
			System.out.println(result + "명 삭제");
			
			
			query = p.getProperty("jdbc.sql.select");
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
		catch (FileNotFoundException e) 
		{
			e.printStackTrace();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		} 
		
		
	}

}
