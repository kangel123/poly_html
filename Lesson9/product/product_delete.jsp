<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat"%> <%--import--%>
<% request.setCharacterEncoding("UTF-8"); %>

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
    <meta charset="UTF-8">  <!--한글 인코딩-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<style>
table{  /*테이블*/
    width: 900px;   /*넓이*/
    border : 1px solid black;   /*테두리*/
}
</style>
<body>	<!--본문-->   
<%
    
    if(request.getParameter("key")!=null){  // 해당 페이지를 강제로 들어왔을때, key값이 있는지 확인
        String key=request.getParameter("key"); // key를 인자로 가져옴
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
            Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
            ResultSet rset = stmt.executeQuery("select name from product where id='"+key+"';"); // 해당 id가 존재하는지 알아보기 위해 이름만 가져오는 sql문
            if(rset.next()){    // 해당 id가 존재하면
                String name=rset.getString(1);  // 이름만 따로 저장
                stmt.executeUpdate("delete from product where id='"+key+"';"); // 모든 공지를 가져오는 sql문
                out.println("<script>alert('["+name+"]상품이 삭제되었습니다')</script>");    // 해당 상품의 이름과 함께 알림창 출력
            } else{ // 이미 삭제되서 없는 경우
                out.println("<script>alert('해당 상품은 존재하지 않은 상태입니다')</script>");   // 에러 알림창 출력
            }            
            rset.close(); // rset 닫기
            stmt.close(); // stmt 닫기
            conn.close(); // conn 닫기  
        } catch(Exception e){
            out.println("<script>alert('삭제과정 중 DB에 에러가 발생하였습니다.');</script>");  // 에러 알림창 출력               
        }
    } else {    // key값이 없는 경우
        out.println("<script>alert('삭제할 상품번호를 찾지 못했습니다');</script>");    // 에러 알림창 출력    
    }
%>
</body>	<!--본문 끝-->
<script>
window.onload = function() {
  window.location.href = "product_list.jsp"; // 어떤 경우든 작업이 완료되면 상품 리스트로 넘어간다
}
</script>
</html>	<!--HTML의 끝-->