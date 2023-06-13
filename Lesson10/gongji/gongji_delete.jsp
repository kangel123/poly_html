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
    if(request.getParameter("key")!=null&&!request.getParameter("key").equals("")){  // 해당 페이지를 강제로 들어왔을때, key값이 있는지 확인            
        int key=Integer.parseInt(request.getParameter("key")); // 번호

        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
        PreparedStatement pstmt = conn.prepareStatement("select rootid from gongji2 where id = ?;");   // 삭제할 id의 rootid 찾기
        pstmt.setInt(1, key);   // 번호
        ResultSet rset = pstmt.executeQuery();  // rset에 가져온 내용 저장
        if(rset.next()){    // 존재하면
            int rootid=rset.getInt(1);  // rootid 저장
            if(key==rootid){    // 번호와 rootid가 같은 경우 == 공지 (즉, 공지 삭제)
                pstmt = conn.prepareStatement("delete from gongji2 where rootid=?;"); // 만약 해당 id가 공지였으면 공지에 달린 모든 댓글들은 삭제
                pstmt.setInt(1, key);  // 번호
                pstmt.executeUpdate();  // 실행
            } else{ // 번호와 rootid가 다름 경우 == 댓 (즉, 공지 삭제)
                /* 삭제된 댓글의 정보는 유지하면서 일반 유저는 볼수 없도록 하며, 
                현재 제공된 db의 속성을 추가하지 않는 방향을 만들기 위해 viewcnt를 사용하였다 */
                pstmt = conn.prepareStatement("UPDATE gongji2 SET viewcnt=-1 WHERE id = ?;");   // 조회수를 음수로 변경하는 sql문
                pstmt.setInt(1, key);  // 번호
                pstmt.executeUpdate();  // 실행
            }
        } else{ // 존재하지 않으면
            out.println("<script>alert('해당 게시물은 존재하지 않은 상태입니다')</script>");   // 에러 알림창 출력
        }
    } else {    // key값이 없는 경우
        out.println("<script>alert('삭제할 게시물을 찾지 못했습니다');</script>");    // 에러 알림창 출력    
    }
%>
</body>	<!--본문 끝-->
<script>
window.onload = function() {
  window.location.href = "gongji_list.jsp"; // 모든 작업이 완료되면 공지 리스트로 넘어간다
}
</script>
</html>	<!--HTML의 끝-->