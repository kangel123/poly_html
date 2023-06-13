<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.io.*,java.util.ArrayList"%>
<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
        <meta charset="UTF-8">  <!--한글 인코딩-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
	<title>wifi</title>	<!--제목-->
    <style>
    table, th, td{  /*테이블에 대한 속성*/
        border : 1px solid; /*테두리*/
        text-align : center;    /*글자 : 가운데 정렬*/
    }
    .outer-div {    /*바깥쪽 div에 대한 속성*/
        width : 850px;  /*넓이 지정*/
    }

    .inner-div {    /*안쪽 div에 대한 속성*/
        text-align:center   /*글자 : 가운데 정렬*/
    }
    </style>

</head>	<!--머리말 끝-->
<body>	<!--본문-->
    <%   
        String filePath = "/var/lib/tomcat9/webapps/ROOT/Lesson5/wifi/전국무료와이파이표준데이터1.txt"; // 파일 이름
        
        File f = new File(filePath); // 파일 객체 생성
        BufferedReader br = new BufferedReader(new FileReader(f)); // 버퍼로 내용을 읽는 BufferedReader의 객체 생성            
    try{
        String readtxt; // 한 줄씩 내용을 저장하기 위한 용도    
        if ((readtxt = br.readLine()) == null) { // 필드명이 없는 경우
		    out.println("빈 파일입니다<br>"); // 빈 파일 메시지
	    } else{ // 빈 파일이 아닌 경우
            int fromPT = 0; // 시작 번호,0으로 초기화
            int cntPT = 10; // 출력할 개수
            try{    // 받은 인자에 대한 try-catch문
                fromPT=Integer.parseInt(request.getParameter("from"));  // 시작번호 변경
                cntPT=Integer.parseInt(request.getParameter("cnt"));    // 출력할 개수 변경
            }catch(Exception e){    // 없어도 에러처리 없이 넘어감
            }
            
            String[] field_name = readtxt.split("\t"); // 필드명을 배열로 저장

            ArrayList<String[]>  arrField = new ArrayList<>();   // 어레이 리스트 생성
            int totalLine=0;    // 총 개수
            while ((readtxt = br.readLine()) != null) { // readLine()을 사용해 한줄 단위로 readtxt에 저장      
                String[] field = readtxt.split("\t"); // 내용을 배열로 저장   	        	
                arrField.add(field);    // 어레이리스트에 넣기
                totalLine++;    // 개수 증가
            }
            if(cntPT<=0){   // 출력할 개수가 0보다 작거나 같은 경우
                cntPT = 10; // 디폴트 값으로 10 설정
            }
            if(fromPT<0){   // 출력할 번호가 0보다 작거나 같은 경우
                fromPT = 0; // 첫번째 페이지로 설정
            }else if(fromPT>=totalLine){    // 출력할 번호가 초과된 경우
                fromPT = (totalLine-1)/cntPT*cntPT; // 마지막 페이지로 설정
            } else{ // 그외의 경우
                fromPT = fromPT/cntPT*cntPT;    // 해당 번호에 해당하는 테이블 내용이 되도록 설정)
                                                // ex) from=19, cnt=20 =>from=0,cnt=20 (from은 0부터 시작이므로)
            }
            int current=(fromPT/cntPT)+1;   // 현재 페이지
            
    %>
    <div class="outer-div"> <%--전체를 하나의 공간으로 묶음--%>
    <h1>와이파이</h1>   <%--제목--%>
    현재 페이지 : <%=current%> <%--현재 페이지 출력--%>
    
    <table> <%--테이블 생성--%>
        <tr>    <%--테이블 내 헤더부분--%>
            <th width="50px">번호</th>  <%--1행--%>
            <th width="400px">주소</th> <%--2행--%>
            <th width="100px">위도</th> <%--3행--%>
            <th width="100px">경도</th> <%--4행--%>
            <th width="100px">거리</th> <%--5행--%>
        </tr>
        <%              
            // 한국폴리텍대학 분당융합기술교육원    
	        double lat = 37.385796; // 위도
	        double lng = 127.121292; // 경도
	        int LineCnt = 0; // 번호	   
            while(LineCnt<totalLine) { // readLine()을 사용해 한줄 단위로 readtxt에 저장      
                LineCnt++; // 다음 줄 번호    		         
                if(LineCnt <= fromPT) continue; // 시작번호보다 아래인 경우 패스
                if(LineCnt > fromPT+cntPT) continue;    // 출력할 번호를 넘어간 경우 패스
                double dist = Math.sqrt(Math.pow(Double.parseDouble(arrField.get(LineCnt-1)[12]) - lat, 2) + Math.pow(Double.parseDouble(arrField.get(LineCnt-1)[13]) - lng, 2)); // 거리 구하기			                    
        %>
        <tr>    <%--테이블 내 body부분--%>
            <td><%=LineCnt%></td>   <%--번호--%>
            <td><%=arrField.get(LineCnt-1)[9]%></td>  <%--주소--%>
            <td><%=arrField.get(LineCnt-1)[12]%></td> <%--위도--%>
            <td><%=arrField.get(LineCnt-1)[13]%></td> <%--경도--%>
            <td><%=dist%></td>  <%--거리--%>
        </tr>
        <% 
            }   // 반복문 종료   
    %>
    </table>    <%--테이블 종료--%>

    <div class="inner-div"> <%--다른 페이지 정보를 안쪽 공간으로 묶음--%>

    <% 
        int block = 10; // 총 출력할 개수
    
        int maxpage = (int) Math.ceil((double) LineCnt / cntPT);    // 최대 페이지
        int lastfrom = (maxpage-1)*cntPT;   // 마지막 페이지 from

        int startpage=((current-1)/block)*block+1;  // 출력할 번호의 첫번째 번호
        int endpage=startpage+block-1;  // 출력할 번호의 끝
        int maxstartpage=(maxpage-1)/block*block+1; // 마지막 페이지가 있는 block의 시작 위치

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
        if(current>block){  // 맨앞 페이지인 경우
    %>
    <a href="wifi.jsp?from=0&cnt=<%=cntPT%>">&lt;&lt;</a>   <%--첫페이지(<<)--%>
    <%
        }
    %>
    <%
        if(current>block){   // 맨앞 페이지인 경우
    %>
    <a href="wifi.jsp?from=<%=left%>&cnt=<%=cntPT%>">&lt;</a>   <%--이전(<)--%>

    <%  
        }      
        for(int pagenum=startpage;pagenum<=endpage;pagenum++){  // 출력해야된 페이지 수만큼
            if(pagenum>maxpage) break; // 최대페이지를 넘긴 경우 반복문 종료
            int pagefrom=(pagenum-1)*cntPT; // 해당 페이지의 from값
            if(current==pagenum){   // 현재페이지이면
    %>
                <a href="wifi.jsp?from=<%=pagefrom%>&cnt=<%=cntPT%>" style="color:red; font-weight: bold;"><%=pagenum%></a>   <%--변경된 색깔의 페이지 번호와 그에 해당하는 값들을 인자로 하이퍼링크--%>
    <%      
            } else {    // 그 외의 페이지인 경우
    %>            
                <a href="wifi.jsp?from=<%=pagefrom%>&cnt=<%=cntPT%>"><%=pagenum%></a>   <%--페이지 번호와 그에 해당하는 값들을 인자로 하이퍼링크--%>
    <%      
            }   //if-else문 종료
        }   //반복문 종료
        if(maxstartpage>current){    // 맨뒤 페이지인 경우
    %>
    <a href="wifi.jsp?from=<%=right%>&cnt=<%=cntPT%>">&gt;</a>   <%--다음(>)--%>
    <%  }
        if(maxstartpage>current){    // 맨뒤 페이지인 경우
    %>
    <a href="wifi.jsp?from=<%=lastfrom%>&cnt=<%=cntPT%>">&gt;&gt;</a>   <%--마지막페이지(>>)--%>
    <%  }
    %>
    </div>  <%--안쪽 공간 종료--%>    
    </div>  <%--바깥쪽 공간 종료--%>
    <%
        }   // else문 종료
    }catch(Exception e){    // try중 에러가 발생하면
        out.println("에러메시지:"+e);   // 에러메시지 출력
    } finally{  // 최종적으로
        br.close(); // 파일 닫기
    } 
    %>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->