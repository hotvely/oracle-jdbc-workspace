package com.youtube;

import java.util.Scanner;

import com.youtube.controller.YoutubeController;
import com.youtube.model.vo.Category;
import com.youtube.model.vo.Channel;
import com.youtube.model.vo.Member;
import com.youtube.model.vo.Video;

public class Application {
	
	private Scanner sc = new Scanner(System.in);
	private YoutubeController yc = new YoutubeController();
	
	public static void main(String[] args) {

		Application app = new Application();
		//회원가입
		
		app.mainMenu();
	
	}
	public void mainMenu()
	{
		
		System.out.println("========== 유튜브 ==========");
		
		boolean check = true;
		while(check) {
			System.out.println("1. 회원가입");
			System.out.println("2. 로그인");
//			System.out.println("3. ");
//			System.out.println("4. 회원가입");
//			System.out.println("5. 로그인");
			System.out.println("9. 종료");
			System.out.print("메뉴 번호 입력 : ");
			switch(Integer.parseInt(sc.nextLine())) {
			case 1:
				register();
				break;
			case 2:
				login();
				break;
			case 3:
				
				break;
			case 4:
				
				break;
			case 5:
				
				break;
			case 9:
				check = false;
				System.out.println("프로그램 종료");
				break;
			}
			
		}
		
		
	}
	
	public void register()
	{
		System.out.println("========== 회원가입 메뉴 ==========\n");
		System.out.print("아이디 : ");
		String id = sc.nextLine();
		System.out.print("비밀번호 : ");
		String pass = sc.nextLine();
		System.out.print("닉네임 : ");
		String nickName = sc.nextLine();
		Member member = new Member();
		member.setMemberId(id);
		member.setMemberPassword(pass);
		member.setMemberNickName(nickName);
		
		if(yc.register(member))
		{
			System.out.println("회원가입에 성공하였습니다.");
		}
		else
			System.out.println("회원가입에 실패했습니다.");
		System.out.println("========== 회원가입 메뉴 ==========\n");
	}
	
	public void login()
	{
		System.out.println("========== 로그인 메뉴 ==========\n");
		System.out.print("아이디 : ");
		String id = sc.nextLine();
		System.out.print("비밀번호 : ");
		String pass = sc.nextLine();
		
		if(yc.login(id, pass))
		{
			System.out.println("로그인에 성공하였습니다.");
			System.out.println("========== 로그인 메뉴 ==========\n");
			
			memberMenu();		
			
		}
		else
		{
			System.out.println("로그인에 실패했습니다.");
			System.out.println("========== 로그인 메뉴 ==========\n");
		}
	}
	
	public void memberMenu() {
		boolean check = true;
		while(check) {
			System.out.println("1. 채널 추가");
			System.out.println("2. 채널 수정");
			System.out.println("3. 채널 삭제");
			System.out.println("4. 내 채널 보기");
			System.out.println("5. 로그아웃");
			System.out.println("6. 회원탈퇴");
			System.out.print("메뉴 번호 입력 : ");
			switch(Integer.parseInt(sc.nextLine())) {
			case 1:
				addChannel();
				break;
			case 2:
				updateChannel();
				break;
			case 3:
				deleteChannel();
				break;
			case 4:
				myChannel();
				break;
			case 5:
				check = false;
				break;
			case 6:
				check = false;
				break;
				
			}
		}
		
	}
	
	
	public void addChannel()
	{
		System.out.println("========== 채널 추가 ==========\n");
		System.out.print("채널 이름 : ");
		String title = sc.nextLine();
		
		Channel channel = new Channel();
		channel.setChannelName(title);
		
		if(yc.addChannel(channel))
		{
			System.out.println("채널 추가 성공 했습니다.");
			System.out.println("========== 채널 추가 ==========\n");		
		}
		else
		{
			System.out.println("채널 추가 실패 했습니다.");
			System.out.println("========== 채널 추가 ==========\n");	
		}
		
	}
	
	public void updateChannel()
	{
		System.out.println("========== 채널 수정 ==========\n");
		System.out.println("변경될 채널 이름 : ");
		System.out.print("채널 이름 : ");
		String title = sc.nextLine();
		
		Channel channel = new Channel();
		channel.setChannelName(title);
		
		if(yc.addChannel(channel))
		{
			System.out.println("채널 추가 성공 했습니다.");
			System.out.println("========== 채널 추가 ==========\n");		
		}
		else
		{
			System.out.println("채널 추가 실패 했습니다.");
			System.out.println("========== 채널 추가 ==========\n");	
		}
	}
	
	
	public void deleteChannel()
	{
		
		System.out.println("========== 채널 삭제 ==========\n");
		System.out.println("변경될 채널 이름 : ");
		System.out.print("채널 이름 : ");
		String title = sc.nextLine();
		
		Channel channel = new Channel();
		channel.setChannelName(title);
		
		if(yc.addChannel(channel))
		{
			System.out.println("채널 추가 성공 했습니다.");
			System.out.println("========== 채널 추가 ==========\n");		
		}
		else
		{
			System.out.println("채널 추가 실패 했습니다.");
			System.out.println("========== 채널 추가 ==========\n");	
		}
		
	}
	
	
	// 내 채널 보기
	public void myChannel() 
	{
		Channel channel = yc.myChannel();
		System.out.println(channel.getChannelName() + " / " + channel.getMember().getMemberNickName());
	}
		
	// 비디오 추가
	public void addVideo() 
	{
		System.out.println("========== 비디오 추가 ==========\n");
		
		System.out.print("비디오 제목 : ");
		String title = sc.nextLine();
		System.out.print("비디오 URL : ");
		String url = sc.nextLine();
		System.out.print("비디오 썸네일 : ");
		String image = sc.nextLine();
		
		yc.printAllCategory();
		
		int categoryNo = 2;
		Video video = new Video();
		video.setVideoTitle(title);
		video.setVideoUrl(url);
		video.setVideoPhoto(image);
		Category category = new Category();
		category.setCategoryCode(categoryNo);
		video.setCategory(category);

		if(yc.addVideo(video)) {
			System.out.println("비디오 추가 성공!");
		} else {
			System.out.println("비디오 추가 실패 ㅠㅠ");
		}
		
		System.out.println("========== 비디오 추가 ==========\n");
		
	}
	
	
	
	
	// 시험 범위
	// 사용자 계정 생성하는 법.
	// select문 알아야함. (join, subquery)
	// 그룹함수 시험범위 X
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
