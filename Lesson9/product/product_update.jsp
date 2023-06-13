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
    String key="-1";    // key값 초기화, 상품번호가 -1이 존재해도 해당 상품정보를 db에서 가져오므로 상관없다 
    if(!request.getParameter("key").equals("")){    // 전달받은 key 인자값이 있으면
        key=request.getParameter("key");    // 해당 인자값 저장
    }

    String name=""; // 이름 초기화
    int cnt=0;  // 재고 초기화
    String prd="";  // 상품등록일자 초기화
    String content="";  // 내용 초기화
    String photo="";    // 사진 초기화
    Date currentDate = new Date();  // 날짜를 가져옴
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 형식 지정
    String date = dateFormat.format(currentDate);  // 형식에 맞춰 변환, 재고등록일자
    
    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	ResultSet rset = stmt.executeQuery("select * from product where id='"+key+"';"); // 해당 상품 정보를 가져오는 sql문
    if(rset.next()) {   // 존재하면
        name = rset.getString(2);   // 이름
        cnt = rset.getInt(3);   // 재고
        prd = rset.getString(4);    // 상품등록일자
        content = rset.getString(6);    // 내용
        photo = rset.getString(7);  // 사진
    }
    if(name.equals("")){    // 이름이 없다==해당 상품이 없다
        out.println("<script>");    // 스크립트 사용
        out.println("alert('존재하지 않은 상품번호입니다.');"); // 알림창으로 에러 메시지 출력 후
        out.println(" location.href = 'product_list.jsp';");    // 상품 리스트로 이동
        out.println("</script>");   // 스크립트 사용 종료
    }
%>
<form method="post" id="inputForm">    <!--폼 시작, post-->
<div style="width:900px">   <!--바깥 공간 시작-->
    <h1> 재고 수정</h1>
    <div>   <!--안쪽 공간 시작-->
    <table cellspacing=3 border=1> <!--신규 공지-->    
        <tr>    <!--1행-->
            <th style="width:100px;">번호</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="key" size="90" value="<%=key%>" tabindex="-1" readonly ></td> <!--2열-->
         </tr>   <!--1행 끝-->
        <tr>    <!--2행-->   
            <th style="width:100px;">상품명</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="productName" size="90" value="<%=name%>" maxlength=70 readonly></td>    <!--2열-->  
        </tr>   <!--2행 종료-->
        <tr>    <!--3행-->   
            <th style="width:100px;">재고 현황</th>   <!--1열-->
            <td style="width:800px;">   <!--2열 시작-->
                <input type="number" name="cnt" id="cnt" value="<%=cnt%>"  value="<%=cnt%>" max="10">   <!--재고-->
                <input style="border: none; pointer-events: none;" type="text" id="cntMessage" size="30" tabindex="-1" readonly>    <!--재고 에러메시지 창-->
            </td>   <!--2열 끝-->
        </tr>   <!--3행 종료-->
          <tr>    <!--4행-->   
            <th style="width:100px;">상품등록일자</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="prd" value="<%=prd%>" tabindex="-1" readonly></td>    <!--2열-->    
        </tr>   <!--4행 종료-->
          <tr>    <!--5행-->   
            <th style="width:100px;">재고등록일자</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="srd" value="<%=date%>" tabindex="-1"  readonly></td>  <!--2열-->    
        </tr>   <!--5행 종료-->
        <tr>    <!--6행-->   
            <th style="width:100px;">내용</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="content" size="90" value="<%=content%>" tabindex="-1" readonly></td>    <!--2열-->
        </tr>   <!--6행 종료-->
        <tr>    <!--7행-->   
            <th style="width:100px;">상품사진</th>   <!--1열-->
            <td style="width:800px;"><image src="./image/<%=photo%>"></td>  <!--2열-->
        </tr>   <!--7행 종료-->   
    </table>    <!--테이블 종료-->
    </div>  <!--안쪽 공간 끝-->
	
    <div style="text-align: right;">    <!--안쪽 공간 시작, 오른쪽 정렬-->
        <input type="reset" value="취소" onclick="window.location.href = './product_list.jsp'">     <!--취소버튼-->
        <input type="submit" value="쓰기" id="submitButton">    <!--제출 버튼-->
     </div> <!--안쪽 공간 끝-->
</div>  <!--바깥 공간 끝-->
</form> <!--폼 종료-->
</body>	<!--본문 끝-->
<script>
    var errors = {   // 에러를 묶어놓음
        cnt: false  // 재고 에러X
    };

   function checkCnt(e) { 
        const input=document.getElementById("cnt").value;    // 재고에 대한 값을 가져와 저장
        if (input.trim() === "") {  // 빈칸인 경우        
            errors.cnt = true;  // 에러O  
            document.getElementById("cntMessage").value="내용을 입력하시오";  // 에러 메시지 출력
        } else if(input<0){     // 음수인 경우    
            errors.cnt = true;  // 에러O    
            document.getElementById("cntMessage").value="재고가 0보다 작을 수 없습니다";  // 에러 메시지 출력
        } else if(input>=1000000000){     // 음수인 경우    
            errors.cnt = true;  // 에러O    
            document.getElementById("cntMessage").value="재고는 최대9자리까지 가능합니다";  // 에러 메시지 출력
        } else {    // 그 외는 성공한 경우 
            errors.cnt = false;  // 에러X  
            document.getElementById("cntMessage").value="";  // 에러 메시지 초기화        
        }                  
    }

    function updateSubmitButtonState() {    // 버튼 활성 여부 함수
        if(errors.cnt){    // 에러가 있으면                                    
            submitButton.addEventListener("click", handleClick);    // 버튼에 클릭 이벤트 추가(클릭 시 추가 불가능)
        }else{    // 에러가 없는 경우
            submitButton.removeEventListener("click", handleClick); // 기존에 있던 버튼 클릭 이벤트 제거(클릭 시 추가 가능)
            const form = document.getElementById("inputForm"); // 폼의 ID를 지정하여 해당 폼 요소 가져옴
            form.action = "./product_write.jsp"; // 폼의 주소를 설정함
            form.submit();  // 넘어감
        }
    }

    function handleClick(e) {   // 버튼 클릭에 대한 함수
        e.preventDefault(); // 기본 클릭 동작 막기
    }

    window.addEventListener("load", document.getElementById("submitButton").addEventListener("click", handleClick));   // 최초 실행 시의 버튼 클릭을 막는 이벤트 실행        
    document.getElementById("submitButton").addEventListener("click", updateSubmitButtonState);   // 제출 여부를 판단
    document.getElementById("cnt").addEventListener("input", checkCnt);   // 재고 입력이 들어오면 checkCnt 실행
</script>
</html>	<!--HTML의 끝-->