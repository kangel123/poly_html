<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>try-catch</title>	<!--제목-->
   
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    <% // jsp 부분
    String arr[] = new String[]{"111","222","333"}; // 배열 선언
    try{    // try-catch문
        out.println(arr[4]+"<br>"); // 4번째 인덱스 값 출력
    }catch(Exception e){    // 이 예제에서는 4번 인덱스가 없으므로 해당 코드 실행
        out.println("error==>"+e+"<========<br>");  // 에러시 출력
    }
    %>
    Good...
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->