//
//  NetworkRequest.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//回调结果
typedef void (^requestDidFinished)(BOOL success, NSData *response);

@interface NetworkRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) NSURLConnection *requestConnection;

@property (nonatomic, strong)NSMutableData *requestData;

@property (nonatomic, strong) requestDidFinished finishBlock;

- (id)initWithRequestURL:(NSString *)urlString
              httpMethod:(NSString *)method
                finished:(requestDidFinished)finish;

- (void)setPostBody:(NSData *)postData;

- (void)setFormPostBody:(NSData *)postData;

/*
 图片上传
 imageData  图片二进制
 imageName  图片名
 key        参数名
*/
- (void)uploadImageData:(NSData *)imageData
              imageName:(NSString *)imageName
                    key:(NSString *)key;

- (void)start;

@end
