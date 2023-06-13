<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*, javax.xml.parsers.*,org.w3c.dom.*"%> <%--import--%>

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
    <meta charset="UTF-8">  <!--한글 인코딩-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<body>	<!--본문-->
<%
    DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder(); //  DocumentBuilder 인스턴스를 할당받음, 파싱을 위한 준비
    Document doc = docBuilder.parse("http://192.168.23.58:8081/Lesson8/xmlmake.jsp");   // 해당 주소의 xml파일을 파싱함

    Element root = doc.getDocumentElement();
    NodeList tag_name = doc.getElementsByTagName("name");   // 이름을 이름에 대한 NodeList에 저장
    NodeList tag_studentid= doc.getElementsByTagName("studentid");  // 학번을 학번에 대한 NodeList에 저장
    NodeList tag_kor = doc.getElementsByTagName("kor"); // 국어 성적을 국어에 대한 NodeList에 저장
    NodeList tag_eng = doc.getElementsByTagName("eng"); // 영어 성적을 영어에 대한 NodeList에 저장
    NodeList tag_mat = doc.getElementsByTagName("mat"); // 수학 성적을 수학에 대한 NodeList에 저장

    out.println("<table cellspacing=1 width=500 border=1>");    // 테이블 생성
    out.println("<tr>");    // 1행
    out.println("<td width=100>이름</td>"); // 1열
    out.println("<td width=100>학번</td>"); // 2열
    out.println("<td width=100>국어</td>"); // 3열
    out.println("<td width=100>영어</td>"); // 4열
    out.println("<td width=100>수학</td>"); // 5열
    out.println("</tr>");   // 1행 종료

    for(int i=0;i<tag_name.getLength();i++){    // // 모든 학생들(이름)에 대하여
        out.println("<tr>");    // 행 시작
        out.println("<td width=100>"+tag_name.item(i).getFirstChild().getNodeValue()+"</td>");  // i번째 이름태그의 첫번째의 값을 가져옴, 1열
        out.println("<td width=100>"+tag_studentid.item(i).getFirstChild().getNodeValue()+"</td>");     // i번째 학번태그의 첫번째의 값을 가져옴, 2열
        out.println("<td width=100>"+tag_kor.item(i).getFirstChild().getNodeValue()+"</td>");   // i번째 국어태그의 첫번째의 값을 가져옴, 3열
        out.println("<td width=100>"+tag_eng.item(i).getFirstChild().getNodeValue()+"</td>");   // i번째 영어태그의 첫번째의 값을 가져옴, 4열
        out.println("<td width=100>"+tag_mat.item(i).getFirstChild().getNodeValue()+"</td>");   // i번째 수학태그의 첫번째의 값을 가져옴, 5열
        out.println("</tr>");   // 행 종료
    }    
    out.println("</table>");    // 테이블 종료
%>
</body>
</html>