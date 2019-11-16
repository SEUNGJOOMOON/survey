package softone.monitoring.survey.controller;


import java.util.ArrayList;
import softone.monitoring.survey.vo.Pagination;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import softone.monitoring.survey.service.SurveyService;


@Controller
public class SurveyController {
	Logger log = Logger.getLogger(this.getClass());
	@Resource(name = "surveyService")
	private SurveyService surveyService;

	@RequestMapping(value = "/user/index.do")
	public String index() throws Exception {
		return "/user/survey_index";
	}
	
//	실사용
	@RequestMapping(value = "/user/test2.do")
	public ModelAndView test2() throws Exception {
		
		ModelAndView mv = new ModelAndView("/user/survey_test2");
		
		List<Map<String, Object>> orgCode = surveyService.selectOrgCode();//담당기관코드
		//List<Map<String, Object>> operCode = surveyService.selectOperCode();//운영기관코드
		List<Map<String, Object>> surveyList = surveyService.selectSurveyDefineAll();//설문종류
		
		mv.addObject("orgCode", orgCode);
		//mv.addObject("operCode", operCode);
		mv.addObject("surveyList", surveyList);
		
		return mv;
	}
	
	
	@RequestMapping(value = "/user/getOperCode.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String getOperCode(@RequestParam String orgCd) throws Exception {

		Map<String, Object> searchMap = new HashMap<String, Object>();
		searchMap.put("orgCd", orgCd);
		List<Map<String, Object>> operCode = surveyService.selectOperCode(searchMap);
		String rtnString = "";
		for (int i = 0; i < operCode.size(); i++) {
			rtnString += operCode.get(i).get("OPER_CD") + "/";//향후 JSON 으로 떨궈서... 그려주는걸로 바꿔야함...
		}
		return rtnString;
	}
	
	
	
	
	//테스트용 리스트(2019-10-26)
	@RequestMapping(value = "/user/survey_list.do")
	public ModelAndView surveyList() throws Exception {
		
		ModelAndView mv = new ModelAndView("/user/survey_comfirm_list");
		
		List<Map<String, Object>> orgCode = surveyService.selectOrgCode();//담당기관코드
		//List<Map<String, Object>> operCode = surveyService.selectOperCode();//운영기관코드
		List<Map<String, Object>> surveyList = surveyService.selectSurveyDefineAll();//설문종류
		
		mv.addObject("orgCode", orgCode);
		//mv.addObject("operCode", operCode);
		mv.addObject("surveyList", surveyList);
		
		return mv;
	}
	
	@ResponseBody
	@RequestMapping("/user/survey_list_json.do")
	public Map<String, Object> surveyListJson(Pagination paging, @RequestParam String confirmPass2, @RequestParam String surveySn, @RequestParam String withoutNoSufrerPin, @RequestParam String orgCd, @RequestParam String operCd , @RequestParam String sufrerNm , @RequestParam String sufrerPin,  @RequestParam String hsptlId, @RequestParam String orderby) {
		List<Map<String, Object>> surveyMstList = null;
		if(!confirmPass2.equals("1357")){
			return new HashMap<String, Object>();
		}
		
		paging.setStart(((paging.getPage() - 1) / 10) * 10 + 1);
		paging.setEnd((paging.getStart() + 10) - 1);
		
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//검색용 맵 셋팅
		Map<String, Object> surveyListSearchMap = new HashMap<String, Object>();
		surveyListSearchMap.put("surveySn", surveySn);
		surveyListSearchMap.put("orgCd", orgCd);
		surveyListSearchMap.put("operCd", operCd);
		surveyListSearchMap.put("sufrerNm", sufrerNm);
		surveyListSearchMap.put("sufrerPin", sufrerPin);
		surveyListSearchMap.put("hsptlId", hsptlId);
		surveyListSearchMap.put("orderby", orderby);
		surveyListSearchMap.put("rowStart", ((paging.getPage() * 10) - 9));
		surveyListSearchMap.put("rowEnd", (paging.getPage() * 10));
		surveyListSearchMap.put("withoutNoSufrerPin", withoutNoSufrerPin);
		try {
			surveyMstList = surveyService.selectSurveyAnsMstAll(surveyListSearchMap);
			try {
				paging.setTotalCnt(Long.parseLong(surveyMstList.get(0).get("TOTCNT").toString()));
			}catch(java.lang.IndexOutOfBoundsException e) {
				return resultMap;
			}
			
			paging.setTotalPages((int)paging.getTotalCnt() / 10);
			paging.setPageSize(10);
			
			resultMap.put("totalCnt", paging.getTotalCnt());
			resultMap.put("page", paging.getPage());
			resultMap.put("totalPages", paging.getTotalPages());
			resultMap.put("pageSize", paging.getPageSize());
			resultMap.put("surveyMstList", surveyMstList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultMap;

	}
	
	@RequestMapping(value = "/user/survey/surveyprocess2.do", method=RequestMethod.POST)
	public ModelAndView surveyProcess2(Map<String, Object> surveyParams, String viewMode, String p_nextSurveySn, String surveyAnsMstSn, String orgCd, String operCd, String surveySn, @RequestParam String confirmPass, HttpServletRequest request) throws Exception {
		if(!confirmPass.equals("1357")){
			return new ModelAndView("/user/survey_test2");
		}
		ModelAndView mv = new ModelAndView("/user/survey/survey");

		surveyParams.put("surveyAnsMstSn",surveyAnsMstSn);
		surveyParams.put("orgCd",orgCd);
		surveyParams.put("operCd",operCd);
		surveyParams.put("surveySn",surveySn);
		
		
		
		Map<String, Object> surveyMaster = null;
		List<Map<String, Object>> surveyEx = null;
		
		
		if((viewMode.equals("view") || viewMode.equals("print"))){//조회/인쇄시 
			surveyEx = surveyService.selectSurveyExWithAns(surveyParams);//질문 보기(작성값 포함)
			surveyMaster = surveyService.selectSurveyMaster(surveyParams);
		}else{
			Map<String, Object> surveyDefine = surveyService.selectSurveyDefine(surveyParams);
			
			//그룹설문의 경우 분기처리
			Map<String, Object> surveyMasterMap = new HashMap<String, Object>();
			if(surveyDefine.get("GROUP_SURVEY_AT").toString().equals("Y")){
			//그룹설문일경우
				String groupSurveySn = surveyDefine.get("GROUP_SURVEY_SN").toString();
				String[] surveySnGroup = groupSurveySn.split("/");// groupSurveySn은 "1/2/3" 등올 잡혀있기 때문에 반복문을 통해 순서제어
				String nextSurveySn = "";
				surveyParams.put("surveySn",surveySnGroup[0]);//첫번째 surveySn으로 셋팅
				
				for(int i = 1; i < surveySnGroup.length; i++){
					if(!surveySnGroup[i].equals("")){
						nextSurveySn += surveySnGroup[i];
						if(i < surveySnGroup.length - 1){
							nextSurveySn += "/";
						}
					}
				}
				
				mv.addObject("nextSurveySn", nextSurveySn);//남은 설문지 정보 셋팅 
			}else{
			// 일반 설문일 경우
				surveyMasterMap.put("surveySn", surveySn);
			}
			
			//마스터 정보 셋팅
			surveyMasterMap.put("surveyAnsMstSn", surveyAnsMstSn);
			surveyMasterMap.put("surveySn", surveySn);
			surveyMasterMap.put("orgCd", orgCd);//임시 하드코딩, survey 테이블에서 가져와야함(현재 index에서 받아온값셋팅/공통일경우 비어있는데 어케할지..)
			surveyMasterMap.put("operCd", operCd);//임시 하드코딩, survey 테이블에서 가져와야함(현재 index에서 받아온값셋팅/공통일경우 비어있는데 어케할지..)
			surveyMasterMap.put("surveyNm", surveyDefine.get("SURVEY_NM"));
			surveyMasterMap.put("surveyCd", surveyDefine.get("SURVEY_CD"));
			
			
			surveyService.insertSurveyAnsMst(surveyMasterMap);//마스터정보 인서트
			surveyMaster = surveyService.selectSurveyMaster(surveyParams);//인서트한 마스터정보 가져오기
			
			
			surveyEx = surveyService.selectSurveyEx(surveyParams);//질문 보기
		}
	
		List<Map<String, Object>> surveyQn = surveyService.selectSurveyQn(surveyParams);//질문 리스트
		List<Map<String, Object>> surveyQnEx = connectSurveyQnAndEx(surveyQn, surveyEx);//설문 질문
		List<Map<String, Object>> surveySubQnEx = connectSurveySubQnAndEx(surveyQnEx);//설문 서브질문

		
		mv.addObject("surveyQnEx", surveyQnEx);
		mv.addObject("surveySubQnEx", surveySubQnEx);
		mv.addObject("viewMode", viewMode);
		mv.addObject("surveyMaster", surveyMaster);
		
		
		HttpSession httpSession = request.getSession(true);
        
        // "USER"로 sessionVO를 세션에 바인딩한다.
        httpSession.setAttribute("auth_key", surveyAnsMstSn);
		
		return mv;
	}
	
	 /*
	  * @param List surveyQn (해당 surveySn으로 조회해온 SURVEY_QN 데이터)
	  * @param List surveyEx (해당 surveySn으로 조회해온 SURVEY_QN_EX 데이터)
	  * @return List surveyQn에 해당하는 surveyEx 리스트를 포함하여 리턴
	  * @ author sjmoon
	  * @ date 2019.11.16
	  */
	public List<Map<String, Object>> connectSurveyQnAndEx(List<Map<String, Object>> surveyQn, List<Map<String, Object>> surveyEx){
		List<Map<String, Object>> surveyQnEx = new ArrayList<Map<String, Object>>();//질문
		
		for (Map<String, Object> qn : surveyQn) {//질문 리스트에 해당 질문에 해당하는 보기를 넣음.
		  String qnCd = qn.get("QN_CD").toString();
		  List<Map<String, Object>> surveySubEx = new ArrayList<Map<String, Object>>();
		  for (Map<String, Object> ex : surveyEx) {//질문보기 loop
			  if(ex.get("QN_CD").toString().equals(qnCd)){
				  surveySubEx.add(ex);
			  }
		  }
		  
		  qn.put("QN_EX", surveySubEx);

		  surveyQnEx.add(qn);
		}
		
		return surveyQnEx;
	}
	
	/*
	  * @param List surveyQnEx(surveyQn에 해당하는 surveyEx 리스트를 포함 connectSurveyQnAndEx에서 반환받은 리턴값임)
	  * @return List surveyQnEx에서 P_QN_CD 갖고 있는 설문질문(서브질문)만 뽑아서 리턴
	  * @ author sjmoon
	  * @ date 2019.11.16
	  */
	public List<Map<String, Object>> connectSurveySubQnAndEx(List<Map<String, Object>> surveyQnEx){
		List<Map<String, Object>> surveySubQnEx = new ArrayList<Map<String, Object>>();
		for(Iterator<Map<String, Object>> it = surveyQnEx.iterator() ; it.hasNext() ; ) {
		  Map<String, Object> qnEx = it.next();
		  if(qnEx.get("P_QN_CD") != null) {
			 surveySubQnEx.add(qnEx);
			 it.remove();
		  }
		}
		
		return surveySubQnEx;
	}
	
	
   /*
	* @param json 설문답변 데이터
	* @return string 답변저장 성공여부
	* @ author sjmoon
	* @ date 2019.10.02
	*/
	@RequestMapping(value="/user/survey/write", method=RequestMethod.POST)
	@ResponseBody
    public Object surveyWrite(@RequestBody List<Map<String, Object>> surveyAnsJson) {

	for(Map<String, Object> surveyAns : surveyAnsJson){
		try {
			surveyService.updateSurveyAnsUseAtN(surveyAns);
			surveyService.insertSurveyAns(surveyAns);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "failed";
		}
	}
        return "successed";
    }
	
	
	/*SurveyMaster 정보 use_at T(임시저장) ->Y 변경
	* @ author sjmoon
	* @ date 2019.10.14
	*/
	@RequestMapping(value="/user/survey/surveyMasterActive", method=RequestMethod.POST)
    @ResponseBody
    public Object surveyMasterActive(String surveyAnsMstSn, HttpServletRequest request) {
		HttpSession httpSession = request.getSession(true);
		
		httpSession.invalidate();
		
		Map<String, Object> masterMap = new HashMap<String, Object>();
		masterMap.put("surveyAnsMstSn", surveyAnsMstSn);
		try {
			surveyService.updateSSurveyAnsMstUseAtY(masterMap);
		} catch (Exception e) {
			e.printStackTrace();
			return "failed";
		}
        return "successed";
    }
	
	
	 /*
	  * 설문작성 미리보기
	  * @ author sjmoon
	  * @ date 2019.10.09
	  */
	@RequestMapping(value = "/user/survey/preview.do", method=RequestMethod.POST)
	public ModelAndView preview(String surveyAnsMstSn, String orgCd, String operCd, String surveySn, HttpServletRequest request) throws Exception {
		ModelAndView mv = null;
		
		HttpSession httpSession = request.getSession(true);
		
		try{
			if(!httpSession.getAttribute("auth_key").toString().equals(surveyAnsMstSn)){
				mv = new ModelAndView("/user/survey_test2");
				return mv;
			}
		}catch(Exception e){//세션 널체크 해주어야함.. 임시처리...
			mv = new ModelAndView("/user/survey_test2");
			return mv;
		}

		mv = new ModelAndView("/user/survey/survey");
		Map<String, Object> surveyParams = new HashMap<String, Object>();
		surveyParams.put("surveyAnsMstSn",surveyAnsMstSn);
		surveyParams.put("operCd", operCd);
		surveyParams.put("orgCd",orgCd);
		surveyParams.put("surveySn",surveySn);
		Map<String, Object> surveyMaster = surveyService.selectSurveyMaster(surveyParams);
		
		
		List<Map<String, Object>> surveyQn = surveyService.selectSurveyQn(surveyParams);//질문 리스트
		List<Map<String, Object>> surveyEx = null;
		
		surveyEx = surveyService.selectSurveyExWithAnsTemp(surveyParams);//질문 보기

		List<Map<String, Object>> surveyQnEx = connectSurveyQnAndEx(surveyQn, surveyEx);//설문 질문
		List<Map<String, Object>> surveySubQnEx = connectSurveySubQnAndEx(surveyQnEx);//설문 서브질문
		
		mv.addObject("surveySubQnEx", surveySubQnEx);
		mv.addObject("surveyQnEx", surveyQnEx);
		mv.addObject("viewMode", "tempView");
		mv.addObject("surveyMaster", surveyMaster);
		return mv;
	}
	
}