<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat"%> <%--import--%>
<% request.setCharacterEncoding("UTF-8"); %>

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
    <meta charset="UTF-8">  <!--한글 인코딩-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
</head>	<!--머리말 끝-->
<style>
table{  /*테이블*/
    width: 900px;   /*넓이*/
    border : 1px solid black;   /*테두리*/
}
</style>
<body>	<!--본문-->   
<%
    String key="-1";    // key값 초기화, 번호는 자동부여이므로 음수일 수는 없으니 인자값이 없는 경우 자동 에러가 된다
    if(!request.getParameter("key").equals("")){    // 전달받은 key 인자값이 있으면
        key=request.getParameter("key");    // 해당 인자값 저장
    }    
    
    String title="";    // 제목 초기화
    String date=""; // 날짜 초기화
    String content="";  // 내용 초기화
    String rootid="";   // 루트id 초기화
    String relevel="";  // 레벨 초기화
    String recnt="";    // 순서 초기화
    String viewcnt="";  // 조회수 초기화

    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	ResultSet rset = stmt.executeQuery("select * from gongji2 where id='"+key+"';"); // 해당 공지를 가져오는 sql문
    if(rset.next()) { // 존재하면
        title=rset.getString(2);    // 제목 저장
        date=rset.getString(3); // 날짜 저장
        content=rset.getString(4);  // 내용 저장
        rootid = rset.getString(5); // 루트id 저장
        relevel = rset.getString(6);    // 레벨 저장
        recnt = rset.getString(7);  // 순서 저장
        viewcnt = rset.getString(8);    // 조회수 저장        
    }

    if(viewcnt.equals("")){ // 비어있는 경우==존재하지 않는 게시물
        out.println("<script>");    // 스크립트 사용
        out.println("alert('존재하지 않은 게시물입니다.');");   // 에러메시지 출력
        out.println(" location.href = 'gongji_list.jsp';"); // 공지 리스트로 이동
        out.println("</script>");   // 스크립트 종료
    } else if(Integer.parseInt(viewcnt)==-1){   // 조회수가 -1인 경우==삭제된 댓글
        out.println("<script>");    // 스크립트 사용
        out.println("alert('해당 댓글은 삭제된 댓글입니다.');");    // 에러메시지 출력
        out.println(" location.href = 'gongji_list.jsp';"); // 공지 리스트로 이동
        out.println("</script>");   // 스크립트 종료
    }
%>
<form method="post" id="inputForm">    <!--폼 시작, post-->
<div style="width:900px">   <!--바깥쪽 공간-->
    <h1> 내용 수정하기</h1>
    <div>   <!--안쪽 공간-->
    <table cellspacing=3 border=1> <!--테이블 시작-->    
        <tr>    <!--1행-->
            <th style="width:100px;">번호</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><input style="border: none; pointer-events: none;" type="text" name="key" value="<%=key%>" tabindex="-1" readonly ></td>  <!--2열--> 
         </tr>   <!--1행 끝-->
        <tr>    <!--2행-->   
            <th style="width:100px;">제목</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><input type="text" name="title" id="title" value="<%=title%>" maxlength=70>    <!--2열--> 
            </td>    
        </tr>   <!--2행 종료-->
        <tr>    <!--3행-->   
            <th style="width:100px;">일자</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><input style="border: none; pointer-events: none;" type="text" name="date" value="<%=date%>" tabindex="-1" readonly ></td>     <!--2열-->    
        </tr>   <!--3행 종료-->
        <tr>    <!--4행-->   
            <th style="width:100px;">내용</th>   <!--1열-->
            <td style="width:800px;" colspan="3">
                <textarea name="content" id="content" cols="100" rows="20" style="overflow: auto; resize: none;" ><%=content%></textarea>   <!--2열--> 
            </td>
        </tr>   <!--4행 종료-->
         <tr>    <!--5행-->   
            <th style="width:100px;">원글</th>   <!--1열-->
            <td style="width:350px;"><input style="border: none; pointer-events: none;" type="number" name="rootid" value="<%=rootid%>" tabindex="-1" readonly ></td> <!--2열, 원글-->
            <th style="width:100px;">조회수</th>   <!--1열-->
            <td style="width:350px;"><input style="border: none; pointer-events: none;" type="number" name="viewcnt" value="<%=viewcnt%>" tabindex="-1" readonly ></td> <!--2열, 원글-->
        </tr>   <!--5행 종료-->     
         <tr>    <!--6행-->   
            <th style="width:100px;">댓글 수준</th>   <!--1열-->
            <td style="width:350px;"><input style="border: none; pointer-events: none;" type="number" name="relevel" value="<%=relevel%>" tabindex="-1" readonly ></td> <!--2열, 원글-->
            <th style="width:100px;">댓글내 순서</th>   <!--1열-->
            <td style="width:350px;"><input style="border: none; pointer-events: none;" type="number" name="recnt" value="<%=recnt%>" tabindex="-1" readonly ></td> <!--2열, 원글-->
        </tr>   <!--6행 종료-->  
    </table>    <!--테이블 종료-->
    </div>  <!--안쪽 공간 끝-->
	
    <div style="text-align: right;">    <!--안쪽 공간-->
        <input type="reset" value="취소" onclick="window.location.href = './gongji_list.jsp'">  <!--취소 시 공지리스트로 이동-->
        <input type="submit" value="쓰기" id="submitButton">    <!--변경된 내용 확인 후 db에 내용 수정-->
    </div>  <!--안쪽 공간 끝-->
</div>  <!--바깥쪽 공간-->
</form> <!--폼 종료-->
</body>	<!--본문 끝-->
<script>
    var errors = {   // 에러를 묶어놓음
        title: false,  // 처음 제목 에러X
        content: false  // 처음 내용 에러X
    };

    function checkString(e) { // 제목과 내용 에러를 확인하는 함수
        var inputTitle = document.getElementById("title").value;  // 제목 필드의 내용을 가져옴
        var inputContent = document.getElementById("content").value;  // 이름 필드의 내용을 가져옴   

        if(inputTitle.trim() === "" && inputContent.trim() === ""){
            alert("제목과 내용을 입력하시오");
            errors.title = true;  // 에러O    
            errors.content = true;  // 에러X O  
        } else if (inputTitle.trim() === "") {  // 빈칸인 경우
            alert("제목을 입력하시오");
            errors.title = true;  // 에러O    
            errors.content = false;  // 에러X    
        } else if (inputContent.trim() === "") {  // 빈칸인 경우
            alert("내용을 입력하시오");
            errors.title = false;  // 에러X    
            errors.content = true;  // 에러O    
        } else {    // 그 외는 성공한 경우 
            errors.title = false;  // 에러X  
            errors.content = false;  // 에러X   
        }   
    }

    function updateSubmitButtonState() {    // 버튼 활성 여부 함수
        checkString();
        if(errors.title||errors.content){    // 에러가 있으면      
            submitButton.addEventListener("click", handleClick);    // 버튼에 클릭 이벤트 추가(클릭 시 추가 불가능)
        }else{    // 에러가 없는 경우
            submitButton.removeEventListener("click", handleClick); // 기존에 있던 버튼 클릭 이벤트 제거(클릭 시 추가 가능)
            const form = document.getElementById("inputForm"); // 폼의 ID를 지정하여 해당 폼 요소 가져옴
            form.action = "./gongji_write.jsp"; // 폼의 주소를 설정함
            form.submit();  // 넘어감
        }
    }

    function handleClick(e) {   // 버튼 클릭에 대한 함수
        e.preventDefault(); // 기본 클릭 동작 막기
    }

    window.addEventListener("load", document.getElementById("submitButton").addEventListener("click", handleClick));   // 최초 실행 시의 버튼 클릭을 막는 이벤트 실행        
    document.getElementById("submitButton").addEventListener("click", updateSubmitButtonState);   // 제출 여부를 판단

</script>
</html>	<!--HTML의 끝-->