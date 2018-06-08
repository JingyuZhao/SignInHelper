//
//  NSObject+BHRouter.h
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHRoutingAction.h"
#import <Foundation/Foundation.h>
#import "BHRoutingProtocol.h"

@interface NSObject (BHRouter)

- (id<BHRoutingActionResponder>)routingResponder;
- (id)performRoutingAction:(BHRoutingAction *)action;
- (id)performRouting:(NSString *)routing;

@end
