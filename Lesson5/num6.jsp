<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>배열</title>	<!--제목-->
   
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    <%! // jsp 부분
    String arr[] = new String[]{"111","222","333"}; // 배열 선언
    String str="abc,efg,hij";   // 문자열 선언
    String str_arr[]=str.split(",");    // 문자열을 ','로 나누어서 배열에 넣기
    %>
    arr[0]:<%=arr[0]%><br> <!--arr의 0번 인덱스 값-->
    arr[1]:<%=arr[1]%><br> <!--arr의 1번 인덱스 값-->
    arr[2]:<%=arr[2]%><br>  <!--arr의 2번 인덱스 값-->
    
    str_arr[0]:<%=str_arr[0]%><br>  <!--str_arr의 0번 인덱스 값-->
    str_arr[1]:<%=str_arr[1]%><br>  <!--str_arr의 1번 인덱스 값-->
    str_arr[2]:<%=str_arr[2]%><br> <!--str_arr의 2번 인덱스 값-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->