//
//  BHRoutingBuilder.h
//  Pods
//
//  Created by Chen Yihu on 6/15/15.
//
//

#import <Foundation/Foundation.h>
#import "BHRoutingAction.h"

#define ROUTING(pattern) [[BHRoutingBuilder alloc] initWithPattern:pattern]
#define AS_RoutingPattern(__key) @property (nonatomic, readonly) BHRoutingBuilder *__key; \
+ (NSString *)__key

#define DEF_RoutingPattern(__name, __value) \
- (BHRoutingBuilder *)__name \
{ \
return ROUTING( __value ); \
} \
+ (NSString *)__name \
{ \
    return __value; \
} \

@class BHRoutingBuilder;
typedef BHRoutingBuilder *(^BHRoutingKeyValueParamBlock)(NSString *key, id format, ...);
typedef BHRoutingBuilder *(^BHRoutingOrderedParamBlock)(id first, ...);

@interface BHRoutingBuilder : NSObject

@property (nonatomic, readonly, copy) BHRoutingKeyValueParamBlock PARAM;

// TODO:
//@property (nonatomic, readonly, copy) BHRoutingOrderedParamBlock PARAMS;

@property (nonatomic, readonly) NSString *ROUTING;

// TODO:
//@property (nonatomic, readonly) BHRoutingAction *ACTION;

@property (nonatomic, readonly, strong) NSString *pattern;

- (instancetype)initWithPattern:(NSString *)pattern;

@end
