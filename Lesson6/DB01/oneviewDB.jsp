<%--한 사람만 조회--%>
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>db일부조회</title>	<!--제목-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<%  try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	
    	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        String stuname = null;  // 학생 이름 초기값
        int stuid = 0;    // 학번 초기값
        stuname=request.getParameter("studentname");  // 학생이름 인자로 받기
        stuid=Integer.parseInt(request.getParameter("studentid"));  // 학번 인자로 받기
        ResultSet rset = stmt.executeQuery("select * from examtable where id="+stuid+";"); // 해당 학번의 학생 정보 가져오기
%>
<body>	<!--본문-->
<h1>[<%=stuname%>]조회</h1>   <%--제목--%>

<hr>    <%--구분 선--%>
<table cellspacing=1 width=600 border=1>    <%--테이블 생성--%>
    <tr>    <%--테이블 헤더--%>
        <th>이름</th>   <%--1열--%>
        <th>학번</th>   <%--2열--%>
        <th>국어</th>   <%--3열--%>
        <th>영어</th>   <%--4열--%>
        <th>수학</th>   <%--5열--%>
    </tr>
<%    
        while(rset.next()){ // 반복
%>
    <tr>    <%--다음 행--%>
    <td><%=rset.getString(1)%></td>   <%--이름--%>
    <td><%=Integer.toString(rset.getInt(2))%></td>  <%--학번--%>
    <td><%=Integer.toString(rset.getInt(3))%></td>  <%--국어--%>
    <td><%=Integer.toString(rset.getInt(4))%></td>  <%--영어--%>
    <td><%=Integer.toString(rset.getInt(5))%></td>  <%--수학--%>
    </tr>
<% 
        }   // 반복문 종료
        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러 발생 시
        out.println("<h1>조회 실패</h1>");   // 에러 출력
    }
%>