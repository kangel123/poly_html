<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*, javax.xml.parsers.*,org.w3c.dom.*"%> <%--import--%>
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

<%
    String kiho = request.getParameter("kiho"); // 출력할 후보의 기호
 
    DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder(); //  DocumentBuilder 인스턴스를 할당받음, 파싱을 위한 준비
    Document doc = docBuilder.parse("http://192.168.23.58:8081/Lesson8/tupyo/ReportOne.jsp?kiho="+kiho);   // 해당 주소의 xml파일을 파싱함

    Element root = doc.getDocumentElement();    // 요소를 저장
    NodeList tag_hubo = doc.getElementsByTagName("hubo");   // 이름을 이름에 대한 NodeList에 저장
    NodeList tag_data = doc.getElementsByTagName("data");   // 이름을 이름에 대한 NodeList에 저장

    String hubo=tag_hubo.item(0).getFirstChild().getNodeValue();    // 후보 정보

    out.println("<div style='width: 900px;'>");  // 바깥쪽 공간
    out.println("<div>");   // 안쪽 공간
    out.println("<h2> "+hubo+" 후보의 득표성향 분석</h2>");     // 제목 출력
    out.println("</div>");  // 안쪽 공간 끝

    out.println("<table cellspacing=3 border=1>");    // 테이블 생성
    out.println("<tr>");    // 1행
    out.println("<th style='width:20%;'>연령대</th>"); // 1열
    out.println("<th style='width:80%;'>득표율</th>"); // 2열
    out.println("</tr>");   // 1행 종료

    for(int i=0;i<tag_data.getLength();i++){    // // 모든 학생들(이름)에 대하여        
        Element elmt=(Element)tag_data.item(i);  // tag_data의 요소들만 가져와 저장
        String age = elmt.getElementsByTagName("age").item(0).getFirstChild().getNodeValue();   // 연령대
        String pyosu = elmt.getElementsByTagName("pyosu").item(0).getFirstChild().getNodeValue(); // 득점표
        String pyoyul = elmt.getElementsByTagName("pyoyul").item(0).getFirstChild().getNodeValue();   // 득점율     

        out.println("<tr>");    // 행 시작 
        out.println("<td style='width:20%;'>"+Integer.parseInt(age)*10+"대</a></td>");  // 1열, 후보
        out.println("<td style='width:80%;'><p align=left><img src='./bar.jpg' width="+Double.parseDouble(pyoyul)*6+" height='20'> "+pyosu+"(%"+pyoyul+")</p></td>");     //  2열, 득점표, 득점율
        out.println("</tr>");   // 행 종료
    }    
    out.println("</table>");    // 테이블 종료
    out.println("</div> ");    // 바깥 공간 종료
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->