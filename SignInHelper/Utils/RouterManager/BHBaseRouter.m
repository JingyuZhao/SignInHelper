//
//  BHBaseRouter.m
//  Pods
//
//  Created by Chen Yihu on 6/3/15.
//
//

#import "BHBaseRouter.h"

@interface BHBaseRouter ()
@end

@implementation BHBaseRouter
{
    NSMutableDictionary *_routes;
    NSMutableDictionary *_schemas;
}

+ (instancetype)shared
{
    static BHBaseRouter *router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if ( !router ) {
            router = [[self alloc] init];
        }
    });
    return router;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _routes = [[NSMutableDictionary alloc] init];
        _schemas = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)map:(NSString *)route toObject:(id)object withIdentifier:(NSString *)identifier
{
    NSMutableDictionary *subRoutes = [self subRoutesToRoute:route createIfNotExists:YES];
    
    if ([object conformsToProtocol:@protocol(NSCopying)]) {
        subRoutes[identifier] = [object copy];
    }
    else {
        subRoutes[identifier] = object;
    }
}

- (NSString *)extractSchema:(NSString *)route;
{
    NSRange range = [route rangeOfString:@"://"];
    if ( range.location != NSNotFound ) {
        return [route substringToIndex:range.location];
    }
    return nil;
}

- (void)mapSchema:(NSString *)schema toObject:(id)object withIdentifier:(NSString *)identifier
{
    schema = [self extractSchema:schema] ?: schema;
    NSMutableDictionary *subRoutes = [self subRoutesToSchema:schema createIfNotExists:YES];
    
    if ([object conformsToProtocol:@protocol(NSCopying)]) {
        subRoutes[identifier] = [object copy];
    }
    else {
        subRoutes[identifier] = object;
    }
}

- (id)objectForSchema:(NSString *)schema identifier:(NSString *)identifier
{
    NSMutableDictionary *subRoutes = [self subRoutesToSchema:schema createIfNotExists:NO];
    return subRoutes[identifier];
}

#pragma mark -

- (NSDictionary *)subRoutesForRoutingString:(NSString *)route
                              extractParams:(NSDictionary **)extractParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    route = [self stringFromFilterAppUrlScheme:route];
    params[@"route"] = route;
    
    NSString *routeDomain = [self pathComponentsFromRoute:route];
    NSMutableDictionary *subRoutes = self.routes;
    NSArray *subRoutesKeys = subRoutes.allKeys;
    if ( [subRoutesKeys containsObject:routeDomain] ) {
        subRoutes = subRoutes[routeDomain];
    }else{
        if ([self.routes count]>0) {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"提示"
//                                  message:@"请升级到最新版本"
//                                  delegate:nil
//                                  cancelButtonTitle:@"知道了"
//                                  otherButtonTitles:nil,nil];
//            [alert show];
        }
    }
    

    // Extract Params From Query.
    NSRange firstRange = [route rangeOfString:@"?"];
    if ( (firstRange.location != NSNotFound) && (route.length > firstRange.location + firstRange.length) ) {
        NSString *paramsString  = [route substringFromIndex:firstRange.location + firstRange.length];
        NSArray *paramStringArr = [paramsString componentsSeparatedByString:@"&"];
        for ( NSString *paramString in paramStringArr ) {
            NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
            if ( paramArr.count > 1 ) {
                NSString *key   = [paramArr objectAtIndex:0];
                NSString *value = [paramArr objectAtIndex:1];
                params[key] = value;
            }
        }
    }
    
    *extractParams = [NSDictionary dictionaryWithDictionary:params];
    return subRoutes;
}

- (NSMutableDictionary *)routes
{
    if ( !_routes ) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    
    return _routes;
}

- (NSMutableDictionary *)schemas
{
    if ( !_schemas ) {
        _schemas = [[NSMutableDictionary alloc] init];
    }
    return _schemas;
}

- (NSString *)pathComponentsFromRoute:(NSString *)route
{
    NSURL *routeUrl = [[NSURL alloc] initWithString:[route stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    route = routeUrl.relativePath;
    
    NSArray *pathComponents = [route componentsSeparatedByString:@"?"];
    return pathComponents[0];
}

- (NSString *)stringFromFilterAppUrlScheme:(NSString *)string
{
    // filter out the app URL compontents.
    for ( NSString *appUrlScheme in [self appUrlSchemes] ) {
        if ( [string hasPrefix:[NSString stringWithFormat:@"%@:", appUrlScheme]] ) {
            return [string substringFromIndex:appUrlScheme.length + 2];
        }
    }
    
    return string;
}

- (NSArray *)appUrlSchemes
{
    static NSMutableArray *s_appUrlSchemes = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_appUrlSchemes = [NSMutableArray array];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        for ( NSDictionary *dic in infoDictionary[@"CFBundleURLTypes"] ) {
            NSString *appUrlScheme = dic[@"CFBundleURLSchemes"][0];
            [s_appUrlSchemes addObject:appUrlScheme];
        }
    });
    
    return [s_appUrlSchemes copy];
}

- (NSMutableDictionary *)subRoutesToSchema:(NSString *)schema createIfNotExists:(BOOL)flag
{
    NSMutableDictionary *subRoutes = self.schemas[schema];
    if ( flag && !subRoutes ) {
        subRoutes = [[NSMutableDictionary alloc] init];
        self.schemas[schema] = subRoutes;
    }
    return subRoutes;
}

- (NSMutableDictionary *)subRoutesToRoute:(NSString *)route createIfNotExists:(BOOL)flag
{
     route = [self pathComponentsFromRoute:route];
    NSMutableDictionary *subRoutes = self.routes;
    if (flag) {
        if ( ![subRoutes objectForKey:route] ) {
            subRoutes[route] = [[NSMutableDictionary alloc] init];
        }
    }
    subRoutes = subRoutes[route];
    
    return subRoutes;
}

@end

