//
//  NTNetHelper.m
//  neitui
//
//  Created by hzf on 16/7/19.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTNetHelper.h"
#import "Extend_Description.h"
#import "NTFollowModel.h"
#import "NTCityModel.h"
#import "NTSearchJobParaModel.h"
#import "NTJobListModel.h"
#import "NTJobDetailModel.h"
#import "NTJobRefereeModel.h"
#import "NTCompanyDetailModel.h"
#import "NTMy_FollowedRefereeModel.h"
#import "NTMy_FollowedRefereeList.h"
#import "NTMy_followedCompanyModel.h"
#import "NTMy_followedCompanyList.h"
#import "NTReferee_DetailModel.h"
#import "NSError+NetHelper.h"
#import "NTResumeModel.h"
#import "NTJob_NewsModel.h"
#import "NTCompany_NewsModel.h"
#import "NTCollectModel.h"
#import "NTDeliveryModel.h"
#import "NTRecieveCondidateModel.h"
#import "NTReferee_SearchResultModel.h"

@implementation NTNetHelper

+ (void)postWithURLString:(NSString *)URLString parameters:(id)parameters success:(netSuccess)success failure:(failure)failure {
    
    [NTNetworkHelper postWithURLString:URLString parameters:parameters success:^(id responseObject) {
//        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        DLog(@"jsonStr : %@",str);
        NSError *error = nil;;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        if ([dic[@"className"] isEqualToString: @"success"]) {
            if (success) {
                success(responseObject, dic);
            }
        } else {
            if (failure) {
                failure([NSError createError:dic]);
            }
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];

    
}

+ (void)getWithURLString:(NSString *)URLString parameters:(id)parameters success:(netSuccess)success failure:(failure)failure {
    
    [NTNetworkHelper postWithURLString:URLString parameters:parameters success:^(id responseObject) {
        
        NSError *error = nil;;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        if ([dic[@"className"] isEqualToString: @"success"]) {
            if (success) {
                success(responseObject, dic);
            }
        } else {
            if (failure) {
                failure([NSError createError:dic]);
            }
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


#pragma mark------------------------- 获取推送的内推人


+ (void)loginWithParam:(id)param success:(success)success failure:(failure)failure {
    
}

+ (void)getReferenceListWithUser:(NTUser *)user success:(success)success failure:(failure)failure{
    NSDictionary *dic = @{
                          @"uid":@1,
                          @"sid" : @"",
                          @"cid" : @""
                          };
    [self postWithURLString:api_user_follow parameters:dic success:^(id responseObject, NSDictionary *dic) {
        
        DLog(@"%@",dic);
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSArray * referees = dic[@"referees"];
        for (int i = 0; i < referees.count; i++) {
            NSError *error = nil;;
            NTFollowModel *model = [[NTFollowModel alloc]initWithDictionary:referees[i] error:&error];
            if (!error) {
                [array addObject:model];
            } else {
                DLog(@"error: %@",error);
            }
        }
        success(array);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------关注 / 取消关注内推人
+ (void)followRefereesWithId:(NSString *)followuid type:(NSString *)type Success:(success)success failure:(failure)failure {
    NSDictionary *dic = @{
                          @"uid":@1,
                          @"followuid": followuid,
                          @"click":@"1",
                          @"type":type
                          };
    [self postWithURLString:api_user_follow parameters:dic success:^(id responseObject, NSDictionary *dic) {

        DLog(@"%@",dic);
         success(dic);

    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------城市列表

+ (void)getCityListSuccess:(success)success failure:(failure)failure {
    
    [self getWithURLString:api_site_getcitylist parameters:nil success:^(id responseObject, NSDictionary *dic) {
        
       DLog(@"%@",dic);
        NSArray * city = dic[@"city"];
        
        if (![city isKindOfClass:[NSArray class]]) {
            NSError *error = [[NSError alloc]initWithDomain:@"数组为空" code:0 userInfo:nil];
            
            failure(error);
            return ;
        }
        
        NSArray *array = [self siftCity:city];
        success(array);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


+ (NSArray *)siftCity:(NSArray *)citys {
    NSMutableArray *citylist = [NSMutableArray array];
    NSMutableArray *hotlist = [NSMutableArray array];
    NSMutableArray *abcdef = [NSMutableArray array];
    NSMutableArray *ghij = [NSMutableArray array];
    NSMutableArray *klmn = [NSMutableArray array];
    NSMutableArray *opqr = [NSMutableArray array];
    NSMutableArray *stuv = [NSMutableArray array];
     NSMutableArray *wxyz = [NSMutableArray array];

    for (int i = 0; i< citys.count; i++) {
        NSError *error;
        NTCityModel *model = [[NTCityModel alloc]initWithDictionary:citys[i] error:&error];
        if (!error) {
            if(model.hot == 1){
                [hotlist addObject:model];
            } else {
                NSString *name = model.name;
                if (name == nil || [name isEqualToString: @""]) {
                    continue;
                }
                char pinyin = pinyinFirstLetter([name characterAtIndex:0]);
                
                if (pinyin == 'a' || pinyin == 'b' || pinyin == 'c' ||pinyin ==  'd' || pinyin ==  'e' || pinyin ==  'f') {
                    DLog(@"%@:_____%c",name,pinyin);
                    [abcdef addObject:model];
                }
                //abcdef ghij klmn opqr stuv wxyz
                if (pinyin == 'g' || pinyin ==  'h' || pinyin ==  'i' || pinyin ==  'j') {
                    [ghij addObject:model];
                    continue;
                }
                
                if (pinyin == 'k' || pinyin == 'l' || pinyin == 'm' || pinyin == 'n') {
                    [klmn addObject:model];
                    continue;
                }
                
                if (pinyin == 'o' || pinyin == 'p' || pinyin == 'q' || pinyin == 'r') {
                    [opqr addObject:model];
                    continue;
                }
                
                if (pinyin == 's' || pinyin == 't' || pinyin == 'u' || pinyin == 'v') {
                    [stuv addObject:model];
                    continue;
                }
                
                if (pinyin == 'w' || pinyin == 'x' || pinyin == 'y' || pinyin == 'z') {
                    [wxyz addObject:model];
                    continue;
                }
                
            }
        }
            
    }
    [citylist addObject:hotlist];
    [citylist addObject:abcdef];
    [citylist addObject:ghij];
    [citylist addObject:klmn];
    [citylist addObject:opqr];
    [citylist addObject:stuv];
    [citylist addObject:wxyz];
    
    return citylist;
}

#pragma mark-------------------------职位列表

+ (void)getJobWithParas:(NTSearchJobParaModel *)paras Success:(success)success failure:(failure)failure {
    
    NSDictionary *dic = [paras toDictionary];
    DLog(@"paras----:%@", dic);
    [self postWithURLString:api_job_searchjob parameters:dic success:^(id responseObject, NSDictionary *dic) {
     
        DLog(@"%@",dic);
        NSMutableArray *array = [NSMutableArray array];
        NSArray *job = dic[@"job"];
        
        if (! [job isKindOfClass:[NSArray class]]) {
            
            NSError *error = [[NSError alloc]initWithDomain:@"数组为空" code:0 userInfo:nil];
            
            failure(error);
            return ;
        }
    
        
        [job enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
            NSError *error = nil;;
            NTJobListModel *model = [[NTJobListModel alloc] initWithDictionary:obj error:&error];
            if (!error) {
                [array addObject:model];
            }
        }];
    
        success(array);
        
    } failure:^(NSError *error) {
        failure(error);
        
    }];
    
    
}

#pragma mark-------------------------职位详情

+ (void)getjobDetailWithJobId:(NSString *)jobId  Success:(success)success failure:(failure)failure {
    NSDictionary *dic = @{@"jid": jobId};
    
    [self postWithURLString:api_job_jobdetail parameters:dic success:^(id responseObject, NSDictionary *dic) {
    
        NSArray *array = nil;
        DLog(@"%@",dic);
        NSError *error1 = nil;;
        NSError *error2 = nil;;
            
        NTJobRefereeModel *refereeModel = [[NTJobRefereeModel alloc] initWithDictionary:dic[@"referee"] error:&error1];
        NTJobDetailModel *jobDetailModel = [[NTJobDetailModel alloc] initWithDictionary:dic[@"job"] error:&error2];
        if (error1 || error2) {
            failure(error2);
            failure(error1);
            return ;
        }
        array = @[jobDetailModel, refereeModel,dic[@"follow"]];
        success(array);
  
       
        
       
    } failure:^(NSError *error) {
         failure(error);
    }];
}

#pragma mark-------------------------我关注的______内推人列表

+ (void)getFollowRefereeWithSuccess:(success)success failure:(failure)failure {
   
    NSDictionary *dic = @{@"uid" : @"2"};
    
    [self postWithURLString:api_user_followreferee parameters:dic success:^(id responseObject, NSDictionary *dic) {
        NSError *error = nil;;

        DLog(@"%@",dic);
  
        NTMy_FollowedRefereeList *model = [[NTMy_FollowedRefereeList alloc]initWithDictionary:dic error:&error];
            
        if (error) {
            failure(error);
        } else {
            success(model);
        }

    } failure:^(NSError *error) {
       failure(error);
    }];
}

#pragma mark-------------------------公司详情
+ (void)getCompanyDetailWithCID:(NSString *)cid success:(success)success failure:(failure)failure {
    NSDictionary *dic = @{@"cid" : cid};
    [self postWithURLString:api_company_getcominfo parameters:dic success:^(id responseObject, NSDictionary *dic) {
        NSError *error;

        DLog(@"%@",dic);

        NTCompanyDetailModel *model = [[NTCompanyDetailModel alloc] initWithDictionary:dic error:&error];
        if (error) {
            failure(error);
                
        } else {
            success(model);
        }
   
    } failure:^(NSError *error) {
       failure(error);
    }];
}

#pragma mark-------------------------我关注的______公司列表

+ (void)getCompanyListWithSuccess:(success)success failure:(failure)failure {
    NSDictionary *dic = @{ @"uid" : @"3" };
    
    [self postWithURLString:api_follow_companylist parameters:dic success:^(id responseObject, NSDictionary *dic) {
        NSError *error = nil;;
        DLog(@"%@",dic);

        NTMy_followedCompanyList *list = [[NTMy_followedCompanyList alloc]initWithDictionary:dic error:&error];
            
        if (error) {
            failure(error);
            return ;
        }
        else {
            success(list);
        }

    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------内推人详情/主页 暂不使用

+ (void)getRefereeDetailWithPara:(id)para Success:(success)success failure:(failure)failure {
    
    [self postWithURLString:api_referee_show parameters:para success:^(id responseObject, NSDictionary *dic) {


        DLog(@"%@",dic);
        
    } failure:^(NSError *error) {
       failure(error);
    }];
}

#pragma mark-------------------------内推人发布的职位列表

+ (void)getRefereejobsWithPara:(id)para Success:(success)success failure:(failure)failure {
    
    [self postWithURLString:api_referee_refereejobs parameters:para success:^(id responseObject, NSDictionary *dic) {

        DLog(@"%@",dic);
        
        NSMutableArray *array = [NSMutableArray array];
            
        NSArray *job = dic[@"jobs"];
        
        if (![job isKindOfClass:[NSArray class]]) {
            NSError *error = [[NSError alloc]initWithDomain:@"数组为空" code:0 userInfo:nil];
            
            failure(error);
            return ;
        }
        
        [job enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
            NSError *error = nil;;
            NTJobListModel *model = [[NTJobListModel alloc] initWithDictionary:obj error:&error];
            if (error == nil) {
                [array addObject:model];
            }
        }];
    
        success(array);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------内推人信息

+ (void)getRefereeinfoWithPara:(id)para Success:(success)success failure:(failure)failure {
    
    [self postWithURLString:api_referee_refereeinfo parameters:para success:^(id responseObject, NSDictionary *dic) {
        
                NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                DLog(@"jsonStr : %@",str);
        NSError *error = nil;;
     
        NTReferee_DetailModel *model = [[NTReferee_DetailModel alloc]initWithData:responseObject error:&error];
        if (error) {
            failure(error);
        }
        else {
            success(model);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------简历
+ (void)getCandidateInfosWithuid:(NSString *)uid Success:(success)success failure:(failure)failure {
    NSDictionary *param = @{@"uid" : uid};
    
    [self postWithURLString:api_candidate_getcandidateinfos parameters:param success:^(id responseObject, NSDictionary *dic) {
                NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                DLog(@"jsonStr : %@",str);
//        DLog(@"%@",dic);
        NSError *error = nil;
//        NTResumeModel *model = [[NTResumeModel alloc]initWithDictionary:dic error:&error];
//        if (!error) {
//            success(model);
//        } else {
//            failure(error);
//        }
        if (![dic[@"candidate_expses"] isKindOfClass:[NSArray class]] || ![dic[@"candidate_projects"] isKindOfClass:[NSArray class]] || ![dic[@"candidate_modules"] isKindOfClass:[NSArray class]]|| ![dic[@"candidate_edus"] isKindOfClass:[NSArray class]]) {
            
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            mutableDic[@"candidate_expses"] = [dic[@"candidate_expses"] isKindOfClass:[NSArray class]] ? dic[@"candidate_expses"] : @[];
            mutableDic[@"candidate_projects"] = [dic[@"candidate_projects"] isKindOfClass:[NSArray class]] ? dic[@"candidate_projects"] : @[];
            mutableDic[@"candidate_modules"] = [dic[@"candidate_modules"] isKindOfClass:[NSArray class]] ? dic[@"candidate_modules"] : @[];
            mutableDic[@"candidate_edus"] = [dic[@"candidate_edus"] isKindOfClass:[NSArray class]] ? dic[@"candidate_edus"] : @[];

            NTResumeModel *model = [[NTResumeModel alloc]initWithDictionary:mutableDic error:&error];
            if (!error) {
                success(model);
            } else {
                failure(error);
            }
            
        } else {
            NTResumeModel *model = [[NTResumeModel alloc]initWithDictionary:dic error:&error];
            if (!error) {
                success(model);
            } else {
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        failure(error);
    }];

}

#pragma mark-------------------------编辑工作经历
+ (void)editcandidateexpsWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure {
    
    [self postWithURLString:api_candidate_editcandidateexps parameters:param success:^(id responseObject, NSDictionary *dic) {
        
       success(dic);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

#pragma mark-------------------------编辑教育经历
+ (void)editcandidateeduWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure {
    
    [self postWithURLString:api_candidate_editcandidateedu parameters:param success:^(id responseObject, NSDictionary *dic) {
        
        success(dic);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

#pragma mark-------------------------编辑项目经历
+ (void)editcandidateprojectWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure {
    
    [self postWithURLString:api_candidate_editcandidateproject parameters:param success:^(id responseObject, NSDictionary *dic) {
        
        success(dic);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

#pragma mark-------------------------编辑个人信息
+ (void)editcandidateinfoWithParam:(NSDictionary *)param Success:(success)success failure:(failure)failure {
    
    [self postWithURLString:api_candidate_editcandidateinfo parameters:param success:^(id responseObject, NSDictionary *dic) {
        
        success(dic);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

#pragma mark-------------------------职位收藏列表

+ (void)getjobcollectlistWithSuccess:(success)success failure:(failure)failure {
    NSDictionary *param = @{@"uid": @"1"};
    
    [self postWithURLString:api_candidate_getjobcollectlist parameters:param success:^(id responseObject, NSDictionary *dic) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        DLog(@"jsonStr : %@",str);
        
        NSError *error = nil;
        NTCollectModel *model = [[NTCollectModel alloc]initWithDictionary:dic[@"jobs"] error:&error];
        if (!error) {
            success(model);
        } else {
            failure(error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------简历投递记录
+ (void)getdeliveryrecordWithSuccess:(success)success failure:(failure)failure  {
    NSDictionary *param = @{@"uid": @"1"};
    [self postWithURLString:api_candidate_getdeliveryrecord parameters:param success:^(id responseObject, NSDictionary *dic) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        DLog(@"jsonStr : %@",str);
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSArray *deliverys = dic[@"deliverys"];
        
        if(![deliverys isKindOfClass:[NSArray class]]){
            NSError *error = [[NSError alloc]initWithDomain:@"数组为空" code:0 userInfo:nil];
            
            failure(error);
            
            return ;
        }
        
        [deliverys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             NSError *error =  nil;
             NTDeliveryModel *model = [[NTDeliveryModel alloc]initWithDictionary:obj error:&error];
            
            if (!error) {
                [mutableArray addObject:model];
            }
        }];
        
        success(mutableArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------发送简历
+ (void)deliveryWithParam:(id)param Success:(success)success failure:(failure)failure {
    [self postWithURLString:api_candidate_delivery parameters:param success:^(id responseObject, NSDictionary *dic) {
        
        success(dic);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------收藏职位
+ (void)jobcollectWithParam:(id)param Success:(success)success failure:(failure)failure {
    [self postWithURLString:api_job_jobcollect parameters:param success:^(id responseObject, NSDictionary *dic) {
//        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        DLog(@"jsonStr : %@",str);
        success(dic);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------改版职位状态 内推人

+ (void)jobChangeStatusWithParam:(id)param Success:(success)success failure:(failure)failure {
    [self postWithURLString:api_job_jobChangeStatus parameters:param success:^(id responseObject, NSDictionary *dic) {
        
        success(dic);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------主页信息

+ (void)follownewsWithParam:(id)param Success:(success)success failure:(failure)failure {
    [self postWithURLString:api_follow_follownews parameters:param success:^(id responseObject, NSDictionary *dic) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        DLog(@"jsonStr : %@",str);
        NSMutableArray *news = [NSMutableArray array];
        NSArray *allNews = dic[@"allnews"];
        if ([allNews isKindOfClass:[NSArray class]]) {
            [allNews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                
                NSError *error = nil;
                if ([dic[@"type"] isEqualToString:@"1"]) { //job
                    NTJob_NewsModel *model = [[NTJob_NewsModel alloc]initWithDictionary:dic error:&error];
                    if (!error) {
                        [news addObject:model];
                    }
                }
                
                if ([dic[@"type"] isEqualToString:@"2"]) { // company
                    NTCompany_NewsModel *model = [[NTCompany_NewsModel alloc] initWithDictionary:dic error:&error];
                    if (!error) {
                        [news addObject:model];
                    }
                }
            }];
               success(news);
        } else {
            NSError *error = [[NSError alloc]initWithDomain:@"数组为空" code:0 userInfo:nil];
            
            failure(error);
        }
        
     
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark------------------------- 热搜标签
+ (void)getHotSearchWithSuccess:(success)success failure:(failure)failure {
    
    [self getWithURLString:api_job_getHotSearch parameters:nil success:^(id data, NSDictionary *dic) {
        success(dic);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------内推人-----收到的简历
+ (void)recieveCondidatesWithParam:(id)param success:(success)success failure:(failure)failure {
    [self postWithURLString:api_referee_recieveCondidates parameters:param success:^(id data, NSDictionary *dic) {
//        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        DLog(@"jsonStr : %@",str);
        NSArray *array = dic[@"condidates"];
        NSMutableArray *condidates = [NSMutableArray array];
        
        if (![array isKindOfClass:[NSArray class]]) {
       
            NSError *error = [[NSError alloc]initWithDomain:@"数组为空" code:0 userInfo:nil];
            
            failure(error);
            return ;
        }
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSError *error = nil;
            
            NTRecieveCondidateModel *model = [[NTRecieveCondidateModel alloc]initWithDictionary:obj error:&error];
            
            if (!error) {
                [condidates addObject:model];
            }
        }];
        success(condidates);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------内推人信息编辑
+ (void)refereeEditWithParam:(id)param success:(success)success failure:(failure)failure {
    [self postWithURLString:api_referee_recieveCondidates parameters:param success:^(id data, NSDictionary *dic) {
        //        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //        DLog(@"jsonStr : %@",str);
        NSArray *array = dic[@"condidates"];
        NSMutableArray *condidates = [NSMutableArray array];
        
        if (![array isKindOfClass:[NSArray class]]) {
            
            NSError *error = [[NSError alloc]initWithDomain:@"数组为空" code:0 userInfo:nil];
            
            failure(error);
            return ;
        }
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSError *error = nil;
            
            NTRecieveCondidateModel *model = [[NTRecieveCondidateModel alloc]initWithDictionary:obj error:&error];
            
            if (!error) {
                [condidates addObject:model];
            }
        }];
        success(condidates);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark-------------------------搜索人才
+ (void)candidateSearchWithParam:(id)param success:(success)success failure:(failure)failure {
    [self postWithURLString:api_candidate_search parameters:param success:^(id data, NSDictionary *dic) {
                NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                DLog(@"jsonStr : %@",str);
        
        NSDictionary *msg = dic[@"msg"];
     
        if (msg && [msg isKindOfClass:[NSDictionary class]]) {
            NSArray *result = msg[@"result"];
            if (!result || ![result isKindOfClass:[NSArray class]]) {
                success(nil);
                return;
            }
            
            NSError *error = nil;
              NTReferee_SearchResultModel *model = [[NTReferee_SearchResultModel alloc] initWithDictionary:msg error:&error];
            if (error) {
                failure(error);
                return ;
            }
            success(model);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
