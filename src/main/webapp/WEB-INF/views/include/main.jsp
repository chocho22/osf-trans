<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인</title>
</head>
<style>
#lDiv {
	width : 48%;
	height : 500px;
	background-color : #2C5863;
	float : left;
	text-align : center;
}
#rDiv {
	width : 48%;
	height : 500px;
	background-color : #FFBF00;
	float : right;
	text-align : center;
}
</style>
<%
String rPath = "/WEB-INF/views/include/right" 
		+ request.getParameter("page") + ".jsp";
/* if(request.getParameter("page")!=null) {
	rPath = "/WEB-INF/views/include/right" 
	+ request.getParameter("page") + ".jsp";
} */
%>
<body>

<div id="lDiv">
<jsp:include page="/WEB-INF/views/include/left.jsp"></jsp:include>
</div>

<div id="rDiv">
<jsp:include page="/WEB-INF/views/include/right${param.page}.jsp"></jsp:include>
</div>

</body>
</html>