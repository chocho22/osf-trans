package com.osf.sp.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import lombok.extern.slf4j.Slf4j;

@Repository
public class NaverTranslationDAO {

	@Resource
	private SqlSession ss;
	
	public List<Map<String,Object>> selectTranslationHisList() {
		return ss.selectList("com.osf.sp.mapper.NaverTranslationMapper.selectList");
	}
	
	public Map<String,Object> selectTranslationsHisOne(Map<String,String> param) {
		return ss.selectOne("com.osf.sp.mapper.NaverTranslationMapper.selectOne", param);
	}
	
	public int insertTranslationsHis(Map<String,String> param) {
		return ss.insert("com.osf.sp.mapper.NaverTranslationMapper.insertOne",param);
	}
	
	public int updateTranslationsHis(Map<String,Object> param) {
		return ss.update("com.osf.sp.mapper.NaverTranslationMapper.updateOne",param);
	}
	
	public List<Map<String,Object>> selectTransCodeList() {
		return ss.selectList("com.osf.sp.mapper.NaverTranslationMapper.selectTransCodeList");
	}
}
