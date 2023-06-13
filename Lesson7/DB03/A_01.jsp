<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.List,java.util.ArrayList"%> <%--import--%>
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
		<td width=100 bgcolor=yellow><a href="./A_01.jsp" target="main"><h2>후보등록</h2></a>   <!--1번, 현재 메뉴-->
        <td width=100><a href="./B_01.jsp" target="main"><h2>투표</h2></a>  <!--2번-->
        <td width=100><a href="./C_01.jsp" target="main"><h2>개표결과</h2></a>  <!--3번-->
	</tr>   <!--1행 끝-->
</table>    <!--메뉴창 끝-->

<%
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
		Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
		ResultSet rset = stmt.executeQuery("select * from hubo;"); // 모든 후보의 정보를 가져오는 sql문
        List<Integer> list = new ArrayList<>(); // 기호를 저장할 리스트를 만든다
%>
<br>    <!--메뉴와 현재 페이지의 테이블과의 간격을 위해 띄움-->
<table cellspacing=3 border=1> <!--후보 등록 페이지-->
	<tr>    <!--1행-->
		<th>기호</th>   <!--1열-->
		<th>후보명</th> <!--2열-->
		<th></th>   <!--3열, 추가 또는 삭제 버튼 공간-->
	</tr>
	<%  
		while(rset.next()){ // 가져온 모든 정보들에 대하여
			int kiho=rset.getInt(1);    // 기호번호
			String name=rset.getString(2);  // 후보이름
            list.add(kiho); // 리스트에 기호 추가
	%>
	
	<form method="post">    <!--폼 시작, post-->
	<tr>    <!--행 시작, 기존에 존재하는 후보들에 대한 행-->       
		<td><%=kiho%></td>  <!--기호번호-->
		<td><%=name%></td>  <!--후보이름-->
		<td><input type="submit" value="삭제" formaction="./A_02.jsp?kiho=<%=Integer.toString(kiho)%>"/></td>	<!--삭제 버튼-->
	</tr>   <!--행 종료-->
	</form> <!--폼 종료-->
	<%
		}   // 반복문 종료
        int newKiho=1;  // 새로운 기호
        for(int cnt=0;cnt<list.size();cnt++,newKiho++){ // 연속적으로 기호가 있으면 다음 기호가 된다
            if(newKiho!=list.get(cnt)) break;   // 비어있는 기호가 있으면 종료
        }
        
	%>
	
	<form method="post" id="inputForm">    <!--폼 시작, post-->
	<tr>    <!--행 시작, 후보 추가를 위한 행--> 
		<td>    <!--1열-->
            <input style="text-align:center" type="number" name="new_kiho"  value=<%=newKiho%> readonly>   <!--새로운 후보의 기호번호 입력창-->
            <br>
            <input style="border: none; pointer-events: none; text-align: center;" type="text" value = "기호는 자동으로 지정됩니다" size="30" tabindex="-1" readonly>   <!--에러 창-->
        </td>   <!--1열 끝-->
		<td>    <!--2열-->
            <input style="text-align:center" type="text" id="new_name" name="new_name" maxlength=10> <!--새로운 후보의 이름 입력창-->
            <br>
            <input style="border: none; pointer-events: none; text-align: center;" type="text" id="messageName" size="30" tabindex="-1" readonly>   <!--에러 창-->
        </td>    <!--2열 끝-->
		<td><input type="submit" id="submitButton" value="추가"/></td>  <!--3열, 추가 버튼-->
	</tr>   <!--행 종료-->
	</form> <!--폼 종료-->
</table>    <!--테이블 종료-->
	<%
		rset.close();   // ResultSet 닫기
		stmt.close();   // Statement 닫기
		conn.close();   // Connection 닫기
        request.setAttribute("list", list); // 리스트를 자바스크립트에서 사용가능하도록 설정한다
		} catch(Exception e){   // 에러가 발생한 경우
			out.println(e); // 에러 메시지 출력
		}
	%>
</body>	<!--본문 끝-->

<script>  
    var error = {   // 에러를 묶어놓음
        name: true  // 처음은 에러O
    };

    function checkName(e) { // 이름에 대한 에러를 확인하는 함수
        var inputName = document.getElementById("new_name").value;  // 이름 필드의 내용을 가져옴
        var specialChar = /[!@#$%^&*()_+\-=[\]{};'':""\\|,.<>/?]+/;   // 특수문자들
        
        if (specialChar.test(inputName)) {  // 특수문자가 있는경우
            error.name=true;   // 에러O
            document.getElementById("messageName").value = "특수문자는 사용할 수 없습니다";  // 에러 메시지
        } else if (inputName.trim() === "") {  // 빈칸인 경우
            error.name=true;   // 에러O
            document.getElementById("messageName").value = "내용을 입력하십시오";  // 에러 메시지
        } else {    // 그 외는 성공한 경우 
            error.name=false;  // 에러X
            document.getElementById("messageName").value = "";  // 에러 메시지는 필요 없음
        }   
    }

    function updateSubmitButtonState() {    // 버튼 활성 여부 함수
        if(error.name){    // 이름 입력 시 에러이면
            checkName();    // 이름 에러 메시지 출력                                      
            submitButton.addEventListener("click", handleClick);    // 버튼에 클릭 이벤트 추가(클릭 시 추가 불가능)
        }else{    // 에러가 없는 경우
            submitButton.removeEventListener("click", handleClick); // 기존에 있던 버튼 클릭 이벤트 제거(클릭 시 추가 가능)
            const form = document.getElementById("inputForm"); // 폼의 ID를 지정하여 해당 폼 요소 가져옴
            form.action = "A_03.jsp"; // 폼의 주소를 설정함
            form.submit();  // 넘어감
        }
    }

    function handleClick(e) {   // 버튼 클릭에 대한 함수
        e.preventDefault(); // 기본 클릭 동작 막기
    }

    window.addEventListener("load", document.getElementById("submitButton").addEventListener("click", handleClick));   // 최초 실행 시의 버튼 클릭을 막는 이벤트 실행       
    document.getElementById("new_name").addEventListener("input", checkName);   // 새로운 후보이름 입력창에 입력이 들어오면 checkName실행
    document.getElementById("submitButton").addEventListener("click", updateSubmitButtonState);   // 제출 여부를 판단

</script>
</html>	<!--HTML의 끝-->