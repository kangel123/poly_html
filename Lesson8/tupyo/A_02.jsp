<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.ArrayList"%> <%--import--%>
<% request.setCharacterEncoding("UTF-8"); %>    <!--인자 값 한글 인코딩-->
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
		<td width=100 bgcolor=yellow><a href="./A_01.jsp" target="main"><h2>후보등록</h2></a>   <!--1번, 현재 메뉴-->
        <td width=100><a href="./B_01.jsp" target="main"><h2>투표</h2></a>  <!--2번-->
        <td width=100><a href="./C_01.jsp" target="main"><h2>개표결과</h2></a>  <!--3번-->
	</tr>   <!--1행 끝-->
</table>    <!--메뉴창 끝-->
<br>    <!--메뉴와의 공간을 띄움-->
<%
    int kiho = Integer.parseInt(request.getParameter("kiho"));  // 기호를 받아와 숫자형으로 저장
    try{
	    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
        ResultSet rset = stmt.executeQuery("select * from tupyo where kiho="+kiho+";"); // 포린키 여부 파악하기 위한 sql문
        if(rset.next()){    // 투표 정보가 존재하는 후보이면, 즉 포링키
%>
            <script>
            var result = confirm('해당 후보를 투표한 정보가 존재합니다. 삭제를 진행하시겠습니까?'); // 사용자에게 확인 메시지 표시
        
            if (result) { // 확인을 선택한 경우
            <%
                stmt.executeUpdate("delete from tupyo where kiho="+kiho+";");    // 투표정보의 삭제하는 sql문                
                stmt.executeUpdate("delete from hubo where kiho="+kiho+";");    // 해당 기호를 삭제하는 sql문               
            %>
            } else {    // 취소를 선택한 경우
                alert('삭제를 취소했습니다.');  // 취소 시 메시지 표시 후
                history.go(-1);  // 뒤로 돌아가기
            }
            </script>
<%            
        } else{ // 투표 정보가 없는 후보이면
            stmt.executeUpdate("delete from hubo where kiho="+kiho+";");    // 해당 기호를 삭제하는 sql문            
        }
        out.println("<h2>후보등록 결과 : 후보 삭제를 성공하였습니다.</h2>");    // 삭제 성공 시 메시지 출력

        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){
        out.println("<h2>후보등록 결과 : 후보 삭제를 실패하였습니다.</h2>");    // 삭제 성공 시 메시지 출력
    }
%>

</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->