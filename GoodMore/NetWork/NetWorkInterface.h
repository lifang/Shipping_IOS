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
   
    OrderStatusAll=-1,       //全部
    OrderStatusSelecting=0, //选船中
    OrderStatusRefuse=1,    //被拒绝
    OrderStatusPerforming=2,//执行中
    OrderStatusFinished=3,  //已完成
}OrderStatus;


#import <Foundation/Foundation.h>
#import "Constants.h"
#import "NetworkRequest.h"
#import "EncryptHelper.h"

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

//我的任务
static NSString *myTask_method = @"app/orders/getListByShipOwnerId";

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

static NSString *getRefresh_method = @"common/forRefresh";


@interface NetWorkInterface : NSObject

//注册
+(void)registerWithLoginName:(NSString*)loginName pwd:(NSString*)pwd shipName:(NSString*)shipName shipNumber:(NSString*)shipNumber phone:(NSString*)phone dentCode:(NSString*)dentCode volume:(NSString*)volume finished:(requestDidFinished)finish;

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
+(void)getOrderListWithPage:(int)page status:(int)status keys:(NSString*)keys mLat1:(double)mLat1 mLon1:(double)mLon1 finished:(requestDidFinished)finish;

/*
 page  
 status
 shipOwnerId
 */
//我的任务
+(void)myTaskListWithPage:(int)page status:(int)status shipOwerId:(int)shipOwerId finished:(requestDidFinished)finish;

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
@end
