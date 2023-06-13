<?xml version="1.0" encoding="UTF-8"?>  <!--xml파일 선언-->
<%@ page contentType="text/xml; charset=utf-8"%>    <!--xml형식이며 한글임을 선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.net.*"%> <!--import-->
<%
    try{
	    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	    ResultSet rset = stmt.executeQuery("select * from examtable");  // 모든 학생의 정보를 가져오는 sql문 실행해 저장
        out.println("<datas>");     // 해당 xml의 전체 학생정보 시작
        while(rset.next()){ // 모든 학생들에 대하여
            out.println("<data>");  // 한명씩 학생 정보 시작

            out.println("<name>"+rset.getString(1)+"</name>");  // 이름을 이름태그 안에 넣기
            out.println("<studentid>"+Integer.toString(rset.getInt(2))+"</studentid>"); // 학번을 학번태그 안에 넣기
            out.println("<kor>"+rset.getInt(3)+"</kor>");   // 국어을 국어태그 안에 넣기
            out.println("<eng>"+rset.getInt(4)+"</eng>");   // 영어을 영어태그 안에 넣기
            out.println("<mat>"+rset.getInt(5)+"</mat>");   // 수학을 수학태그 안에 넣기

            out.println("</data>"); // 한명씩 학생 정보 종료
        }
        out.println("</datas>");    // 전체 학생정보 종료

        rset.close();
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 생길 경우
        out.println(e);    // 메시지 출력
    }
%>