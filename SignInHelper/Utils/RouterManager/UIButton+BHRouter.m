//
//  UIButton+BHRouter.m
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "UIButton+BHRouter.h"
#import "UIView+BHRouter.h"
#import <objc/runtime.h>

@implementation UIButton (BHRouter)

- (void)didSetRoutingString
{
    [self bhr_hijackActionAndTargetIfNeeded];
}

- (void)bhr_hijackActionAndTargetIfNeeded
{
    SEL hijackSelector = @selector(performDefaultRoutingAction);

    for ( NSString *selector in [self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] ) {
        if ( hijackSelector == NSSelectorFromString(selector) ) {
            return;
        }
    }

    [self addTarget:self action:hijackSelector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRoutingTapEnabled:(BOOL)routingTapEnabled
{
    self.enabled = routingTapEnabled;
}

- (BOOL)routingTapEnabled
{
    return self.enabled;
}

@end
