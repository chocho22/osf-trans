<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/head.jspf" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">
	<table class="table table-bordered">
		<tr>
			<td>ID</td>
			<td><input type="text" id="id"></td>
		</tr>
		<tr>
			<td>PASSWORD</td>
			<td><input type="password" id="pwd"></td>
		</tr>
		<tr>
			<td colspan="2"><button>login</button></td>
		</tr>
	</table>
</div>
<script>
	$(document).ready(function() {
		$('button').click(function() {
			var param = {
					id : document.querySelector('#id').value,
					pwd : document.querySelector('#pwd').value
			}
			console.log(param);
			var conf = {
					url : '/login',
					data : JSON.stringify(param),
					contentType : 'application/json',
					method : 'POST',
					success : function(res) {
						if(res.login && res.login==='ok') {
							alert('로그인 성공');
						} else {
							alert('로그인 실패');
						}
					},
					error : function(error) {
						
					}
			}
			$.ajax(conf);
		})
	})
</script>
</body>
</html>