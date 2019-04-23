//
//  KNVUNDObservable.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 25/1/19.
//

#import "KNVUNDObservable.h"

@interface KNVUNDObservable()

@property (strong, nonatomic) NSHashTable *observers;
@property (strong, nonatomic) NSHashTable *invocationHashTable; /// We are using this to tracing if the Observer is notifying or not...
@property (readonly) BOOL isNotifying;

@end

@implementation KNVUNDObservable

- (BOOL)shouldShowRelatedLog
{
    return YES;
}

#pragma mark - Getters && Setters
#pragma mark - Getters
- (BOOL)isNotifying
{
    return self.invocationHashTable.count > 0;
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        self.observers = [NSHashTable weakObjectsHashTable];
        self.invocationHashTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

#pragma mark - General Methods
- (void)addObserver:(id<NSObject>)observer
{
    NSUInteger countBeforeChange = [self.observers count];
    NSHashTable *tempHashTable = [self.observers copy];
    [tempHashTable addObject:observer];
    self.observers = tempHashTable;
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Added new Observer (From %@ to %@)",
     @(countBeforeChange), @([self.observers count])];
}

- (void)removeObserver:(id<NSObject>)observer
{
    NSUInteger countBeforeChange = [self.observers count];
    NSHashTable *tempHashTable = [self.observers copy];
    [tempHashTable removeObject:observer];
    self.observers = tempHashTable;
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Removed new Observer (From %@ to %@)",
     @(countBeforeChange), @([self.observers count])];
}

- (void)notifyObservers:(KNVUNDInvocation *)invocation
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                           andLogString:@"Notifying new Observer"];
    [self.invocationHashTable addObject:invocation];
    for (id<NSObject> observer in self.observers) {
        if ([observer respondsToSelector:[invocation selector]]) {
            [invocation setTarget:observer];
            [invocation invoke];
        }
    }
    [self.invocationHashTable removeObject:invocation];
}

#pragma mark - Support Methods
- (void)checkAndAddObserver:(id<NSObject>)observer
{
    if (![self.observers containsObject:observer]) {
        [self.observers addObject:observer];
    }
}

@end
