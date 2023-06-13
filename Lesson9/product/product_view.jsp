<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat"%> <%--import--%>
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
    String name=""; // 이름 초기화
    int cnt=0;  // 재고 초기화
    String prd=""; // 상품등록일자 초기화
    String srd="";  // 재고등록일자 초기화
    String content="";  // 내용 초기화
    String photo="";    // 사진 초기화

    String key="-1";    // key값 초기화, 상품번호가 -1이 존재해도 해당 상품정보를 db에서 가져오므로 상관없다 
    if(!request.getParameter("key").equals("")){    // 전달받은 key 인자값이 있으면
        key=request.getParameter("key");    // 해당 인자값 저장
    }

    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
    
           
	ResultSet rset = stmt.executeQuery("select * from product where id='"+key+"';"); // 해당 상품 정보를 가져오는 sql문
    if(rset.next()) {   // 존재하면
        name = rset.getString(2);   // 이름 저장
        cnt = rset.getInt(3);   // 재고 저장
        prd = rset.getString(4);    // 상품등록일자 저장
        srd = rset.getString(5);    // 재고등록일자 저장
        content = rset.getString(6);    // 내용 저장
        photo = rset.getString(7);  // 사진 저장
    }
        
    if(name.equals("")){    // 이름이 없다==해당 상품이 없다
        out.println("<script>");    // 스크립트 사용
        out.println("alert('존재하지 않은 상품번호입니다.');"); // 알림창으로 에러 메시지 출력 후
        out.println(" location.href = 'product_list.jsp';");    // 상품 리스트로 이동
        out.println("</script>");   // 스크립트 사용 종료
    } 
%>
<div style="width:900px">   <!--바깥 공간 시작-->
    <h1>상세 조회</h1>
    <div>   <!--안쪽 공간 시작-->
    <table cellspacing=3 border=1> <!--신규 공지-->    
        <tr>    <!--1행-->
            <th style="width:100px;">번호</th>   <!--1열-->
            <td style="width:800px;"><%=key%></td> <!--2열-->
         </tr>   <!--1행 끝-->
        <tr>    <!--2행-->   
            <th style="width:100px;">상품명</th>   <!--1열-->
            <td style="width:800px;"><%=name%></td> <!--2열-->    
        </tr>   <!--2행 종료-->
        <tr>    <!--3행-->   
            <th style="width:100px;">재고 현황</th>   <!--1열-->
            <td style="width:800px;"><%=cnt%></td> <!--2열-->    
        </tr>   <!--3행 종료-->
          <tr>    <!--4행-->   
            <th style="width:100px;">상품등록일자</th>   <!--1열-->
            <td style="width:800px;"><%=prd%></td>   <!--2열-->    
        </tr>   <!--4행 종료-->
          <tr>    <!--5행-->   
            <th style="width:100px;">재고등록일자</th>   <!--1열-->
            <td style="width:800px;"><%=srd%></td>   <!--2열-->    
        </tr>   <!--5행 종료-->
        <tr>    <!--6행-->   
            <th style="width:100px;">내용</th>   <!--1열-->
            <td style="width:800px;"><%=content%></td>   <!--2열-->
        </tr>   <!--6행 종료-->
        <tr>    <!--7행-->   
            <th style="width:100px;">상품사진</th>   <!--1열-->
            <td style="width:800px;"><image src="./image/<%=photo%>"></td>  <!--2열-->
        </tr>   <!--7행 종료-->   
    </table>    <!--테이블 종료-->
    </div>  <!--안쪽 공간 끝-->
	
    <div style="text-align: right;">    <!--안쪽 공간 시작, 오른쪽 정렬-->
        <input type="button" value="상품 삭제" onclick="window.location.href = './product_delete.jsp?key=<%=key%>'">    <!--삭제 버튼-->
        <input type="button" value="재고 수정 " onclick="window.location.href = './product_update.jsp?key=<%=key%>'">   <!--수정 버튼-->
     </div> <!--안쪽 공간 끝-->
</div>  <!--바깥 공간 끝-->
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->