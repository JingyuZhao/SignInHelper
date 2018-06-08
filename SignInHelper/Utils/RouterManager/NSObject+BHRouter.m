//
//  NSObject+BHRouter.m
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHActionRouter.h"
#import "NSObject+BHRouter.h"
#import <objc/runtime.h>

@implementation NSObject (BHRouter)

static char kAssociatedRoutingStringObjectKey;

- (id<BHRoutingActionResponder>)routingResponder
{
    return [BHActionRouter shared];
}

- (void)setRoutingString:(NSString *)routingString
{
    objc_setAssociatedObject(self, &kAssociatedRoutingStringObjectKey, routingString,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)routingString
{
    return objc_getAssociatedObject(self, &kAssociatedRoutingStringObjectKey);
}

- (id)performRoutingAction:(BHRoutingAction *)action
{
    return [[self routingResponder] handleRoutingAction:action];
}

- (id)performRouting:(NSString *)routing
{
    return [self performRoutingAction:[BHRoutingAction actionFor:routing sender:self]];
}

@end
