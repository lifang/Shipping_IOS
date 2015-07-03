//
//  MYView.h
//  GoodMore
//
//  Created by lihongliang on 15/6/24.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYViewDelegate <NSObject>

-(void)changeValueWithView:(UIView*)myview Index:(NSInteger)index;

@end


@interface MYView : UIView

@property(nonatomic,assign) id<MYViewDelegate> delegate;

@property(nonatomic,assign) NSInteger selectIndex;//当前点击button的索引

-(void)setItems:(NSArray*)itemNames;

@end
