function CheckChar(e){
    const input=e.target.value; // 입력값 받아오기
    const lastChar = input.charAt(input.length - 1);    // 마지막 문자
    const isNonNumeric = /\D/.test(lastChar);   //  /\D/.test():숫자가 아닌 문자인지 확인, 숫자면 false
    if (isNonNumeric) { // 숫자가 아닌 경우
        alert("숫자만 입력할 수 있습니다");    // 에러 메시지
        e.target.value = input.slice(0, input.length - 1);  // 마지막 문자 전까지 자르기
    }
    if (input>100||input<0) { // 0부터 100까지의 범위를 초과한 경우
        alert("0부터 100까지만 가능합니다");    // 에러 메시지
        e.target.value = "";  // 문자열 초기화
    }
}
    