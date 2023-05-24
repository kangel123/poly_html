<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<% request.setCharacterEncoding("utf-8"); %>   <!--한글 받을 때-->
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>데이터 받기</title>	<!--제목-->
    
    <% // jsp 부분
    String name = request.getParameter("username"); // 전달받은 이름의 인자를 저장
    String password = request.getParameter("userpassword"); // 전달받은 패스워드의 인자를 저장    
    %>
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    이름:<%=name%><br>  <!--전달받은 이름 출력-->
    비밀번호:<%=password%><br>  <!--전달받은 비밀번호 출력-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->