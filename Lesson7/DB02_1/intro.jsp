<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*,java.net.*" %>

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
</head>	<!--머리말 끝-->
<body>	<!--본문-->
    <h1>JSP Database 실습</h1>  <!--제목-->
<%
    String data;    // 읽어온 줄의 정보
    int cnt = 0;    // 방문 조회수 초기화
    try {
        FileReader fileReader = new FileReader("/home/cnt.txt");    // 파일을 읽기 형식으로 가져오기
        BufferedReader bufferedReader = new BufferedReader(fileReader); // BufferedReader 객체 생성

        data = bufferedReader.readLine();   // 줄 읽어오기
        if (data != null) { // 비어있지 않은 경우
            cnt = Integer.parseInt(data);   // 해당 값을 가져오기
        }

        cnt++;  // 방문 조회수 증가

        FileWriter fileWriter = new FileWriter("/home/cnt.txt");    // 파일을 쓰기 형식으로 다시 가져오기
        BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);     // BufferedWriter 객체 생성

        bufferedWriter.write(String.valueOf(cnt));  // 증가시킨 방문 조회수를 파일에 다시 씀

        bufferedWriter.close(); // BufferedWriter 객체 닫기
        fileWriter.close(); // FileWriter 객체 닫기
        bufferedReader.close(); // BufferedReader 객체 닫기
        fileReader.close(); // FileReader 객체 닫기
        out.println("<br><br>현재 홈페이지 방문조회수는 [" + cnt + "] 입니다</br></br>");   // 방문 조회수 출력
    } catch (IOException e) {   // 파일 읽고쓰는 과정 중 에러 발생 시
        out.println(e); // 에러 출력
    }
 %>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->