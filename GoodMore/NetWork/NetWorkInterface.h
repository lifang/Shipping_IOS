//
//  NetWorkInterface.h
//  GoodMore
//
//  Created by lihongliang on 15/5/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//


typedef enum {
    RequestTokenOverdue = -3,   //token失效
    RequestShortInventory = -2, //库存不足
    RequestFail = -1,           //请求错误
    RequestSuccess = 1,         //请求成功
}RequestCode;

typedef enum {
   
    ShipTeamStatusAll=-1,        //全部
    ShipTeamStatusMaking=0,      //组队中
    ShipTeamStatusMakeSuccess=1, //组队成功
    ShipTeamStatusMakeFail=2,    //组队失败
    ShipTeamStatusPayfreight=3,  //计算运费
    ShipTeamStatusFinished=4,    //完成
}ShipTeamStatus;

typedef enum{
    
    GoodsTransportStatusAll=-1,         //全部
    GoodsTransportStatusMaking=0,       //组队中
    GoodsTransportStatusMakeFail=1,     //组队失败
    GoodsTransportStatusPerforming=2,   //执行中
    GoodsTransportStatusFinish=3,       //完成
}GoodsTransportStatus;

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "NetworkRequest.h"
#import "EncryptHelper.h"
//到达装/卸货港签到
static NSString *s_sign_method = @"app/shipBusiness/arrive";
//运输中信息
static NSString *s_details_method = @"app/shipBusiness/getTransIng";
//注册
static NSString *register_method = @"app/addNewShip";

//发送验证码(注册)
static NSString *sendCode_method = @"common/sendPhoneVerificationCodeReg";

//发送验证码(找回密码)
static NSString *sendForPwd_method = @"common/sendPhoneVerificationCodePwd";

//验证手机验证码是否正确(找回密码)
static NSString *testDentCode_method = @"app/checkDencode";

//验证码验证后修改密码（用于找回密码）
static NSString *setNewPwd_method = @"app/changePwd";

//登录
static NSString *login_method = @"app/login";


//任务大厅
static NSString *orderList_method = @"app/orders/getList";

//绑定船老大与货单列表
static NSString *bindOerder_method= @"app/orders/bindOrder";

//查看货单详情
static NSString *orderDetail_method = @"app/orders/getInfo";

//版本更新
static NSString *updataApp_method = @"app/index/getVersion";



//保存船坐标
static NSString *recordCoorddinate_method = @"app/coordinate/recordCoordinate";

//可提现列表
static NSString *availblePay_method = @"app/payRecord/toAvailblePay";

//未支付运费列表
static NSString *noPay_method = @"app/payRecord/toNoPay";

//货运公司支付列表
static NSString *noPatDetail_method = @"app/payRecord/toNoPayDetail";

//获得支持的银行列表
static NSString *getBanksList_method = @"common/getBanks";

//获得省列表
static NSString *getProvinceList_method = @"common/getPros";

//获得省的子级城市列表
static NSString *getCityList_method = @"common/getPros";

//扣除手续费可提现金额
static NSString *checkGetCash_method = @"common/checkGetCash";

//提现
static NSString *getCash_method = @"common/getCash";

//刷新重新提现
static NSString *getRefresh_method = @"common/forRefresh";

//单张图片上传
static NSString *uploadSingleImage_method = @"app/util/uploadImg/";

//多张图片上传
static NSString *uploadManyImage_method = @"app/util/uploadImgs/";

//加入船队
static NSString *joinTeam_method = @"app/team/joinTeam";

//组队接单
static NSString *makeTeam_method = @"app/team/makeTeam";

//船队列表
static NSString *getShipTeamList_method = @"app/team/getShipTeamListByShipOwnerId";

//货物运输列表
static NSString *getGoodsList_method = @"app/orders/getMyOrderListByShipOwnerId";

//船队详细列表
static NSString *getShipTeamDetail_method = @"app/team/getShipTeamInfoById";

//解散船队
static NSString *breakShipTeam_method = @"app/team/breakTeam";

//船队抢单
static NSString *shipTeamGetOrder_method = @"app/team/getOrder";

//删除船
static NSString *deleteFromTeam_method = @"app/team/delFromTeam";

//分配船队运费
static NSString *setPayEveryShip_method = @"app/team/setPay";

//装货吨位设置
static NSString *upInAccount_method = @"app/orders/upInAccount";

//卸货吨位设置
static NSString *upOutAccount_method = @"app/orders/upOutAccount";

//升级为高级船
static NSString *upShip_method = @"app/toPay/getPayInfo";

//组队中
static NSString *shipMakeTeam_methd = @"app/team/getMyIngTeam";

//加入船队
static NSString *shipInTeam_methd = @"app/team/joinTeam";
//单船竞价
static NSString *singleShipComplete_method= @"app/shipBusiness/singleComplete";

//消息列表
static NSString *messageList_method= @"app/messages/getList";

//批量更新消息为已读
static NSString *uploadMessageStatus_method= @"app/messages/upStatus";

//删除消息
static NSString *deleteMessage_method = @"app/messages/delById";

//获得港口列表
static NSString *getPortList_method = @"common/getPortList";

//距离列表
static NSString *getDistanceList_method = @"app/util/getDistanceList";

@interface NetWorkInterface : NSObject

/*
 "loginName":"船老大",
 "pwd":"123456",
 "name":"yangyibin",
 "shipNumber":"苏F110234",//船舶号
 "phone":"1537132460",
 "volume":"20",//吨位
 “dentCode”：”256963”,//验证码
 “builderTime”:”adfa”,//建造时间
 “imgList”:23//签证薄照片id
 “joinCode”:”xadf”//邀请码
 “shipName”://船名
 */
//注册
+(void)registerWithLoginName:(NSString*)loginName pwd:(NSString*)pwd name:(NSString*)name shipNumber:(NSString*)shipNumber phone:(NSString*)phone volume:(NSString*)volume dentCode:(NSString*)dentCode builderTime:(NSString*)builderTime imgList:(int)imgList joinCode:(NSString*)joinCode shipName:(NSString*)shipName  finished:(requestDidFinished)finish;
//运输中信息
+ (void) getdetailsWithloginid:(NSString *)loginid
                      finished:(requestDidFinished)finish;

+(void)registerWithLoginName:(NSString*)loginName pwd:(NSString*)pwd name:(NSString*)name  phone:(NSString*)phone  dentCode:(NSString*)dentCode  joinCode:(NSString*)joinCode  finished:(requestDidFinished)finish;

//到达装/卸货港签到
+ (void)signWithid:(NSString *)idbumber
             type:(NSString *)type
          loginid:(NSString *)loginid
         finished:(requestDidFinished)finish;
//发送验证码 (注册)
+(void)sendCodeWith:(NSString*)phone finished:(requestDidFinished)finish;

//发送验证码 (找回密码)
+(void)sendForPwdWithPhone:(NSString*)phone finished:(requestDidFinished)finish;

//登录
+(void)loginWithLoginName:(NSString*)loginName pwd:(NSString*)pwd finished:(requestDidFinished)finsh;

//版本更新
+(void)checkVersionFinished:(requestDidFinished)finish;

/*
 page 页数
 status 状态
 keys ""
 mLat1
 mlon
*/
//任务大厅
+(void)getOrderListWithPage:(int)page status:(int)status keys:(NSString*)keys mLat1:(double)mLat1 mLon1:(double)mLon1 portId:(int)portId distance:(NSString*)distance finished:(requestDidFinished)finish;



/*
 id     每一个货单的ID
 loginId 登录ID
 */
//货单详情
+(void)OrderDetailWithID:(int)ID loginId:(int)loginId finished:(requestDidFinished)finish;


/*
 loginId   登录ID
 ordersList   货单ID
 */
//绑定船老大与货单列表
+(void)bindOrderWithloginId:(int)loginId ordersList:(NSString*)ordersList finished:(requestDidFinished)finish;


/*
 loginName  登录名
 dentCode   验证码
 */
//验证验证码是否正确
+(void)testdentCodeWithloginName:(NSString*)loginName dentCode:(NSString*)dentCode finished:(requestDidFinished)finish;

/*
 loginName  登录名
 oldPwd     旧密码
 pwd        新密码
 */
//设置新密码
+(void)setNewPwdWithloginName:(NSString*)loginName oldPwd:(NSString*)oldPwd pwd:(NSString*)pwd finished:(requestDidFinished)finish;

/*
 shipOwnerId 
 loginId
 coordinate
 */
//保存船坐标
+(void)recordCoordinateWithshipOwerId:(int)shipOwerId loginId:(int)loginId coordinate:(NSString*)coordinate finished:(requestDidFinished)finish;

//可提现列表
+(void)availblePayWithshipOwerId:(int)shipOwerId page:(int)page finished:(requestDidFinished)finish;

//未支付运费列表
+(void)noPaylistWithshipOwerId:(int)shipOwerId finished:(requestDidFinished)finish;



/*
 cargoId
 shipOwnerId
 page
 cargoName
 */
//货运公司支付列表
+(void)payRecordListWithCargoId:(int)cargoId shipOwerId:(int)shipOwerId page:(int)page cargoName:(NSString*)cargoName finished:(requestDidFinished)finish;

//扣除手续费可提金额
+(void)checkGetCashWithmoneyNum:(int)moneyNum finished:(requestDidFinished)finish;
//获得支持的银行列表
+(void)getBanksListfinished:(requestDidFinished)finish;

//获得省列表
+(void)getProvinceListfinished:(requestDidFinished)finish;
//获得省的子级城市列表
+(void)getCityListWithID:(int)ID finished:(requestDidFinished)finish;

//提现
/*
 "shipOwnerId": 36,
 "cashNum": 36,
 "provinceCity": "苏州",
 "bankName": "银行名",
 "kuaihuhang": "开户行",
 "creditName": "收款人",
 "bankCardNumber": "银行卡号"
 */
+(void)getCashWithshipOwerId:(int)shipOwnerId cashNum:(int)cashNum provinceCity:(NSString*)provinceCity bankName:(NSString*)bankName kuaihuhang:(NSString*)kuaihuhang creditName:(NSString*)creditName bankCardNumber:(NSString*)bankCardNumber finished:(requestDidFinished)finish;

//“orderId”:”xxx”    流水号
//刷新查询提现
+(void)getRefreshWithorderId:(NSString*)orderId finished:(requestDidFinished)finish;

//单张图片上传
+(void)uploadSingleImageWithImage:(UIImage*)image loginId:(NSString*)loginId finished:(requestDidFinished)finish;

//多张图片上传
+(void)uploadManyImageWithloginId:(NSString*)loginId finished:(requestDidFinished)finish;

//加入船队
+(void)joinTeamWithCode:(NSString*)code loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish;

//组队接单
+(void)makeTeamWithorderId:(int)orderId loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish;

//船队列表
+(void)getshipTeamListWithPage:(int)page status:(int)status shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish;
/*
 page
 status
 shipOwnerId
 */
//货物运输
+(void)getGoodsTransportListWithPage:(int)page status:(int)status shipOwerId:(int)shipOwerId finished:(requestDidFinished)finish;

//船队详情
+(void)getShipTeamDetailWithloginId:(int)loginId ID:(int)ID finished:(requestDidFinished)finish;

//解散船队
+(void)breakshipTeamWithshipTeamId:(int)shipTeamId loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish;

//船队抢单
+(void)shipTeamGetOrderWithshipTeamId:(int)shipTeamId loginId:(int)loginId shipOwnerId:(int)shipOwnerId finished:(requestDidFinished)finish;

//删除船
+(void)deleteShipFromTeamWithshipTeamId:(int)shipTeamId loginId:(int)loginId delShipId:(int)delShipId finished:(requestDidFinished)finish;

//分配船队运费
+(void)setPayEveryShipWithshipTeamId:(int)shipTeamId loginId:(int)loginId shipSetStr:(NSString*)shipSetStr finished:(requestDidFinished)finish;

//装货吨位设置
+(void)upInAccountWithID:(int)ID inAccount:(int)inAccount loginId:(int)loginId imgUrlList:(NSString*)imgUrlList finished:(requestDidFinished)finish;

//卸货吨位设置
+(void)upOutAccountWithID:(int)ID inAccount:(int)inAccount loginId:(int)loginId imgUrlList:(NSString*)imgUrlList finished:(requestDidFinished)finish;

//升级为高级船
+(void)upShipWithshipId:(int)shipId loginId:(int)loginId finished:(requestDidFinished)finish;

//获取船队详细列表
+(void)shipMakeTeamWithLoginId:(int)loginId finished:(requestDidFinished)finish;

//获取船队详细列表
+(void)joinInTeamWithLoginId:(int)loginId
                        Code:(NSString *)code
                   ShipOwnID:(int)shipOwnId
                       Quote:(int)quote
                    finished:(requestDidFinished)finish;
//单船竞价
+(void)singleShipCompletWithshipOwnerId:(int)shipOwnerId bsOrderId:(int)bsOrderId loginId:(int)loginId quote:(double)quote finished:(requestDidFinished)finish;

//消息列表
+(void)getMessageListWithshipOwnerId:(int)shipOwnerId page:(int)page finished:(requestDidFinished)finish;

//批量更新消息为已读
+(void)uploadMessageStausWithStatus:(int)status loginId:(int)loginId idStr:(NSArray*)idStr finished:(requestDidFinished)finish;

//删除消息
+(void)deleteMessageWithID:(int)ID finished:(requestDidFinished)finish;

//获得港口列表
+(void)getPortListWithfinished:(requestDidFinished)finish;

//获得距离列表
+(void)getDictanceListWithfinished:(requestDidFinished)finish;
@end

