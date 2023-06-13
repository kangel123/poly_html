
<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*, java.util.ArrayList, java.util.Collections"%> <%--import--%>
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

    
	try{    
		Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
		Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
		ResultSet rset = stmt.executeQuery("select * from examtable;"); // 모든 학생의 정보를 가져오는 sql문
		ArrayList<Integer> arr_id = new ArrayList<>();  // 학번만 어레이리스트로 저장하기 위한 객체생성
		while(rset.next()){ // 모든 학생에 대하여
			arr_id.add(rset.getInt(2));     // 학번만 저장
		}
		int min=Collections.min(arr_id);    // 현재는 가장 작은 학번
		int max=Collections.max(arr_id);    // 가장 큰 학번
		while(min<max){ // 모든 학번에 대하여 
			min++;  // 다음 학번
			if(!(arr_id.contains(min))){    // 해당 학번이 존재하지 않은 경우에
			id=Integer.toString(min);   // 해당 학번으로 하기로 결정
			break;  // 반복문 탈출
			}
		}
		if(min==max) id=Integer.toString(max+1);    // 만약에 가장 큰 학번까지 빈 학번이 없는 경우 그 뒤에 학번으로 결정

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
    <div style="display: inline-block; width: 900px;">   <!--바깥쪽 공간 지정-->
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
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->