//
//  BHActionRouter.m
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHActionRouter.h"
#import "UIViewController+BHRouter.h"

NSString *const BHActionRouterBlockKey = @"BHActionRouterBlockKey";

@interface BHActionRouter ()

@end

@implementation BHActionRouter

- (instancetype)init
{
    self = [super init];
    if ( self ) {
    }
    return self;
}

#pragma mark - 

- (void)mapSchema:(NSString *)schema toBlock:(BHRouterActionBlock)block
{
    [self mapSchema:schema toObject:block withIdentifier:BHActionRouterBlockKey];
}

- (void)mapSchema:(NSString *)schema toControllerClass:(Class)controllerClass
{
    [self mapSchema:schema toBlock:^id(BHRoutingAction *action) {
        return [[controllerClass alloc] init];
    }];
}

// block 可以返回一个 UIViewController, 此时 Router 会自行处理相关跳转工作
- (void)map:(NSString *)route toBlock:(BHRouterActionBlock)block
{
    [self map:route toObject:block withIdentifier:BHActionRouterBlockKey];
}

- (void)map:(NSString *)schema toControllerClass:(Class)controllerClass
{
    [self map:schema toBlock:^id(BHRoutingAction *action) {
        return [[controllerClass alloc] init];
    }];
}

#pragma mark - Handle Action

- (BOOL)shouldHandleRoutingAction:(BHRoutingAction *)route
{
    return YES;
}

- (id)handleRoutingAction:(BHRoutingAction *)action
{
    // 取出 block
    // 1. schema
    BHRouterActionBlock block = [self objectForSchema:[self extractSchema:action.routingString] identifier:BHActionRouterBlockKey];
    
    NSDictionary *extractParams = nil;
    
    // 2. route
    if ( !block ) {
        NSDictionary *subRoutes = [self subRoutesForRoutingString:action.routingString extractParams:&extractParams];
        block = subRoutes[BHActionRouterBlockKey];
    }

    id result = nil;
    if ( block ) {
        // 处理 action
        action.state = BHRoutingStateSending;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addEntriesFromDictionary:extractParams];
        [params addEntriesFromDictionary:action.input];
        // support DataBinding
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        id sender = action.sender;
        if ( [sender respondsToSelector:@selector(bindedData)] ) {
            id data = [sender performSelector:@selector(bindedData)];
            if ( data ) {
                [params setValue:data forKey:@"bindedData"];
            }
        }
#pragma clang diagnostic pop
        action.input = params;
        
        result = block(action);
        if ( [result isKindOfClass: [UIViewController class]] ) {
            [self handleViewController:result routingAction:action];
        }
        else if ( [result isKindOfClass:[BHRoutingAction class]] ) {
            [self handleRoutingAction:result];
        }
    }
    
    return result;
}

- (void)handleViewController:(UIViewController *)vc routingAction:(BHRoutingAction *)action
{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *from = action.context;
    UIViewController *to   = vc;
    
    // 建立关系
    to.recivedAction = action;
    action.target = vc;
    
    // title
    if ( action.title ) {
        to.title = action.title;
    }
    
    // Launch It !
    
    // 1. 查看 route 的 启动者，优先级 routeAction > pageDefault
    action.pageFrom = action.pageFrom ? : [to preferredRoutingPageFrom];
    
    // 2. 假如 启动者 是 Context, 但是却没有，就换成 RootViewController
    if ( action.pageFrom == BHRoutingPageFromRoot ) {
        from = root;
    }
    else {
        from = from ? : root;
    }
    
    action.pageWay = action.pageWay ? : [to preferredRoutingPageWay];
    [self transitionFrom:from to:to action:action];
}

- (UINavigationController *)navigationControllerWithRootViewController:(UIViewController *)vc
{
    UINavigationController *nv = nil;
    if ( self.globalNavigationClass ) {
        nv = [self.globalNavigationClass new];
    }
    else {
        nv = [UINavigationController new];
    }
    nv.viewControllers = @[vc];
    return nv;
}

- (void)transitionFrom:(UIViewController *)from
                    to:(UIViewController *)to
                action:(BHRoutingAction *)action
{
    if ( self.transitioningBlock && self.transitioningBlock(from, to, action) ) {
        return;
    }

    if ( action.pageWay == BHRoutingPageWayPresent ) {
        if ( [to isKindOfClass:[UINavigationController class]] || ![to preferredRoutingAutoNavigationWapper] ) {
            [from presentViewController:to animated:YES completion: ^{
                action.state = BHRoutingStateArrived;
            }];
        }
        else {
            UINavigationController *nv = [self navigationControllerWithRootViewController:to];
            [from presentViewController:nv animated:YES completion: ^{
                action.state = BHRoutingStateArrived;
            }];
        }
    }
    else {
        if ( [from isKindOfClass:[UINavigationController class]] ) {
            [(UINavigationController *) from pushViewController:to animated:YES];
        }
        else {
            [from.navigationController pushViewController:to animated:YES];
        }
        action.state = BHRoutingStateArrived;
    }
}

@end
