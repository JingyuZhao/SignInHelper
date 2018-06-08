//
//  UIView+BHRouter.m
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHRoutingAction.h"
#import "UIView+BHRouter.h"
#import "UIViewController+BHRouter.h"
#import <objc/runtime.h>

@implementation UIView (BHRouter)

- (UIViewController *)findViewController
{
    UIResponder *responder = self;

    while ( (responder = responder.nextResponder) != nil ) {
        if ( [responder isKindOfClass:[UIViewController class]] ) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

#pragma mark - Accessor

- (NSString *)routingString
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRoutingString:(NSString *)routingString
{
    objc_setAssociatedObject(self, @selector(routingString), routingString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ( [self.routingString length] ) {
        [self didSetRoutingString];
    }
}

- (NSString *)routingTargetTitle
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRoutingTargetTitle:(NSString *)routingTargetTitle
{
    objc_setAssociatedObject(self, @selector(routingTargetTitle), routingTargetTitle, OBJC_ASSOCIATION_COPY);
}

- (void)didSetRoutingString
{
    [self setRoutingTapEnabled:YES];
}

- (id)routingProxy
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRoutingProxy:(id)routingProxy
{
    objc_setAssociatedObject(self, @selector(routingProxy), routingProxy, OBJC_ASSOCIATION_ASSIGN);
}

- (BHRoutingTapGesture *)routingTapGesture
{
    BHRoutingTapGesture *tapGesture = objc_getAssociatedObject(self, _cmd);
    if ( !tapGesture ) {
        tapGesture = [[BHRoutingTapGesture alloc] initWithTarget:self action:@selector(handleRoutingTapGesture:)];
        objc_setAssociatedObject(self, _cmd, tapGesture, OBJC_ASSOCIATION_RETAIN);
        [self addGestureRecognizer:tapGesture];
    }
    return tapGesture;
}

- (void)handleRoutingTapGesture:(BHRoutingTapGesture *)gesture
{
    [self performDefaultRoutingAction];
}

- (BOOL)routingTapEnabled
{
    if ( !objc_getAssociatedObject(self, @selector(routingTapGesture)) ) {
        return NO;
    }
    
    return self.routingTapGesture.enabled;
}

- (void)setRoutingTapEnabled:(BOOL)flag
{
    self.routingTapGesture.enabled = flag;
    if ( flag ) {
        self.userInteractionEnabled = YES;
    }
}

#pragma mark - Fire Action

- (void)performDefaultRoutingAction
{
    if ( [self.routingString length] ) {
        BHRoutingAction *action = [BHRoutingAction actionFor:self.routingString sender:self.routingProxy ?: self];
        action.title = self.routingTargetTitle;
        [self performRoutingAction:action];
    }
}

- (id<BHRoutingActionResponder>)routingResponder
{
    id<BHRoutingActionResponder> responder = [self findViewController];
    
    if ( responder ) {
        return responder;
    }
    
    return [super routingResponder];
}

@end
