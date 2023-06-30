package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

public class DBConnectionTest2
{
	public static final String DRIVER_NAME = "oracle.jdbc.driver.OracleDriver";
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
	public static final String DB_USER = "kh";
	public static final String DB_PASS = "kh";
	
	public static void main(String[] args) 
	{
		
		
		try 
		{
			// 1. 드라이버 로딩
			Class.forName(DRIVER_NAME);
			
			// 2. DB연결
			Connection cnn = DriverManager.getConnection(URL, DB_USER, DB_PASS);						
			
			// 3. Statement 객체 생성
		
			String query = "INSERT INTO EMP (EMP_ID, EMP_NAME) VALUES(?, ?)";// 실행할 쿼리문 임시 변수에 String형으로 저장
			PreparedStatement st = cnn.prepareStatement(query);

			// 4. 쿼리문 실행
			st.setInt(1,2);
			st.setString(2, "멍뭉이");
			int result = st.executeUpdate();	//연결한 Statement 객체 결과값 저장 객체에 저장
			if(result == 1)
			{
				System.out.println("한명추가");
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
