<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>[건강영향설문조사]성인용(첫방문)</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0,maximum-scale=1.0,user-scalable=yes"/>
<meta http-equiv="X-UA-Compatible" content="ie=edge"/>
<link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR&display=swap" rel="stylesheet"/>

<c:choose>
    <c:when test="${viewMode eq 'survey'}">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/survey_common.css?ver=8" />
    </c:when>
    <c:otherwise>
    	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/survey_common_viewmode.css?ver=8" />
    </c:otherwise>
</c:choose>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/survey_ex_class.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/fullpage.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/scrolloverflow.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/fullpage.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/JQuery3.4.1.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/sweetAlert.js"></script>

	<script>

	var surveyCommonUtils = {
			"setLayoutToSurvey" : function() {
				var myFullpage = new fullpage('#fullpage', {
					licenseKey : '2BD03B7C-BEE54D5A-AA0125A7-58B34D98',
					scrollOverflow : true,
					recordHistory: false,
					anchors:['questionGroup'],
					afterLoad : function(origin, destination, direction) {
						$(".btn_prev").bind("click", function() {
							//네비게이션 dot
							$(".navi-dot").removeClass("active-dot");
							$(".navi-dot").eq(Number(Number($(this).attr("turn"))-1)).addClass("active-dot");
							
							fullpage_api.moveSlideLeft();
							fullpage_api.reBuild();
						});
						$(".btn_next").bind("click", function() {
							//네비게이션 dot
							$(".navi-dot").removeClass("active-dot");
							$(".navi-dot").eq(Number(Number($(this).attr("turn"))+1)).addClass("active-dot");
							
							fullpage_api.moveSlideRight();
							fullpage_api.reBuild();
						});
						fullpage_api.setAllowScrolling(false, 'left, right');
						
						//정보닫기 버튼과 문항사이 간격을 동적으로 조절해줌
						$(".qest_wrap").css("margin-top", getSurveyTopHeight());
					},
					onSlideLeave: function(section, origin, destination, direction){
						//이곳에 필수입력, 다음 문항 이동 등 로직 
						//이곳에서 설문데이터 저장
						
						var writeResult = surveyCommonUtils.writeSurveyAns(origin.anchor, "one", "T");
						/* if(direction == "right"){
							if(writeResult != "true"){
								var writeResult = writeResult.split("/");
								fullpage_api.moveTo(1, writeResult[1]);
								return false;
							}
						} */
						
						
						
					},
					scrollOverflowOptions : {
						click : false,
						preventDefaultException : {
							tagName : /.*/
						}
					}
				});
			},
			"setLayoutToView" : function() {
				//작성하기 모드로 로드 후 조회모드로 CSS로 변경처리
				//태그 등을 작성/조회 모드로 별도로 관리하지 않기 위해.. CSS만 변경하여.. 처리함
				//$(".qest_wrap").css("border", "0px").css("min-height", "100px");
				//$("html, body").css("overflow", "visible");
				//$(".qest_title").css("margin-top", "0px");
				//$(".qest_title, .label_txt, label, td, th").css("font-size","15px");
				$("input, textarea").attr("disabled", "disabled");
				$("input[type='text']").each(function() {//input text -> span 태그로 변경
					$(this).replaceWith("<span class='span_font15'>" + $(this).val() + '</span>');
				});
				$("textarea").each(function() {//input textarea -> span 태그로 변경
					$(this).replaceWith("<div class='span_font15 txt_area_min_60'>" + $(this).val() + '</div>');
				});
				//$(".subQuest").css("font-size", "15px");
				//$(".qest_btn_group").hide();
				//$(".surveyTop").css("top", "0px");
				//$("#btn_close").hide();
				
				//$(".slide").css("margin-top", "-200px");
				//$(".slide").eq(0).css("margin-top", "-150px");
				if(this.isMobile()){
					$("#slide1").css("margin-top", "40px");	
				}else{
					$("#slide1").css("margin-top", "0px");
				}
				//$(".surveyTop").hide();
				//$(".quest_end").hide();
				//$(".quest_red").hide();
				//$(".btn_close").hide();
				//$(".subQuestWrap").show();
				//$(".view_quest_no").show();
				//$(".qest_no").hide();
				//$(".qest").hide();
				//$(".navigation").hide();
				//$(".qest_anwer_wrap").css("margin-top", "0px");
				//$(".section").css("padding-top", "148px");
				//$(".survey_img_check").css("cursor", "default");
				$("div[quest-type='알림']").hide();
				//$(".qest_wrap").css("margin-top", "230px");
				//$("body").css("width", "100%");
			},
			"printSurvey" : function(printThis) {
				/* if(!this.isMobile()){
					alert("인쇄는 PC에서만 가능합니다.");
					return;
				} */
				this.setLayoutToView();
				
				$(".qest_wrap").css("margin-top", "150px");
				$("#survey_cover").show();
				$(".qest_wrap").eq(0).css("margin-top", "0px");
				$(".qest_title").css("border-bottom", "0px");
				$(".qest_title").css('background-image', 'url("")');
				$(".qest_anwer_wrap").css('background-image', 'url("")');
				$(".qest_title").css("padding", "0");
				$(".slide").css("margin-top", "-150px");
				window.onbeforeprint = function(ev) {
					document.body.innerHTML = $("#fullpage").html();
				};
				window.print();

			},
			"isMobile" : function(){
				var filter = "win16|win32|win64|mac";
				if(navigator.platform){
					if(0 > filter.indexOf(navigator.platform.toLowerCase())){
						return true;
					}else{
						return false;
					}
				}
			},
			"writeSurveyAns" : function(qestNo, type, useAt, callback){//설문작성내용 DB 인서트, useAt = T(임시저장) , Y(실데이터)
				//type = "all" 전체문항 저장, type = "one" 해당 문항만 저장
				var surveyAnsMstSn = $("#survey_form > #SURVEY_ANS_MST_SN").val();
				var surferNm = $("#survey_form > #SUFRER_NM").val();
				var sufrerPin = $("#survey_form > #SUFRER_PIN").val();
				var orgCd = $("#survey_form > #ORG_CD").val();
				var operCd = $("#survey_form > #OPER_CD").val();
				var surveySn = $("#survey_form > #SURVEY_SN").val();
				var surveyCd = $("#survey_form > #SURVEY_CD").val();
				var surveyNm = $("#survey_form > #SURVEY_NM").val();
				var groupSurveySn = $("#survey_form > #GROUP_SURVEY_SN").val();
				var extype = "";
				var ansValue = "";
				var ansTxt1 = "";
				var ansTxt2 = "";
				var qnCd = "";
				var exCd = "";
				var useAt = useAt;
				var exqnlink = "";//예/아니오에 따라 이동할 특정 문항
				var surveyQnArray = new Array();
		    
				var targetObj = null;
				
				if(type == "all"){
					targetObj = $(".question");//전체저장
				}else{
					targetObj = $("div[quest-no='"+qestNo + "']");//해당 문항만 저장
				}
				
				var _callback = callback;
				
				$(targetObj).find("textarea, input[type=checkbox], input[type=radio], input[type=text]").each(function(index, el){//현재 작성중인 설문지의 모든 textarea, input 태그를 가져와서 반복
					extype = $(el).attr("extype");
					qnCd = $(el).attr("qncd");
					exCd = $(el).attr("excd");
					switch(extype){
						case "선택" :
							ansValue = $(el).is(":checked")? "Y" : "N";
							
							if($(el).is(":checked")){
								exqnlink = $(el).attr("exqnlink");	
							}
							break;
						case "선택(텍스트)" ://qntxtlink => 현재 문항 컴포넌트에 연결되는 textbox를 명시(해당 textbox에 qntxtlink라는 어트리뷰트로 정의되어 있음)
							ansValue = $(el).is(":checked")? "Y" : "N";
							ansTxt1 = $("input[qntxtlink='" + qnCd + "-" + exCd + "']").val();
							if($(el).is(":checked")){
								exqnlink = $(el).attr("exqnlink");	
							}
							break;
						case "텍스트" :
							ansTxt1 = $(el).val();
							break;
						case "텍스트(텍스트)" ://qntxtlink => 현재 문항 컴포넌트에 연결되는 textbox를 명시(해당 textbox에 qntxtlink라는 어트리뷰트로 정의되어 있음)
							ansTxt1 = $(el).val();
							ansTxt2 = $("input[qntxtlink='" + qnCd + "-" + exCd + "']").eq(1).val();//첫번째 텍스트 필드 외에 다른 필드
							break;
						case "텍스트(텍스트)2" ://qntxtlink => 현재 문항 컴포넌트에 연결되는 textbox를 명시(해당 textbox에 qntxtlink라는 어트리뷰트로 정의되어 있음)
							ansTxt1 = $(el).val();
							ansTxt2 = $("input[qntxtlink='" + qnCd + "-" + exCd + "']").val();
							break;
						/* case "선택(이미지)" :
							ansValue = $(el).is(":checked")? "Y" : "N";
							
							if($(el).is(":checked")){
								exqnlink = $(el).attr("exqnlink");	
							}
							break; */
						//그외 survey_qn_ex.ex_type이 추가되면 이곳에 정의
						
					}
					if(typeof extype != "undefined"){//해당 문항내 모든 input element를 대상으로 조회하므로, extype을 갖고 있지 않은 태그(ex : qntxtlink용 태그) 등은 답변목록에서 제외
						
						//if(ansValue === "Y" || ansTxt1 !== "" || ansTxt2 !== ""){
							var surveyQnObj = new Object();
							surveyQnObj.surveyAnsMstSn = surveyAnsMstSn;
							surveyQnObj.surferNm = surferNm;
							surveyQnObj.sufrerPin = sufrerPin;
							surveyQnObj.orgCd = orgCd;
							surveyQnObj.operCd = operCd;
							surveyQnObj.surveySn = surveySn;
							surveyQnObj.surveyCd = surveyCd;
							surveyQnObj.surveyNm = surveyNm;
							surveyQnObj.ansValue = ansValue;
							surveyQnObj.ansTxt1 = ansTxt1;
							surveyQnObj.ansTxt2 = ansTxt2;
							surveyQnObj.qnCd = qnCd;
							surveyQnObj.exCd = exCd;
							surveyQnObj.useAt = useAt;
							surveyQnObj.groupSurveySn = groupSurveySn;
							surveyQnArray.push(surveyQnObj);//현재 답변정보를 저장
							console.log(surveyQnObj);
						//}
					}
					//해당 답변정보 초기화
					extype = "";
					ansValue = "";
					ansTxt1 = "";
					ansTxt2 = "";
					qnCd = "";
					exCd = "";
					
					
				})
				
				var surveyJson = JSON.stringify(surveyQnArray);//서버 전달용 JSON
				$.ajax({
			        type: "POST",
			        url: "/user/survey/write",
			        dataType: 'json',
			        data: surveyJson,
			        contentType:'application/json; charset=utf-8',
			        beforeSend: function(){
			        	$('#loading').show(); 
			        },
			        success: function(data){
			        	
			        },
			        complete : function(data) {
			        	if(typeof _callback != "undefined"){
			        		_callback();	
			        	}
			        	$('#loading').hide();
		           	},
				});				
				
			}
			
		};
	

		$(document).ready(
				function() {
					var viewMode = value='<c:out value="${viewMode}"/>';
					switch (viewMode) {
						case "survey":
							surveyCommonUtils.setLayoutToSurvey();
							break;
						case "view":
							surveyCommonUtils.setLayoutToView();
							break;
						case "tempView":
							surveyCommonUtils.setLayoutToView();
							break;
						case "print":
							surveyCommonUtils.printSurvey();
							break;
					}

					$("#btn_close").click(function() {
						if ($(".st_con").css("display") == "none") {
							$(".st_con").show();
							$(".qest_wrap").css("margin-top", getSurveyTopHeight());
							$("#btn_close").text("정보닫기");
							$("#btn_close").removeClass("btn_close3");
							$("#btn_close").addClass("btn_close2");
							fullpage_api.reBuild();
						} else {
							$(".st_con").hide();
							$(".qest_wrap").css("margin-top", "90px");
							$("#btn_close").text("정보열기");
							$("#btn_close").removeClass("btn_close2");
							$("#btn_close").addClass("btn_close3");
							fullpage_api.reBuild();
						}
					});
					
					//네비게이션 클릭시
					$(".navi-dot").click(function(){
						$(".navi-dot").removeClass("active-dot");
						$(this).addClass("active-dot");
					});
					
					//체크박스 선택시 text필드 활성화/비활성화, 서브질문 보이기, 감추기 
					$("input[type='checkbox']").click(function(){
						
						//클릭시 서브질문 show/hide
						var exsubdisplays = $(this).attr("exsubdisplay");
						if(exsubdisplays){
							
							var exsubdisplays = exsubdisplays.split('/');
						    for ( var i in exsubdisplays ) {
						    	var exsubdisplay = exsubdisplays[i].split(':');
								var exsubtype = exsubdisplay[0];//SHOW OR HIDE
								var exsubexno = exsubdisplay[1];//설문 번호
								if(exsubtype == "SHOW"){
									$("div[subquestno='" + exsubexno + "']").show();
								}else{
									$("div[subquestno='" + exsubexno + "']").hide();
									$("form[name='" + exsubexno + "']")[0].reset();
							
									$("form[name='" + exsubexno + "']").find("input[type='checkbox'], input[type='radio']").each(function(index, el){//활성화된 text 비활성화 처리
										var disabletarget = (typeof $(el).attr("disabletarget") != "undefined") ? $(el).attr("disabletarget").split('/') : null;
									    for ( var i in disabletarget ) {
											$("input[qntxtlink='" + disabletarget[i] + "']").prop("disabled", true);
									    }
									});
								}
								fullpage_api.reBuild();
						    }
						}
						
						
						var disableTargets = $(this).attr("disableTarget");
						if(disableTargets){//survey_qn_ex.disable_target이 있는 경우만
							if($(this).is(":checked")){
								var disableTarget = disableTargets.split('/');
							    for ( var i in disableTarget ) {
							    	$("input[qntxtlink='" + disableTarget[i] + "']").attr("disabled", false);
							    }
							}else{
								var disableTarget = disableTargets.split('/');
							    for ( var i in disableTarget ) {
							    	$("input[qntxtlink='" + disableTarget[i] + "']").attr("disabled", true);
									$("input[qntxtlink='" + disableTarget[i] + "']").val("");//체크 해제시 해당 내용 초기화
							    }
							}
						}
					});
					
					//라디오 선택시 text필드 활성화/비활성화 ,서브질문 보이기/감추기
					$("input[type='radio']").click(function(){
						
						//클릭시 서브질문 show/hide
						/* var exsubdisplays = $(this).attr("exsubdisplay");
						if(exsubdisplays){
							
							var exsubdisplays = exsubdisplays.split('/');
						    for ( var i in exsubdisplays ) {
						    	var exsubdisplay = exsubdisplays[i].split(':');
								var exsubtype = exsubdisplay[0];//SHOW OR HIDE
								var exsubexno = exsubdisplay[1];//설문 번호
								if(exsubtype == "SHOW"){
									$("div[subquestno='" + exsubexno + "']").slideDown(300);
								}else{
									$("div[subquestno='" + exsubexno + "']").slideUp(300);
									$("form[name='" + exsubexno + "']")[0].reset();
								}
						    }
						} */
						
						
						$("input[exsubdisplay='" + $(this).attr("exsubdisplay") + "']").each(function(){
							if($(this).is(":checked")){
								var exsubdisplays = $(this).attr("exsubdisplay");
								if(exsubdisplays){
									
									var exsubdisplays = exsubdisplays.split('/');
								    for ( var i in exsubdisplays ) {
								    	var exsubdisplay = exsubdisplays[i].split(':');
										var exsubtype = exsubdisplay[0];//SHOW OR HIDE
										var exsubexno = exsubdisplay[1];//설문 번호
										if(exsubtype == "SHOW"){
											$("div[subquestno='" + exsubexno + "']").show();
										}else{
											$("div[subquestno='" + exsubexno + "']").hide();
											$("form[name='" + exsubexno + "']")[0].reset();
											
											$("form[name='" + exsubexno + "']").find("input[type='checkbox'], input[type='radio']").each(function(index, el){//활성화된 text 비활성화 처리
												var disabletarget = (typeof $(el).attr("disabletarget") != "undefined") ? $(el).attr("disabletarget").split('/') : null;
											    for ( var i in disabletarget ) {
													$("input[qntxtlink='" + disabletarget[i] + "']").prop("disabled", true);
											    }
											});
											
										}
										fullpage_api.reBuild();
								    }
								}
							}
						});
						
						
						
						$("input[name='" + $(this).attr("name") + "']").each(function(i, obj){//라디오의 경우, 해당 라디오에 대한 체크해제는 다른 라디오 버튼을 클릭했을 경우이므로, 라디오 클릭시 같은 name값에 다른 라디오 버튼의 textbox를 먼저 초기화 + disable 진행 후 해당 라디오에 textbox enable 처리
							var disableTargets = $(obj).attr("disableTarget");
							if(disableTargets){
								var disableTarget = disableTargets.split('/');
							    for ( var i in disableTarget ) {
							    	$("input[qntxtlink='" + disableTarget[i] + "']").attr("disabled", true);
									$("input[qntxtlink='" + disableTarget[i] + "']").val("");//체크 해제시 해당 내용 초기화
							    }
							}
						});
						
						
						var disableTargets = $(this).attr("disableTarget");
						if(disableTargets){//survey_qn_ex.disable_target이 있는 경우만
							if($(this).is(":checked")){
								var disableTarget = disableTargets.split('/');
							    for ( var i in disableTarget ) {
							    	$("input[qntxtlink='" + disableTarget[i] + "']").attr("disabled", false);
							    }
							}
						}
					});
					
					//미리보기 팝업
					$("[name='btn_preview']").click(function(){
						
						surveyCommonUtils.writeSurveyAns("", "all", "T", 
						function(){
							var url = "/user/survey/preview.do";
							window.open('','preView','width=800, height=1000, menubar=no, status=no, toolbar=no, scrollbars=yes');
							var frmPreview= document.survey_preview_form;
						    frmPreview.action = url;
						    frmPreview.method = "post";
						    frmPreview.target = 'preView'; //window,open()의 두번째 인수와 같아야 하며 필수다.  
						    frmPreview.submit();
						});
						
						
						
					});
					
					//설문완료
					$(".btn_survey_end").click(function(){
						swal({
						  title: "설문조사 완료",
						  text: "설문조사를 완료하시겠습니까?",
						  icon: "info",
						  buttons: true,
						  dangerMode: false,
						})
						.then(function(surveyEnd){
						  if (surveyEnd) {
							//useAt => Y 로직 여기에
							surveyCommonUtils.writeSurveyAns("", "all", "Y");
							$.ajax({
						        type: "POST",
						        url: "/user/survey/surveyMasterActive",
						        dataType: 'json',
						        data: "surveyAnsMstSn=" + $("#survey_form > #SURVEY_ANS_MST_SN").val(),
						        success: function(data){}
							});
							
							swal("설문조사가 완료되었습니다.\r\n 오랜 시간 설문 조사에 응답해 주셔서 진심으로 감사드립니다.", {
						      icon: "success",
						    }).then(function(surveyEnd){
							  if (surveyEnd) {
							  	location.href="/user/test2.do";
							  }
							});
						    
						  }
						});
					});
					
					//미리보기 닫기버튼
					$(".btn_view_close").click(function(){
						swal({
						  title: "",
						  text: "조회 페이지를 종료하시겠습니까?",
						  icon: "warning",
						  buttons: true,
						  dangerMode: false,
						})
						.then(function(surveyTempEnd){
						  if (surveyTempEnd) {
						    window.close();
						  }
						});
					});
					
					
					<c:if test="${viewMode eq 'survey'}">
					//작성모드에서만 실행되는 함수
					
					
					//이미지 클릭시 선택처리(ex_type : 선택(이미지))
					$(".survey_img_check").click(function(){
						var imgGroup = $(this).attr("imggroup");//동일한 문항에 이미지에 대한 그룹관리
						$("[imggroup='" + imgGroup + "']").addClass("uncheck");
						console.log($("[imggroup='" + imgGroup + "']"));
						$(this).removeClass("uncheck");
					});
					
					//그룹설문 다음설문으로 이동
					$(".btn_survey_move_next").click(function(){
						
						swal("남은 설문조사가 진행됩니다.", {
						      icon: "success",
						    }).then(function(surveyEnd){
							  if (surveyEnd) {
								  surveyCommonUtils.writeSurveyAns("", "all", "Y");
								  var $form = $('<form></form>');
								  $form.attr('action', '/user/survey/surveyprocess2.do');
								  $form.attr('method', 'post');
								  $form.appendTo('body');
								  
								  var password = prompt("진행을 위해 관리 비밀번호를 입력해주세요.");
								  var confirmPass = $('<input type="hidden" value="' + password + '" name="confirmPass">');
								  var surveySn = $('<input type="hidden" value="' + $('#survey_turn_form > #p_nextSurveySn').val() + '" name="surveySn">');
								  var surveyAnsMstSn = $('<input type="hidden" value="' + $('#survey_form > #SURVEY_ANS_MST_SN').val() + '" name="surveyAnsMstSn">');
								  var orgCd = $('<input type="hidden" value="' + $('#survey_form > #ORG_CD').val() + '" name="orgCd">');
								  var operCd = $('<input type="hidden" value="' + $('#survey_form > #OPER_CD').val() + '" name="operCd">');
								  
								  var viewMode = $('<input type="hidden" value="survey" name="viewMode">');
								  var p_nextSurveySn = $('<input type="hidden" value="' + $('#survey_turn_form > #p_nextSurveySn').val() + '" name="p_nextSurveySn">');
								  var p_GroupSurveySn = $('<input type="hidden" value="' + $('#GROUP_SURVEY_SN').val() + '" name="p_GroupSurveySn">');   
								 
								  $form.append(surveySn).append(surveyAnsMstSn).append(orgCd).append(operCd).append(confirmPass).append(viewMode).append(p_nextSurveySn).append(p_GroupSurveySn);
								     
								  $form.submit();
							  }
							});
					});
					
					</c:if>

				});
		
		function openSurveyView(surveyAnsMstSn, orgCd, operCd, surveySn, groupSurveySn, viewMode){
			
		  var $form = $('<form></form>');
		  $form.attr('action', '/user/survey/surveyprocess2.do');
		  $form.attr('method', 'post');
		  $form.appendTo('body');
		     
		     
		  var surveySn = $('<input type="hidden" value="' + surveySn + '" name="p_viewSurveySn">');
		  var surveyAnsMstSn = $('<input type="hidden" value="' + surveyAnsMstSn + '" name="surveyAnsMstSn">');
		  var orgCd = $('<input type="hidden" value="' + orgCd + '" name="orgCd">');
		  var operCd = $('<input type="hidden" value="' + operCd + '" name="operCd">');
		  var password = prompt("조회를 위해 관리 비밀번호를 입력해주세요.");
		  var confirmPass = $('<input type="hidden" value="' + password + '" name="confirmPass">');
		  var viewMode = $('<input type="hidden" value="' + viewMode + '" name="viewMode">');
		  var groupSurveySn = $('<input type="hidden" value="' + groupSurveySn + '" name="p_GroupSurveySn">');
		     
		 
		  $form.append(surveySn).append(surveyAnsMstSn).append(orgCd).append(operCd).append(confirmPass).append(viewMode).append(groupSurveySn);
		     
		  $form.submit();

		}
		
		function openSurveyPrint(surveyAnsMstSn, orgCd, operCd, surveySn){
			
			  var $form = $('<form></form>');
			  $form.attr('action', '/user/survey/surveyprocess2.do');
			  $form.attr('method', 'post');
			  $form.appendTo('body');
			     
			     
			  var surveySn = $('<input type="hidden" value="' + surveySn + '" name="surveySn">');
			  var surveyAnsMstSn = $('<input type="hidden" value="' + surveyAnsMstSn + '" name="surveyAnsMstSn">');
			  var orgCd = $('<input type="hidden" value="' + orgCd + '" name="orgCd">');
			  var operCd = $('<input type="hidden" value="' + operCd + '" name="operCd">');
			  var password = prompt("조회를 위해 관리 비밀번호를 입력해주세요.");
			  var confirmPass = $('<input type="hidden" value="' + password + '" name="confirmPass">');
			  var viewMode = $('<input type="hidden" value="print" name="viewMode">');
			     
			 
			  $form.append(surveySn).append(surveyAnsMstSn).append(orgCd).append(operCd).append(confirmPass).append(viewMode);
			     
			  $form.submit();

			}
		
		//정보닫기와 설문지 작성 DIV 간격을 동적으로 셋팅하기 위해 surveyTop의 height값을 리턴
		function getSurveyTopHeight(){
			return (Number($(".surveyTop").css("height").replace("px", "")) + 10) + "px";
		}
	</script>
</head>
<body>
	<!-- 설문지 인쇄용 표지영역 -->
	<div id="loading"><img id="loading-image" src="${pageContext.request.contextPath}/resources/img/ajax-loader.gif" alt="Loading..." /></div>
	<div class="surveyTop">
		<div class="st_con">
			<div class="surveyLogo">
				<c:choose>
				    <c:when test="${surveyMaster.OPER_CD eq '국립중앙'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/nmc_logo.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '강북삼성'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/kbsmc_logo.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '가천길병원'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/gcd.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '서울아산'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/suas.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '충남대'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/cbd.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '전북대'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/jbd.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '순천향구미'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/schgm.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '울산대'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/usd.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '동아대'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/dad.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '대가대'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/dgd.jpg" alt="" class="hospital_logo" />
				    </c:when>
				    <c:when test="${surveyMaster.OPER_CD eq '과학원'}">
				        <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/gbss.jpg" alt="" class="hospital_logo" />
				    </c:when>
				</c:choose>
				<%-- <img src="${pageContext.request.contextPath}/resources/img/hospital_logo/gbss.png" alt="" class="hospital_logo" /> --%>
				<img src="${pageContext.request.contextPath}/resources/img/logo_kor.jpg" alt="" class="kor_logo" />
			</div>
			<div class="surveyTitle"><c:out value="${surveyDefine.SURVEY_NM}"/></div>

			<div class="surveyInfo">
				<ul>
					<li>설문대상자 :<c:out value="${surveyMaster.SUFRER_NM}"/>(<c:out value="${surveyMaster.SEXDSTN}"/>) / 생년월일 : <c:out value="${surveyMaster.BRTHDY}"/></li>
					<li>식별(환자)번호 : <c:out value="${surveyMaster.SUFRER_PIN}"/>(<c:out value="${surveyMaster.HSPTL_ID}"/>)</li>
				</ul>
			</div>
		</div>
		<c:if test="${viewMode eq 'survey'}">
			<div id="btn_close" class="btn_close2">정보닫기</div>
		</c:if>
		<!-- 설문지 네비게이션 -->
		<c:if test="${viewMode eq 'survey'}">
			<%-- <div class="navigation">
				<ul>
					<c:forEach var="surveyQn" items="${surveyQnEx}" varStatus="status">
						<li><a href="#questionGroup/<c:out value='${surveyQn.QN_CD}' />" class="navi-dot <c:if test='${status.first }'>active-dot</c:if>" id="slide<c:out value='${status.count}'/>_dot" ></a></li>
					</c:forEach>
				</ul>
			</div> --%>
			<div style="width:100%;height:3rem;text-align:center;">
				<c:forEach var="surveyQn" items="${surveyQnEx}" varStatus="status">
					<span style="display:inline-block"><a href="#questionGroup/<c:out value='${surveyQn.QN_CD}' />" class="navi-dot <c:if test='${status.first }'>active-dot</c:if>" id="slide<c:out value='${status.count}'/>_dot" ></a></span>
				</c:forEach>
			</div>
		</c:if>
		<!-- 설문지 네비게이션 끝-->
	</div>
	<!-- 설문지 인쇄용 표지영역 끝 -->
	<!-- 설문지 작성영역 -->
	<form id="survey_preview_form" name="survey_preview_form">
		<input type="hidden" name="surveyAnsMstSn" value="<c:out value="${surveyMaster.SURVEY_ANS_MST_SN}"/>" />
		<input type="hidden" name="orgCd" value="<c:out value="${surveyMaster.ORG_CD}"/>" />
		<input type="hidden" name="operCd" value="<c:out value="${surveyMaster.OPER_CD}"/>" />
		<input type="hidden" name="surveySn" value="<c:out value="${surveyDefine.SURVEY_SN}"/>" />
	</form>
	<form id="survey_form" name="survey_form">
		<input type="hidden" id="SURVEY_ANS_MST_SN" value="<c:out value="${surveyMaster.SURVEY_ANS_MST_SN}"/>" />
		<input type="hidden" id="SUFRER_NM" value="<c:out value="${surveyMaster.SUFRER_NM}"/>" />
		<input type="hidden" id="SUFRER_PIN" value="<c:out value="${surveyMaster.SUFRER_PIN}"/>" />
		<input type="hidden" id="ORG_CD" value="<c:out value="${surveyMaster.ORG_CD}"/>" />
		<input type="hidden" id="OPER_CD" value="<c:out value="${surveyMaster.OPER_CD}"/>" />
		<input type="hidden" id="SURVEY_SN" value="<c:out value="${surveyDefine.SURVEY_SN}"/>" />
		<input type="hidden" id="SURVEY_CD" value="<c:out value="${surveyDefine.SURVEY_CD}"/>" />
		<input type="hidden" id="SURVEY_NM" value="<c:out value="${surveyDefine.SURVEY_NM}"/>" />
		<input type="hidden" id="GROUP_SURVEY_SN" value="<c:out value="${groupSurveySnForInst}"/>" />
	</form>
	<!-- 그룹설문시 사용되는 다음 설문지 정보 저장용 폼  -->
	<form id="survey_turn_form" name="survey_turn_form">
		<input type="hidden" id="p_nextSurveySn" value="<c:out value="${nextSurveySn}"/>" />
	</form>
	<div id="fullpage">
		<!-- 설문지 상단 작성자 정보 -->
		<div id="survey_cover" class="survey_cover">
			<div class="survey_cover_img">
				<img src="${pageContext.request.contextPath}/resources/img/hospital_logo/gbss.png" alt="" class="hospital_logo" />
			</div>
			<div class="survey_cover_title" >
				건강모니터링 건강영향설문조사<br/>작성 결과지
			</div>
			<div class="survey_cover_wrap">
				<div class="survey_kind_of">
					<b><c:out value="${surveyMaster.SURVEY_NM}"/></b>
				</div>
				<table class="cover_table">
					<colgroup>
						<col style="width:25%"/>
						<col style="width:25%"/>
						<col style="width:25%"/>
						<col style="width:25%"/>
					</colgroup>
					<tr>
						<td style="text-align:center;">식 별 번 호</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.SUFRER_PIN}"/></td>
						<td style="border-left:1px solid black;text-align:center;">성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.SUFRER_NM}"/></td>
					</tr>
					<tr>
						<td style="text-align:center;">성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;별</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.SEXDSTN}"/></td>
						<td style="border-left:1px solid black;text-align:center;">생 년 월 일</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.BRTHDY}"/></td>
					</tr>
					<tr>
						<td style="text-align:center;">응답자 성명</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.SUFRER_NM}"/></td>
						<td style="border-left:1px solid black;text-align:center;">조사대상자와의<br/>관계</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.SUFRER_RELATE}"/></td>
					</tr>
					<tr>
						<td style="text-align:center;">의 료 기 관</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.ORG_CD}"/></td>
						<td style="border-left:1px solid black;text-align:center;">작 성 일 자</td>
						<td style="border-left:1px solid black;"><c:out value="${surveyMaster.SURVEY_DT}"/></td>
					</tr>
				</table>
				<div class="survey_cover_bottm_img">
					<img src="${pageContext.request.contextPath}/resources/img/logo_kor.gif" alt="" />
				</div>
			</div>
		</div>
		<!-- 설문지 상단 작성자 정보 끝-->
		<!-- 설문지 작성 -->
		<div class="section" id="section1">
			<!-- 그룹설문 조회시  -->
			<c:if test="${groupSurveyView eq 'Y' && viewMode eq 'view' }">
				<div style="width:100%;text-align:center;height:40px">
					<c:forEach var="viewSurveySnDefine" items="${viewSurveySnDefines}" varStatus="index">
					     <button class="view-survey-menu-btn <c:if test='${surveyDefine.SURVEY_SN eq viewSurveySnDefine.SURVEY_SN}'>active</c:if>" onclick="openSurveyView('<c:out value="${groupSurveyViewInfo.groupSurveyMstSn}"/>', '<c:out value="${groupSurveyViewInfo.groupOrgCd}"/>', '<c:out value="${groupSurveyViewInfo.groupOrgCd}"/>', '<c:out value="${viewSurveySnDefine.SURVEY_SN}"/>', '<c:out value="${groupSurveySn}"/>', 'view')" ><c:out value="${viewSurveySnDefine.SURVEY_NM}"/></button>
					</c:forEach> 
				</div>
			</c:if>
			<c:forEach var="surveyQn" items="${surveyQnEx}" varStatus="status">
				<div class="slide" data-anchor="<c:out value='${surveyQn.QN_CD}' />" quest-type="<c:out value='${surveyQn.QN_TYPE }' />" >

					<div class="fp-responsive question" quest-no="<c:out value='${surveyQn.QN_CD}' />">
						
						<div class="qest_wrap">
							<span class="qest_no"><c:if test="${surveyQn.QN_TYPE eq '알림' }" >안내사항</c:if><c:if test="${surveyQn.QN_TYPE ne '알림' }" >
							<c:choose>
							    <c:when test="${fn:contains(surveyQn.QN_CD, 'M_')}">
							        <c:out value="${fn:replace(surveyQn.QN_CD, 'M_', '')}" />
							    </c:when>
							    <c:when test="${fn:contains(surveyQn.QN_CD, 'F_')}">
							        <c:out value="${fn:replace(surveyQn.QN_CD, 'F_', '')}" />
							    </c:when>
							    <c:otherwise>
							        <c:out value='${surveyQn.QN_CD}' />
							    </c:otherwise>
							</c:choose>
							 Question</c:if> </span>
							 <c:if test="${viewMode eq 'survey'}">
								<c:if test="${surveyQn.QN_EXPLN_TYPE eq 'TYPE1'}">
									<div class="quest_red">
										<c:out value="${surveyQn.QN_EXPLN}" escapeXml="false" />
									</div>
								</c:if>
								<c:if test="${surveyQn.QN_EXPLN_TYPE eq 'TYPE2'}">
									<div class="quest_end">
										<c:out value="${surveyQn.QN_EXPLN}" escapeXml="false" />
									</div>
								</c:if>
							</c:if>
							<c:if test="${surveyQn.QN_TYPE ne '알림' }" >
								<div class="qest_title">
								<span class="view_quest_no">
									<c:choose>
									    <c:when test="${fn:contains(surveyQn.QN_CD, 'M_')}">
									        <c:out value="${fn:replace(surveyQn.QN_CD, 'M_', '')}" />
									    </c:when>
									    <c:when test="${fn:contains(surveyQn.QN_CD, 'F_')}">
									        <c:out value="${fn:replace(surveyQn.QN_CD, 'F_', '')}" />
									    </c:when>
									    <c:otherwise>
									        <c:out value='${surveyQn.QN_CD}' />
									    </c:otherwise>
									</c:choose>.
								</span><c:out value="${surveyQn.QN_NM}" escapeXml="false" /></div>
								<div class="qest_anwer_wrap" >
									<c:set var="p_surveyDate" value="${surveyQn}" scope="request"/><!-- 보기 컴포넌트로 전달용 파라메터 -->
									<jsp:include page="./components/survey_component.jsp"/>
									<!-- 서브질문  -->
									<c:forEach var="subQnEx" items="${surveySubQnEx}" varStatus="status3">
									
										<c:if test="${subQnEx.P_QN_CD eq surveyQn.QN_CD }">
											<form name="<c:out value='${subQnEx.QN_CD}'/>">
												<div subquestno="<c:out value='${subQnEx.QN_CD}'/>" class="subQuestWrap" <c:if test="${subQnEx.INIT_DISPLAY_AT eq 'N'}">style="display:none"</c:if> >
													<div class="subQuest">
														<c:out value="${subQnEx.QN_NM}" escapeXml="false" />
													</div>
													<div class="subAnwer">
														<c:set var="p_surveyDate" value="${subQnEx}" scope="request"/><!-- 서브보기 컴포넌트로 전달용 파라메터 -->
														<jsp:include page="./components/survey_component.jsp"/>
													</div>
												</div>
											</form>
										</c:if>
									</c:forEach>
								</div>
							</c:if>
							<c:if test="${surveyQn.QN_TYPE eq '알림' }" >
								<br/>
								<br/>
							</c:if>
							<c:if test="${viewMode eq 'survey'}">
								<div class="qest_btn_group">
									<c:if test='${not status.first}'><input type="button" class="btn_prev" turn="<c:out value='${status.index}' />" value="이전" /></c:if>
									&nbsp;&nbsp;<input type="button" name="btn_preview" class="btn_preview" value="미리보기" />&nbsp;&nbsp;
									<c:if test='${not status.last}'><input type="button" class="btn_next" turn="<c:out value='${status.index}' />" value="다음" /></c:if>
									<c:if test='${status.last}'>
										<c:if test="${not empty nextSurveySn}">
											<input type="button" class="btn_survey_move_next" turn="<c:out value='${status.index}' />" value="설문진행" />
										</c:if>
										<c:if test="${empty nextSurveySn}">
											<input type="button" class="btn_survey_end" value="설문완료" />
										</c:if>
									</c:if>
								</div>
							</c:if>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
		<!-- 설문지 작성 끝 -->
		<c:if test="${viewMode eq 'tempView' || viewMode eq 'view' }">
			<div style="width:100%;text-align:center;margin-bottom:50px;">
				<button type="button" class="btn_view_close" >닫기</button>
				<c:if test="${viewMode eq 'view' }">
					<button type="button" class="btn_view_print" onclick="openSurveyPrint(<c:out value="${surveyMaster.SURVEY_ANS_MST_SN}"/>, '<c:out value="${surveyMaster.ORG_CD}"/>', '<c:out value="${surveyMaster.OPER_CD}"/>', <c:out value="${surveyDefine.SURVEY_SN}"/>)" >인쇄</button>
				</c:if>
			</div>
		</c:if>
	</div>
	

</body>
</html>
