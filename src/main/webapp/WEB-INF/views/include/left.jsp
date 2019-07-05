<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
왼쪽왼쪽
<select id="pageController" onchange="changeValue(this)">
	<option value="">선택</option>
	<option value="1">1번페이지</option>
	<option value="2">2번페이지</option>
</select>

<script>
	document.querySelector('#pageController').value = "${param.page}";
	function changeValue(f) {
		/* if(f.value) {
			location.href="/views/include/main?page=" + f.value;
		} */
		location.href="/views/include/main?page=" + f.value;
	}
</script>