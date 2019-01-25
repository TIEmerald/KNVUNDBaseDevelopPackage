//
//  KNVUNDInvocation.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 25/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Reference: https://a-coding.com/making-nsinvocations/

@interface KNVUNDInvocation : NSInvocation

#pragma mark - Factory Method
+ (instancetype)invocationWithTarget:(NSObject*)targetObject
                            selector:(SEL)selector;
+ (instancetype)invocationWithClass:(Class)targetClass
                           selector:(SEL)selector;
+ (instancetype)invocationWithProtocol:(Protocol*)targetProtocol
                              selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
