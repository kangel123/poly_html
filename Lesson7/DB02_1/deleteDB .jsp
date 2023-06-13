<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%> <%--import--%>
<% request.setCharacterEncoding("UTF-8"); %>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
    <meta charset="UTF-8">  <!--한글 인코딩-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->

<body>	<!--본문-->
<% 
    boolean first;  // 처음 시작한 경우인지 판단하기 위한 boolean
    int fromPT = 0; // 시작 번호,0으로 초기화
    int cntPT = 20; // 출력할 개수
    int LineCnt=0;  // 줄 번호
    try{    // 다른 페이지로 이동 시
        fromPT=Integer.parseInt(request.getParameter("from"));  // 시작번호 변경
        cntPT=Integer.parseInt(request.getParameter("cnt"));    // 출력할 개수 변경
        first=false;    // 위에 인자를 다 받았으면 처음이 아닌 경우이므로 false
    }catch(Exception e){    // 따로 입력받은 인자가 없는 경우에느
        first= true;    // 처음이므로 true
    }

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클0래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결  
        if(first){  // 처음 시작이면
            String name=request.getParameter("name");   // 이름 인자로 받음
            String id=request.getParameter("id");   // 학번 인자로 받음
            String kor=request.getParameter("korean");  // 국어 성적 인자로 받음
            String eng=request.getParameter("english"); // 영어 성적 인자로 받음
            String mat=request.getParameter("math");    // 수학 성적 인자로 받음

            PreparedStatement pstmt = conn.prepareStatement("delete from examtable where id = ?");   // 수정하는 sql문
            pstmt.setString(1, id);   // 이름
            pstmt.executeUpdate();  // sql문 실행
            pstmt.close();   // PreparedStatement 닫기
        }
        Statement stmt = conn.createStatement();    // 수정한 후의 모든 학생의 정보를 가져오기 위한 Statement객체 생성
        ResultSet rset = stmt.executeQuery("select *, kor+eng+mat as sum, (kor+eng+mat)/3 as ave,"+
        "(select count(*)+1 from examtable as m where m.kor+m.eng+m.mat > n.kor+n.eng+n.mat) as ranking from examtable as n order by id;"); // 모든 학생 정보 가져오기                
%>
<h1>레코드 삭제</h1>   <%--제목--%>
<hr>    <%--구분 선--%>
<table>    <%--테이블 생성--%>
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
    <td><a href="./oneviewDB.jsp?studentname=<%=studentname%>&studentid=<%=studentid%>"><%=studentname%></a></td>  <%--이름,하이퍼링크--%>
    <td><%=studentid%></td>  <%--학번--%>
    <td><%=Integer.toString(rset.getInt(3))%></td>  <%--국어--%>
    <td><%=Integer.toString(rset.getInt(4))%></td>  <%--영어--%>
    <td><%=Integer.toString(rset.getInt(5))%></td>  <%--수학--%>
    <td><%=Integer.toString(rset.getInt(6))%></td>  <%--총점--%>
    <td><%=Integer.toString(rset.getInt(7))%></td>  <%--평균--%>
    <td><%=Integer.toString(rset.getInt(8))%></td>  <%--등수--%>
    </tr>
<% 
        }   // 반복문 종료
        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러 발생 시
        out.println("<h1>삭제 실패</h1>");   // 에러 출력
    }
%>

</table>    <!--테이블 종료-->
</div>  <!--1번 안쪽 공간 닫기-->
     
    <div style="text-align:center;">    <%--2번, 다른 페이지 정보를 안쪽 공간으로 묶음--%>
    <% 
        int block = 10; // 총 출력할 개수
    
        int maxpage = (int) Math.ceil((double) LineCnt / cntPT);    // 최대 페이지
        int lastfrom = (maxpage-1)*cntPT;
        int current=(fromPT/cntPT)+1;   // 현재 페이지

        int startpage=((current-1)/block)*block+1;  // 출력할 번호의 첫번째 번호
        int endpage=startpage+block-1;  // 출력할 번호의 끝
        int maxstartpage=(maxpage-1)/block*block+1; 

        // 왼쪽(<)의 from 구하기
        int left=0; // 왼쪽의 초기값은 0
        if(current>block){  // 현재페이지가 앞부분이 아닌 경우
                left = ((((current-1)/block)-1)*block)*cntPT;   // (<)시 이동할 페이지의 from 구하기
        }

        // 오른쪽(>)의 from 구하기
        int right=(((current-1)/block)+1)*block*cntPT;  // (>)시 이동할 페이지의 from 구하기
        if((maxpage-1)*cntPT < right){  // 만약 최대페이지 시의 from를 초과한 경우
                right = (maxpage-1)*cntPT;  // (>)는 최대페이지 시의 from으로 변경
        }        
    %>   
    <%
        if(current>block){  // 현재페이지가 맨앞 페이지가 아닌 경우
    %>
    <a href="deleteDB.jsp?from=0&cnt=<%=cntPT%>">&lt;&lt;</a>   <%--첫페이지(<<)--%>
    <%
        }   // (<<) 출력 조건 종료
    %>
    <%
        if(current>block){  // 현재페이지가 맨앞 페이지가 아닌 경우
    %>
    <a href="deleteDB.jsp?from=<%=left%>&cnt=<%=cntPT%>">&lt;</a>   <%--이전(<)--%>

    <%  
        }      // (<) 출력 조건 종료
        for(int pagenum=startpage;pagenum<=endpage;pagenum++){  // 출력할 페이지 앞번호부터 뒷번호까지 반복
            if(pagenum>maxpage) break; // 최대페이지를 넘긴 경우가 존재하면, 그 즉시 반복문 종료
            int pagefrom=(pagenum-1)*cntPT; // 해당 페이지의 from값
            if(pagenum==current){  // 출력 번호가 현재 페이지이면
    %>    
        <a href="deleteDB.jsp?from=<%=pagefrom%>&cnt=<%=cntPT%>"  style="color:red; font-weight: bold;"><%=pagenum%></a>   <%--페이지 번호와 색과 강조 변경--%>
    <%
            } else{
    %>
        <a href="deleteDB.jsp?from=<%=pagefrom%>&cnt=<%=cntPT%>"><%=pagenum%></a>   <%--페이지 번호와 그에 해당하는 값들을 인자로 하이퍼링크--%>
    <%  
            } // 조건문 종료
        }   // 페이지 출력 반복문 종료
        if(maxstartpage>current){    // 맨뒤 페이지인 경우
    %>
    <a href="AllviewDB.jsp?from=<%=right%>&cnt=<%=cntPT%>">&gt;</a>   <%--다음(>)--%>
    <%  }   // (>) 출력 조건 종료
        if(maxstartpage>current){    // 맨뒤 페이지인 경우
    %>
    <a href="deleteDB.jsp?from=<%=lastfrom%>&cnt=<%=cntPT%>">&gt;&gt;</a>   <%--마지막페이지(>>)--%>
    <%  } %>  <%--(>>) 출력 조건 종료--%>
    
    </div>  <%--2번 안쪽 공간 종료--%>
</div>  <%--바깥쪽 공간 종료--%>

</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->