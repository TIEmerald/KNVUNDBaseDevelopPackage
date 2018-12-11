//
//  KNVUNDDebugTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 14/12/17.
//

#import "KNVUNDDebugTool.h"

// Libs
#import <objc/runtime.h>

@implementation KNVUNDDebugTool

#pragma mark - KNVUNDBaseModle
#pragma mark - Class Methods
// You have to override this method if you want to show any log inside Class Method.
//+ (BOOL)shouldShowClassMethodLog
//{
//    return YES;
//}

#pragma mark - Method Related
+ (void)logSupportedMethodNameFromObject:(id)object
{
    int i=0;
    unsigned int mc = 0;
    Method * mlist = class_copyMethodList(object_getClass(object), &mc);
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Object %@ has %d supported methods",
     [object description],
     mc];
    for(i = 0 ; i < mc ; i++){
        [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                         andLogStringFormat:@"Method no #%d: %s",
         i,
         sel_getName(method_getName(mlist[i]))];
    }
}

@end
