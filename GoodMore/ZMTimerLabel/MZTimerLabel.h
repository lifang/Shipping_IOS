//
//  MZTimerLabel.h
//  TimerLable
//
//  Created by tangdi on 15/7/10.
//  Copyright (c) 2015年 ZM. All rights reserved.
//

#import <UIKit/UIKit.h>


/**********************************************
 MZTimerLabel TimerType Enum
 **********************************************/
typedef enum{
    MZTimerLabelTypeStopWatch,
    MZTimerLabelTypeTimer
}MZTimerLabelType;

/**********************************************
 Delegate Methods
 @optional
 
 - timerLabel:finshedCountDownTimerWithTimeWithTime:
 ** MZTimerLabel Delegate method for finish of countdown timer
 
 - timerLabel:countingTo:timertype:
 ** MZTimerLabel Delegate method for monitering the current counting progress
 
 - timerlabel:customTextToDisplayAtTime:
 ** MZTimerLabel Delegate method for overriding the text displaying at the time, implement this for your very custom display formmat
 **********************************************/

@class MZTimerLabel;
@protocol MZTimerLabelDelegate <NSObject>
@optional
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime;
-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType;
-(NSString*)timerLabel:(MZTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time;
@end

/**********************************************
 MZTimerLabel Class Defination
 **********************************************/

@interface MZTimerLabel : UILabel;

/*Delegate for finish of countdown timer */
@property (nonatomic, weak) id<MZTimerLabelDelegate> delegate;

/*Time format wish to display in label*/
@property (nonatomic,copy) NSString *timeFormat;

/*Target label obejct, default self if you do not initWithLabel nor set*/
@property (nonatomic,strong) UILabel *timeLabel;

/*Type to choose from stopwatch or timer*/
@property (assign) MZTimerLabelType timerType;

/*Is The Timer Running?*/
@property (assign,readonly) BOOL counting;

/*Do you want to reset the Timer after countdown?*/
@property (assign) BOOL resetTimerAfterFinish;

/*Do you want the timer to count beyond the HH limit from 0-23 e.g. 25:23:12 (HH:mm:ss) */
@property (assign) BOOL shouldCountBeyondHHLimit;

#if NS_BLOCKS_AVAILABLE
@property (copy) void (^endedBlock)(NSTimeInterval);
#endif


/*--------Init methods to choose*/
-(id)initWithTimerType:(MZTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel andTimerType:(MZTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel;


/*--------Timer control methods to use*/
-(void)start;
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval countTime))end; //use it if you are not going to use delegate
#endif
-(void)pause;
-(void)reset;

/*--------Setter methods*/
-(void)setCountDownTime:(NSTimeInterval)time;
-(void)setStopWatchTime:(NSTimeInterval)time;
-(void)setCountDownToDate:(NSDate*)date;

-(void)addTimeCountedByTime:(NSTimeInterval)timeToAdd;

/*--------Getter methods*/
- (NSTimeInterval)getTimeCounted;
- (NSTimeInterval)getTimeRemaining;






@end

