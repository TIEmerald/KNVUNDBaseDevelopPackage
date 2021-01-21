//
//  KNVUNDObservable.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 25/1/19.
//

#import "KNVUNDBaseModel.h"

/// Models
#import "KNVUNDInvocation.h"

NS_ASSUME_NONNULL_BEGIN

//// Reference: https://a-coding.com/observer-pattern-in-objective-c/

@interface KNVUNDObservable : KNVUNDBaseModel

#pragma mark - General Methods
- (void)addObserver:(id<NSObject>)observer;
- (void)removeObserver:(id<NSObject>)observer;
- (void)notifyObservers:(KNVUNDInvocation *)invocation;

@end

NS_ASSUME_NONNULL_END
