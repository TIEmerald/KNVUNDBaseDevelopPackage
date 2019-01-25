//
//  KNVUNDObservable.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 25/1/19.
//

#import "KNVUNDObservable.h"

@interface KNVUNDObservable()

@property (strong, nonatomic) NSHashTable *observers;
@property (strong, nonatomic) NSHashTable *pendingAdd;
@property (strong, nonatomic) NSHashTable *pendingRemove;
@property (strong, nonatomic) NSHashTable *invocationHashTable; /// We are using this to tracing if the Observer is notifying or not...
@property (readonly) BOOL isNotifying;

@end

@implementation KNVUNDObservable

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
        self.pendingAdd = [NSHashTable weakObjectsHashTable];
        self.pendingRemove = [NSHashTable weakObjectsHashTable];
        self.invocationHashTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

#pragma mark - General Methods
- (void)addObserver:(id<NSObject>)observer
{
    if (self.isNotifying) {
        [self.pendingAdd addObject:observer];
    } else {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id<NSObject>)observer
{
    if (self.isNotifying) {
        [self.pendingRemove addObject:observer];
    } else {
        [self.observers addObject:observer];
    }
}

- (void)notifyObservers:(KNVUNDInvocation *)invocation
{
    [self.invocationHashTable addObject:invocation];
    for (id<NSObject> observer in self.observers) {
        if (![self.pendingRemove containsObject:observer] && [observer respondsToSelector:[invocation selector]]) {
            [invocation setTarget:observer];
            [invocation invoke];
        }
    }
    [self.invocationHashTable removeObject:invocation];
    [self commitPending];
}

#pragma mark - Support Methods
- (void)commitPending
{
    if (!self.isNotifying) {
        for (id <NSObject> pendingAddObserver in self.pendingAdd.copy) {
            [self.observers addObject:pendingAddObserver];
            [self.pendingAdd removeObject:pendingAddObserver];
        }
        for (id <NSObject> pendingRemoveObserver in self.pendingRemove.copy) {
            [self.observers removeObject:pendingRemoveObserver];
            [self.pendingRemove removeObject:pendingRemoveObserver];
        }
    }
}

@end
