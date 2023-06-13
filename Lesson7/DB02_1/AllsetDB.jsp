<%--데이터를 삽입--%>
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>데이터 삽입</title>	<!--제목-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->


<body>	<!--본문-->
<%  try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결	
        PreparedStatement pstmt = conn.prepareStatement("insert into examtable value(?,?,?,?,?);");   // 임의의 데이터를 추가하는 sql문
        for(int cnt=0;cnt<100;cnt++){   // 100번 반복
            String name="홍길"+cnt; // 이름 만들기

            pstmt.setString(1, name);   // 이름
            pstmt.setInt(2, 209900+cnt);  // 학번
            pstmt.setInt(3, (int)(Math.random()*100)); // 국어 성적
            pstmt.setInt(4,(int)(Math.random()*100)); // 영어 성적
            pstmt.setInt(5, (int)(Math.random()*100)); // 수학 성적
            pstmt.executeUpdate();  // sql문 실행
        }

        out.println("<h1>데이터 입력 성공</h1>");   // 성공 메시지 출력
        pstmt.close();  // PreparedStatement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 생겼으면
        out.println("<h1>데이터 입력 실패</h1>");   // 에러 출력
    }
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->