<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat"%> <%--import--%>
<% request.setCharacterEncoding("UTF-8"); %>

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
    <meta charset="UTF-8">  <!--한글 인코딩-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
</head>	<!--머리말 끝-->
<style>
table{  /*테이블*/
    width: 900px;   /*넓이*/
    border : 1px solid black;   /*테두리*/
}
</style>
<body>	<!--본문-->   
<%
    String key=request.getParameter("key"); // key값을 인자로 받아옴
    String title=request.getParameter("title"); // 제목을 인자로 받아옴
    String date=request.getParameter("date");   // 날짜를 인자로 받아옴
    String content=request.getParameter("content"); // 내용을 인자로 받아옴
    
    title = title.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;"); // 제목에 문자 이스케이프 및 <>의 문제 해결
    content = content.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;"); // 내용에 문자 이스케이프 및 <>의 문제 해결

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        if(key.equals("INSERT")){   // key값이 INSERT이면
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO gongji (title, date, content) VALUES (?, ?, ?)");  // 내용추가하는 sql문
            pstmt.setString(1, title);  // 제목
            pstmt.setString(2, date);   // 날짜
            pstmt.setString(3, content);    // 내용
            pstmt.executeUpdate();  // 실행
            pstmt.close();  // 사용 후 닫기
        } else {
            PreparedStatement pstmt = conn.prepareStatement("UPDATE gongji SET title=?, date=?, content=? WHERE id=?"); // 내용 업데이트하는 sql문
            pstmt.setString(1, title);  // 제목
            pstmt.setString(2, date);   // 날짜
            pstmt.setString(3, content);    // 내용
            pstmt.setString(4, key);    // 번호
            pstmt.executeUpdate();  // 실행
            pstmt.close();  // 사용 후 닫기
        }
        conn.close();   // Connection 닫기
    }catch(Exception e){    // 예기치 못한 에러가 발생하면
        e.printStackTrace();    // 에러 메시지 출력
    }
%>
</body>	<!--본문 끝-->
<script>
window.onload = function() {
  window.location.href = "gongji_list.jsp"; // 어떤 경우든 작업이 완료되면 공지 리스트로 넘어간다
}
</script>
</html>	<!--HTML의 끝-->