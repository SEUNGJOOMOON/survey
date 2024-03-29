<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">

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
		</script>
</head>
<body>
	<div class="surveyIndexWrap">
		<div class="surveyTop">
			<div class="surveyLogo">
				<img
					src="${pageContext.request.contextPath}/resources/img/hospital_logo/gbss.png"
					alt="" class="hospital_logo"> <img
					src="${pageContext.request.contextPath}/resources/img/logo_kor.gif"
					alt="" class="kor_logo">
			</div>
			<div class="surveyTitle">[건강영향 설문조사] 성인용(테스트 조회)</div>
			<!--<img src="../resource/img/logo_kor.gif" alt="" class="kor_logo">-->
		</div>
		<div class="surveyInfo">
			안녕하십니까? <br />본 설문지는 진료 전 일반건강상태에 대한 설문입니다. <br /> 본 설문지는 진료나 연구목적
			이외에는 절대 이용되지 않으며, 통계법 33조에 의해 개인 비밀이 보장됩니다.<br /> 바쁘시더라도 각 질문에 대하여
			아래 보기 중 정확하게 있는 그대로 기술해 주시기를 부탁 드립니다.
		</div>
		<form id="surveyTestForm" name="surveyTestForm" method="post" action="/user/survey/surveyprocess.do" onSubmit="return checkFrm();")>
			<div class="surveyPersonal">
				<div class="surveyPersonTitle">대상자정보</div>
	
				<div class="surv_box">
					<ul>
						<li class="qu">담당병원</li>
						<li class="aw">
							<select name="orgCd">
								<option value="국립중앙">국립중앙병원</option>
								<option value="충남대" >충남대병원</option>
								<option value="강북삼성" >강북삼성병원</option>
								<option value="전북대">전북대병원</option>
								<option value="서울아산" >서울아산병원</option>
								<option value="순천향구미" >순천향구미병원</option>
							</select>
						</li>
						<li class="qu">설문조회 마스터키</li>
						<li class="aw"><input type="text" class="input_txt" name="surveyAnsMstSn" ></li>
						<li class="qu">관리 비밀번호</li>
						<li class="aw"><input type="password" class="input_txt" name="confirmPass"></li>
						<li class="qu">조회 모드</li>
						<li class="aw" style="width:500px">
							<ul>
							<li style="float:left"><label><input type="radio" name="viewMode" value="survey"></input>설문작성</label></li>
							<li style="float:left"><label><input type="radio" name="viewMode" value="view"></input>설문조회</label></li>
							<li style="float:left"><label><input type="radio" name="viewMode" value="print"></input>프린트(PC)</label></li>
							</ul>
						</li>
					</ul>
					</div>
				</div>
				<div class="buttonGroup">
			<input type="submit" class="btn_blue" value="조회">
		</div>
		</div>


	</form>
		
</body>
</html>