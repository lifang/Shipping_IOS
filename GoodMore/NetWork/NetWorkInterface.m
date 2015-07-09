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
+(void)registerWithLoginName:(NSString*)loginName pwd:(NSString*)pwd name:(NSString*)name  phone:(NSString*)phone  dentCode:(NSString*)dentCode  joinCode:(NSString*)joinCode  finished:(requestDidFinished)finish
{
    //参数
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:loginName forKey:@"loginName"];
    NSString *encryptPwd=[EncryptHelper MD5_encryptWithString:pwd];
    [paramDic setObject:encryptPwd forKey:@"pwd"];
    [paramDic setObject:name forKey:@"name"];
    
    [paramDic setObject:phone forKey:@"phone"];
    
    [paramDic setObject:dentCode forKey:@"dentCode"];
    
    [paramDic setObject:joinCode forKey:@"joinCode"];
    
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
+(void)getOrderListWithPage:(int)page status:(int)status keys:(NSString*)keys mLat1:(double)mLat1 mLon1:(double)mLon1 portId:(int)portId distance:(NSString*)distance finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [paramDic setObject:keys forKey:@"keys"];
    [paramDic setObject:[NSNumber numberWithDouble:mLat1]  forKey:@"mLat1"];
    [paramDic setObject:[NSNumber numberWithDouble:mLon1]  forKey:@"mLon1"];
    [paramDic setObject:[NSNumber numberWithDouble:portId]  forKey:@"portId"];
    [paramDic setObject:distance forKey:@"distance"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,orderList_method];
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
    [paramDic setObject:kuaihuhang forKey:@"kaihuhang"];
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
//单张图片上传
+(void)uploadSingleImageWithImage:(UIImage*)image loginId:(NSString*)loginId finished:(requestDidFinished)finish
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",KServiceURL,uploadSingleImage_method,loginId];
    NSLog(@"-------%@",urlString);
    NetworkRequest *request=[[NetworkRequest alloc]initWithRequestURL:urlString httpMethod:HTTP_POST finished:finish];
    [request uploadImageData:UIImagePNGRepresentation(image) imageName:nil key:@"img"];
    [request start];
}

//多张图片上传
+(void)uploadManyImageWithloginId:(NSString*)loginId finished:(requestDidFinished)finish
{
    
}
//加入船队
+(void)joinTeamWithCode:(NSString*)code loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:code forKey:@"code"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,joinTeam_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//组队接单
+(void)makeTeamWithorderId:(int)orderId loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:orderId] forKey:@"orderId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,makeTeam_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//船队列表
+(void)getshipTeamListWithPage:(int)page status:(int)status shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getShipTeamList_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//货物运输
+(void)getGoodsTransportListWithPage:(int)page status:(int)status shipOwerId:(int)shipOwerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getGoodsList_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//船队详情
+(void)getShipTeamDetailWithloginId:(int)loginId ID:(int)ID finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:[NSNumber numberWithInt:ID] forKey:@"id"];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,getShipTeamDetail_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//解散船队
+(void)breakshipTeamWithshipTeamId:(int)shipTeamId loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipTeamId] forKey:@"shipTeamId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,breakShipTeam_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//船队抢单
+(void)shipTeamGetOrderWithshipTeamId:(int)shipTeamId loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipTeamId] forKey:@"shipTeamId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,shipTeamGetOrder_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//删除船
+(void)deleteShipFromTeamWithshipTeamId:(int)shipTeamId loginId:(int)loginId delShipId:(int)delShipId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipTeamId] forKey:@"shipTeamId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:[NSNumber numberWithInt:delShipId] forKey:@"delShipId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,deleteFromTeam_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//分配船队运费
+(void)setPayEveryShipWithshipTeamId:(int)shipTeamId loginId:(int)loginId shipSetStr:(NSString*)shipSetStr finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipTeamId] forKey:@"shipTeamId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:shipSetStr forKey:@"shipSetStr"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,setPayEveryShip_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//装货吨位设置
+(void)upInAccountWithID:(int)ID inAccount:(int)inAccount loginId:(int)loginId imgUrlList:(NSString*)imgUrlList finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:ID] forKey:@"id"];
    [paramDic setObject:[NSNumber numberWithInt:inAccount] forKey:@"inAccount"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:imgUrlList forKey:@"imgUrlList"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,upInAccount_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//卸货吨位设置
+(void)upOutAccountWithID:(int)ID inAccount:(int)outAccount loginId:(int)loginId imgUrlList:(NSString*)imgUrlList finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:ID] forKey:@"id"];
    [paramDic setObject:[NSNumber numberWithInt:outAccount] forKey:@"outAccount"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:imgUrlList forKey:@"imgUrlList"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,upOutAccount_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//升级为高级船
+(void)upShipWithshipId:(int)shipId loginId:(int)loginId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipId] forKey:@"shipId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,upShip_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}

//获取船队详细列表
+(void)shipMakeTeamWithLoginId:(int)loginId finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,shipMakeTeam_methd];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}

+(void)joinInTeamWithLoginId:(int)loginId Code:(NSString *)code ShipOwnID:(int)shipOwnId Quote:(int)quote finished:(requestDidFinished)finish {
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    [paramDic setObject:code forKey:@"code"];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnId] forKey:@"shipOwnerId"];
    [paramDic setObject:[NSNumber numberWithInt:quote] forKey:@"quote"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,shipInTeam_methd];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
//单船竞价
+(void)singleShipCompletWithshipOwnerId:(int)shipOwnerId bsOrderId:(int)bsOrderId loginId:(int)loginId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    [paramDic setObject:[NSNumber numberWithInt:bsOrderId] forKey:@"bsOrderId"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,singleShipComplete_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}
//消息列表
+(void)getMessageListWithshipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:shipOwnerId] forKey:@"shipOwnerId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,messageList_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}
//批量更新消息为已读
+(void)uploadMessageStausWithStatus:(int)status loginId:(int)loginId idStr:(NSString*)idStr finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [paramDic setObject:idStr forKey:@"idStr"];
    [paramDic setObject:[NSNumber numberWithInt:loginId] forKey:@"loginId"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,uploadMessageStatus_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];

}
//删除消息
+(void)deleteMessageWithID:(int)ID finished:(requestDidFinished)finish
{
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:[NSNumber numberWithInt:ID] forKey:@"id"];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KServiceURL,deleteMessage_method];
    [[self class] requestWithURL:urlString params:paramDic httpMethod:HTTP_POST finished:finish];
}
@end
