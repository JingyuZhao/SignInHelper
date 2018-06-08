//
//  BHRoutingAction.m
//  Pods
//
//  Created by Chen Yihu on 5/22/15.
//
//

#import "BHRoutingAction.h"

@interface BHRoutingAction ()



@end

@implementation BHRoutingAction

+ (instancetype)actionFor:(NSString *)route
{
    return [self actionFor:route sender:nil];
}

+ (instancetype)actionFor:(NSString *)route sender:(id)sender
{
    BHRoutingAction *action = [BHRoutingAction new];

    action.routingString = route;
    action.sender        = sender;
    action.state         = BHRoutingStateInited;
    return action;
}

- (void)resetState;
{
    _state                = BHRoutingStateInited;
    self.stateChangeBlock = NULL;
}

- (void)setState:(BHRoutingState)state
{
    if ( _state != state ) {
        _state = state;
        if ( self.stateChangeBlock ) {
            self.stateChangeBlock(self);
        }
    }
}

- (void)setInput:(NSDictionary *)input
{
    if ( _input != input ) {
        _input = input;
        [self parseInput];
    }
}

- (void)parseInput
{
    if ( [_input[@"title"] length] ) {
        _title = _input[@"title"];
    }
    
    NSDictionary *wayMap = \
    @{
      @"push": @(BHRoutingPageWayPush),
      @"present": @(BHRoutingPageWayPresent)
      };

    NSString *way = _input[@"way"];
    if ( way ) {
        _pageWay = [wayMap[way] integerValue];
    }
    
    NSDictionary *fromMap = \
    @{
      @"root": @(BHRoutingPageFromRoot),
      @"context": @(BHRoutingPageFromContext)
      };
    NSString *from = _input[@"from"];
    if ( from ) {
        _pageFrom = [fromMap[from] integerValue];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"<%@"
            @" route: %@"
            @", sender: %@"
            @", state: %ld"
            @", input: %@"
            @", output: %@"
            @">",
            [super description], self.routingString, self.sender, (long)self.state, self.input, self.output];
}

@end
