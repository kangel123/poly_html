<!--처음 url시작할때 그냥 제목 보이는 파일-->
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=utf-8" %>  <!--한글 처리-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*" %>   <!--import-->

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>학생 성적</title>	<!--제목-->
   
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    <h1>JSP Database 실습</h1>  <!--제목-->
<%
    int cnt = 0;    // 방문조회수 초기화

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        ResultSet rset = stmt.executeQuery("select * from counttable;");    // 방문조회수 정보만 있는 테이블의 정보 가져오기
        rset.next();    // 첫번째 레코드 정보
        cnt=rset.getInt(1);        // 방문조회수 가져옴
        cnt++;  // 방문조회수 증가 시킴

        out.println("<br><br>현재 홈페이지 방문조회수는 [" + cnt + "] 입니다</br></br>");   // 방문 조회수 출력

        stmt.executeUpdate("update counttable set count="+cnt+" where count="+(cnt-1)+";"); // DB에 방문 조회수를 업데이트함
     } catch (Exception e) {    // 에러가 발생한 경우
        out.println(e); // 에러 메시지 출력
    }    
%>

</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->