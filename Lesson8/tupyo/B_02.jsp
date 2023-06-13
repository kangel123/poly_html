<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.ArrayList"%> <%--import--%>
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
        <td width=100 bgcolor=yellow><a href="./B_01.jsp" target="main"><h2>투표</h2></a>  <!--2번, 현재 메뉴-->
        <td width=100><a href="./C_01.jsp" target="main"><h2>개표결과</h2></a>  <!--3번-->
	</tr>   <!--1행 끝-->
</table>    <!--메뉴창 끝-->
<br>    <!--메뉴와의 공간을 띄움-->

<%
    int kiho = Integer.parseInt(request.getParameter("kiho"));  // 기호를 가져와서 숫자형으로 저장
    int age =  Integer.parseInt(request.getParameter("age"));   // 연령대를 가져와서 숫자형으로 저장

    try{
    	Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO tupyo VALUES (?,?);");    // 데이터 삽입하는 sql문
		pstmt.setInt(1, kiho);   // 기호
		pstmt.setInt(2, age);  // 연령대
        pstmt.executeUpdate();  // 완성된 sql문 실행
        out.println("<h2>투표 성공하였습니다.</h2>"); // 투표 성공 메시지

        pstmt.close();   // Statement 닫기
		conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 발생한 경우
        out.println("<h2>투표 실패하였습니다.</h2>");   // 투표 실패 메시지
        out.println(e); // 에러 내용 출력
    }
%>
<br>

</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->