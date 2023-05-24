<!DOCTYPE html> <!--html 형식임을 선언함-->
<html lang="en">    <!--HTML의 시작-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->

<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>java script와 jsp비교</title>	<!--제목-->
    <%! // jsp 함수 선언하는 부분
    private String call1(){ // call1 함수 선언
        String a = "abc";   // 문자열1
        String b = "efg";   // 문자열2
        return (a+b);   // 문자열 이어붙여서 리턴
    }
    private Integer call2(){ // call2 함수 선언
        int a = 1;   // 숫자형1
        int b = 2;   // 숫자형2
        return (a+b);   // 합 리턴
    }
    %>
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    String연산:<%=call1()%><br> <!--call1함수를 실행한 값 출력-->
    Integer연산:<%=call2()%><br>    <!--call2함수를 실행한 값 출력-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->