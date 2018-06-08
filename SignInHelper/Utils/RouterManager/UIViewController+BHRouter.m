//
//  UIViewController+BHRouter.m
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "UIViewController+BHRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (BHRouter)

- (id)performRoutingAction:(BHRoutingAction *)action
{
    return [self handleRoutingAction:action];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIViewController (BHRoutingActionResponder)

- (void)setActionRouter:(BHActionRouter *)actionRouter
{
    objc_setAssociatedObject(self, @selector(actionRouter), actionRouter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BHActionRouter *)actionRouter
{
    BHActionRouter *router = objc_getAssociatedObject(self, _cmd);

    if ( !router ) {
        router = [[BHActionRouter alloc] init];
        [self setActionRouter:router];
    }
    return router;
}

- (BOOL)forwardRoutingActionToParent
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setForwardRoutingActionToParent:(BOOL)forwardRoutingActionToParent
{
    objc_setAssociatedObject(self, @selector(forwardRoutingActionToParent), @(forwardRoutingActionToParent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldHandleRoutingAction:(BHRoutingAction *)route
{
    return YES;
}

- (id)handleRoutingAction:(BHRoutingAction *)route
{
    if ( self.forwardRoutingActionToParent ) {
        [self.parentViewController handleRoutingAction:route];
    }
    
    // 如果是 NavigationController 则转交给 RootViewController 处理
    if ( [self isKindOfClass:[UINavigationController class]] ) {
        return [[(UINavigationController *)self topViewController] handleRoutingAction:route];
    }
    else {
        if ( [self shouldHandleRoutingAction:route] ) {
            route.context = self;
            [self.actionRouter handleRoutingAction:route];
            // controller 的 router 无法处理此路由，交给全局路由处理
            if ( route.state < BHRoutingStateSending ) {
                return [[BHActionRouter shared] handleRoutingAction:route];
            }
        }
        
        return nil;
    }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIViewController (BHRoutingTargetController)

- (NSDictionary *)routingParams
{
    return self.recivedAction.input;
}

- (void)setRecivedAction:(BHRoutingAction *)recivedAction
{
    objc_setAssociatedObject(self, @selector(recivedAction), recivedAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BHRoutingAction *)recivedAction
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPreferredRoutingPageFrom:(BHRoutingPageFrom)preferredRoutingPageFrom
{
    objc_setAssociatedObject(self, @selector(preferredRoutingPageFrom), @(preferredRoutingPageFrom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPreferredRoutingPageWay:(BHRoutingPageWay)preferredRoutingPageWay
{
    objc_setAssociatedObject(self, @selector(preferredRoutingPageWay), @(preferredRoutingPageWay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPreferredRoutingAutoNavigationWapper:(BOOL)flag
{
    objc_setAssociatedObject(self, @selector(preferredRoutingAutoNavigationWapper), @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BHRoutingPageWay)preferredRoutingPageWay
{
    if ( objc_getAssociatedObject(self, _cmd) ) {
        return [objc_getAssociatedObject(self, _cmd) integerValue];
    }
    
    return BHRoutingPageWayAuto;
}

- (BHRoutingPageFrom)preferredRoutingPageFrom
{
    if ( objc_getAssociatedObject(self, _cmd) ) {
        return [objc_getAssociatedObject(self, _cmd) integerValue];
    }
    
    return BHRoutingPageFromAuto;
}

- (BOOL)preferredRoutingAutoNavigationWapper
{
    if ( objc_getAssociatedObject(self, _cmd) ) {
        return [objc_getAssociatedObject(self, _cmd) integerValue];
    }
    return YES;
}

@end

