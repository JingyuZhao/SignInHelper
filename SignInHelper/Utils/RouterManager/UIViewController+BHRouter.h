//
//  UIViewController+BHRouter.h
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHActionRouter.h"
#import "BHRoutingProtocol.h"
#import "NSObject+BHRouter.h"
#import <UIKit/UIKit.h>

@interface UIViewController (BHRouter)

- (id)performRoutingAction:(BHRoutingAction *)action;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIViewController (BHRoutingActionResponder)<BHRoutingActionResponder>

@property (nonatomic, strong) BHActionRouter *actionRouter;
@property (nonatomic, assign) BOOL forwardRoutingActionToParent;

- (BOOL)shouldHandleRoutingAction:(BHRoutingAction *)route;
- (id)handleRoutingAction:(BHRoutingAction *)route;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIViewController (BHRoutingTargetController)<BHRoutingTargetController>

@property (nonatomic, strong) BHRoutingAction *recivedAction;
@property (nonatomic, strong, readonly) NSDictionary *routingParams;
@property (nonatomic, assign) BHRoutingPageWay preferredRoutingPageWay;
@property (nonatomic, assign) BHRoutingPageFrom preferredRoutingPageFrom;
@property (nonatomic, assign) BOOL preferredRoutingAutoNavigationWapper; // 是否自动加 NavigationController

@end
