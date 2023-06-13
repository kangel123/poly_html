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
    String key=request.getParameter("key");    
    String title=request.getParameter("title");
    String date=request.getParameter("date");
    String content=request.getParameter("content"); 
    title = title.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    content = content.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");


    int relevel=0;    // 
    if (request.getParameter("relevel") != null) {
        relevel = Integer.parseInt(request.getParameter("relevel"));
    }

        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
         if(relevel>0 && key.equals("INSERT")){    //   신규 댓글
            String recnt=request.getParameter("recnt");
            String viewcnt=request.getParameter("viewcnt");            
            String rootid=request.getParameter("rootid");

            PreparedStatement pstmt = conn.prepareStatement("UPDATE gongji2 SET recnt = recnt + 1 WHERE rootid = ? AND recnt >= ?;");   // recnt값 뒤로 미루는 sql문
            pstmt.setInt(1, Integer.parseInt(rootid));  //
            pstmt.setInt(2, Integer.parseInt(recnt));
            pstmt.executeUpdate();

            pstmt = conn.prepareStatement("INSERT INTO gongji2 (title, date, content, rootid, relevel ,recnt, viewcnt) VALUES (?, ?, ?, ?, ?, ?, ?);");
            pstmt.setString(1, title);
            pstmt.setString(2, date);
            pstmt.setString(3, content);
            pstmt.setInt(4, Integer.parseInt(rootid));
            pstmt.setInt(5, relevel);
            pstmt.setInt(6, Integer.parseInt(recnt));
            pstmt.setInt(7, 0);
            pstmt.executeUpdate();
            
            pstmt.close();            
        } else if(key.equals("INSERT")){  // 신규 공지
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO gongji2 (title, date, content, rootid, relevel ,recnt, viewcnt) VALUES (?, ?, ?, ?, ?, ?, ?);");
            pstmt.setString(1, title);
            pstmt.setString(2, date);
            pstmt.setString(3, content);
            pstmt.setInt(4, 0);
            pstmt.setInt(5, relevel);
            pstmt.setInt(6, 0);
            pstmt.setInt(7, 0);
            pstmt.executeUpdate();

            pstmt = conn.prepareStatement("select id from gongji2 where id=(select max(id) from gongji2);");    // 방금 저장된 id값이 가장 클 것이므로 해당 id값을 가져온다
            ResultSet rset = pstmt.executeQuery();
            
            if(rset.next()){    
                int id = rset.getInt(1);
                pstmt = conn.prepareStatement("UPDATE gongji2 SET rootid=? WHERE id=?;");
                pstmt.setInt(1, id);
                pstmt.setInt(2, id);
                pstmt.executeUpdate();
            }
            
            pstmt.close();
        } else {    // 공지 또는 댓글 수정
            PreparedStatement pstmt = conn.prepareStatement("UPDATE gongji2 SET title=?, date=?, content=? WHERE id=?");
            pstmt.setString(1, title);
            pstmt.setString(2, date);
            pstmt.setString(3, content);
            pstmt.setString(4, key);
            pstmt.executeUpdate();   
            pstmt.close();  
        }
        conn.close();   // Connection 닫기
    
%>
</body>	<!--본문 끝-->
<script>
window.onload = function() {
  window.location.href = "gongji_list.jsp";
}
</script>
</html>	<!--HTML의 끝-->