<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*,javax.servlet.*, javax.servlet.http.*"%> <%--import--%>
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
<%!
    public String getFileName(Part part) {  // 파일 이름을 찾는 함수
        String contentDisposition = part.getHeader("content-disposition");  // content-disposition 헤더는 HTTP 요청에서 업로드된 파일의 원본 파일 이름을 포함하는 헤더
        
        String[] elements = contentDisposition.split(";");  // ;를 기준으로 요소들을 나눔
        for (String element : elements) {   // 모든 요소에 대하여
            if (element.trim().startsWith("filename")) {    // 파일이 존재하면
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");    // 현재 요소에서 등호(=) 다음의 문자부터 파일 이름을 추출
                                                                                                // 파일 이름 앞뒤에 있는 큰따옴표(")를 제거한 후 반환
            }
        }
        return null;    // 실패한 경우 null
    }

    public void saveFile(Part part, String savePath, String fileName) throws IOException {  // 파일을 저장하는 함수
        InputStream inputStream = null; // 읽기용
        OutputStream outputStream = null;   // 쓰기용        
        try {
            inputStream = part.getInputStream();    // 받아온 이미지 파일을 읽기용으로 사용
            outputStream = new FileOutputStream(savePath + File.separator + fileName);  // 이미지 쓰기용 파일 경로 지정 및 생성
            
            byte[] buffer = new byte[4096]; // 바이트로 나눈다
            int bytesRead;  // 읽기용도 바이트
            while ((bytesRead = inputStream.read(buffer)) != -1) {  // 그다음 바이트가 없을때까지
                outputStream.write(buffer, 0, bytesRead);   // 쓰기용 파일에 차례대로 넣는다. 이미지 복사
            }
        } finally { // 성공하든 실패하든
            if (inputStream != null) inputStream.close();   // 읽기용을 사용했다면 닫기
            if (outputStream != null) outputStream.close(); // 쓰기용을 사용했다면 닫기            
        }
    }
%>
<%
    String key=request.getParameter("key"); // key값을 받음, 새로운 등록 여부 확인 용도 또는 id값        
    String productID=request.getParameter("productID");    // 상품ID
    String name=request.getParameter("productName");    // 상품명
    String cnt=request.getParameter("cnt");  // 재고
    String prd=request.getParameter("prd");     // 상품등록일자
    String srd=request.getParameter("srd");     // 재고등록일자
    String content=request.getParameter("content");     // 내용
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    if(key.equals("INSERT")){   // 새로운 등록인 경우
            String savePath = "/var/lib/tomcat9/webapps/ROOT/Lesson9/product/image";    // 이미지를 저장할 경로
            Part filePart = request.getPart("photoName");   // 이미지를 가져옴     

            String photoName= getFileName(filePart);    // 이미지의 이름만 가져옴
            saveFile(filePart, savePath, photoName);    // 이미지 파일 이름으로 해당 파일 위치에 저장
            
            productID = productID.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");   // id에서 <와 >의 사용 시 html에서 사용하는 용어로 변경, 에러걸림을 방지
            name = name.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");   // 이름에서 <와 >의 사용 시 html에서 사용하는 용어로 변경, 에러걸림을 방지
            content = content.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;"); // 내용에서 <와 >의 사용 시 html에서 사용하는 용어로 변경, 에러걸림을 방지

            // 혹시 모를 경우를 대비하여 중복된 상품코드인지 여기서도 한번 더 확인한다
            PreparedStatement pstmt = conn.prepareStatement("select id from product where id=?"); // 내용을 추가하는 sql문            
            pstmt.setString(1, productID);   // id
            ResultSet rset = pstmt.executeQuery();  // 실행
            if(!rset.next()){   // 해당 내용가 존재하지 않으면
                    pstmt = conn.prepareStatement("INSERT INTO product (id,name, cnt, prd,srd,content,photoName) VALUES (?,?,?,?,?,?,?)"); // 내용을 추가하는 sql문
                    pstmt.setString(1, productID);   // id
                    pstmt.setString(2, name);   // 이름 
                    pstmt.setInt(3, Integer.parseInt(cnt)); // 재고
                    pstmt.setDate(4, java.sql.Date.valueOf(prd));   // 상품등록일자
                    pstmt.setDate(5, java.sql.Date.valueOf(srd));   // 재고등록일자
                    pstmt.setString(6, content);    // 내용
                    pstmt.setString(7, photoName);  // 이미지 파일 이름
                    pstmt.executeUpdate();  // 실행
            } else{ // 존재하면
                    out.println("<script>");    // 스크립트 실행
                    out.println("alert('중복된 상품코드입니다');"); // 알림창으로 에러 메시지 출력
                    out.println("history.back();"); // 이전 페이지로 가기
                    out.println("</script>");   // 스크립트 종료
                }
            rset.close();   // ResultSet 닫기
            pstmt.close();  // PreparedStatement 닫기
        } else {    // 아닌 경우
            PreparedStatement pstmt = conn.prepareStatement("UPDATE product SET cnt=?,srd=? WHERE id=?");   // 내용을 업데이트하는 sql문
            pstmt.setInt(1, Integer.parseInt(cnt)); // 재고
            pstmt.setDate(2, java.sql.Date.valueOf(srd));   // 재고등록일자
            pstmt.setString(3, key); // 상품번호
            pstmt.executeUpdate();  // 실행
            pstmt.close();  // 닫기
        }
        conn.close();   // Connection 닫기    
    }catch(Exception e){    // 에러가 발생한 경우
        e.printStackTrace();    // 에러 메시지 출력
    }
    
%>
</body>	<!--본문 끝-->
<script>
window.onload = function() {
  window.location.href = "product_list.jsp"; // 어떤 경우든 작업이 완료되면 상품 리스트로 넘어간다
}
</script>
</html>	<!--HTML의 끝-->