//
//  NTNetHelper.h
//  neitui
//
//  Created by hzf on 16/7/19.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTFollowModel.h"
#import "NTCityModel.h"
#import "NTSearchJobParaModel.h"
#import "NTJobListModel.h"
#import "NTJobDetailModel.h"
#import "NTJobRefereeModel.h"

typedef void(^success) (id data);

typedef void(^netSuccess) (id data, NSDictionary *dic);

typedef void(^failure) (NSError *error);

@interface NTNetHelper : NSObject

/**
 *  获取推荐的内推人列表
 *
 *  @param user    当前用户
 *  @param success success blcok
 *  @param failure failure blcok
 */
+ (void)getReferenceListWithUser:(NTUser *)user success:(success)success failure:(failure)failure;

/**
 *  添加/取消关注内推人
 *
 *  @param followuid 内推人id
 *  @param type      关注（2）/取消关注（1）
 */
+ (void)followRefereesWithId:(NSString *)followuid type:(NSString *)type Success:(success)success failure:(failure)failure;

/**
 *  获取城市列表
 *
 *  @param success success description
 *  @param failure failure description
 */
+ (void)getCityListSuccess:(success)success failure:(failure)failure;

/**
 *  获取职位列表
 *
 *  @param paras   NTSearchJobParaModel
 *  @param success success description
 *  @param failure failure description
 */
+ (void)getJobWithParas:(NTSearchJobParaModel *)model Success:(success)success failure:(failure)failure;

/**
 *  获取职位详情
 *
 *  @param jobId   职位id
 *  @param success success description
 *  @param failure failure description
 */
+ (void)getjobDetailWithJobId:(NSString *)jobId  Success:(success)success failure:(failure)failure;


/**
 *  获取关注的内推人列表
 *
 *  @param success success description
 *  @param failure failure description
 */
+ (void)getFollowRefereeWithSuccess:(success)success failure:(failure)failure;

/**
 *  获取关注的公司列表
 *
 *  @param success success description
 *  @param failure failure description
 */

+ (void)getCompanyListWithSuccess:(success)success failure:(failure)failure;

/**
 *  获取公司详情信息
 *
 *  @param cid     公司id
 *  @param success success description
 *  @param failure failure description
 */
+ (void)getCompanyDetailWithCID:(NSString *)cid success:(success)success failure:(failure)failure;

/**
 *  获取内推人详情/主页
 *
 *  @param para    uid :内推人编号， everyPage ：每页显示多少个， page，第几页
 *  @param success jobs 内推人发布的职位，referee ： 内推人信息
 *  @param failure 失败信息
 */
+ (void)getRefereeDetailWithPara:(id)para Success:(success)success failure:(failure)failure;

/**
 * 内推人职位列表
 * @param uid 内推人用户编号
 * @param everypage 每页显示多少个
 * @param page 第几页
 * @return jobs 内推人职位信息
 */
+ (void)getRefereejobsWithPara:(id)para Success:(success)success failure:(failure)failure;

/**
 *  内推人信息
 *
 *  @param para    uid 登陆用户编号 refereeid  内推人用户编号
 *  @return refereeinfo 内推人信息
 *  @return followstatus 关注状态
 */
+ (void)getRefereeinfoWithPara:(id)para Success:(success)success failure:(failure)failure;

/**
 *  获取简历
 *
 *  @param uid     用户id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)getCandidateInfosWithuid:(NSString *)uid Success:(success)success failure:(failure)failure;

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
+ (void)editcandidateexpsWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure;

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
+ (void)editcandidateeduWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure;

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
+ (void)editcandidateprojectWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure;

/**
 *  编辑个人信息
 *
 *  @param uid 用户编号
 *  @param type 类型 ：1改user表， 2改candidate表
 *  @return
 */
+ (void)editcandidateinfoWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure;

/**
 *  获取简历投递记录
 *
 *  @param uid 用户编号
 *  @return deliverys
 */
+ (void)getdeliveryrecordWithSuccess:(success)success failure:(failure)failure;

/**
 *  获取职位收藏列表
 *
 *  @param uid 用户编号
 *  @return jobs
 */
+ (void)getjobcollectlistWithSuccess:(success)success failure:(failure)failure;

/**
 *  发送简历
 *
 *  @param uid 用户编号
 *  @param jid 投递职位编号
 *  @param touid 投递内推人编号
 *  @param type 投递类型： 0 附件简历，1在线简历
 */
+ (void)deliveryWithParam:(id)param Success:(success)success failure:(failure)failure;



/**
 * 收藏职位
 * @param jid 职位编号
 * @param uid 用户编号
 * @param status 关注状态（1关注，0不关注）
 * @return collect 操作成功以后的关注信息
 */
+ (void)jobcollectWithParam:(id)param Success:(success)success failure:(failure)failure;


/**
 * 职位下线删除
 * @param jid 职位编号
 * @param status 职位状态（-1下线，-3删除）0 待审核， 1 普通，2 推荐, -2 隐藏
 * @return collect 操作成功以后的关注信息
 */
+ (void)jobChangeStatusWithParam:(id)param Success:(success)success failure:(failure)failure;

/**
 * 主页信息
 * @param uid 用户编号
 * @param page 第几页
 * @param everypage 每页有几组数据
 * @return allnews 所有新闻
 */
+ (void)follownewsWithParam:(id)param Success:(success)success failure:(failure)failure;

/**
 * 热搜标签
 * @return hotsearch 热搜标签（数组）
 */
+ (void)getHotSearchWithSuccess:(success)success failure:(failure)failure;

/**
 * 收到的简历
 * @param uid 登陆用户编号
 * @param type 简历类型（0：未读，已查看；3：已内推；4：已通知面试；-1：不通过）
 * @return condidates 简历信息
 */
+ (void)recieveCondidatesWithParam:(id)param success:(success)success failure:(failure)failure;

/**
 * 内推人信息编辑
 * @param uid 登陆用户编号
 * @param realname 名字
 * @param position 职位
 * @return msg 返回信息
 */
+ (void)refereeEditWithParam:(id)param success:(success)success failure:(failure)failure;

/**
 *  搜索人才
 *
 *  @param param   click=1,,keyword,city,min(工作年龄下限),max(工作年龄上限),page
 *  @param success candidateList
 *  @param failure failure
 */
+ (void)candidateSearchWithParam:(id)param success:(success)success failure:(failure)failure;

@end
