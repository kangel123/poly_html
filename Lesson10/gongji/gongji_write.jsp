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
    String key=request.getParameter("key");    // key을 인자값으로 받음
    String title=request.getParameter("title"); // 제목을 인자값으로 받음
    String date=request.getParameter("date");   // 날짜를 인자값으로 받음
    String content=request.getParameter("content");     // 내용을 인자값으로 받음
    title = title.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;"); // 제목에 &,<,> 사용 가능해짐
    content = content.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;"); // 내용에 &,<,> 사용 가능해짐

    int relevel=0;    // 레벨 초기화
    if (request.getParameter("relevel") != null) {  // 레벨이 있으면
        relevel = Integer.parseInt(request.getParameter("relevel"));    // 레벨을 받아옴
    }
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
         if(relevel>0 && key.equals("INSERT")){    //   신규 댓글
            String recnt=request.getParameter("recnt"); // 순서를 받아옴
            String viewcnt=request.getParameter("viewcnt"); // 조회수를 받아옴
            String rootid=request.getParameter("rootid");   // rootid를 받아옴

            PreparedStatement pstmt = conn.prepareStatement("UPDATE gongji2 SET recnt = recnt + 1 WHERE rootid = ? AND recnt >= ?;");   // recnt값 뒤로 미루는 sql문
            pstmt.setInt(1, Integer.parseInt(rootid));  // rootid
            pstmt.setInt(2, Integer.parseInt(recnt));   // 순서
            pstmt.executeUpdate();  // 업데이트 

            pstmt = conn.prepareStatement("INSERT INTO gongji2 (title, date, content, rootid, relevel ,recnt, viewcnt) VALUES (?, ?, ?, ?, ?, ?, ?);"); // 새로운 댓글 삽입하는 sql문
            pstmt.setString(1, title);  // 제목
            pstmt.setString(2, date);   // 날짜
            pstmt.setString(3, content);    // 내용
            pstmt.setInt(4, Integer.parseInt(rootid));  // rootid
            pstmt.setInt(5, relevel);   // 레벨
            pstmt.setInt(6, Integer.parseInt(recnt));   // 순서
            pstmt.setInt(7, 0); // 조회수
            pstmt.executeUpdate();  // 실행
            
            pstmt.close();  // 닫기
        } else if(key.equals("INSERT")){  // 신규 공지
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO gongji2 (title, date, content, rootid, relevel ,recnt, viewcnt) VALUES (?, ?, ?, ?, ?, ?, ?);");   // 삽입하는 sql문
            pstmt.setString(1, title);  // 제목
            pstmt.setString(2, date);   // 날짜
            pstmt.setString(3, content);    // 내용
            pstmt.setInt(4, 0); // rootid는 현재의 id를 모르므로 0으로 초기화
            pstmt.setInt(5, 0);   // 레벨은 0
            pstmt.setInt(6, 0); // 순서은 공지므로 0
            pstmt.setInt(7, 0); // 조회수는 0
            pstmt.executeUpdate();  // 실행

            pstmt = conn.prepareStatement("select id from gongji2 where id=(select max(id) from gongji2);");    // 방금 저장된 id값이 가장 클 것이므로 해당 id값을 가져온다
            ResultSet rset = pstmt.executeQuery();  // 실행한 결과 저장
            
            if(rset.next()){    // 존재하면
                int id = rset.getInt(1);    // id를 받아오고
                pstmt = conn.prepareStatement("UPDATE gongji2 SET rootid=? WHERE id=?;");   // 해당 id와 공지 rootid을 같도록 만든다
                pstmt.setInt(1, id);    // rootid
                pstmt.setInt(2, id);    // id
                pstmt.executeUpdate();  // 실행
            }            
            pstmt.close();  // 닫기
        } else {    // 공지 또는 댓글 수정
            PreparedStatement pstmt = conn.prepareStatement("UPDATE gongji2 SET title=?, date=?, content=? WHERE id=?");    // 내용을 수정하는 sql문
            pstmt.setString(1, title);  // 제목
            pstmt.setString(2, date);   // 날짜
            pstmt.setString(3, content);    // 내용
            pstmt.setString(4, key);    // id
            pstmt.executeUpdate();  // 실행   
            pstmt.close();  // 닫기
        }
        conn.close();   // Connection 닫기
    }catch(Exception e){    // 에러가 발생한 경우
        e.printStackTrace();    // 에러메시지 출력
    }
%>
</body>	<!--본문 끝-->
<script>
window.onload = function() {
  window.location.href = "gongji_list.jsp"; // 어떤 경우든 작업이 완료되면 공지 리스트로 넘어간다
}
</script>
</html>	<!--HTML의 끝-->