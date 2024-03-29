<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<head>
<title>Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no," />
<meta http-equiv="X-UA-Compatible" content="ie=edge">

	<link
		href="https://fonts.googleapis.com/css?family=Noto+Sans+KR&display=swap"
		rel="stylesheet">
		<link rel="stylesheet" type="text/css"
			href="${pageContext.request.contextPath}/resources/css/survey_index.css" />

		<script src="${pageContext.request.contextPath}/resources/js/JQuery3.4.1.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/sweetAlert.js"></script>
		<script>
			function checkFrm(){
				if(!$("input[name='surveyAnsMstSn']").val()){
					swal("설문조회 마스터키를 입력해주세요.");
					return false;
				}
				if(!$("input[name='confirmPass']").val()){
					swal("관리 비밀번호를 입력해주세요.");
					return false;
				}
				return true;
				
			}
			
			
			function getOperCode(obj){
				
				if(!$(obj).val()){
					var allHtml = "<select id='operCd' name='operCd'><option value=''>전체</option></select>"
					$("#selectOperCd").html(allHtml);
					return;
				}
				
				
				$.ajax({
			        type: "get",
			        url: "/user/getOperCode.do",
			        data: "orgCd="+$(obj).val(),
			        dataType: 'text',
			        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			        complete: function(data){
			        	var operCdsText = data.responseText;
			        	var operCds = operCdsText.split('/');
			        	var selectHtml = "<select name='operCd' style='width:150px;'>";
			            for ( var i in operCds ) {
			            	if(operCds[i]){
			            		selectHtml += "<option value='" + operCds[i] + "'>" + operCds[i] + "</option>";
			            	}
			            }
			            selectHtml += "</select>";
			            $("#selectOperCd").html(selectHtml);
			            
			            
			        }
				});
				
				
			}
			
		</script>
</head>
<body>
	<div class="surveyIndexWrap">
		<div class="surveyTop">
			<div class="surveyLogo">
				<%-- <img
					src="${pageContext.request.contextPath}/resources/img/hospital_logo/gbss.png"
					alt="" class="hospital_logo"> --%>
					 <img
					src="${pageContext.request.contextPath}/resources/img/logo_kor.gif"
					alt="" class="kor_logo">
			</div>
			<div class="surveyTitle">[건강영향 설문조사] 작성용</div>
			<!--<img src="../resource/img/logo_kor.gif" alt="" class="kor_logo">-->
		</div>
		<div class="surveyInfo">
			안녕하십니까? <br />본 설문지는 진료 전 일반건강상태에 대한 설문입니다. <br /> 본 설문지는 진료나 연구목적
			이외에는 절대 이용되지 않으며, 통계법 33조에 의해 개인 비밀이 보장됩니다.<br /> 바쁘시더라도 각 질문에 대하여
			아래 보기 중 정확하게 있는 그대로 기술해 주시기를 부탁 드립니다.
		</div>
		<form id="surveyTestForm" name="surveyTestForm" method="post" action="/user/survey/surveyprocess2.do" onSubmit="return checkFrm();")>
			<div class="surveyPersonal">
				<div class="surveyPersonTitle">대상자정보</div>
	
				<div class="surv_box">
					<ul>
						<li class="qu" style="width: 100px;">담당기관</li>
						<li class="aw"><select name="orgCd" onchange="getOperCode(this);" style="width:150px;">
								<c:forEach var="orgCd" items="${orgCode}" varStatus="status">
									<option value="<c:out value="${orgCd.ORG_CD }" />"><c:out
											value="${orgCd.ORG_CD }" /></option>
								</c:forEach>
						</select></li>
						<li class="qu" style="width: 100px;">운영기관</li>
						<li class="aw" id="selectOperCd">
							<select id="operCd" name="operCd" style="width:150px;">
								<option value="국립중앙">국립중앙</option>
							</select>
						</li>
						<li class="qu" style="width: 100px;">설문종류</li>
						<li class="aw">
							<select name="surveySn">
								<c:forEach var="survey" items="${surveyList}" varStatus="status">
									<option value="<c:out value="${survey.SURVEY_SN }" />">
									<c:out value="${survey.SURVEY_NM }" /></option>
								</c:forEach>
						</select></li>
						<li class="qu" style="width: 100px;">설문작성 마스터키</li>
						<li class="aw"><input type="text" class="input_txt" name="surveyAnsMstSn" ><input type="hidden" name="viewMode" value="survey"></li>
						<li class="qu" style="width: 100px;">관리 비밀번호</li>
						<li class="aw"><input type="password" class="input_txt" name="confirmPass"></li>
					</ul>
					</div>
				</div>
				<div class="buttonGroup">
			<input type="submit" class="btn_blue" value="작성">
		</div>
		</div>


	</form>
		
</body>
</html>