package com.youtube.model.dao;

import java.sql.*;

import com.youtube.model.vo.Channel;

public interface ChannelDAOTemplate {
	
	Connection getConnect() throws SQLException;
	void closeAll(PreparedStatement st, Connection conn) throws SQLException;
	void closeAll(ResultSet rs, PreparedStatement st, Connection conn) throws SQLException;
	
	//채널 추가, 수정, 삭제, 내 채널 보기	
	int addChannel(Channel channel) throws SQLException;
	int updateChannel(Channel channel) throws SQLException;	
	int deleteChannel(int channelCode) throws SQLException;
	Channel myChannel(String memeberId) throws SQLException;
}
