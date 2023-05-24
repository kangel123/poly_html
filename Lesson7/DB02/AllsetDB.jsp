<%--데이터를 삽입--%>
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>데이터 삽입</title>	<!--제목-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->


<body>	<!--본문-->
<%  try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
    
        stmt.execute("insert into examtable values('나연',209901,95,100,95);");    // 나연 데이터 삽입
        stmt.execute("insert into examtable values('정연',209902,95,95,95);");    // 정연 데이터 삽입
        stmt.execute("insert into examtable values('모모',209903,100,100,100);");    // 모모 데이터 삽입
        stmt.execute("insert into examtable values('사나',209904,100,95,90);");    // 사나 데이터 삽입
        stmt.execute("insert into examtable values('지효',209905,80,100,70);");    // 지효 데이터 삽입
        stmt.execute("insert into examtable values('미나',209906,100,100,70);");    // 미나 데이터 삽입
        stmt.execute("insert into examtable values('다현',209907,70,70,70);");    // 다현 데이터 삽입
        stmt.execute("insert into examtable values('채영',209908,80,75,72);");    // 채영 데이터 삽입
        stmt.execute("insert into examtable values('쯔위',209909,78,79,82);");    // 쯔위 데이터 삽입
        out.println("<h1>실습데이터 입력</h1>");   // 성공 시 메시지 출력
        
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 생겼으면
        out.println("<h1>데이터 입력 실패</h1>");   // 에러 출력
    }
%>
    </tbody>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->