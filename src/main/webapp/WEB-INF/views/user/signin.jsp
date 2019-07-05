<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<script>
	function checkValue(f) {
		
		if(f.id.value.length < 4) {
			alert('아이디는 4글자 이상입니다.');
			return false;
		}
		if(f.pwd.value.length < 6) {
			alert('비밀번호는 6글자 이상입니다.');
			return false;
		}
		if(f.pwd.value !== f.pwd2.value) {
			alert('비밀번호가 일치하지 않습니다.');
			return false;
		}
		if(f.age.value < 1 || f.age.value > 130) {
			alert('나이를 정확히 입력해주세요.');
			return false;
		}
		alert('완료');
		return true;
	}
</script>
<body>
<form onsubmit="return checkValue(this)">
	아이디 : <input type="text" name="id" id="id" required><br>
	비밀번호 : <input type="password" name="pwd" id="pwd"><br>
	비밀번호 확인 : <input type="password" name="pwd2" id="pwd2"><br>
	나이 : <input type="number" name="age" id="age"><br>
	Email : <input type="email" name="email" id="email"><br>
	<button>회원가입</button>
</form>
</body>
</html>