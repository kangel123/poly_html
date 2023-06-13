<!DOCTYPE html> <!--html 형식임을 선언함-->
<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->
<%@ page import="java.sql.*,javax.sql.*,java.io.*, javax.xml.parsers.*,org.w3c.dom.*"%> <%--import--%>

<html lang="en">    <!--HTML의 시작-->
<head>	<!--머리말 시작-->
    <meta charset="UTF-8">  <!--한글 인코딩-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   <!--문자셋 메타 정보-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!--뷰포트 메타 정보-->
    <link type = "text/css" rel="stylesheet" href="./main1.css">  <!--css파일을 불러옴-->
</head>	<!--머리말 끝-->
<style>
td{
    width:5%;   /*넓이*/
    text-align:center;  /*가운데 정렬*/
}
</style>
<body>	<!--본문-->
<%
    DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder(); //  DocumentBuilder 인스턴스를 할당받음, 파싱을 위한 준비
    Document doc = docBuilder.parse("http://www.kma.go.kr/wid/queryDFS.jsp?gridx=61&gridy=123");   // 해당 주소의 xml파일을 파싱함

    Element root = doc.getDocumentElement();    // doc의 요소를 가져옴
    NodeList tag_001 = doc.getElementsByTagName("data"); //xml의 루트를 기준으로  data테그를 찾는다.

    out.println("<table cellspacing=1 width=2000 border=1>");    // 테이블 생성
    out.println("<tr>");    // 1행
    out.println("<td>관측순서</td>"); // 1열
    out.println("<td>관측시간</td>"); // 2열
    out.println("<td>현재 온도</td>"); // 3열
    out.println("<td>최고 온도</td>"); // 4열
    out.println("<td>최저 온도</td>"); // 5열
    out.println("<td>구름상태</td>"); // 6열
    out.println("<td>강수상태</td>"); // 7열
    out.println("<td>날씨(한국어)</td>"); // 8열
    out.println("<td>날씨(영어)</td>"); // 9열
    out.println("<td>강수 확률</td>"); // 10열
    out.println("<td>12시간 예상 강수량</td>"); // 11열
    out.println("<td>12시간 예상 적설량</td>"); // 12열
    out.println("<td>풍속(m/s)</td>"); // 13열
    out.println("<td>풍향</td>"); // 14열
    out.println("<td>풍향(한국어)</td>"); // 15열
    out.println("<td>풍향(영어)</td>"); // 16열
    out.println("<td>습도</td>"); // 17열
    out.println("<td>6시간 예상 강수량</td>"); // 18열
    out.println("<td>6시간 예상 적설량</td>"); // 19열
    out.println("</tr>");   // 1행 종료

    for(int i=0; i<tag_001.getLength(); i++) {
        String seq=tag_001.item(i).getAttributes().getNamedItem("seq").getNodeValue();  // 관측순서
        Element elmt=(Element)tag_001.item(i);  // tag_001d의 요소들만 가져와 저장
        String hour=elmt.getElementsByTagName("hour").item(0).getFirstChild().getNodeValue();   // 관측시간
        String day=elmt.getElementsByTagName("day").item(0).getFirstChild().getNodeValue(); // 관측날짜
        String temp=elmt.getElementsByTagName("temp").item(0).getFirstChild().getNodeValue();   // 현재 온도
        String tmx=elmt.getElementsByTagName("tmx").item(0).getFirstChild().getNodeValue(); // 최고 온도
        String tmn=elmt.getElementsByTagName("tmn").item(0).getFirstChild().getNodeValue(); // 최저 온도
        String sky=elmt.getElementsByTagName("sky").item(0).getFirstChild().getNodeValue(); // 구름 상태
        String pty=elmt.getElementsByTagName("pty").item(0).getFirstChild().getNodeValue(); // 강수 상태
        String wfKor=elmt.getElementsByTagName("wfKor").item(0).getFirstChild().getNodeValue(); // 날씨(한국어)
        String wfEn=elmt.getElementsByTagName("wfEn").item(0).getFirstChild().getNodeValue();   // 날씨(영어)
        String pop=elmt.getElementsByTagName("pop").item(0).getFirstChild().getNodeValue(); // 강수 확률
        String r12=elmt.getElementsByTagName("r12").item(0).getFirstChild().getNodeValue(); //12시간 예상 강수량
        String s12=elmt.getElementsByTagName("s12").item(0).getFirstChild().getNodeValue(); //12시간 예상 적설량
        String ws=elmt.getElementsByTagName("ws").item(0).getFirstChild().getNodeValue(); // 풍속(m/s)
        String wd=elmt.getElementsByTagName("wd").item(0).getFirstChild().getNodeValue(); // 풍향
        String wdKor=elmt.getElementsByTagName("wdKor").item(0).getFirstChild().getNodeValue(); // 풍향(한국어)
        String wdEn=elmt.getElementsByTagName("wdEn").item(0).getFirstChild().getNodeValue(); // 풍향(영어)
        String reh=elmt.getElementsByTagName("reh").item(0).getFirstChild().getNodeValue(); // 습도
        String r06=elmt.getElementsByTagName("r06").item(0).getFirstChild().getNodeValue(); // 6시간 예상 강수량
        String s06=elmt.getElementsByTagName("s06").item(0).getFirstChild().getNodeValue(); // 6시간 예상 적설량
        
        String kDay=""; // 관측 날짜 한글 초기화
        switch(day){    // 날짜에 따라
            case "0": kDay="오늘"; break;   // 0은 오늘
            case "1": kDay="내일"; break;   // 1은 내일
            case "2": kDay="모레"; break;   // 2는 모레
            default: break; // 그외는 빈칸
        }

        String skyIcon="";  // 구름 상태 사진 초기화
        switch(sky){    // 구름 상태에 따라
            case "1": skyIcon="sky1.png"; break;    // 맑음
            case "2": skyIcon="sky2.png"; break;    // 구름 조금
            case "3": skyIcon="sky3.png"; break;    // 구름 많음
            case "4": skyIcon="sky4.png"; break;    // 흐림
            default: break; // 그외는 빈칸
        }

        String ptyIcon="";  // 강수 상태 사진 초기화
        switch(pty){    // 강수 상태에 따라
            case "0": ptyIcon="sky1.png"; break;    // 맑음
            case "1": ptyIcon="pty1.png"; break;    // 비
            case "2": ptyIcon="pty2.png"; break;    // 비/눈
            case "3": ptyIcon="pty3.png"; break;    // 눈/비
            case "4": ptyIcon="pty4.png"; break;    // 눈
            default: break; // 그외는 빈칸            
        }
        
        String wdIcon="";   // 풍향 사진 초기화
        switch(wd){ // 풍향에 따라
            case "0": wdIcon="d0.png"; break;   // 0, 북
            case "1": wdIcon="d1.png"; break;   // 1, 북동
            case "2": wdIcon="d2.png"; break;   // 2, 동
            case "3": wdIcon="d3.png"; break;   // 3, 동남
            case "4": wdIcon="d4.png"; break;   // 4, 남
            case "5": wdIcon="d5.png"; break;   // 5, 남서
            case "6": wdIcon="d6.png"; break;   // 6, 서
            case "7": wdIcon="d7.png"; break;   // 7, 북서
            default: break; // 그외는 빈칸
        }

        out.println("<tr>");    // 행 시작
            out.println("<td>"+(Integer.parseInt(seq)+1)+"</td>"); // 1열, 관측순서
            out.println("<td>"+kDay+" "+hour+"시</td>"); // 2열, 관측시간
            out.println("<td>"+temp+"</td>"); // 3열, 현재 온도

            if(tmx.equals("-999.0")){   // 해당 숫자는 측정 못한 경우로 판단하여
                out.println("<td>-</td>"); // '-'로 빈칸을 만든다, 4열
            } else{
                out.println("<td>"+tmx+"</td>"); // 4열, 최고 온도   
            }

            if(tmn.equals("-999.0")){   // 해당 숫자는 측정 못한 경우로 판단하여
                out.println("<td>-</td>"); //  '-'로 빈칸을 만든다, 5열
            } else{
                out.println("<td>"+tmn+"</td>"); // 5열, 최저 온도 
            }

            out.println("<td><img src="+skyIcon+"></td>"); // 6열, 구름상태 아이콘으로 표시
            out.println("<td><img src="+ptyIcon+"></td>"); // 7열, 강수상태 아이콘으로 표시
            out.println("<td>"+wfKor+"</td>"); // 8열, 날씨(한국어)
            out.println("<td>"+wfEn+"</td>"); // 9열, 날씨(영어)
            out.println("<td>"+pop+"</td>"); // 10열, 강수 확률
            out.println("<td>"+r12+"</td>"); // 11열, 12시간 예상 강수량
            out.println("<td>"+s12+"</td>"); // 12열, 12시간 예상 적설량
            out.println("<td>"+(Math.round(Double.parseDouble(ws)*10)/10.0)+"</td>"); // 13열, 풍속을 소수점 한자리까지만 표시
            out.println("<td><img src="+wdIcon+" width=30 height=20></td>"); // 14열, 풍향을 아이콘으로 표시
            out.println("<td>"+wdKor+"</td>"); // 15열, 풍향(한국어)
            out.println("<td>"+wdEn+"</td>"); // 16열, 풍향(영어)
            out.println("<td>"+reh+"</td>"); // 17열, 습도
            out.println("<td>"+r06+"</td>"); // 18열, 6시간 예상 강수량
            out.println("<td>"+s06+"</td>"); // 19열, 6시간 예상 강수량
        out.println("</tr>");   // 행 종료
    }

    out.println("</table>");    // 테이블 종료

%>
</body>
</html>