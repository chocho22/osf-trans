package com.osf.sp.controller;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Clob;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.osf.sp.dao.NaverTranslationDAO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NaverTranslationController {
	
	private Gson gson = new Gson();
	
	@Resource
	private NaverTranslationDAO ntdao;
	
	@GetMapping("/translations")
	public @ResponseBody List<Map<String,Object>> getTranslations() {
		List<Map<String,Object>> tList = ntdao.selectTranslationHisList();
		log.info("tList=>{}",tList);
		for(Map<String,Object> trans : tList) {
//			log.info("trans, th_tgtext=>{}",trans.get("TH_TGTEXT"));
			if(trans.get("TH_TGTEXT") instanceof Clob) {
				trans.put("TH_TGTEXT", clobtoString((Clob)trans.get("TH_TGTEXT")));
//				tList.add(trans);
				log.info("trans, th_tgtext=>{}",trans.get("TH_TGTEXT"));
			}
		}
		return tList;
	}
	
	@GetMapping("/transcode")
	public @ResponseBody List<Map<String,Object>> getTransCodeList() {
		List<Map<String,Object>> tcList = ntdao.selectTransCodeList();
		log.info("tcList=>{}",tcList);
		return tcList;
	}
	
	@GetMapping("/translation/{target}/{source}/{text}")
	public @ResponseBody Map<String,Object> doTranslation(@PathVariable("target") String target
			,@PathVariable("source") String source, @PathVariable("text") String text) {
		log.info("target=>{},source=>{},text=>{}"
				,new String[] {target,source,text});
		Map<String,String> param = new HashMap<>();
		param.put("target", target);
		param.put("source", source);
		param.put("text", text);
		Map<String,Object> rMap = ntdao.selectTranslationsHisOne(param);
		if(rMap==null) {
			// 번역한 다음 에러 검사하고 이상 없으면 저장
			rMap = translationTest(target,source,text);
			if(rMap.get("errorCode")!=null) {
				param.put("error", rMap.get("errorCode").toString());
				param.put("result", "");
			} else {
				param.put("error", "");
			}
			Map<String,Object> map2 = (Map)rMap.get("message");
			Map<String,Object> map3 = (Map)map2.get("result");
			String result = map3.get("translatedText").toString();
			param.put("result", ((Map)((Map)rMap.get("message")).get("result")).get("translatedText").toString());
			
//			log.info("translated text=>{}",rMap.get("text"));
			ntdao.insertTranslationsHis(param);
			rMap = ntdao.selectTranslationsHisOne(param);
			} else {
				log.info("rMap=>{}",rMap);
				ntdao.updateTranslationsHis(rMap);
			}
//		log.info("TH_TGTEXT=>{}",rMap.get("TH_TGTEXT"));
		if(rMap.get("TH_TGTEXT") instanceof Clob) {
			rMap.put("TH_TGTEXT", clobtoString((Clob)rMap.get("TH_TGTEXT")));
			log.info("instanceof Clob TH_TGTEXT=>{}",rMap.get("TH_TGTEXT"));
		}
		return rMap;
	}
	
	private String clobtoString(Clob data) {
		StringBuilder sb = new StringBuilder();
		Reader reader;
		try {
			reader = data.getCharacterStream();
			BufferedReader br = new BufferedReader(reader);
			String line;
			while(null != (line = br.readLine())) {
				sb.append(line);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sb.toString();
	}
	
	private Map<String,Object> translationTest(String target, String source, String text) {
		String clientId = "KLeO_pANGTC24OsJ0Gzu";//애플리케이션 클라이언트 아이디값";
        String clientSecret = "sXHrO_rB2h";//애플리케이션 클라이언트 시크릿값";
        try {
            text = URLEncoder.encode(text,"UTF-8");
            String apiURL = "https://openapi.naver.com/v1/papago/n2mt";
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("X-Naver-Client-Id", clientId);
            con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
            // post request
            String postParams = "source="+source+"&target="+target+"&text=" + text;
            con.setDoOutput(true);
            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if(responseCode==200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            ObjectMapper om = new ObjectMapper();
            br.close();
            Map<String,Object> rMap = om.readValue(response.toString(), Map.class);
            if(rMap.get("errorCode")!=null) {
            	
            }
            log.info("rMap=>{}",rMap);
            return rMap;
        } catch (Exception e) {
        	log.error("error=>{}",e);
        }
        return null;
	}
}
