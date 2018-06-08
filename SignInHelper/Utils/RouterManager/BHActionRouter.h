//
//  BHActionRouter.h
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHRoutingAction.h"
#import "BHBaseRouter.h"
#import <UIKit/UIKit.h>
#import "BHRoutingProtocol.h"

typedef NS_ENUM (NSInteger, BHRouteType) {
    BHRouteTypeNone           = 0,
    BHRouteTypeViewController = 1,
    BHRouteTypeBlock          = 2
};

typedef BOOL (^BHRoutingTransitioningBlock)(UIViewController *from, UIViewController *to, BHRoutingAction *action);
typedef id (^BHRouterActionBlock)(BHRoutingAction *action);

@interface BHActionRouter : BHBaseRouter<BHRoutingActionResponder>

@property (nonatomic, copy) Class globalNavigationClass;

- (BOOL)shouldHandleRoutingAction:(BHRoutingAction *)route;
- (id)handleRoutingAction:(BHRoutingAction *)route;

// block 可以返回一个 UIViewController, 此时 Router 会自行处理相关跳转工作
// block 可以返回一个 RoutingAction, 此时 Router 会自动 handle 这个RoutingAction
- (void)map:(NSString *)route toBlock:(BHRouterActionBlock)block;
- (void)map:(NSString *)schema toControllerClass:(Class)controllerClass;

- (void)mapSchema:(NSString *)schema toBlock:(BHRouterActionBlock)block;
- (void)mapSchema:(NSString *)schema toControllerClass:(Class)controllerClass;

@property (nonatomic, copy) BHRoutingTransitioningBlock transitioningBlock;

@end
