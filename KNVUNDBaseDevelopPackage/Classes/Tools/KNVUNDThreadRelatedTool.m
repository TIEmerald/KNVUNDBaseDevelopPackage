//
//  KNVUNDThreadRelatedTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 15/12/17.
//

#import "KNVUNDThreadRelatedTool.h"

@implementation KNVUNDThreadRelatedTool

+ (NSString *)usingCustomQueueName
{
    return @"";
}

#pragma mark - Queue Related
+ (void)performBlockInMainQueue:(void(^)(void))block
{
    if (!block) {
        return;
    }
    
    if ([NSThread isMainThread]) {
        block();
        return; // If current Tread is main tread, there is no need to do something like dispatch_sync()
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        block();
    });
}

+ (void)performBlockNotInMainQueue:(void(^)(void))block
{
    if (![NSThread isMainThread]) {
        block();
        return; // If current Tread is main tread, there is no need to do something like dispatch_sync()
    }
    
    dispatch_queue_t myCustomQueue;
    if ([self usingCustomQueueName ].length == 0) {
        myCustomQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    } else {
        myCustomQueue = dispatch_queue_create([[self usingCustomQueueName] cStringUsingEncoding:NSASCIIStringEncoding],
                                              nil);
    }
    
    dispatch_async(myCustomQueue,
                   block);
}

@end
