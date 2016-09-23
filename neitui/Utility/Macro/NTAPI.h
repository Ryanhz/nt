//
//  neituiAPI.h
//  neituiDemo
//
//  Created by hzf on 16/6/24.
//  Copyright © 2016年 neitui. All rights reserved.
//

#ifndef NTAPI_h
#define NTAPI_h


//scheme：//host：port/path
#if DEBUG


#define api_scheme_host @"http://2016.neituidev.sinaapp.com/"

#else

#define api_scheme_host @"http://2016.neituidev.sinaapp.com/"


#endif

#define api_user_login                      [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=user&handle=login"]

#define api_user_findJobInfo                [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=user&handle=findJobInfo"] //设置个人基本数据

#define api_user_follow                     [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=user&handle=follow"] //获取内推人 / 添加关注

#define api_site_getcitylist                [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=site&handle=getcitylist"] //获取城市

#define api_job_searchjob                   [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=job&handle=searchjob"] //职位列表

#define api_job_jobdetail                   [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=job&handle=jobdetail"] //职位详情

#define api_user_followreferee              [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=user&handle=followreferee"] //我关注的--内推人列表

#define api_follow_companylist              [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=company&handle=getcomlist"] //我关注的—— 公司列表

#define api_company_getcominfo              [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=company&handle=getcominfo"] //cid 公司详情

#pragma mark ------------------------------简历部分----------start
/**
 *  简历展示
 *
 * @param uid 用户id
 *  @return return value description
 */
#define api_candidate_getcandidateinfos     [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=getcandidateinfos"] //简历展示

/**
 *  编辑新增模块
 *  @param id 模块编号
 *  @param uid 用户编号
 *  @param modulename 模块名称
 *  @param detail 详细描述
 *  @parem status 状态 删除 -1 正常1
 *  @return
 */
#define api_candidate_editcandidatemodules    [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=editcandidatemodules"] //编辑新增模块

/**
 *  编辑教育经历
 *  @param id 教育经历编号
 *  @param uid 用户编号
 *  @param sid school编号
 *  @param school 学校名称
 *  @param career 学历
 *  @param major 专业
 *  @param graduation 毕业年份
 *  @parem status 状态 删除 -1 正常1
 *  @return
 */
#define api_candidate_editcandidateedu   [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=editcandidateedu"] //编辑教育经历

/**
 *  编辑工作经历
 *  @param id 工作经历编号
 *  @param uid 用户编号
 *  @param company 公司
 *  @param position 职位
 *  @param dateend 截止时间
 *  @param datefrom 起始时间
 *  @param description 详细描述
 *  @parem status 状态 删除 -1 正常1
 *  @return
 */
#define api_candidate_editcandidateexps    [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=editcandidateexps"] //编辑工作经历

/**
 *  编辑项目经验
 *  @param id 项目经验编号
 *  @param uid 用户编号
 *  @param endfrom 截止时间
 *  @param datefrom 起始时间
 *  @param detail   详细描述
 *  @param shortdetail 项目简介
 *  @param description 详细描述
 *  @parem status 状态 删除 -1 正常1
 *  @return
 */
#define api_candidate_editcandidateproject   [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=editcandidateproject"] //编辑项目经验

/**
 *  编辑个人信息
 *
 *  @param uid 用户编号
 *  @param type 类型 ：1改user表， 2改candidate表
 *  @return
 */
#define api_candidate_editcandidateinfo   [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=editcandidateinfo"] //编辑个人信息

#pragma mark-----------简历部分---------end

#pragma mark----------内推人详情------start
/**
 * 内推人详情
 * 内推人职位列表
 * @param uid 用户编号
 * @param everypage 每页显示多少个
 * @param page 第几页
 * @return jobs 内推人职位信息
 * @return referee 内推人信息
 */
#define api_referee_show                    [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=referee&handle=show"] //内推人详情

/**
 * 内推人发布的职位列表
 * @param uid 内推人用户编号
 * @param everypage 每页显示多少个
 * @param page 第几页
 * @return jobs 内推人职位信息
 */
#define api_referee_refereejobs             [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=referee&handle=refereejobs"] //内推人发布的职位列表

/**
 * 内推人信息
 * @param uid 登陆用户编号
 * @param refereeid  内推人用户编号
 * @return refereeinfo 内推人信息
 * @return followstatus 关注状态
 */
#define api_referee_refereeinfo              [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=referee&handle=refereeinfo"] //内推人信息

#pragma mark----------内推人详情------end

/**
 *  获取简历投递记录
 *
 *  @param uid 用户编号
 *  @return deliverys
 */
#define api_candidate_getdeliveryrecord  [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=getdeliveryrecord"] //获取简历投递记录

/**
 *  获取职位收藏列表
 *  
 *  @param uid 用户编号
 *  @return jobs
 */
#define api_candidate_getjobcollectlist [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=getjobcollectlist"] //获取职位收藏列表

/**
 *  发送简历
 *
 *  @param uid 用户编号
 *  @param jid 投递职位编号
 *  @param touid 投递内推人编号
 *  @param type 投递类型： 0 附件简历，1在线简历
 */
#define api_candidate_delivery [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=candidate&handle=delivery"] //发送简历

/**
 * 收藏职位
 * @param jid 职位编号
 * @param uid 用户编号
 * @param status 关注状态（1关注，0不关注）
 * @return collect 操作成功以后的关注信息
 */
#define api_job_jobcollect [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=job&handle=jobcollect"] //职位收藏

/**
 * 职位下线删除
 * @param jid 职位编号
 * @param status 职位状态（-1下线，-3删除）0 待审核， 1 普通，2 推荐, -2 隐藏
 * @return collect 操作成功以后的关注信息
 */
#define api_job_jobChangeStatus [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php/?name=job&handle=jobChangeStatus"] // 改变职位信息

/**
 * 主页信息
 * @param uid 用户编号
 * @param page 第几页
 * @param everypage 每页有几组数据
 * @return allnews 所有新闻
 */
#define api_follow_follownews [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=follow&handle=follownews"] // 主页信息

/**
 * 热搜标签
 * @return hotsearch 热搜标签（数组）
 */
#define api_job_getHotSearch [NSString stringWithFormat:@"%@%@",api_scheme_host,@"api.php?name=job&handle=getHotSearch"] // 热搜标签


/**
 * 收到的简历
 * @param uid 登陆用户编号
 * @param type 简历类型（0：未读，已查看；3：已内推；4：已通知面试；-1：不通过）
 * @return condidates 简历信息
 */
#define api_referee_recieveCondidates [NSString stringWithFormat:@"%@%@",api_scheme_host, @"api.php?name=referee&handle=recievecondidates"] //收到的简历

/**
 * 内推人信息编辑
 * @param uid 登陆用户编号
 * @param realname 名字
 * @param position 职位
 * @return msg 返回信息
 */
#define api_referee_edit [NSString stringWithFormat:@"%@%@",api_scheme_host, @"api.php?name=referee&handle=edit"] // 内推人信息编辑

/**
 *  搜索人才
 *  @params click=1,keyword,city,min(工作年龄下限),max(工作年龄上限),page
 *
 *  @return candidateList
 */
#define api_candidate_search [NSString stringWithFormat:@"%@%@",api_scheme_host, @"api.php?name=candidate&handle=search"] // 搜索人才

#endif /* NTAPI_h */
