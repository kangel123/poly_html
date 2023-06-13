<%@ page contentType="text/html; charset=UTF-8"%>   <!--content Type:utf-8선언-->

<div style="text-align: right"> <!--오른쪽 정렬-->
    <form method="post" name="search">  <!--폼 시작-->
        <select name="attribute" id="attribute">
            <option value="id">번호</option>
            <option value="title">제목</option>
            <option value="content">내용</option>
            <option value="date">날짜</option>
        </select>       
        <input type="text" placeholder="검색할 내용을 입력하시오" id="searchText" name="searchText" size = "25"  maxlength="70"> <!--입력창-->            
        <input type="submit" id="submitButton" value="검색">    <!--제출 버튼-->         
    </form> <!--폼 종료 -->
</div>  <!--종료-->
