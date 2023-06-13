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
    String key="-1";    // key값 초기화, 번호는 자동부여이므로 음수일 수는 없으니 인자값이 없는 경우 자동 에러가 된다
    if(!request.getParameter("key").equals("")){    // 전달받은 key 인자값이 있으면
        key=request.getParameter("key");    // 해당 인자값 저장
    }
    
    String title="";    // 제목 초기화
    String date=""; // 날짜 초기화
    String content="";  // 내용 초기화  

    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	ResultSet rset = stmt.executeQuery("select * from gongji where id='"+key+"';"); // 해당 공지를 가져오는 sql문
       if(rset.next()) { // 존재하면
        title=rset.getString(2);    // 제목 저장
        date=rset.getString(3); // 날짜 저장
        content=rset.getString(4);  // 내용 저장
    }
    if(title.equals("")){   // 제목이 없다==해당 공지가 없다
        out.println("<script>");    // 스크립트 형식 시작
        out.println("alert('존재하지 않은 게시물입니다.');");   // 알림창으로 메세지 출력 후
        out.println(" location.href = 'gongji_list.jsp';"); // 공지 리스트로 이동시킴
        out.println("</script>");   // 스크립트 형식 끝
    } 
    
%>
<div style="width:900px">   <!--바깥쪽 공간-->
    <h1> 상세 조회 </h1>
    <div>   <!--안쪽 공간-->
    <table cellspacing=3 border=1> <!--테이블 시작-->    
        <tr>    <!--1행-->
            <th style="width:100px;">번호</th>   <!--1열-->
            <td style="width:800px;"><%=key%></td>   <!--2열--> 
         </tr>   <!--1행 끝-->
        <tr>    <!--2행-->   
            <th style="width:100px;">제목</th>   <!--1열-->
            <td style="width:800px;"><%=title%></td>  <!--2열-->     
        </tr>   <!--2행 종료-->
        <tr>    <!--3행-->   
            <th style="width:100px;">일자</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="date" value="<%=date%>" tabindex="-1" value="<%=date%>" readonly></td>    <!--2열-->     
        </tr>   <!--3행 종료-->
        <tr>    <!--4행-->   
            <th style="width:100px;">내용</th>   <!--1열-->
            <td style="width:800px;">
                <textarea style="overflow: auto;resize: none; border: none; pointer-events: none;" name="content" id="content" cols="100" rows="20" readonly><%=content%></textarea>    <!--2열--> 
            </td>
        </tr>   <!--4행 종료-->
    </table>    <!--테이블 종료-->
    </div>  <!--안쪽 공간 끝--> 
	
    <div style="text-align: right;">    <!--안쪽 공간-->
       <input type="button" value="목록" onclick="window.location.href = './gongji_list.jsp'">  <!--목록으로 이동 버튼-->
        <input type="button" value="수정" onclick="window.location.href = './gongji_update.jsp?key=<%=key%>'">  <!--수정 버튼-->
    </div>  <!--안쪽 공간 끝-->
</div>  <!--바깥쪽 공간 끝-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->