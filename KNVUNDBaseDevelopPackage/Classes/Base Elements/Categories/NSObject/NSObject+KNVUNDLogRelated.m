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
+ (BOOL)isDevelopMode
{
    return YES;
}

+ (BOOL)isLogIntoTempDirectory
{
    return NO;
}

+ (void)performFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *)string
{
    [self performServerLogWithLogString:string];
}

#pragma mark Log Related
+ (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)string
{
    [self performConsoleLogWithLogString:string
                      withControlBoolean:[self shouldShowClassMethodLog]];
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

+ (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)logString
{
    NSString *usingLogString = [self getFormatedStringFromString:logString];
    [self performConsoleLogWithLogLevel:logLevel andLogString:usingLogString];
    [self performFurtherLogWithLogLevel:logLevel andLogString:usingLogString];
}

+ (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndFurtherLogWithLogLevel:logLevel andLogString:string];
}

#pragma mark - Support Methods
+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string withControlBoolean:(BOOL)couldLog
{
    if ([self isDevelopMode] && couldLog) {
        NSLog(@"%@", string);
        if ([self isLogIntoTempDirectory]) {
            [self logStringIntoTempDirectory:string];
        }
    }
}

+ (NSString *)getFormatedStringFromString:(NSString *)fromString
{
    return [NSString stringWithFormat:@"[%@] %@",
            NSStringFromClass(self),
            fromString];
}

+ (void)logStringIntoTempDirectory:(NSString *)string {
    
    // Setup date stuff
    NSDateFormatter *dateLevelformatter = [NSDateFormatter new];
    [dateLevelformatter setDateFormat:@"YYYY-MM-dd"];
    NSDateFormatter *secondLevelDateFormatter = [NSDateFormatter new];
    [secondLevelDateFormatter setDateFormat:@"YYYYMMddHHmmss.SSSS"];
    NSDate *date = [NSDate date];
    
    // Paths - We're saving the data based on the day.
    NSError *error;
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/KNVUNDLogFiles"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }
    NSString *fileName = [NSString stringWithFormat:@"KNVUNDLogFile-%@.txt", [dateLevelformatter stringFromDate:date]];
    NSString *writePath = [folderPath stringByAppendingPathComponent:fileName];
    
    // We're going to want to append new data, so get the previous data.
    NSString *fileContents = [NSString stringWithContentsOfFile:writePath encoding:NSUTF8StringEncoding error:nil];
    
    // Write it to the string
    string = [NSString stringWithFormat:@"%@\n%@ - %@", fileContents, [secondLevelDateFormatter stringFromDate:date], string];
    
    // Write to file stored at: "~/Library/Application\ Support/iPhone\ Simulator/*version*/Applications/*appGUID*/temp/KNVUNDLogFiles/KNVUNDLogFile-*date*.txt"
    [string writeToFile:writePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
                              withControlBoolean:self.shouldShowRelatedLog];
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

- (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)logString
{
    NSString *usingLogString = [[self class] getFormatedStringFromString:logString];
    [[self class] performFurtherLogWithLogLevel:logLevel
                                  andLogString:usingLogString];
    [self performConsoleLogWithLogLevel:logLevel
                           andLogString:usingLogString];
}

- (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndFurtherLogWithLogLevel:logLevel
                                    andLogString:string];
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

@end
