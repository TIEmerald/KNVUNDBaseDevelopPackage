//
//  KNVUNDBaseModel.h
//  Expecta
//
//  Created by Erjian Ni on 8/12/17.
//

#import <Foundation/Foundation.h>

@interface KNVUNDBaseModel : NSObject

@property (nonatomic) BOOL shouldShowRelatedLog;

#pragma mark - Class Methods
// You have to override this method if you want to show any log inside Class Method.
+ (BOOL)shouldShowClassMethodLog;

#pragma mark Log Related
+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string;
+ (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2);
+ (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString;
+ (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2);

#pragma mark - Log Related
// If you want to log anything for current model, please call this method inside.
- (void)performConsoleLogWithLogString:(NSString *_Nonnull)string;
- (void)performConsoleLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)performConsoleAndServerLogWithLogString:(NSString *_Nonnull)logString;
- (void)performConsoleAndServerLogWithLogStringFormat:(NSString *_Nonnull)format, ... NS_FORMAT_FUNCTION(1,2);

@end
