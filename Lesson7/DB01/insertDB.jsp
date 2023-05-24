<%--examtable 삭제--%>
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
	<title>db삭제</title>	<!--제목-->
</head>	<!--머리말 끝-->
<body>	<!--본문-->
<%
    String name = request.getParameter("name"); // 이름 인자 받아오기
    String id="";   // 학번는 빈칸으로 초기화
    String kor = request.getParameter("korean"); // 국어 성적 인자 받아오기
    String eng = request.getParameter("english"); // 영어 성적 인자 받아오기
    String mat = request.getParameter("math"); // 수학 성적 인자 받아오기
  
    if(name.equals("")||kor.equals("")||eng.equals("")||mat.equals("")){    // 비어있는 칸이 존재하는 경우
        PrintWriter script = response.getWriter();  // PrintWriter 객체 생성
        script.println("<script>");
        script.println("alert('빈칸을 확인해 주세요')");    // 알림창 내용
        script.println("history.back()");   // 뒤로 돌아가기
        script.println("</script>");
    } else {

        try{    
            Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	        Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
            ResultSet rset = stmt.executeQuery("select max(id) from examtable;");   // 가장 큰 학번을 찾아
            while(rset.next()){
                id=Integer.toString(rset.getInt(1)+1);  // 해당 학번보다 1만큼 더 큰 학번으로 한다
            }

	        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO examtable VALUES (?,?,?,?,?)");    // 데이터 삽입하는 sql문
			pstmt.setString(1, name);   // 이름
			pstmt.setInt(2, Integer.parseInt(id));  // 학번 
			pstmt.setInt(3, Integer.parseInt(kor)); // 국어 성적
			pstmt.setInt(4, Integer.parseInt(eng)); // 영어 성적
			pstmt.setInt(5, Integer.parseInt(mat)); // 수학 성적
			
			pstmt.executeUpdate();  // sql문 실행

            out.println("<h1>성적입력추가완료</h1>");   // 성공 시
            pstmt.close();   // Statement 닫기
            conn.close();   // Connection 닫기
        
%>
    <div style="display: inline-block; width: 700px;">   <!--바깥쪽 공간 지정-->
    <form method="post" action="inputForm1.html">   <!--뒤로가기 위한 폼 생성-->
    <div style="text-align: right;"><input type="submit" value="뒤로가기"></div>  <!--뒤로가기 버튼-->
    </form> <!--폼 종료-->
    <table> <!--테이블 생성-->
            <tr>    <!--1행-->
                <td>이름</td>   <!--1열-->          
                <td><%=name%></td>  <!--2열--> 
            </tr>
            <tr>    <!--2행-->
                <td>학번</td>   <!--1열-->                
                <td><%=id%></td>    <!--2열--> 
            </tr>
            <tr>    <!--3행-->
                <td>국어</td>   <!--1열-->                 
                <td><%=kor%></td>   <!--2열--> 
            </tr>
            <tr>    <!--4행-->
                <td>영어</td>   <!--1열-->                 
                <td><%=eng%></td>   <!--2열--> 
            </tr>
            <tr>    <!--5행-->
                <td>수학</td>   <!--1열-->                 
                <td><%=mat%></td>   <!--2열--> 
            </tr>
        </table>    <!--테이블 종료-->
    </div>  <!--바깥쪽 공간 지정 종료-->
<%
        } catch(Exception e){   // 에러가 생겼으면
            out.println("<h1>데이터 추가 실패</h1>");   // 에러 출력
        }
    }
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->