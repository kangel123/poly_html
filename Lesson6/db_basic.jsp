<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>db조회</title>	<!--제목-->
   
</head>	<!--머리말 끝-->
<body>	<!--본문-->
<% 
    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
    ResultSet rset = stmt.executeQuery("select * from examtable;"); // 해당 테이블의 모든 레코드를 ResultSet으로 저장
%>
<table cellspacing=1 width=600 border=1>    <!--테이블 생성-->
<%
    while(rset.next()){ // 반복문
        out.println("<tr>");    // 행
        out.println("<td width=50><p align=center>"+rset.getString(1)+"</p></td>"); // 1열:이름
        out.println("<td width=50><p align=center>"+Integer.toString(rset.getInt(2))+"</p></td>");  // 2열:학번
        out.println("<td width=50><p align=center>"+Integer.toString(rset.getInt(3))+"</p></td>");  // 3열:국어
        out.println("<td width=50><p align=center>"+Integer.toString(rset.getInt(4))+"</p></td>");  // 4열:영어
        out.println("<td width=50><p align=center>"+Integer.toString(rset.getInt(5))+"</p></td>");  // 5열:수학
        out.println("</tr>");   // 해당 행 종료
    }
    rset.close();   // ResultSet 객체 닫기
    stmt.close();   // Statement 객체 닫기
    conn.close();   // Connection 객체 닫기
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->