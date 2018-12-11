//
//  NSObject+KNVUNDLogRelated.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 30/1/18.
//

#import "NSObject+KNVUNDLogRelated.h"

#import <objc/runtime.h>

@implementation NSObject (KNVUNDLogRelated)

#pragma mark - Class Methods
+ (BOOL)shouldShowClassMethodLog
{
    return NO;
}

#pragma mark - Override Methods
+ (BOOL)willSkipShouldShowLogChecking
{
    return NO;
}

+ (void)performLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *)string
{
    NSLog(@"%@", string);
}

#pragma mark Log Related
+ (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)string
{
    [self performConsoleLogWithLogString:string
                      withControlBoolean:[self shouldShowClassMethodLog]
                             andLogLevel:(NSObject_LogLevel)logLevel];
}

+ (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogLevel:logLevel andLogString:string];
}

#pragma mark - Support Methods
+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string withControlBoolean:(BOOL)couldLog andLogLevel:(NSObject_LogLevel)logLevel
{
    NSString *usingLogString = [[self class] getFormatedStringFromString:string];
    if ([self willSkipShouldShowLogChecking] || couldLog) {
        [self performLogWithLogLevel:logLevel andLogString:usingLogString];
    }
}

+ (NSString *)getFormatedStringFromString:(NSString *)fromString
{
    return [NSString stringWithFormat:@"[%@] %@",
            NSStringFromClass(self),
            fromString];
}

#pragma mark - Getters && Setters
static void * ShouldShowRelatedLogPropertyKey = &ShouldShowRelatedLogPropertyKey;

#pragma mark - Getters
- (BOOL)shouldShowRelatedLog
{
    return ((NSNumber *)objc_getAssociatedObject(self, ShouldShowRelatedLogPropertyKey)).boolValue;
}

#pragma mark - Setters
- (void)setShouldShowRelatedLog:(BOOL)shouldShowRelatedLog
{
    objc_setAssociatedObject(self, ShouldShowRelatedLogPropertyKey, @(shouldShowRelatedLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Log Related
- (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)string
{
    [[self class] performConsoleLogWithLogString:string
                              withControlBoolean:self.shouldShowRelatedLog
                                     andLogLevel:logLevel];
}

- (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogLevel:logLevel andLogString:string];
}


#pragma mark - Deprecated Methods
+ (void)performServerLogWithLogString:(NSString *)string
{
    
}

+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                           andLogString:string];
}

+ (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                           andLogString:string];
}

+ (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString
{
    [self performConsoleAndFurtherLogWithLogLevel:NSObject_LogLevel_Debug
                                    andLogString:logString];
}

+ (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndFurtherLogWithLogLevel:NSObject_LogLevel_Debug
                                    andLogString:string];
}

+ (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)logString
{
    [self performConsoleLogWithLogLevel:logLevel andLogString:logString];
}

+ (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogLevel:logLevel andLogString:string];
}

- (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                           andLogString:string];
}

- (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                           andLogString:string];
}

- (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString
{
    [self performConsoleAndFurtherLogWithLogLevel:NSObject_LogLevel_Debug
                                    andLogString:logString];
}

- (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndFurtherLogWithLogLevel:NSObject_LogLevel_Debug
                                    andLogString:string];
}

- (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)logString
{
    [self performConsoleLogWithLogLevel:logLevel
                           andLogString:logString];
}

- (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogLevel:logLevel
                           andLogString:string];
}

@end
