<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.ArrayList,java.util.HashMap"%> <%--import--%>
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
    text-align : center;    /*글자 정렬*/
}

td{
	width : 10%;    /*넓이*/
}

a{
    display: block; /*유형 block*/
    text-align: center; /*글자 가운데 정렬*/ 
    text-decoration-line: none;	/*밑줄 제거*/
    font-weight: bold;  /*폰트 볼드체*/
    padding: 10px;  /*패딩*/
}
</style>
<body>	<!--본문-->
<table> <!--테이블 생성, 메뉴창-->
	<tr>    <!--메뉴는 1행으로 구성-->
		<td width=100><a href="./A_01.jsp" target="main"><h2>후보등록</h2></a>   <!--1번-->
        <td width=100><a href="./B_01.jsp" target="main"><h2>투표</h2></a>  <!--2번-->
        <td width=100  bgcolor=yellow><a href="./C_01.jsp" target="main"><h2>개표결과</h2></a>  <!--3번, 현재 메뉴-->
	</tr>   <!--1행 끝-->
</table>    <!--메뉴창 끝-->
<br>    <!--메뉴와의 공간을 띄움-->

<%
    int kiho = Integer.parseInt(request.getParameter("kiho")); // 출력할 후보의 기호
    String name=request.getParameter("name");;    // 출력할 후보의 이름
    
%>
<div style="width: 900px;"> <!--바깥 공간은 900px로 지정-->
    <div>   <!--왼쪽 공간-->
            <h2><%=kiho%>.<%=name%> 후보의 득표성향 분석</h2>  <!--제목-->
    </div>  <!--왼쪽 공간 종료-->

<table cellspacing=3 border=1>  <!--테이블 생성-->
    <tr>    <!--1행-->
        <th style="width:20%;">연령대</th>  <!--1열-->
        <th style="width:80%;">득표율</th>  <!--2열-->
    </tr>   <!--1행 종료-->
<%
    try{
    	Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        ResultSet  rset = stmt.executeQuery("select age, count(*), count(*)/(select count(*) from tupyo where kiho="+kiho+")*100 "+ 
                    "from tupyo where kiho="+kiho+" group by age order by age;");    // 해당 후보를 투표한 연령대와 득표수와 득점율을 가져옴
                                      
        Integer age=1;  // 연령대 초기화
        HashMap<Integer, double[]> map = new HashMap<>();    // 해당 연령대가 없는 경우를 위해 HashMap을 사용함
        while(rset.next()){ // db에서 가져온 모든 정보를
            map.put(rset.getInt(1), new double[]{rset.getInt(2),rset.getDouble(3)});    // HashMap에 넣음
        }
        
        while(age<10){  // 해당 연령대가 없는 경우를 위해 1부터 9까지
            map.put(age, map.getOrDefault(age, new double[]{0,0})); // 해당 연령대의 정보가 있으면 그대로 없으면 0으로 초기화
            age++;  // 다음 연령대
        }

        for(Integer a : map.keySet()){  // 모든 연령대에 대하여
            int num = Double.valueOf(map.get(a)[0]).intValue(); // 득표수는 숫자형으로 변환                  
            double average = Math.round(map.get(a)[1]*100)/100.0; // 득표율은 가져와서 소수점 2자리까지만 출력
%>          
    <tr>    <!--2행부터 10행까지-->
        <td style="width:20%;"><%=a*10%>대</td> <!--1열, 연령대-->  
        <td style="width:80%;"><p align=left><img src="./bar.jpg" width=<%=average*6%> height=20> <%=num%>(%<%=average%>)</p></td>  <!--2열, 득점수,득점율-->  
    </tr>   <!--행 종료-->
<%        
        }   // 반복문 종료
%>      
</table>    <!--테이블 종료-->

</div>  <!--바깥 공간 종료-->
<%
        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 발생한경우
        out.println(e); // 에러메시지 출력
    }
%>

</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->