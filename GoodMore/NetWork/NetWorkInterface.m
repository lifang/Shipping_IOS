//
//  NetWorkInterface.m
//  GoodMore
//
//  Created by lihongliang on 15/5/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "NetWorkInterface.h"

static NSString *HTTP_POST = @"POST";
static NSString *HTTP_GET = @"GET";

@implementation NetWorkInterface

+ (void)requestWithURL:(NSString *)urlString
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)method
              finished:(requestDidFinished)finish {
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:method
                                                                finished:finish];
    NSLog(@"url = %@,params = %@",urlString,params);
    if ([method isEqualToString:HTTP_POST] && params) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:postData];
    }
    [request start];
}


//注册
+(void)registerWithLoginName:(NSString*)loginName pwd:(NSString*)pwd shipName:(NSString*)shipName shipNumber:(NSString*)shipNumber phone:(NSString*)phone dentCode:(NSString*)dentCode volume:(NSString*)volume finished:(requestDidFinished)finish
{
    //参数
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:loginName forKey:@"loginName"];
    NSString *encryptPwd=[EncryptHelper MD5_encryptWithString:pwd];
    [paramDic setObject:encryptPwd forKey:@"pwd"];
    [paramDic setObject:shipName forKey:@"name"];
    [paramDic setObject:phone forKey:@"phone"];
    [paramDic setObject:volume forKey:@"volume"];
    [paramDic setObject:shipNumber forKey:@"shipNumber"];
    [paramDic setObject:dentCode forKey:@"dentCode"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,register_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//验证码(注册)
+(void)sendCodeWith:(NSString*)phone finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:phone forKey:@"phone"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,sendCode_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}
//发送验证码 (找回密码)
+(void)sendForPwdWithPhone:(NSString*)phone finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:phone forKey:@"phone"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,sendForPwd_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}
//登录
+(void)loginWithLoginName:(NSString*)loginName pwd:(NSString*)pwd finished:(requestDidFinished)finsh
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:loginName forKey:@"loginName"];
    NSString*encryptPwd=[EncryptHelper MD5_encryptWithString:pwd];
    [paramDic setObject:encryptPwd forKey:@"pwd"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,login_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finsh];
}
+ (void)checkVersionFinished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:kAppVersionType] forKey:@"types"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,updataApp_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}


//任务大厅
//如果获取定位失败，则mLat1,mLon1传0值
+(void)getOrderListWithPage:(int)page status:(int)status keys:(NSString*)keys mLat1:(double)mLat1 mLon1:(double)mLon1 finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [paramDic setObject:keys forKey:@"keys"];
    [paramDic setObject:[NSNumber numberWithDouble:mLat1]  forKey:@"mLat1"];
    [paramDic setObject:[NSNumber numberWithDouble:mLon1]  forKey:@"mLon1"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,orderList_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//我的任务
+(void)myTaskListWithPage:(int)page status:(int)status shipOwerId:(int)shipOwerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,myTask_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//货单详情
+(void)OrderDetailWithID:(int)ID loginId:(int)loginId finished:(requestDidFinished)finish
{
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:ID] forKey:@"id"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,orderDetail_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//绑定船老大与货单列表
+(void)bindOrderWithloginId:(int)loginId ordersList:(NSString*)ordersList finished:(requestDidFinished)finish
{
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:ordersList forKey:@"ordersList"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,bindOerder_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}

//验证验证码是否正确
+(void)testdentCodeWithloginName:(NSString*)loginName dentCode:(NSString*)dentCode finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:loginName forKey:@"loginName"];
    [paramDic setObject:dentCode forKey:@"dentCode"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,testDentCode_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//设置新密码
+(void)setNewPwdWithloginName:(NSString*)loginName oldPwd:(NSString*)oldPwd pwd:(NSString*)pwd finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
     NSString *encryptPwd=[EncryptHelper MD5_encryptWithString:pwd];
    NSString *encryptOldPwd=nil;
    if (![oldPwd isEqualToString:@""])
    {
        encryptOldPwd=[EncryptHelper MD5_encryptWithString:oldPwd];
    }else
    {
        encryptOldPwd=oldPwd;
    }
    
    [paramDic setObject:loginName forKey:@"loginName"];
    [paramDic setObject:encryptOldPwd forKey:@"oldPwd"];
    [paramDic setObject:encryptPwd forKey:@"pwd"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,setNewPwd_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}
//保存船坐标
+(void)recordCoordinateWithshipOwerId:(int)shipOwerId loginId:(int)loginId coordinate:(NSString*)coordinate finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipOwerId] forKey:@"shipOwnerId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:coordinate forKey:@"coordinate"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,recordCoorddinate_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//可提现列表
+(void)availblePayWithshipOwerId:(int)shipOwerId page:(int)page finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipOwerId] forKey:@"shipOwnerId"];
    [paramDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,availblePay_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//未支付运费列表
+(void)noPaylistWithshipOwerId:(int)shipOwerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipOwerId] forKey:@"shipOwnerId"];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,noPay_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}
//货运公司支付列表
+(void)payRecordListWithCargoId:(int)cargoId shipOwerId:(int)shipOwerId page:(int)page cargoName:(NSString*)cargoName finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:cargoId] forKey:@"cargoId"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwerId] forKey:@"shipOwnerId"];
    [paramDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDic setObject:cargoName forKey:@"cargoName"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,noPatDetail_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//扣除手续费可提金额
+(void)checkGetCashWithmoneyNum:(int)moneyNum finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:moneyNum] forKey:@"moneyNum"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,checkGetCash_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//获得支持的银行列表
+(void)getBanksListfinished:(requestDidFinished)finish
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getBanksList_method];
    [[self class] requestWithURL:urlString params:nil httpMethod:HTTP_POST finished:finish];
}
//获得省列表
+(void)getProvinceListfinished:(requestDidFinished)finish
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getProvinceList_method];
    [[self class] requestWithURL:urlString params:nil httpMethod:HTTP_POST finished:finish];
}
//获得省的子级城市列表
+(void)getCityListWithID:(int)ID finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:ID] forKey:@"id"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getCityList_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
+(void)getCashWithshipOwerId:(int)shipOwnerId cashNum:(int)cashNum provinceCity:(NSString*)provinceCity bankName:(NSString*)bankName kuaihuhang:(NSString*)kuaihuhang creditName:(NSString*)creditName bankCardNumber:(NSString*)bankCardNumber finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    [paramDic setObject:[NSNumber numberWithInt:cashNum] forKey:@"cashNum"];
    [paramDic setObject:provinceCity forKey:@"provinceCity"];
    [paramDic setObject:bankName forKey:@"bankName"];
    [paramDic setObject:kuaihuhang forKey:@"kuaihuhang"];
    [paramDic setObject:creditName forKey:@"creditName"];
    [paramDic setObject:bankCardNumber forKey:@"bankCardNumber"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getCash_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//刷新查询提现
+(void)getRefreshWithorderId:(NSString*)orderId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:orderId forKey:@"orderId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getRefresh_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
@end
