package config;

// 디비 서버의 정보를 상수값으로 구성한 인터페이스.

public interface ServerInfo 
{
	// 명시하지 않더라고 static final 상수값을 가지게 됨
	/*public static final*/ String DRIVER_NAME = "oracle.jdbc.driver.OracleDriver";
	String URL = "jdbc:oracle:thin:@localhost:1521:xe";
	String DB_USER = "kh";
	String DB_PASS = "kh";
	
}
