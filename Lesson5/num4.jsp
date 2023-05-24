<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>class 사용</title>	<!--제목-->
    <%! // jsp 변수 및 함수 선언하는 부분
    private class AA{   // 클래스 생성
        private int Sum(int i,int j){   // 함수 생성
            return i+j; // 합 리턴
        }
    }
    AA aa = new AA();   // 객체 생성
    %>
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    <% out.println("2+3="+aa.Sum(2,3));%><br>    <!--함수 실행한 결과 출력-->
    Good... <!--위에 오류가 없으면 같이 출력 될 것임-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->