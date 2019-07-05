<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/head.jspf" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>번역</title>
</head>

<link href="https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700,800&amp;subset=korean" rel="stylesheet">

<style>
	.papago{
		display:block;
		margin:0px auto;
		width:120px;
		height:60px;
	}
	*{
		font-family:"Nanum Gothic";
	}
	.div{
		top:90%;
		left:90%;
		width:90%;
		height:90%;
		margin:0px auto;
	}
	
	.table table-striped{
		
	}
</style>
<script>
	/* function check() {
		var selectObj1 = document.querySelector('#source');
		var selectObj2 = document.querySelector('#target');
		if(selectObj1.value==selectObj2.value) {
			alert('번역할 언어와 번역될 언어가 같습니다. \n다시 선택해주세요.');
			return false;
		}
		var textObj = document.querySelector('#text');
		if(textObj.value.length >= 1000) {
			alert('번역 할 내용은 1000글자 이상일 수 없습니다.');
			return false;
		}
		return true;
	} */
	
	function doTranslate() {
		var source = document.querySelector('#source');
		var target = document.querySelector('#target');
		var text = document.querySelector('#text');
		var url = '/translation/' + target.value + '/' + source.value + '/';
		console.log(text.value);
		url += text.value;
		console.log(url);
		var xhr = new XMLHttpRequest();
		xhr.open('GET',url);
		xhr.onreadystatechange = function() {
			if(xhr.readyState == xhr.DONE) {
				if(xhr.status==200) {
					var res = JSON.parse(xhr.response);
					var result = document.querySelector('#result');
					/* console.log(res);
					console.log(res.TH_TGTEXT); */
					result.value = res.TH_TGTEXT;
				}
			}
		}
		xhr.send();
		transList();
	}
	
	function transCode() {
		var xhr = new XMLHttpRequest();
		xhr.open('GET','/transcode');
		xhr.onreadystatechange = function() {
			if(xhr.readyState==xhr.DONE) {
				if(xhr.status==200) {
					/* console.log(xhr.response); */
					var res = JSON.parse(xhr.response);
					html = '';
					for(var tc of res) {
						html += '<option value="' + tc.TC_CODE.trim() + '">';
						html += tc.TC_LAN.trim();
						html += '</option>';
					}
					var source = document.querySelector('#source');
					source.innerHTML = html;
					
					var target = document.querySelector('#target');
					target.innerHTML = html;
				}
			}
		}
		xhr.send();
	}
	transCode();
	
	    function transList() {
		var xhr = new XMLHttpRequest();
		xhr.open('GET','/translations');
		xhr.onreadystatechange = function() {
			if(xhr.readyState==xhr.DONE) {
				if(xhr.status==200) {
					var res = JSON.parse(xhr.response);
					/* console.log(xhr.response); */
					html = '<h2 align="center">번역 랭킹</h2>';
					html += '<table class="table table-striped">';
					html += '<thead><br><tr>';
					html += '<th width="5%">검색 횟수</th>';
					html += '<th width="5%">번역 전 언어</th>';
					html += '<th width="25%">번역할 내용</th>';
					html += '<th width="5%">번역 후 언어</th>';
					html += '<th width="25%">번역된 내용</th>';
					html += '<th width="10%">에러</th>';
					html += '</tr><br></thead>';
					html += '<tbody>';
					for(var tl of res) {
						html += '<tr>';
						html += '<th width="5%">' + tl.TH_COUNT + '</td>';
						html += '<td width="5%">' + tl.TH_SOURCE.trim() + '</td>';
						html += '<td width="25%">' + tl.TH_SRCTEXT.trim() + '</td>';
						html += '<td width="5%">' + tl.TH_TARGET.trim() + '</td>';
						html += '<td width="25%">' + tl.TH_TGTEXT.trim() + '</td>';
						if(tl.TH_ERROR!=null) {
							html += '<td width="10%">' + tl.TH_ERROR + '</td>';
						} else {
							html += '<td width="10%">없음</td>';
						}
						html += '</tr>';
					}
					html += '</tbody>';
					html += '</table>';
					var translist = document.querySelector('#lDiv');
					translist.innerHTML = html;
				}
			}
		}
		xhr.send();
	}
	transList();
	
</script>
<c:if test="${rMap.isError=='true'}">
	<script>
		alert('${rMap.error}');
	</script>
</c:if>
<body>
<div class="div">
<img class="papago" src="/resources/img/Papago.png" onclick="location.href='/views/trans';"
	style="cursor:pointer"/>

<div class="md-form amber-textarea active-amber-textarea-2">
	<table class="table">
		<thead>
			<tr class="table-info">
				<th>번역할 언어</th>
				<td><select name="source" id="source">
					</select>
				</td>
			<td>
			</td>				
				<th class="table-warning">번역될 언어</th>
				<td><select name="target" id="target">
					</select>
				</td>
			</tr>
		</thead>
		<tr>
			<td colspan="2">
				<textarea class="md-textarea form-control" rows="5" name="text" id="text"
					 placeholder="번역할 내용을 입력해주세요." autofocus>${param.text}</textarea>
			</td>
			<td align="center">
				<button type="button" class="btn btn-outline-primary" onclick="doTranslate()">번역</button>
			</td>
			<td colspan="2">
				<textarea class="md-textarea form-control" rows="5" name="result" id="result"></textarea>
				<c:if test="${rMap.isError!='true'}">
					${rMap.msg}
				</c:if>
			</td>
		</tr>
	</table>
</div>
<br><br><br>
	
	<div id="lDiv"></div>
	
	<br><br><br><br><br>
	
</div>
</body>
</html>