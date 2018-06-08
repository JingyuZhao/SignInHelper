//
//  BHRoutingTapGesture.m
//  Pods
//
//  Created by Chen Yihu on 6/4/15.
//
//

#import "BHRoutingTapGesture.h"

@implementation BHRoutingTapGesture

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if ( self ) {
        self.numberOfTapsRequired = 1;
        self.numberOfTouchesRequired = 1;
        self.cancelsTouchesInView = YES;
        self.delaysTouchesBegan = YES;
        self.delaysTouchesEnded = YES;
    }
    return self;
}

@end
