package jdbc;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.kh.model.dao.MemberDAOTemplate;
import com.kh.model.vo.Member;

import config.DB_Info;

public class MemberTest implements MemberDAOTemplate{
	
	private Properties p = new Properties();
	
	public MemberTest() {
		try
		{
			// 1 생성자에서 드라이버 로딩
			Class.forName(DB_Info.DRIVER_NAME);
			System.out.println("드라이버로딩");
			p.load(new FileInputStream("src/config/jdbc.properties"));
			
		} catch (IOException | ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	public Connection getConnect() throws SQLException {
		// 2 database 랑 연결하기 ~
		Connection conn = DriverManager.getConnection(DB_Info.URL, DB_Info.DB_USER, DB_Info.DB_PASS);
		return conn;
	}
	
	public void closeAll(PreparedStatement st, Connection conn) throws SQLException {
		st.close();
		conn.close();
	}
	
	public void closeAll(ResultSet rs, PreparedStatement st, Connection conn) throws SQLException {
		rs.close();
		closeAll(st,conn);
	}
	
	public void registerMember(Member vo) throws SQLException {
		// 1 db연결해주는 객체 만듬
		Connection conn = getConnect();
		PreparedStatement st;
		String query;
		//자동 커밋 끈이후에 세이브 포인트 지정하고.. 
		conn.setAutoCommit(false);
		Savepoint savepoint = conn.setSavepoint("A"); 
			
		
		//같은 아이디 있는지 체크한 이후에 있으면 롤백
		query = p.getProperty("jdbc.sql.checkdupl_id");
		st = conn.prepareStatement(query);
		st.setString(1, vo.getId());
		ResultSet rs = st.executeQuery();
		if(rs.next())
		{
			conn.rollback(savepoint);
			System.out.println("회원 정보가 있으므로 회원추가 실패했습니다.");
		}
		else
		{					
			// 2 쿼리문 만들어서 연결해줌 ~ 멤버 추가니까 insert 만들면 될듯.
			query = p.getProperty("jdbc.sql.insert");
			st = conn.prepareStatement(query);
			// set함수 이용해서 db랑 연결한 객체에 id, pass, name 설정
			st.setString(1, vo.getId());
			st.setString(2, vo.getPassword());
			st.setString(3, vo.getName());	
			int result = st.executeUpdate();
			
			conn.setAutoCommit(true);
			System.out.println("회원 정보가 없으므로 추가 합니다.");
			System.out.println(result + "명 회원 추가 완료");
		}

		// 메모리 해제
		closeAll(rs, st, conn);		
	}
	
	public void updatePassword(Member vo) throws SQLException
	{ 

		Connection conn = getConnect();
		String query = p.getProperty("jdbc.sql.updatePass");
		PreparedStatement st = conn.prepareStatement(query);
		st.setString(1, vo.getPassword());
		st.setString(2, vo.getId());
		
		int result = st.executeUpdate();
		
		if(result == 0)
			System.out.println("비밀번호 변경 실패");
		else
			System.out.println(result + "명 비밀번호 변경 완료");
	
		//메모리해제
		closeAll(st, conn);
	}
	
	public void updateName(Member vo) throws SQLException {
		Connection conn = getConnect();
		String query = p.getProperty("jdbc.sql.updateName");
		PreparedStatement st = conn.prepareStatement(query);
		st.setString(1, vo.getName());
		st.setString(2, vo.getId());

		int result = st.executeUpdate();
		if(result == 0)
		{
			System.out.println("이름 변경 실패");
		}
		else
			System.out.println(result + "명 이름 변경 완료");
		
		//메모리해제
		closeAll(st, conn);
	}
	
	public Member getMember(String id) throws SQLException {
	
		Member member = null;
		Connection conn = getConnect();
		String query = p.getProperty("jdbc.sql.findMember");
		PreparedStatement st = conn.prepareStatement(query);
		st.setString(1, id);
		ResultSet rs = st.executeQuery();
		if(rs.next())		
			member = new Member(id, rs.getString(1),rs.getString(2));
	
		//메모리해제
		closeAll(rs, st, conn);		
		return member;
		
	}
	
	public Member login(Member vo) throws SQLException {
		
		Member member = null;
		
		Connection conn = getConnect();
		String query = p.getProperty("jdbc.sql.login");
		PreparedStatement st = conn.prepareStatement(query);
		st.setString(1, vo.getId());
		st.setString(2, vo.getPassword());
		ResultSet rs = st.executeQuery(); 
		if(rs.next())
			member = new Member(vo.getId(), vo.getPassword(), rs.getString(1));

		//메모리해제
		closeAll(rs, st, conn);		
		return member;
	}
	
	public static void main(String[] args) {

		try {
			MemberTest mt = new MemberTest();
			Member m = new Member("user02", "1234", "user11");
			mt.registerMember(m);
			System.out.println("회원가입!");
			
			m.setPassword("123456");
			mt.updatePassword(m);
			System.out.println("비밀번호 변경!");
		
			m.setName("user1234");
			mt.updateName(m);
			System.out.println("이름 변경!");
			
			System.out.println(mt.getMember(m.getId()));
			
			System.out.println(mt.login(m));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

}
