//
//  BHRoutingActionHandler.h
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHRoutingAction.h"

@protocol BHRoutingActionResponder<NSObject>

- (BOOL)shouldHandleRoutingAction:(BHRoutingAction *)route;
- (id)handleRoutingAction:(BHRoutingAction *)route;

@end

@protocol BHRoutingTargetController <NSObject>

@property (nonatomic, strong, readonly) NSDictionary *routingParams;
@property (nonatomic, strong, readonly) BHRoutingAction *recivedAction;

- (BHRoutingPageWay)preferredRoutingPageWay;
- (BHRoutingPageFrom)preferredRoutingPageFrom;

@end
