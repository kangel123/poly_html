<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.ArrayList,java.util.HashMap"%> <%--import--%>
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
    text-align : center;    /*글자 정렬*/
}

td{
	width : 10%;    /*넓이*/
}

a{
    display: block; /*유형 block*/
    text-align: center; /*글자 가운데 정렬*/ 
    text-decoration-line: none;	/*밑줄 제거*/
    font-weight: bold;  /*폰트 볼드체*/
    padding: 10px;  /*패딩*/
}
</style>
<body>	<!--본문-->
<table> <!--테이블 생성, 메뉴창-->
	<tr>    <!--메뉴는 1행으로 구성-->
		<td width=100><a href="./A_01.jsp" target="main"><h2>후보등록</h2></a>   <!--1번-->
        <td width=100><a href="./B_01.jsp" target="main"><h2>투표</h2></a>  <!--2번-->
        <td width=100  bgcolor=yellow><a href="./C_01.jsp" target="main"><h2>개표결과</h2></a>  <!--3번, 현재 메뉴-->
	</tr>   <!--1행 끝-->
</table>    <!--메뉴창 끝-->
<br>    <!--메뉴와의 공간을 띄움-->
<div style="width: 900px;"> <!--바깥 공간은 900px로 지정-->
    <div>   <!--왼쪽 공간-->
        <h2>후보 별 득표율</h2>  <!--제목-->
    </div>

<table cellspacing=3 border=1>  <!--테이블 생성-->
    <tr>    <!--1행-->
        <th style="width:20%;">후보</th>  <!--1열-->
        <th style="width:80%;">득표율</th>  <!--2열-->
    </tr>   <!--1행 종료-->
<%
    try{
    	Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	    ResultSet rset = stmt.executeQuery("select * from hubo;"); // 후보가 존재하는지를 알아보기 위한 모든 후보 정보 가져오기  
        if(!rset.next()){out.println("<script>alert('후보를 먼저 등록해 주십시오.'); history.back();</script>");}   // 등록된 후보가 없는 경우
        
        rset = stmt.executeQuery("select kiho, name, (select count(*) from tupyo where hubo.kiho=tupyo.kiho)," +
            "(select count(*) from tupyo where hubo.kiho=tupyo.kiho)/(select count(*) from tupyo)*100 from hubo;");  // 모든 후보의 투표정보를 가져옴
        
        while(rset.next()){ // 모든 후보의 정보에 대하여
            int kiho = rset.getInt(1);  // 기호
            String name = rset.getString(2);    // 이름
            int num = rset.getInt(3);   // 득표수
            double average = rset.getDouble(4); // 득표율
%>

    <tr>    <!--2행부터 10행까지-->
        <td style="width:20%;"><a href="./C_02.jsp?kiho=<%=kiho%>&name=<%=name%>"><%=kiho%> <%=name%></a></td> <!--1열, 후보-->  
        <td style="width:80%;"><p align=left><img src="./bar.jpg" width=<%=average*6%> height=20> <%=num%>(%<%=average%>)</p></td>  <!--2열, 득점수, 득점율-->  
    </tr>   <!--행 종료-->
<%        
            }   // 반복문 종료
%>      
</table>    <!--테이블 종료-->

</div>  <!--바깥 공간 종료-->
<%

        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 발생한경우
        out.println(e); // 에러메시지 출력
    }
%>

</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->