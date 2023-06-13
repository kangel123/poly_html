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
    Date currentDate = new Date();  // 날짜를 가져옴
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 형식 지정
    String date = dateFormat.format(currentDate);  // 형식에 맞춰 변환
    
    String key="-1";    // key값 초기화, 번호는 자동부여이므로 음수일 수는 없으니 인자값이 없는 경우 자동 에러가 된다
    if(!request.getParameter("key").equals("")){    // 전달받은 key 인자값이 있으면
        key=request.getParameter("key");    // 해당 인자값 저장
    }
    
    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	ResultSet rset = stmt.executeQuery("select rootid, relevel, recnt, viewcnt from gongji2 where id='"+key+"';"); // 해당 부모의 정보를 가져옴
    int prootid=-1; // 부모 루트id 초기화
    int prelevel=-1;  // 부모 레벨 초기화
    int precnt=1;   // 부모 순서 초기화
    int viewcnt=-1; // 조회수 초기화

    if(rset.next()) {   // 있으면
        prootid = rset.getInt(1);   // 부모의 루트id 구하기
        prelevel = rset.getInt(2);  // 부모의 레벨 구하기
        precnt = rset.getInt(3);    // 부모의 순서 구하기
        viewcnt = rset.getInt(4);    // 부모의 조회수 구하기
    }

    if(prelevel==-1){   // 해당 댓글이 없는 경우==댓글을 달 게시물이 없는 경우
        out.println("<script>");    // 스크립트 사용
        out.println("alert('댓글을 쓸 수 있는 게시물이 없는 상태입니다');");    // 에러 메시지 출력
        out.println(" location.href = 'gongji_list.jsp';"); // 공지 리스트로 이동
        out.println("</script>");   // 스크립트 종료
    }  else if(viewcnt==-1){ // 조회수가 음수인 경우==삭제된 댓글
        out.println("<script>");    // 스크립트 사용
        out.println("alert('삭제된 댓글에 댓글을 쓸 수 없습니다.');");  // 에러 메시지 출력
        out.println(" location.href = 'gongji_list.jsp';"); // 공지 리스트로 이동
        out.println("</script>");   // 스크립트 종료
    }

    // 부모 또는 그 위 조상의 형제있는지 알아보기
    int brecnt=Integer.MAX_VALUE;   // 조상의 형제의 순서
    boolean isAncestor=false;    // 조상의 유무(부모까지 포함)
    for(int i=prelevel;i>0;i--){   // 최상위 조상부터 부모까지의 모든 레벨에 대하여
        rset = stmt.executeQuery("select min(recnt) from gongji2 where rootid="+prootid+" and relevel="+i+" and recnt>"+precnt+";");    // 현재 레벨의 작은 recnt값을 가진 조상 구하기
        rset.next();    // 해당 레코드로 이동
        if(rset.getString(1)!=null){    // 조상이 존재하면서
            if(brecnt>rset.getInt(1))   // 더 작은 조상이 존재하면
                brecnt=rset.getInt(1);  // 해당 조상의 형제의 위치 저장
                isAncestor=true;    // 조상 존재함으로 변경
        }
    }
    int rootid=prootid; // 부모와 동일한 조상을 가짐
    int relevel=prelevel+1; // 부모의 다음 레벨로 이동
    int recnt=1;    // 최초의 댓글의 경우로 초기화
    if(!isAncestor){ // 못 찾은 경우, 무한 반복을 돌았던 경우
        rset = stmt.executeQuery("select max(recnt) from gongji2 where rootid="+prootid+" and recnt>="+precnt+" and recnt<"+brecnt+";"); // 현재 부모 밑부터 자신이 갈 수 있는 최대 위치 확인
        rset.next();    // 해당 레코드로 실행
        recnt=rset.getInt(1)+1; // 최대 위치의 다음 위치가 자신이 들어가야하는 위치
    } else{ // 찾았으면
        recnt = brecnt; // 해당 조상의 위치가 자신이 들어가야하는 위치
    }

    
%>
<form method="post" id="inputForm">    <!--폼 시작, post-->
<div style="width:900px">   <!--바깥 공간-->
    <div>   <!--1번째 안쪽 공간-->
    <h1>신규 댓글 등록</h1>
    <table cellspacing=3 border=1> <!--신규 공지-->    
        <tr>    <!--1행-->
            <th style="width:100px;">번호</th>   <!--1열-->
            <td style="width:800px;" colspan="3">댓글(insert)</td>  <!--2열-->
         </tr>   <!--1행 끝-->
        <tr>    <!--2행-->   
            <th style="width:100px;">제목</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><input type="text" name="title" id="title" maxlength=70></td>    <!--2열, 제목-->
        </tr>   <!--2행 종료-->
        <tr>    <!--3행-->   
            <th style="width:100px;">일자</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><input style="border: none; pointer-events: none;" type="text" name="date" value="<%=date%>" tabindex="-1" readonly ></td> <!--2열, 일자-->
        </tr>   <!--3행 종료-->
        <tr>    <!--4행-->   
            <th style="width:100px;">내용</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><textarea name="content" id="content" cols="100" rows="20" style="overflow: auto;resize: none;"></textarea></td>   <!--2열, 내용-->
        </tr>   <!--4행 종료-->   
        <tr>    <!--5행-->   
            <th style="width:100px;">원글</th>   <!--1열-->
            <td style="width:800px;" colspan="3"><input style="border: none; pointer-events: none;" type="number" name="rootid" value="<%=rootid%>" tabindex="-1" readonly ></td> <!--2열, 원글-->
        </tr>   <!--5행 종료-->   
         <tr>    <!--6행-->   
            <th style="width:100px;">댓글 수준</th>   <!--1열-->
            <td style="width:350px;"><input style="border: none; pointer-events: none;" type="number" name="relevel" value="<%=relevel%>" tabindex="-1" readonly ></td> <!--2열, 원글-->
            <th style="width:100px;">댓글내 순서</th>   <!--1열-->
            <td style="width:350px;"><input style="border: none; pointer-events: none;" type="number" name="recnt" value="<%=recnt%>" tabindex="-1" readonly ></td> <!--2열, 원글-->
        </tr>   <!--6행 종료-->   
    </table>    <!--테이블 종료-->
    </div>  <!--1번째 안쪽 공간 끝-->

	<div style="text-align: right;">    <!--2번째 안쪽 공간-->
        <input type="reset" value="취소" onclick="window.location.href = './gongji_list.jsp'">  <!--취소버튼, 목록으로 돌아감-->
        <input type="submit" value="쓰기" id="submitButton">    <!--제출 버튼-->
    </div>  <!--2번째 안쪽 공간 끝-->
</div>  <!--바깥 공간 끝-->
</form> <!--폼 종료-->
</body>	<!--본문 끝-->
<script>
    var errors = {   // 에러를 묶어놓음
        title: true,  // 처음 제목 에러O
        content: true  // 처음 내용 에러O
    };

    function checkString(e) { // 제목과 내용 에러를 확인하는 함수
        var inputTitle = document.getElementById("title").value;  // 제목 필드의 내용을 가져옴
        var inputContent = document.getElementById("content").value;  // 이름 필드의 내용을 가져옴   
        
        if(inputTitle.trim() === "" && inputContent.trim() === ""){  // 둘다 내용이 비어있는 경우
            alert("제목과 내용을 입력하시오");  // 알림창1
            errors.title = true;  // 제목에러O    
            errors.content = true;  // 내용에러O
        } else if (inputTitle.trim() === "") {  // 제목이 비어있는 경우
            alert("제목을 입력하시오"); // 알림창2
            errors.title = true;  // 제목에러O    
            errors.content = false;  // 내용에러X    
        } else if (inputContent.trim() === "") {  // 내용이 비어있는 경우
            alert("내용을 입력하시오"); // 알림창3
            errors.title = false;  // 제목에러X    
            errors.content = true;  // 내용에러O    
        } else {    // 그 외는 성공한 경우 
            errors.title = false;  // 제목에러X  
            errors.content = false;  // 내용에러X   
        }   
    }

    function updateSubmitButtonState() {    // 버튼 활성 여부 함수
        checkString();  // 에러가 있는지 확인한다
        if(errors.title||errors.content){    // 하나라도 에러가 있으면      
            submitButton.addEventListener("click", handleClick);    // 버튼에 클릭 이벤트 추가(클릭 시 추가 불가능)
        }else{    // 에러가 없는 경우
            submitButton.removeEventListener("click", handleClick); // 기존에 있던 버튼 클릭 이벤트 제거(클릭 시 추가 가능)
            const form = document.getElementById("inputForm"); // 폼의 ID를 지정하여 해당 폼 요소 가져옴
            form.action = "./gongji_write.jsp?key=INSERT"; // 폼의 주소를 설정함
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