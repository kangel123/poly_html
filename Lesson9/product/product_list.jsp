<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.List,java.util.ArrayList,java.util.Date"%> <%--import--%>
<% request.setCharacterEncoding("UTF-8"); %>

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
    <meta charset="UTF-8">  <!--한글 인코딩-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<style>
table{  /*테이블*/
    width: 900px;   /*넓이*/
    border : 1px solid black;   /*테두리*/
}

</style>
<body>	<!--본문-->
    <%
    int fromPT = 0; // 시작 번호,0으로 초기화
    int cntPT = 10; // 출력할 개수
    int LineCnt=0;  // 총 레코드 개수
    
    try{    // 다른 페이지로 이동 시
        fromPT=Integer.parseInt(request.getParameter("from"));  // 시작번호 변경
        cntPT=Integer.parseInt(request.getParameter("cnt"));    // 출력할 개수 변경
    }catch(Exception e){    // 따로 입력받은 인자가 없는 경우 그냥 패스
    }
    String searchText = ""; // 검색할 상품번호 초기화
    if(request.getParameter("searchText") != null){ // 검색할 상품번호가 있으면
        searchText = request.getParameter("searchText");    // 해당 상품번호 저장
    }
   
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
		Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        ResultSet rset = stmt.executeQuery("select count(*) from product where id LIKE '%"+ searchText +"%' ;"); // 모든 상품정보(또는 검색한 상품정보)의 개수
        if(rset.next()){    // 내용이 존재하면
            if(cntPT<=0){   // 출력할 개수가 0보다 작거나 같은 경우
                cntPT = 10; // 디폴트 값으로 10 설정
            }
            if(fromPT<0){   // 출력할 번호가 0보다 작거나 같은 경우
                fromPT = 0; // 첫번째 페이지로 설정
            }else if(fromPT>=rset.getInt(1)){    // 출력할 번호가 초과된 경우
                fromPT = (rset.getInt(1)-1)/cntPT*cntPT; // 마지막 페이지로 설정
            } else{ // 그외의 경우
                fromPT = fromPT/cntPT*cntPT;    // 해당 번호에 해당하는 테이블 내용이 되도록 설정)
            }
        }
        rset = stmt.executeQuery("select * from product where id LIKE '%"+ searchText +"%' order by prd desc;"); // 모든 상품번호(또는 검색한 상품정보)를 가져오는 sql문        
    %>
<div style="width:900px">   <%--바깥 공간--%>
    <%if(searchText.equals("")) out.println("<h1>전체 조회</h1>"); else out.println("<h1> 상품번호 "+searchText+" 조회</h1>");%>    <!--경우에 따른 제목 변경-->
    <%@ include file="product_search.jsp" %>    <%--조회 추가--%>
    <br>    <%--여유 공간 만들기--%>
    <div>   <%--1번 안쪽 공간--%>
    <table cellspacing=3 border=1> <!--공지 리스트-->    
        <tr>    <!--1행-->
            <th style="text-align : center;width:100px;">상품번호</th>   <!--1열-->
            <th width="100px">상품명</th>   <!--2열-->
            <th style="text-align : center;width:100px;">현재 재고수</th>   <!--3열-->
            <th style="text-align : center;width:100px;">재고파악일</th>    <!--4열-->
            <th style="text-align : center;width:100px;">상품등록일</th>    <!--5열-->
        </tr>   <!--1행 끝-->
    <%  
            while(rset.next()){ // 가져온 모든 정보들에 대하여
                LineCnt++; // 다음 줄 번호    
                if(LineCnt <= fromPT) continue; // 시작번호보다 아래인 경우 패스
                if(LineCnt > fromPT+cntPT) continue;    // 출력할 번호를 넘어간 경우 패스
                String key=rset.getString(1); // 번호
                String name = rset.getString(2);    // 이름
                int cnt = rset.getInt(3);   // 재고
                String prd = rset.getString(4); // 재고파악일
                String srd = rset.getString(5); // 상품등록일
    %>        
        <form method="post">    <!--폼 시작, post-->
        <tr>    <!--행 시작-->       
            <td style="text-align : center;width:100px;"><a href="./product_view.jsp?key=<%=key%>"><%=key%></a></td>    <!--1열, 상품번호-->
            <td style="text-align : center;width:100px;"><a href="./product_view.jsp?key=<%=key%>"><%=name%></a></td>   <!--2열, 상품명-->
            <td style="text-align : center;width:100px;"><%=cnt%></td>  <!--3열, 재고-->
            <td style="text-align : center;width:100px;"><%=srd%></td>  <!--4열, 재고파악일-->
            <td style="text-align : center;width:100px;"><%=prd%></td>  <!--5열, 상품등록일-->
        </tr>   <!--행 종료-->
        </form> <!--폼 종료-->
    <%
        }   // 반복문 종료           
     %>
        </table>    <!--테이블 종료-->
        </div>  <%--1번 안쪽 공간 종료--%>
	<%
		    rset.close();   // ResultSet 닫기
		    stmt.close();   // Statement 닫기
		    conn.close();   // Connection 닫기
     
    } catch(Exception e){   // 에러가 발생한 경우
		out.println(e); // 에러 메시지 출력
	}
	%>
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
    <a href="product_list.jsp?from=0&cnt=<%=cntPT%>&searchText=<%=searchText%>">&lt;&lt;</a>   <%--첫페이지(<<)--%>
    <%
        }   // (<<) 출력 조건 종료
    %>
    <%
        if(current>block){  // 현재페이지가 맨앞 페이지가 아닌 경우
    %>
    <a href="product_list.jsp?from=<%=left%>&cnt=<%=cntPT%>&searchText=<%=searchText%>">&lt;</a>   <%--이전(<)--%>

    <%  
        }      // (<) 출력 조건 종료
        for(int pagenum=startpage;pagenum<=endpage;pagenum++){  // 출력할 페이지 앞번호부터 뒷번호까지 반복
            if(pagenum>maxpage) break; // 최대페이지를 넘긴 경우가 존재하면, 그 즉시 반복문 종료
            int pagefrom=(pagenum-1)*cntPT; // 해당 페이지의 from값
    %>
        <a href="product_list.jsp?from=<%=pagefrom%>&cnt=<%=cntPT%>&searchText=<%=searchText%>"><%=pagenum%></a>   <%--페이지 번호와 그에 해당하는 값들을 인자로 하이퍼링크--%>
    <%  }   // 페이지 출력 반복문 종료
        if(maxstartpage>current){    // 맨뒤 페이지인 경우
    %>
    <a href="product_list.jsp?from=<%=right%>&cnt=<%=cntPT%>&searchText=<%=searchText%>">&gt;</a>   <%--다음(>)--%>
    <%  }   // (>) 출력 조건 종료
        if(maxstartpage>current){    // 맨뒤 페이지인 경우
    %>
    <a href="product_list.jsp?from=<%=lastfrom%>&cnt=<%=cntPT%>&searchText=<%=searchText%>">&gt;&gt;</a>   <%--마지막페이지(>>)--%>
    <%  }   // (>>) 출력 조건 종료
    %>
    </div>  <%--2번 안쪽 공간 종료--%>
    <div style="text-align: right;">    <%--3번 안쪽 공간, 오른쪽 정렬--%>
        <input type="button" value="신규등록" onclick="window.location.href = './product_insert.jsp'">  <%--신규 등록 버튼--%>
    </div>  <%--3번 안쪽 공간 종료--%>
</div>  <%--바깥 공간 종료--%>
</body>	<!--본문 끝-->

</html>	<!--HTML의 끝-->