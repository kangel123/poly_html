<%--모든 데이터 조회--%>
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>db조회</title>	<!--제목-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<%  
    int fromPT = 0; // 시작 번호,0으로 초기화
    int cntPT = 20; // 출력할 개수
    int LineCnt=0;
    try{    // 다른 페이지로 이동 시
        fromPT=Integer.parseInt(request.getParameter("from"));  // 시작번호 변경
        cntPT=Integer.parseInt(request.getParameter("cnt"));    // 출력할 개수 변경
    }catch(Exception e){    // 따로 입력받은 인자가 없는 경우 그냥 패스
    }

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        ResultSet rset = stmt.executeQuery("select *, kor+eng+mat as sum, (kor+eng+mat)/3 as ave,(select count(*)+1 from examtable as m where m.kor+m.eng+m.mat > n.kor+n.eng+n.mat) as ranking from examtable as n;"); // 모든 학생 정보+총점,평균,등수
%>

<body>	<!--본문-->

<div style="display: inline-block; width: 900px;">   <!--바깥쪽 공간 지정-->
<h1>조회</h1>   <%--제목--%>

<hr>    <%--구분 선--%>
<div>
<table cellspacing=1 width="900" border=1>    <%--테이블 생성--%>
    <tr>    <%--테이블 헤더--%>
        <th>이름</th>   <%--1열--%>
        <th>학번</th>   <%--2열--%>
        <th>국어</th>   <%--3열--%>
        <th>영어</th>   <%--4열--%>
        <th>수학</th>   <%--5열--%>
        <th>총점</th>   <%--6열--%>
        <th>평균</th>   <%--7열--%>
        <th>등수</th>   <%--8열--%>
    </tr>
<%    
        while(rset.next()){ // 반복
		    LineCnt++; // 다음 줄 번호    
            if(LineCnt <= fromPT) continue; // 시작번호보다 아래인 경우 패스
            if(LineCnt > fromPT+cntPT) continue;    // 출력할 번호를 넘어간 경우 패스
            String studentname=rset.getString(1);   // 이름 따로 저장
            String studentid=Integer.toString(rset.getInt(2));  // 학번 따로 저장
            
%>
    <tr>    <%--다음 행--%>
    <td><a href="./oneviewDB.jsp?studentname=<%=studentname%>&studentid=<%=studentid%>"><%=studentname%></a></td>   <%--1열,이름, 하이퍼링크로 인자 전달--%>
    <td><%=studentid%></td>  <%--2열,학번--%>
    <td><%=Integer.toString(rset.getInt(3))%></td>  <%--3열,국어--%>
    <td><%=Integer.toString(rset.getInt(4))%></td>  <%--4열,영어--%>
    <td><%=Integer.toString(rset.getInt(5))%></td>  <%--5열,수학--%>
    <td><%=Integer.toString(rset.getInt(6))%></td>  <%--6열,총점--%>
    <td><%=Integer.toString(rset.getInt(7))%></td>  <%--7열,평균--%>
    <td><%=Integer.toString(rset.getInt(8))%></td>  <%--8열,등수--%>
    </tr>
<% 
        }   // 반복문 종료
        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    
%>

    </div>
    <div style="text-align:center;"> <%--다른 페이지 정보를 안쪽 공간으로 묶음--%>

    <% 
        int block = 10; // 총 출력할 개수
    
        int maxpage = (int) Math.ceil((double) LineCnt / cntPT);    // 최대 페이지

        int current=(fromPT/cntPT)+1;   // 현재 페이지

        // 왼쪽(<<)의 from 구하기
        int left=0; // 왼쪽의 초기값은 0
        if(current>block){  // 현재페이지가 앞부분이 아닌 경우
                left = ((((current-1)/block)-1)*block)*cntPT;   // (<<)시 이동할 페이지의 from 구하기
        }

        // 오른쪽(>>)의 from 구하기
        int right=(((current-1)/block)+1)*block*cntPT;  // (>>)시 이동할 페이지의 from 구하기
        if((maxpage-1)*cntPT < right){  // 만약 최대페이지 시의 from를 초과한 경우
                right = (maxpage-1)*cntPT;  // (>>)는 최대페이지 시의 from으로 변경
        }    
    %>   

    <a href="AllviewDB.jsp?from=<%=left%>&cnt=<%=cntPT%>">&lt;&lt;</a>   <%--이전(<<)--%>

    <%
        int pagenum=((current-1)/block)*block;  // 출력할 번호(현재는 출력할 번호의 첫번째 값)
        int endpage=pagenum+block-1;  // 출력할 번호의 끝
        
        while(pagenum<=endpage){    // 결과적으로 block수 만큼 반복
            if(pagenum>=maxpage) break; // 최대페이지를 넘긴 경우 반복문 종료
            int pagefrom=pagenum*cntPT; // 해당 페이지의 from값
            pagenum++;  // 페이지 번호 증가, 출력할 번호가 1부터 10인 경우, pagenum는 0부터 9이다
                    // 예를 들어 from값을 구할때는 pagenum는 0으므로 from=0이고 그 후 pagenum(현재페이지)는 1이 된다.
    %>
        <a href="AllviewDB.jsp?from=<%=pagefrom%>&cnt=<%=cntPT%>"><%=pagenum%></a>   <%--페이지 번호와 그에 해당하는 값들을 인자로 하이퍼링크--%>
    <%  } %>    <%--반복문 종료--%>

    <a href="AllviewDB.jsp?from=<%=right%>&cnt=<%=cntPT%>">&gt;&gt;</a>   <%--다음(>>)--%>

    </div>  <%--안쪽 공간 종료--%>
    </div>  <%--바깥쪽 공간 종료--%>
<%
    } catch(Exception e){   // 에러 발생 시
        out.println("<h1>조회 실패</h1>");   // 에러 출력
    }
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->