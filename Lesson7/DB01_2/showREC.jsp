<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.util.ArrayList"%> <%--import--%>
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
        String stuname=""; // 이름 초기화
        String stuid=request.getParameter("id");   // 학번을 인자로 받아옴
        String korean="";  // 국어 성적 초기화
        String english="";  // 영어 성적 초기화
        String math="";  // 수학 성적 초기화
        String total="";  // 총점 초기화
        String average="";  // 평균 초기화
        String ranking="";  // 등수 초기화
        ArrayList<Integer> list = new ArrayList<>();	// 총합 리스트
        
        if(!stuid.equals("")){ // 학번을 입력한 경우
            Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	        Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	        ResultSet rset	 = stmt.executeQuery("select kor+eng+mat as total from examtable;");	// 총합 리스트 만들기 위한 sql문
			
	        while(rset.next()){ // 반복문
				list.add(rset.getInt(1));	// 리스트 추가
			}  	   
            request.setAttribute("list", list);  // list 변수를 JSP 변수로 설정

            rset = stmt.executeQuery("select *, kor+eng+mat as sum, (kor+eng+mat)/3 as ave,"+
            "(select count(*)+1 from examtable as m where m.kor+m.eng+m.mat > n.kor+n.eng+n.mat) as ranking from examtable as n where id="+stuid+";"); // 해당 학번을 찾는 sql문
            while(rset.next()){ // 반복문
            	stuname=rset.getString(1); // 이름
                stuid=Integer.toString(rset.getInt(2));    // 학번
                korean=Integer.toString(rset.getInt(3));   // 국어
                english=Integer.toString(rset.getInt(4));   // 영어
                math=Integer.toString(rset.getInt(5));   // 수학
                total=Integer.toString(rset.getInt(6));;  // 총점
                average=Integer.toString(rset.getInt(7));;  // 평균
                ranking=Integer.toString(rset.getInt(8));;  // 등수
          
            }   // 반복문 종료
        }   // if문 종료
       
        if(stuname.equals("")){    // 이름이 비어있으면
        	stuname="해당학번없음";    // 이름 지정
        	stuid="";  // 학번은 빈칸
        }
%>

    <div style="display: inline-block; width: 900px;">   <!--바깥쪽 공간 지정-->
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
                <td>    <!--2열--> 
                    <input style="text-align: center;" type="text" id="name" name="name" maxlength='20' value="<%=stuname%>" onkeyup="checkName(event)" <%if(stuid.equals("")){out.println("readonly");}%>>    <!--이름 입력 필드, 확인 이벤트 추가-->
                    <br>    <!--다음 줄-->
                    <input style="border: none; pointer-events: none; text-align: center;" type="text" id="messageName" size="30" tabindex="-1" readonly>   <!--에러 메시지 창-->
                </td>
            </tr>
            <tr>    <!--2행-->
                <td>학번</td>   <!--1열-->              
                <td><input style="border: none; pointer-events: none; text-align: center;" type="number" value="<%=stuid%>" name="id" tabindex="-1" readonly/></td>    <!--2열, 수정 불가-->
            </tr>           
            <tr>    <!--3행-->
                <td>국어</td>   <!--1열-->                    
                <td>    <!--2열--> 
                    <input style="text-align: center;" type="number" id="kor"  name="korean" value="<%=korean%>" onkeyup="checkInput(event)" <%if(stuid.equals("")){out.println("readonly");}%>>    
                                <!--국어 입력 필드, 확인 이벤트 추가-->
                    <br>    <!--다음 줄-->
                    <input style="border: none; pointer-events: none; text-align: center;" type="text" id="korMessage" size="30" tabindex="-1" readonly>    <!--에러 메시지 창-->               
                </td> 
            </tr>
            <tr>    <!--4행-->
                <td>영어</td>   <!--1열-->                 
                <td>    <!--2열--> 
                    <input style="text-align: center;" type="number" id="eng" name="english" value="<%=english%>" onkeyup="checkInput(event)" <%if(stuid.equals("")){out.println("readonly");}%>>   
                                <!--영어 입력 필드, 확인 이벤트 추가-->
                    <br>    <!--다음 줄-->
                    <input style="border: none; pointer-events: none; text-align: center;" type="text" id="engMessage" size="30" tabindex="-1" readonly>    <!--에러 메시지 창-->
                </td>
            </tr>
            <tr>    <!--5행-->
                <td>수학</td>   <!--1열-->                 
                <td>    <!--2열-->    
                    <input style="text-align: center;" type="number" id="mat" name="math" value="<%=math%>" onkeyup="checkInput(event)" <%if(stuid.equals("")){out.println("readonly");}%>>  
                            <!--수학 입력 필드, 확인 이벤트 추가-->
                    <br>    <!--다음 줄-->
                    <input style="border: none; pointer-events: none; text-align: center;" type="text" id="matMessage" size="30" tabindex="-1" readonly>    <!--에러 메시지 창-->
                </td>
            </tr>  
              <tr>    <!--6행-->
                <td>총점</td>   <!--1열-->                
                <td><input style="border: none; pointer-events: none; text-align: center;" type="number" id="tot" value="<%=total%>" tabindex="-1" readonly/></td>  <!--2열, 수정 불가-->
            </tr>
            <tr>    <!--7행-->
                <td>평균</td>   <!--1열-->                
                <td><input style="border: none; pointer-events: none; text-align: center;" type="number" id="ave" value="<%=average%>" tabindex="-1" readonly/></td>  <!--2열, 수정 불가-->
            </tr>
            <tr>    <!--8행-->
                <td>등수</td>   <!--1열-->                
                <td><input style="border: none; pointer-events: none; text-align: center;" type="number" id="ran" value="<%=ranking%>" tabindex="-1" readonly/></td>  <!--2열, 수정 불가-->
            </tr>
        </table>    <!--테이블 끝-->
        
<%
        if(!stuid.equals("")){ // id가 비어있으면
%>
        <div style="text-align: right;">    <!--안쪽 공간 지정, 오른쪽 정렬-->
            <input type="submit" id="submitButton" value="수정" formaction="./updateDB.jsp"/> <!--수정 버튼-->
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


<script>  
    const errors = {    // 각 필드의 에러를 확인하기 편하게 묶어놓음
        name: false, // 이름 에러 여부
        kor: false,  // 국어 에러 여부
        eng: false,  // 영어 에러 여부
        mat: false   // 수학 에러 여부
    };

    function checkName(e) { // 이름에 대한 에러를 확인하는 함수
        var inputName = document.getElementById("name").value;  // 이름 필드의 내용을 가져옴
        var specialChar = /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]+/;   // 특수문자들
        
        if (specialChar.test(inputName)) {  // 특수문자가 있는경우
            document.getElementById("messageName").value = "특수문자가 사용되었습니다";
            errors.name=true;   // 에러O
        } else if (inputName === "") {  // 빈칸인 경우
            document.getElementById("messageName").value = "내용을 입력하시오";
            errors.name=true;   // 에러O
        } else {    // 그 외는 성공한 경우 
            document.getElementById("messageName").value = "";  // 에러 메시지는 필요 없음
            errors.name=false;  // 에러X
        }   
        updateSubmitButtonState();  // 버튼 활성 여부 확인
    }
    
    function checkScore(e) {    // 점수에 대해 에러를 확인하는 함수
        const input = e.target.value; // 입력 필드의 내용을 가져옴
        const id = e.target.id; // 입력 필드의 id를 가져옴
        var message = "";   // 기존의 메시지는 빈 칸으로 생성
    
        if (input === "") { // 입력값이 비어있는 경우
            message = "내용을 입력하시오";  // 메시지1              
            errors[id] = true;      // 해당 과목 입력에 대한 에러O 
        } else if (input > 100 || input < 0) { // 0부터 100까지의 범위를 초과한 경우
            message = "0부터 100까지만 가능합니다"; // 메시지2
            errors[id] = true;  // 해당 과목 입력에 대한 에러O
        } else {    // 그 외는 성공한 경우
        	var kor = document.getElementById("kor").value; // 국어 점수 가져옴
        	var eng = document.getElementById("eng").value; // 영어 점수 가져옴
        	var mat = document.getElementById("mat").value; // 수학 점수 가져옴
        	var tot = parseInt(kor)+parseInt(eng)+parseInt(mat);    // 총점 구하기
        	var ave = tot/3.0;  // 평균 구하기
        	var ran = 1;    // 등수 초기화
        	var list = <%= request.getAttribute("list") %>; // 총점 리스트를 가져옴
        	for (var i = 0; i < list.length; i++) { // 총점 리스트에 대하여
        		if(list[i]>tot) // 구한 총점보다 큰 경우에만
	        		ran+=1; // 등수 증가 
            }        	
        	document.getElementById("tot").value = tot; // 총점 입력창에 구한 합계 입력
        	document.getElementById("ave").value = ave; // 평균 입력창에 구한 평균 입력
        	document.getElementById("ran").value = ran; // 등수 입력창에 구한 등수 입력
            errors[id] = false;  // 해당 과목 입력에 대한 에러X           
        }  

        document.getElementById(id+'Message').value=message;  // 해당 과목의 에러메시지 입력창에 메시지 출력

        updateSubmitButtonState();  // 버튼 활성 여부 확인
    }

    function updateSubmitButtonState() {    // 버튼 활성 여부 함수
        const submitButton = document.getElementById("submitButton");   // 버튼의 아이디를 가져옴

        if(errors.name||errors.kor||errors.eng||errors.mat) // 에러가 있는 경우            
            submitButton.addEventListener("click", handleClick);    // 버튼에 클릭 이벤트 추가(클릭 시 추가 불가능)
        else    // 에러가 없는 경우
            submitButton.removeEventListener("click", handleClick); // 기존에 있던 버튼 클릭 이벤트 제거(클릭 시 추가 가능)
    }

    function handleClick(e) {   // 버튼 클릭에 대한 함수
        e.preventDefault(); // 기본 클릭 동작 막기
        alert('입력이 잘못된 항목이 존재합니다');   // 에러 메시지
    }

    document.getElementById("name").addEventListener("input", checkName);   // 이름 입력 이벤트(checkName)
    document.getElementById("kor").addEventListener("input", checkScore);   // 국어 성적 입력 이벤트(checkScore)
    document.getElementById("eng").addEventListener("input", checkScore);   // 영어 성적 입력 이벤트(checkScore)
    document.getElementById("mat").addEventListener("input", checkScore);   // 수학 성적 입력 이벤트(checkScore)
</script>
</body>	<!--본문 끝-->
</html>	<!--HTML의 끝-->