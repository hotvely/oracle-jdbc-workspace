package person;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import config.PersonDB_Info;

public class PersonTest {
	
	private Properties p = new Properties();
	
	public PersonTest() {
		try {
			p.load(new FileInputStream("src/config/jdbc.properties"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	// 고정적인 반복 -- 디비연결, 자원 반납
	public Connection getConnect() throws SQLException {
		Connection conn = DriverManager.getConnection(PersonDB_Info.URL, PersonDB_Info.DB_USER, PersonDB_Info.DB_PASS);
		return conn;
	}
	
	public void closeAll(Connection conn, PreparedStatement st) throws SQLException {
		if(st!=null) st.close();
		if(conn!=null) conn.close();
	}
	
	public void closeAll(Connection conn, PreparedStatement st, ResultSet rs) throws SQLException {
		if(rs!=null) rs.close();
		closeAll(conn, st);
	}
	
	
	public void addPerson(String name, String address) throws SQLException
	{		
		
		Connection conn = getConnect();

		// statement 객체 생성A			
		String query = p.getProperty("jdbc.sql.insert");
		PreparedStatement pt = conn.prepareStatement(query);

		// sequence 객체 java에서 사용하기.
		String seqQuery = p.getProperty("jdbc.sql.seq");
		PreparedStatement pt2 = conn.prepareStatement(seqQuery);
		ResultSet rsSeq = pt2.executeQuery();

		if(rsSeq.next())
		{
			System.out.println(rsSeq.getInt(1));				
		}
		pt.setInt(1, rsSeq.getInt(1));
		pt.setString(2, name);
		pt.setString(3, address);
		
		int result = pt.executeUpdate();
		System.out.println(result + "명 추가");
		
		closeAll(conn, pt);
			
		
	}
	
	public void removePerson(int id) throws SQLException
	{
		
		Connection conn = getConnect();
	
		// statement 객체 생성A			
		String query = p.getProperty("jdbc.sql.delete");
		PreparedStatement pt = conn.prepareStatement(query);
		pt.setInt(1, id);
		
		int result = pt.executeUpdate();
		
		System.out.println(result + "명 삭제완료");
	
	}
	
	public void updatePerson(int id, String address) throws SQLException
	{
		Connection conn = getConnect();		
		// statement 객체 생성A			
		String query = p.getProperty("jdbc.sql.update");
		PreparedStatement pt = conn.prepareStatement(query);
		pt.setString(1, address);
		pt.setInt(2, id);
		
		int result = pt.executeUpdate();
		
		System.out.println(result + "명 변경완료");
			
		
	}
	
	// 전체 보기
	public void searchAllPerson() throws SQLException
	{
		Connection conn = getConnect();

		// statement 객체 생성A			
		String query = p.getProperty("jdbc.sql.select");
		PreparedStatement pt = conn.prepareStatement(query);

		ResultSet rs = pt.executeQuery();
		
		while(rs.next())
		{
			System.out.println("ID : " + rs.getInt("ID") + "\tNAME : " + rs.getString("name") + "\tADDRESS : " + rs.getString("address"));
		}
		
		
	}
	
	// 입력받은 id사람 정보 확인
	public void viewPerson(int id) throws SQLException
	{
		Connection conn = getConnect();
		// statement 객체 생성A			
		String query = p.getProperty("jdbc.sql.selectPerson");
		PreparedStatement pt = conn.prepareStatement(query);
		pt.setInt(1, id);
		
		ResultSet rs = pt.executeQuery();
		
		while(rs.next())
		{
			System.out.println("ID : " + rs.getInt("ID") + "\tNAME : " + rs.getString("name") + "\tADDRESS : " + rs.getString("address"));
		}
			
	}
	


	
	public Connection connectDB() throws SQLException
	{
		// DB연결
		Connection conn = DriverManager.getConnection(PersonDB_Info.URL, PersonDB_Info.DB_USER, PersonDB_Info.DB_PASS);
		return conn;
	}
	
	public static void main(String[] args)
	{

		
		
		
		PersonTest pt = new PersonTest();
		
		try {
			pt.addPerson("강아지", "서울");
			pt.addPerson("고양이", "세종시");
			pt.addPerson("너구리", "북한산");
			
			System.out.println("모든person 출력");
			pt.searchAllPerson();

			System.out.println("person삭제");
			pt.removePerson(3);		

			System.out.println("특정 person 수정");
			pt.updatePerson(1, "제주도");		

			System.out.println("특정 person 출력");
			pt.viewPerson(1);
			
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
		}
		
		
		
		
	}

}
