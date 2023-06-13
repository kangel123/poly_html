<!--데이터 조회-->
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
    try{
        String name=""; // 이름 초기화
        String id=request.getParameter("id");   // 학번을 인자로 받아옴
        String kor="";  // 국어 성적 초기화
        String eng="";  // 영어 성적 초기화
        String mat="";  // 수학 성적 초기화
        if(!id.equals("")){ // 학번을 입력한 경우
            Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	        Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
            ResultSet rset = stmt.executeQuery("select * from examtable where id="+id+";"); // 해당 학번을 찾는 sql문
            while(rset.next()){ // 반복문
                name=rset.getString(1); // 이름
                id=Integer.toString(rset.getInt(2));    // 학번
                kor=Integer.toString(rset.getInt(3));   // 국어
                eng=Integer.toString(rset.getInt(4));   // 영어
                mat=Integer.toString(rset.getInt(5));   // 수학
            }   // 반복문 종료
        }   // if문 종료

        if(name.equals("")){    // 이름이 비어있으면
            name="해당학번없음";    // 이름 지정
            id="";  // 학번은 빈칸
        }
%>

    <div style="display: inline-block; width: 700px;">   <!--바깥쪽 공간 지정-->
    <h1>성적조회 후 정정 / 삭제</h1>    <!--제목-->
    <form method="post" action="showREC.jsp">    <!--입력한 내용 보낼 곳-->
        <div>   <!--안쪽 공간 지정-->
        조회할 학번 <input type="text" name="id">   <!--조회할 학번 입력하는 창-->
        <input type="submit" value="조회">  <!--전송 버튼-->
        </div>  <!--안쪽 공간 지정 끝--> 
    </form> <!--폼 종료-->
    <br>    <!--테이블과의 공간 만들기-->
    <form method="post">    <!--폼형식:post-->
        <table> <!--테이블 생성-->
            <tr>    <!--1행-->
                <td>이름</td>   <!--1열-->
                <td><input type="text" value="<%=name%>" name="name"/></td> <!--2열, 수정 가능-->
            </tr>
            <tr>    <!--2행-->
                <td>학번</td>   <!--1열-->              
                <td><input type="text" value="<%=id%>" name="id" readonly/></td>    <!--2열, 수정 불가-->
            </tr>
            <tr>    <!--3행-->
                <td>국어</td>   <!--1열-->              
                <td><input type="text" value="<%=kor%>" name="korean"/></td>    <!--2열, 수정 가능-->
            </tr>
            <tr>    <!--4행-->
                <td>영어</td>   <!--1열-->             
                <td><input type="text" value="<%=eng%>" name="english"/></td>   <!--2열, 수정 가능-->
            </tr>
            <tr>    <!--5행-->
                <td>수학</td>   <!--1열-->              
                <td><input type="text" value="<%=mat%>" name="math"/></td>  <!--2열, 수정 가능-->
            </tr>
        </table>    <!--테이블 끝-->
        
<%
        if(!id.equals("")){ // id가 비어있으면
%>
        <div style="text-align: right;">    <!--안쪽 공간 지정, 오른쪽 정렬-->
            <input type="submit" value="수정" formaction="./updateDB.jsp"/> <!--수정 버튼-->
            <input type="submit" value="삭제" formaction="./deleteDB.jsp"/> <!--삭제 버튼-->
        </div>  <!--안쪽 공간 지정 끝-->
    </form>  <!--폼 종료-->
    </div>  <!--바깥쪽 공간 지정 끝-->
<% 
        }   // if문 종료
    }catch(Exception e){    // 에러가 있으면
        out.println("조회 실패");   // 에러 메시지 출력
    }
%>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->