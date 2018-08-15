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

+ (void)performServerLogWithLogString:(NSString *)string
{
    
}

#pragma mark Log Related
+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    [self performConsoleLogWithLogString:string
                      withControlBoolean:[self shouldShowClassMethodLog]];
}

+ (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogString:string];
}

+ (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString
{
    NSString *usingLogString = [self getFormatedStringFromString:logString];
    [self performServerLogWithLogString: usingLogString];
    [self performConsoleLogWithLogString:usingLogString];
}

+ (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndServerLogWithLogString:string];
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-dd-MM"];
    NSDate *date = [NSDate date];
    
    // Paths - We're saving the data based on the day.
    NSError *error;
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/KNVUNDLogFiles"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }
    NSString *fileName = [NSString stringWithFormat:@"KNVUNDLogFile-%@.txt", [formatter stringFromDate:date]];
    NSString *writePath = [folderPath stringByAppendingPathComponent:fileName];
    
    // We're going to want to append new data, so get the previous data.
    NSString *fileContents = [NSString stringWithContentsOfFile:writePath encoding:NSUTF8StringEncoding error:nil];
    
    // Write it to the string
    string = [NSString stringWithFormat:@"%@\n%@ - %@", fileContents, [formatter stringFromDate:date], string];
    
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
- (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    [[self class] performConsoleLogWithLogString:string
                              withControlBoolean:self.shouldShowRelatedLog];
}

- (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleLogWithLogString:string];
}

- (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString
{
    NSString *usingLogString = [[self class] getFormatedStringFromString:logString];
    [[self class] performServerLogWithLogString:usingLogString];
    [self performConsoleLogWithLogString:usingLogString];
}

- (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list variables;
    va_start(variables, format);
    NSString *string = [[NSString alloc] initWithFormat:format
                                              arguments:variables];
    va_end(variables);
    [self performConsoleAndServerLogWithLogString:string];
}

@end
