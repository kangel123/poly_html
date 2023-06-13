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
    String rootid="";   // 루트id 초기화
    String relevel="";  // 레벨 초기화
    String recnt="";    // 순서 초기화
    String viewcnt="";  // 조회수 초기화

    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	ResultSet rset = stmt.executeQuery("select * from gongji2 where id='"+key+"';"); // 해당 공지를 가져오는 sql문
   
    if(rset.next()) { // 존재하면
        title=rset.getString(2);    // 제목 저장
        date=rset.getString(3); // 날짜 저장
        content=rset.getString(4);  // 내용 저장
        rootid = rset.getString(5); // 루트id 저장
        relevel = rset.getString(6);    // 레벨 저장
        recnt = rset.getString(7);  // 순서 저장
        viewcnt = rset.getString(8);    // 조회수 저장        
    }

    if(viewcnt.equals("")){ // 비어있는 경우==존재하지 않는 게시물
        out.println("<script>");    // 스크립트 사용
        out.println("alert('존재하지 않은 게시물입니다.');");   // 에러메시지 출력
        out.println(" location.href = 'gongji_list.jsp';"); // 공지 리스트로 이동
        out.println("</script>");   // 스크립트 종료
    } else if(Integer.parseInt(viewcnt)==-1){   // 조회수가 -1인 경우==삭제된 댓글
        out.println("<script>");    // 스크립트 사용
        out.println("alert('해당 댓글은 삭제된 댓글입니다.');");    // 에러메시지 출력
        out.println(" location.href = 'gongji_list.jsp';"); // 공지 리스트로 이동
        out.println("</script>");   // 스크립트 종료
    } else{ // 그외의 경우
        stmt.executeUpdate("update gongji2 set viewcnt = viewcnt+1 where id="+key+";"); // 조회수 업데이트
        viewcnt = Integer.toString(Integer.parseInt(viewcnt)+1);    // 현재 페이지에 보여줄 조회수도 증가
    }
%>
<div style="width:900px">   <!--바깥쪽 공간-->
    <h1>내용 상세보기</h1>
    <div>   <!--안쪽 공간-->
    <table cellspacing=3 border=1> <!--테이블 시작-->    
       <tr>    <!--1행-->
            <th style="width:100px;">번호</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><%=key%></td>   <!--2열--> 
         </tr>   <!--1행 끝-->
        <tr>    <!--2행-->   
            <th style="width:100px;">제목</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><%=title%></td>  <!--2열-->     
        </tr>   <!--2행 종료-->
        <tr>    <!--3행-->   
            <th style="width:100px;">일자</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><%=date%></td>    <!--2열-->     
        </tr>   <!--3행 종료-->
        <tr>    <!--4행-->   
            <th style="width:100px;">내용</th>   <!--1열-->
            <td style="width:800px;" colspan="3">
                <textarea style="overflow: auto;resize: none; border: none;" name="content" id="content" cols="100" rows="20" readonly><%=content%></textarea>    <!--2열--> 
            </td>
        </tr>   <!--4행 종료-->
        <tr>    <!--5행-->   
            <th style="width:100px;">원글</th>   <!--1열-->
            <td style="width:350px;"><%=rootid%></td> <!--2열, 원글-->
            <th style="width:100px;">조회수</th>   <!--1열-->
            <td style="width:350px;"><%=viewcnt%></td> <!--2열, 원글-->
        </tr>   <!--5행 종료-->   
         <tr>    <!--6행-->   
            <th style="width:100px;">댓글 수준</th>   <!--1열-->
            <td style="width:350px;"><%=relevel%></td> <!--2열, 원글-->
            <th style="width:100px;">댓글내 순서</th>   <!--1열-->
            <td style="width:350px;"><%=recnt%></td> <!--2열, 원글-->
        </tr>   <!--6행 종료-->   
    </table>    <!--테이블 종료-->
    </div>  <!--안쪽 공간 끝-->
	
    <div style="text-align: right;">    <!--안쪽 공간-->
        <input type="button" value="목록" onclick="window.location.href = './gongji_list.jsp'">     <!--목록으로 이동하는 버튼-->
        <input type="button" value="수정" onclick="window.location.href = './gongji_update.jsp?key=<%=key%>'">  <!--수정 버튼-->
        <input type="button" value="삭제" onclick="window.location.href = './gongji_delete.jsp?key=<%=key%>'">  <!--삭제 버튼-->
        <input type="button" value="댓글" onclick="window.location.href = './gongji_reinsert.jsp?key=<%=key%>'">    <!--댓글 버튼-->
    </div>  <!--안쪽 공간 끝-->
</div>  <!--바깥쪽 공간 끝-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->