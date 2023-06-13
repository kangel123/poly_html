<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.Date,java.text.SimpleDateFormat,java.util.ArrayList,java.util.List"%> <%--import--%>
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
    Date currentDate = new Date();  // 날짜를 가져옴
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 형식 지정
    String date = dateFormat.format(currentDate);  // 형식에 맞춰 변환

    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	ResultSet rset = stmt.executeQuery("select id from product"); // 모든 상품번호를 가져오는 sql문
    List<String> arrId = new ArrayList<>(); // 상품번호만 모아놓은 리스트
    while(rset.next()){ // 모든 상품번호에 대하여
        arrId.add(rset.getString(1));   // 리스트에 저장
    }
    request.setAttribute("arrId", arrId);   // 리스트를 현재 스크립트에서 사용가능하도록 세팅함
%>

<form method="post" id="inputForm" enctype="multipart/form-data">    <!--폼 시작, post-->
<div style="width:900px">   <!--바깥쪽 공간-->
    <h1>신규 등록</h1>
    <div>   <!--안쪽 공간-->
    <table cellspacing=3 border=1> <!--신규 공지-->    
        <tr>    <!--1행-->
            <th style="width:100px;">상품 번호</th>   <!--1열-->
            <td style="width:800px;">
                <input type="number" name="productID" id="productID" size="50" maxlength="70"> 
                <input style="border: none; pointer-events: none;" type="text" id="productIDMessage" size="50" tabindex="-1" readonly>   <!--빈 공간 시 메시지, 특수문자는 write에서 처리-->            
            </td>  <!--2열-->
         </tr>   <!--1행 끝-->
        <tr>    <!--2행-->
            <th style="width:100px;">상품명</th>   <!--1열-->
            <td style="width:800px;">   <!--2열 시작-->
                <input type="text" name="productName" id="productName" maxlength="30" size="50">    <!--상품명-->
                <input style="border: none; pointer-events: none;" type="text" id="productNameMessage" size="30" tabindex="-1" readonly>   <!--빈 공간 시 메시지, 특수문자는 write에서 처리-->
            </td>   <!--2열 종료-->
        </tr>   <!--2행 종료-->
        <tr>    <!--3행-->
            <th style="width:100px;">재고 현황</th>   <!--1열-->
            <td style="width:800px;">   <!--2열 시작-->
                <input type="number" name="cnt" id="cnt" max="10">    <!--재고-->
                <input style="border: none; pointer-events: none;" type="text" id="cntMessage" size="30" tabindex="-1" readonly>   <!--재고칸이 비었거나 음수인지 확인-->
            </td>    <!--2열 종료-->
        </tr>   <!--3행 종료-->
        <tr>    <!--4행-->
            <th style="width:100px;">상품등록일자</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="prd" value="<%=date%>" tabindex="-1" readonly ></td>  <!--2열-->
        </tr>   <!--4행 종료-->
        <tr>    <!--5행-->
            <th style="width:100px;">재고등록일자</th>   <!--1열-->
            <td style="width:800px;"><input style="border: none; pointer-events: none;" type="text" name="srd" value="<%=date%>" tabindex="-1" readonly ></td>  <!--2열-->
        </tr>   <!--5행 종료-->
        <tr>    <!--6행-->
            <th style="width:100px;">내용</th>   <!--1열-->
            <td style="width:800px;">   <!--2열 시작-->
                <input type="text" name="content" id="content" maxlength="70" size="50">  <!--내용-->
                <input style="border: none; pointer-events: none;" type="text" id="contentMessage" size="30" tabindex="-1" readonly>   <!--빈 공간 시 메시지, 특수문자는 write에서 처리-->
            </td>   <!--2열 종료-->
        </tr>   <!--6행 종료-->
         <tr>    <!--7행-->
            <th style="width:100px;">상품사진</th>   <!--1열-->
            <td style="width:800px;">   <!--2열 시작-->
                <div id="preview"></div>    <!--사진을 보여줄 공간-->
                <input type="file" id="photoName" name="photoName" />   <!--사진을 가져올 공간-->
            </td>   <!--2열 종료-->
        </tr>   <!--7행 종료-->
   
    </table>    <!--테이블 종료-->
    </div>  <!--안쪽 공간 끝-->
	
    <div style="text-align: right;">    <!--안쪽 공간, 버튼-->
        <input type="reset" value="취소" onclick="window.location.href = './product_list.jsp'"> <!--취소 버튼-->
        <input type="submit" value="쓰기" id="submitButton">     <!--제출 버튼-->
    </div>  <!--안쪽 공간 끝-->
</div>  <!--바깥 공간 끝-->
</form> <!--폼 종료-->
</body>	<!--본문 끝-->

<script>

    var errors = {   // 에러를 묶어놓음
        productID: true, // id 에러
        productName: true, // 이름 에러
        cnt: true,  // 재고 에러
        content: true,  // 내용 에러
        photo: true // 사진 업로드 에러
    };

    // 사진 업로드 미리보기
    window.onload = function() {    // 처음 로드가 완료되면
        var fileInput = document.getElementById('photoName');   // 사진 주소 id를 가져와 저장
        var imagePreview = document.getElementById('preview');  // 사진 보여줄 공간 id를 가져와 저장
    
        fileInput.addEventListener('change', function(e) {  // 사진이 변경되면
            var file = e.target.files[0];   // 파일 가져오기           
            var allowedExtensions = /(\.jpg|\.png)$/i; // 허용할 확장자(jpg, png)

            if (!file) {    // 파일 선택을 취소한 경우
                fileInput.value = ''    // 기존에 선택한 이미지 초기화
                errors.photo = true;    // 에러 O
                imagePreview.innerHTML = '';    // 이미지 미리보기 초기화
            } else if (!allowedExtensions.exec(file.name)) {    // 허용가능한 확장자가 아닌 경우
                alert('이미지 파일(.jpg, .png)만 업로드할 수 있습니다.');
                fileInput.value = '';   // 기존에 선택한 이미지 초기화
                errors.photo = true;    // 에러 O
                imagePreview.innerHTML = '';    // 이미지 미리보기 초기화
            } else{     // 그 외의 경우
                var reader = new FileReader();  // 파일 읽기용 생성
                reader.onload = function(e) {   // 파일 읽기용이 로드되면
                    var image = new Image();    // 이미지 생성
                    image.src = e.target.result;    // 읽은 결과를 이미지로 저장

                    image.onload = function() { // 이미지가 생성되면
                    imagePreview.innerHTML = '';    // 미리보기 공간 초기화
                    imagePreview.appendChild(image);    // 미리보기 공간에 이미지를 넣어준다
                    };
                };
                reader.readAsDataURL(file); // url을 읽음
                errors.photo=false; // 에러 X
            }
        });
    };

    function checkID(e) { // 상품번호 대한 에러를 확인하는 함수
        const input=document.getElementById("productID").value;    // 재고에 대한 값을 가져와 저장
        const arrId = ${arrId}; // 모든 상품번호의 리스트를 가져옴
        
        if (input.trim() === "") {  // 빈칸인 경우        
            errors.productID = true;  // 에러O  
            document.getElementById("productIDMessage").value="내용을 입력하시오";  // 에러 메시지 출력
        } else if(arrId.includes(parseInt(input))){ // 해당 상품코드가 중복이면
            errors.productID = true;  // 에러O  
            document.getElementById("productIDMessage").value="중복된 상품번호입니다";  // 에러 메시지 출력
        } else {    // 그 외는 성공한 경우 
            errors.productID = false;  // 에러X  
            document.getElementById("productIDMessage").value="";  // 에러 메시지 초기화        
        }    
    }

    function checkString(e) { // 문자형 대한 에러를 확인하는 함수
        const input = e.target.value; // 입력 필드의 내용을 가져옴
        const id = e.target.id; // 입력 필드의 id를 가져옴
        var message = ""    // 메시지
        if (input === "") {  // 빈칸인 경우      
            errors[id] = true;  // 에러O
            message = "내용을 입력하시오"
        } else {    // 그 외는 성공한 경우 
            errors[id] = false;  // 에러X    
        }   
        document.getElementById(id+'Message').value=message;  // 해당 id의 에러메시지 입력창에 메시지 출력
    }

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
        // 내용 입력을 한번도 안하는 경우를 대비하여 한번더 확인한다
        checkID();   // 상품명 확인
        checkCnt(); // 재고 확인
        checkString({ target: productName});   // 상품명 확인
        checkString({ target: content});    // 내용 확인
        
        if(errors.productID||errors.productName||errors.cnt||errors.content){    // 상품명, 재고, 내용에 에러가 있으면
            submitButton.addEventListener("click", handleClick);    // 버튼에 클릭 이벤트 추가(클릭 시 추가 불가능)
        }else if(errors.photo){ // 사진이 없으면
            alert('이미지 파일을 선택하시오');   // 이미지를 한번도 선택하지 않은 경우 알림창 추가
            submitButton.addEventListener("click", handleClick);    // 버튼에 클릭 이벤트 추가(클릭 시 추가 불가능)
        }else {    // 에러가 없는 경우
            submitButton.removeEventListener("click", handleClick); // 기존에 있던 버튼 클릭 이벤트 제거(클릭 시 추가 가능)
            const form = document.getElementById("inputForm"); // 폼의 ID를 지정하여 해당 폼 요소 가져옴
            form.action = "./product_write.jsp?key=INSERT"; // 폼의 주소를 설정함
            form.submit();  // 넘어감
        }
    }

    function handleClick(e) {   // 버튼 클릭에 대한 함수
        e.preventDefault(); // 기본 클릭 동작 막기
    }

    window.addEventListener("load", document.getElementById("submitButton").addEventListener("click", handleClick));   // 최초 실행 시의 버튼 클릭을 막는 이벤트 실행        
    document.getElementById("submitButton").addEventListener("click", updateSubmitButtonState);   // 제출 여부를 판단
    document.getElementById("productID").addEventListener("input", checkID);  // 상품명에 입력이 들어온 경우 checkString 실행
    document.getElementById("productName").addEventListener("input", checkString);  // 상품명에 입력이 들어온 경우 checkString 실행
    document.getElementById("cnt").addEventListener("input", checkCnt);   // 재고에 입력이 들어온 경우 checkCnt 실행
    document.getElementById("content").addEventListener("input", checkString);  // 내용에 입력이 들어온 경우 checkString 실행    
  
</script>
</html>	<!--HTML의 끝-->