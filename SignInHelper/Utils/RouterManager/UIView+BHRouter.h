//
//  UIView+BHRouter.h
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "NSObject+BHRouter.h"
#import <UIKit/UIKit.h>
#import "BHRoutingTapGesture.h"

@class BHRoutingAction;

@interface UIView (BHRouter)

@property (nonatomic, strong) NSString *routingString;
@property (nonatomic, copy) NSString *routingTargetTitle;
@property (nonatomic, weak) id routingProxy;  // User For UITableViewCell
@property (nonatomic, strong, readonly) BHRoutingTapGesture *routingTapGesture;
@property (nonatomic, assign) BOOL routingTapEnabled;

- (UIViewController *)findViewController;

// override piont
- (void)didSetRoutingString;

- (void)performDefaultRoutingAction;

@end
