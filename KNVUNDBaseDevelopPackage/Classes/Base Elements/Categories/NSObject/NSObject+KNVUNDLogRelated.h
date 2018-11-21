//
//  NSObject+KNVUNDLogRelated.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 30/1/18.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NSObject_LogLevel_Off = 0,
    NSObject_LogLevel_Error,
    NSObject_LogLevel_Warning,
    NSObject_LogLevel_Info,
    NSObject_LogLevel_Debug,
    NSObject_LogLevel_Verbose,
    NSObject_LogLevel_All
} NSObject_LogLevel; /// Currently we added for support some DDLog Integration.... we are not actually use it inside our library....

@interface NSObject (KNVUNDLogRelated)

@property (nonatomic) BOOL shouldShowRelatedLog;

#pragma mark - Class Methods
// You have to override this method if you want to show any log inside Class Method.
+ (BOOL)shouldShowClassMethodLog;

#pragma mark - Override Methods
+ (BOOL)isDevelopMode;
+ (BOOL)isLogIntoTempDirectory;
+ (void)performFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *)string;

#pragma mark Log Related
+ (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)string;
+ (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3);
+ (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)logString;
+ (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3);


#pragma mark - Log Related
// If you want to log anything for current model, please call this method inside.
- (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)string;
- (void)performConsoleLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3);
- (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogString:(NSString *_Nonnull)logString;
- (void)performConsoleAndFurtherLogWithLogLevel:(NSObject_LogLevel)logLevel andLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(2,3);


#pragma mark - Deprecated Methods
+ (void)performServerLogWithLogString:(NSString *)string __attribute__((deprecated("Use performFurtherLogWithLogLevel:andLogString: instead.")));
+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string __attribute__((deprecated("Use performConsoleLogWithLogLevel:andLogString: instead.")));
+ (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2) __attribute__((deprecated("Use performConsoleLogWithLogLevel:andLogStringFormat: instead.")));
+ (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString __attribute__((deprecated("Use performConsoleAndFurtherLogWithLogLevel:andLogString: instead.")));
+ (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2) __attribute__((deprecated("Use performConsoleAndFurtherLogWithLogLevel:andLogStringFormat: instead.")));
- (void)performConsoleLogWithLogString:(NSString *_Nonnull)string __attribute__((deprecated("Use performConsoleLogWithLogLevel:andLogString: instead.")));
- (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2) __attribute__((deprecated("Use performConsoleLogWithLogLevel:andLogStringFormat: instead.")));
- (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString __attribute__((deprecated("Use performConsoleAndFurtherLogWithLogLevel:andLogString: instead.")));
- (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2) __attribute__((deprecated("Use performConsoleAndFurtherLogWithLogLevel:andLogStringFormat: instead.")));

@end
