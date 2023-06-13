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
    try{
    	Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성        
	    ResultSet rset = stmt.executeQuery("select * from hubo;"); // 후보가 존재하는지를 알아보기 위한 모든 후보 정보 가져오기  
        if(!rset.next()){out.println("<script>alert('후보를 먼저 등록해 주십시오.'); history.back();</script>");}   // 등록된 후보가 없는 경우
        rset = stmt.executeQuery("select * from hubo;"); // 모든 후보의 정보를 가져오는 sql문   
%>
<form method="post">    <!--폼 생성, 형식:post-->
<table cellspacing=3 border=1>  <!--테이블 생성-->
    <tr>    <!--1행으로만 구성-->
        <td>    <!--1열, 기호-->
            <select name="kiho">    <!--기호에 대한 선택 박스 생성-->
            <%            
            while(rset.next()){ // 모든 후보의 레코드에 대하여
                int kiho=rset.getInt(1);    // 기호 저장
                String name=rset.getString(2);  // 이름 저장
            %>
                <option value=<%=kiho%>><%=kiho%>번 <%=name%></option>  // 선택요소는 기호와 이름을 보여주면 value는 기호로만 구성
            <%  
                }
            %>
            </select>   <!--기호에 대한 선택 박스 종료-->
        </td>   <!--1열 종료-->
        <td>    <!--2열, 연령대-->
            <select name="age"> <!--연령대에 대한 선택 박스 생성-->
                <option value=1>10대</option>   <!--선택요소1:10대-->
                <option value=2>20대</option>   <!--선택요소2:20대-->
                <option value=3>30대</option>   <!--선택요소3:30대-->
                <option value=4>40대</option>   <!--선택요소4:40대-->
                <option value=5>50대</option>   <!--선택요소5:50대-->
                <option value=6>60대</option>   <!--선택요소6:60대-->
                <option value=7>70대</option>   <!--선택요소7:70대-->
                <option value=8>80대</option>   <!--선택요소8:80대-->
                <option value=9>90대</option>   <!--선택요소9:90대-->
            </select>   <!--연령대에 대한 선택 박스 종료-->
        </td>   <!--2열 종료-->
        <td>    <!--3열, 투표 버튼-->
            <input type="submit" value="투표하기" formaction="./B_02.jsp">  <!--제출 버튼-->
        </td>   <!--3열 종료-->
    </tr>   <!--1행 끝-->
</table>    <!--테이블 종료-->
</form>
<%
        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 생겼을 경우
        out.println(e); // 에러 메시지 출력
    }
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->