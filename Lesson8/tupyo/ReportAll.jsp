<?xml version="1.0" encoding="UTF-8"?>  
<%@ page contentType="text/xml; charset=utf-8"%>    
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.net.*"%> 
<%
    try{
	    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	    ResultSet rset = stmt.executeQuery("select kiho, name, (select count(*) from tupyo where hubo.kiho=tupyo.kiho), "+
            "(select count(*) from tupyo where hubo.kiho=tupyo.kiho)/(select count(*) from tupyo)*100 from hubo;");  // 모든 후보의 투표정보를 가져옴
        out.println("<datas>");     // 해당 xml의 전체 후보정보 시작
        while(rset.next()){ // 모든 후보들에 대하여
            out.println("<data>");  // 한명의 후보 정보
            out.println("<hubo>"+rset.getInt(1)+"."+rset.getString(2)+"</hubo>");  // 후보을 hubo태그 안에 넣기
            out.println("<pyosu>"+rset.getInt(3)+"</pyosu>"); // 득표수를 pyosu태그 안에 넣기
            out.println("<pyoyul>"+rset.getDouble(4)+"</pyoyul>");   // 득표율을 pyoyul태그 안에 넣기
            out.println("</data>"); // 한명의 후보 정보 종료
        }
        out.println("</datas>");    // 전체 후보정보 종료

        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 생길 경우
        out.println(e);    // 메시지 출력
    }
%>