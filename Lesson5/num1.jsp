<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>jsp로 content Type 선언 및 간단한 사용</title>	<!--제목-->    
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    <% String myUrl="http://www.kopo.ac.kr";%>  <!--myUrl(변수) 선언-->
    <a href="<%=myUrl%>">안녕</a> World.   <!--변수의 값에 해당하는 사이트로 이동하는 하이퍼링크 생성-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->