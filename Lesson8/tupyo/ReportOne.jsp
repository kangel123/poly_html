<?xml version="1.0" encoding="UTF-8"?>  
<%@ page contentType="text/xml; charset=utf-8"%>    
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.net.*"%> 
<%
    try{      
        int kiho = 1;   // 기호 초기화
        try{
            kiho = Integer.parseInt(request.getParameter("kiho"));  // 기호를 인자로 받아옴
        } catch(Exception e){   // 없으면 패스
        }
        boolean a=true;    // rset의 마지막 여부를 나타남

	    Class.forName("com.mysql.cj.jdbc.Driver");	// Driver 클래스 로드, 클래스 로더에 의해 클래스 또는 인터페이스가 로드된다
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo09","root","kopoctc");	// db 연결
	    Statement stmt = conn.createStatement();	//	sql문을 위한 Statement 객체 생성
	    ResultSet rset = stmt.executeQuery("select kiho, name from hubo where kiho="+kiho+";");  // 해당 후보만 가져옴
        if(rset.next()){    // 해당 후보가 존재하면
            out.println("<datas>");     // 해당 xml의 전체 후보정보 시작               
            out.println("<hubo>"+rset.getInt(1)+"."+rset.getString(2)+"</hubo>");  // 후보을 hubo태그 안에 넣기
            rset = stmt.executeQuery("select age, count(*), count(*)/(select count(*) from tupyo where kiho="+kiho+")*100"
                            +" from tupyo where kiho="+kiho+" group by age order by age;");  // 모든 후보의 투표정보를 가져옴
            if(rset.next()){    // 투표정보가 존재하면
                for(int age=1; age < 10; age++){   // 모든 연령대에 대하여
                    out.println("<data>");  // 연령대별 정보 시작
                    out.println("<age>"+age+"</age>"); // 연령대을 age태그 안에 넣기              
                    if(!a||age!=rset.getInt(1)){    // rset의 마지막까지 다 끝냈거나 출력할 나이와 꺼내온 레코드의 나이가 다른 경우
                        out.println("<pyosu>0</pyosu>"); // 득표수을 pyosu태그 안에 넣기
                        out.println("<pyoyul>0.0</pyoyul>");   // 득표율을 pyoyul태그 안에 넣기
                    }else{  // rset에 아직 남아있고 출력할 나이와 레코드와 나이가 같은경우
                        out.println("<pyosu>"+rset.getInt(2)+"</pyosu>"); // 득표수을 pyosu태그 안에 넣기
                        out.println("<pyoyul>"+rset.getDouble(3)+"</pyoyul>");   // 득표율을 pyoyul태그 안에 넣기
                        if(!rset.next()){   // rset의 그다음 요소로 넘기면서
                            a=false;    // 없는(끝난) 경우에는 false를 통해 if문 조건에서 걸리도록 설정
                        }
                    }
                    out.println("</data>"); // 연령대별 정보 종료
                }
            } else{ // 투표정보가 비었을 경우
                for(int age=1; age < 10; age++){   // 모든 연령대에 대하여
                    out.println("<data>");  // 연령대별 정보 시작
                    out.println("<age>"+age+"</age>"); // 연령대을 age태그 안에 넣기              
                    out.println("<pyosu>0</pyosu>"); // 득표수을 pyosu태그 안에 넣기
                    out.println("<pyoyul>0.0</pyoyul>");   // 득표율을 pyoyul태그 안에 넣기                   
                    out.println("</data>"); // 연령대별 정보 종료
                }
            }
            out.println("</datas>");    // 후보 학생정보 종료
        }
        rset.close();   // ResultSet 닫기
        stmt.close();   // Statement 닫기
        conn.close();   // Connection 닫기
    } catch(Exception e){   // 에러가 생길 경우
        out.println(e);    // 메시지 출력
    }
%>
      
       



