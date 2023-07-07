package com.youtube.model.dao;

import java.sql.*;
import java.util.ArrayList;

import com.youtube.model.vo.Category;
import com.youtube.model.vo.Video;

public interface VideoDAOTemplate {
	
	Connection getConnect() throws SQLException;
	void closeAll(PreparedStatement st, Connection conn) throws SQLException;
	void closeAll(ResultSet rs, PreparedStatement st, Connection conn) throws SQLException;
	
	// 영상 추가, 영상 수정, 영상 삭제
	// 영상 전체 목록 보기, 채널별 영상 목록 보기
	// 영상 1개 보기
	// 카테고리 보기..
	int addVideo(Video video) throws SQLException;
	int updateVideo(Video video) throws SQLException;
	int deleteVideo(int videoCode) throws SQLException;
	
	ArrayList<Video> videoAllList(int videoCode) throws SQLException;
	ArrayList<Video> channelVideoList(int channelCode) throws SQLException;
	
	Video viewVideo(int videoCode) throws SQLException;
	
	ArrayList<Category> categoryList() throws SQLException;
	
}
