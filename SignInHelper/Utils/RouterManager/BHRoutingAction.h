//
//  BHRoutingAction.h
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import <UIKit/UIKit.h>

// 展示页面的位置
typedef NS_ENUM (NSInteger, BHRoutingPageFrom) {
    BHRoutingPageFromAuto    = 0, // 无所谓
    BHRoutingPageFromRoot    = 1, // 只在 RootViewController
    BHRoutingPageFromContext = 2  // 在收到 Route 请求的地方
};

// 展示页面的方式
typedef NS_ENUM (NSInteger, BHRoutingPageWay) {
    BHRoutingPageWayAuto    = 0, // 无所谓
    BHRoutingPageWayPush    = 1, // Push
    BHRoutingPageWayPresent = 2  // Present
};

typedef NS_ENUM (NSInteger, BHRoutingState) {
    BHRoutingStateInited = 0,
    BHRoutingStateSending,
    BHRoutingStateArrived,
    BHRoutingStateSucceed,
    BHRoutingStateFailed,
    BHRoutingStateCancelled
};

// 一些参数规则：
// 如果参数中含有 way=push 则等同于 BHRoutingPageWayPush， way=present 等同于 BHRoutingPageWayPresent
// from=root, from=context 同上
// 如果参数中含有 title='' 则会对 title 赋值

@class BHRoutingAction;

typedef void (^BHRoutingActionStateChangeBlock)(BHRoutingAction *action);

@interface BHRoutingAction : NSObject

@property (nonatomic, strong) NSString *routingString;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) NSDictionary *input;
@property (nonatomic, strong) NSDictionary *output;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) id sender;  // 发出者
@property (nonatomic, weak) UIViewController *context; // 处理的上下文
@property (nonatomic, weak) UIViewController *target;  // 目标

@property (nonatomic, assign) BHRoutingPageFrom pageFrom;
@property (nonatomic, assign) BHRoutingPageWay pageWay;

@property (nonatomic, assign) BHRoutingState state;
@property (nonatomic, copy) BHRoutingActionStateChangeBlock stateChangeBlock;

- (void)resetState;

+ (instancetype)actionFor:(NSString *)route;
+ (instancetype)actionFor:(NSString *)route sender:(id)sender;


@end
