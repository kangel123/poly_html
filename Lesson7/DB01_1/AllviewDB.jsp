<%--모든 데이터 조회--%>
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>db조회</title>	<!--제목-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<%  
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        ResultSet rset = stmt.executeQuery("select * from examtable;"); // 모든 학생 정보 가져오기
    
%>

<body>	<!--본문-->
<h1>조회</h1>   <%--제목--%>

<hr>    <%--구분 선--%>
<table>    <%--테이블 생성--%>
    <tr>    <%--테이블 헤더--%>
        <th>이름</th>   <%--1열--%>
        <th>학번</th>   <%--2열--%>
        <th>국어</th>   <%--3열--%>
        <th>영어</th>   <%--4열--%>
        <th>수학</th>   <%--5열--%>
    </tr>
<%    
        while(rset.next()){ // 반복
            String studentname=rset.getString(1);   // 이름 따로 저장
            String studentid=Integer.toString(rset.getInt(2));  // 학번 따로 저장
%>
    <tr>    <%--다음 행--%>
    <td><a href="./oneviewDB.jsp?studentname=<%=studentname%>&studentid=<%=studentid%>"><%=studentname%></a></td>   <%--이름, 하이퍼링크로 인자 전달--%>
    <td><%=studentid%></td>  <%--학번--%>
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
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->