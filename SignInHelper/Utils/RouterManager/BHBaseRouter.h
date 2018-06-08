//
//  BHBaseRouter.h
//  Pods
//
//  Created by Chen Yihu on 6/3/15.
//
//

#import <UIKit/UIKit.h>

@interface BHBaseRouter : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary *routes;
@property (nonatomic, strong, readonly) NSMutableDictionary *schemas;

+ (instancetype)shared;

- (void)map:(NSString *)route toObject:(id)object withIdentifier:(NSString *)identifier;

- (NSDictionary *)subRoutesForRoutingString:(NSString *)route
                              extractParams:(NSDictionary **)extractParams;

// schema 映射，用于过滤处理特殊的 schema
- (void)mapSchema:(NSString *)schema toObject:(id)object withIdentifier:(NSString *)identifier;
- (NSString *)extractSchema:(NSString *)route;
- (id)objectForSchema:(NSString *)schema identifier:(NSString *)identifier;

@end
