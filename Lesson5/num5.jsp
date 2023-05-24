<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>문자열 다루기</title>	<!--제목-->
    <%! // jsp 변수 및 함수 선언하는 부분
    String str = "abcdfeffasdsd";   // 문자열
    int str_len=str.length();   // 문자열 길이
    String str_sub=str.substring(5);    // 문자 자르기
    int str_loc=str.indexOf("cd");  // 문자열 찾기
    String strL = str.toLowerCase();    // 소문자로 변환
    String strU = str.toUpperCase();    // 대문자로 변환
    %>
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    Str:<%=str%><br>    <!--문자열 출력-->
    str_len:<%=str_len%><br>     <!--문자열 길이 출력-->
    str_sub:<%=str_sub%><br>     <!--문자 자르기 출력-->
    str_loc:<%=str_loc%><br>     <!--문자열 찾기 출력-->
    strL:<%=strL%><br>   <!--소문자로 출력-->
    strU:<%=strU%><br>   <!--대문자로 출력-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->