package com.youtube.model.dao;

import java.sql.*;
import java.util.*;

import com.youtube.model.vo.*;

public interface CommentLikeDAOTemplate {
	
	Connection getConnect() throws SQLException;
	void closeAll(PreparedStatement st, Connection conn) throws SQLException;
	void closeAll(ResultSet rs, PreparedStatement st, Connection conn) throws SQLException;
	
	// CommenLike, VideoComment, VideoLike
	
	
	// VideoLike
	// 영상 좋아요 추가, 영상 좋아요 취소
	int addLike(VideoLike like) throws SQLException;
	int deleteLike(VideoLike like) throws SQLException;
	
	// VideoCommnet
	// 영상 코멘트 추가, 영상 코멘트 수정, 영상 코멘트 삭제 , 영상1개 보기에 따른 댓글들 보기
	int addComment(VideoComment comment) throws SQLException;
	int updateComment(VideoComment comment) throws SQLException;
	int deleteComment(int commentCode) throws SQLException;
	ArrayList<VideoComment> videoCommentList(int videoCode) throws SQLException;
	
	// CommentLike
	// 댓글 좋아요 추가, 댓글 좋아요 취소
	int addCommentLike(CommentLike like) throws SQLException;
	int deleteCommentLike(int likeCode) throws SQLException;
	
	
	
	
}
