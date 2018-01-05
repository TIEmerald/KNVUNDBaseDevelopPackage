//
//  KNVUNDBaseModel.m
//  Expecta
//
//  Created by Erjian Ni on 8/12/17.
//

#import "KNVUNDBaseModel.h"

// Tools
#import "KNVUNDRuntimeRelatedTool.h"

@implementation KNVUNDBaseModel

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

+ (void)performServerLogWithLogString:(NSString *)string
{
    
}

#pragma mark Log Related
+ (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    if ([self isDevelopMode] && [self shouldShowClassMethodLog]) {
        NSLog(@"%@", string);
    }
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

#pragma mark - Properties Related
+ (NSDictionary *)propertyDescriptions
{
    NSMutableDictionary *returnDict = [NSMutableDictionary new];
    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:[self new]
                                   withAttributStringLoopBlock:^(NSString * _Nonnull propertyName, NSString * _Nonnull attributeString, id  _Nullable value, BOOL * _Nonnull stopLoop) {
                                       [returnDict setObject:attributeString
                                                      forKey:propertyName];
                                   }];
    return returnDict;
}

#pragma mark - Support Methods
+ (NSString *)getFormatedStringFromString:(NSString *)fromString
{
    return [NSString stringWithFormat:@"[%@] %@",
            NSStringFromClass(self),
            fromString];
}

#pragma mark - Log Related
- (void)performConsoleLogWithLogString:(NSString *_Nonnull)string
{
    if ([KNVUNDBaseModel isDevelopMode] && self.shouldShowRelatedLog) {
        NSLog(@"%@", string);
    }
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
    [KNVUNDBaseModel performServerLogWithLogString:usingLogString];
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

#pragma mark - Equality
- (BOOL)isEqual:(id)object
{
    // Step One, Check if the object you passed in is same Class or not.
    if ([object class] != [self class]) {
        return NO;
    }
    
    __block BOOL returnValue = YES;
    
    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:object
                                                 withLoopBlock:^(NSString * _Nonnull propertyName, KNVUNDRuntimeRelatedTool_PropertyType propertyType, NSString * _Nullable typeName, id  _Nullable value, BOOL * _Nonnull stopLoop) {
                                                     BOOL isObject = propertyType == KNVUNDRuntimeRelatedTool_PropertyType_Object;
                                                     id selfPropertyValue = [self valueForKey:(NSString *)propertyName];
                                                     id objectPropertyValue = value;
                                                     
                                                     if (!isObject && selfPropertyValue == objectPropertyValue) {
                                                         return;
                                                     } else if (isObject && [selfPropertyValue respondsToSelector:@selector(isEqual:)] && [selfPropertyValue isEqual:objectPropertyValue]){
                                                         return;
                                                     }
                                                     returnValue = NO;
                                                     *stopLoop = YES;
                                                 }];
    return returnValue;
}

@end
