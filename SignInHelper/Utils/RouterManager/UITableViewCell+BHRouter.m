//
//  UITableViewCell+BHRouter.m
//  Pods
//
//  Created by Chen Yihu on 6/11/15.
//
//

#import "UITableViewCell+BHRouter.h"
#import "UIView+BHRouter.h"
#import <objc/runtime.h>

@implementation UITableViewCell (BHRouter)

- (void)setRoutingString:(NSString *)routingString
{
    self.contentView.routingString = routingString;
    self.contentView.routingProxy = self;
    self.contentView.routingTapGesture.delaysTouchesBegan = NO;
    self.contentView.routingTapGesture.delaysTouchesEnded = NO;
}

- (void)setRoutingTapEnabled:(BOOL)routingTapEnabled
{
    self.contentView.routingTapEnabled = routingTapEnabled;
}

- (NSString *)routingTargetTitle
{
    return self.contentView.routingTargetTitle;
}

- (void)setRoutingTargetTitle:(NSString *)routingTargetTitle
{
    self.contentView.routingTargetTitle = routingTargetTitle;
}

- (BOOL)routingTapEnabled
{
    return self.contentView.routingTapEnabled;
}

@end
