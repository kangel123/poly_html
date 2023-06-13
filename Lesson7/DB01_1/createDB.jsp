<%--examtable 생성--%>
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>db생성</title>	<!--제목-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<body>	<!--본문-->
<% 
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db와 연결하기
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
    
        stmt.execute("create table examtable(" + // sql문으로 table 만들기
					"name varchar(20),"+	// 이름
					"id int not null primary key,"+ // 학번
                    "kor int,"+ // 국어 성적
                    "eng int,"+ // 영어 성적
                    "mat int);");   // 수학 성적
        out.println("<h1>테이블 만들기 OK</h1>");   // 성공 시 메시지 출력
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 생겼으면
        out.println("<h1>테이블 생성 실패</h1>");   // 에러 출력
    }
%>
    </tbody>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->