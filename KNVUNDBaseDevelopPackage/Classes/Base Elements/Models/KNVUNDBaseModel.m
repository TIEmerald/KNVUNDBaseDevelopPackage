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

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSString *)debugDescriptionIndentString
{
    if (_debugDescriptionIndentString == nil) {
        _debugDescriptionIndentString = @"";
    }
    return _debugDescriptionIndentString;
}

#pragma mark - NSObject
///// We need to pass a Mutable array to record all checked objects..... in case loop...
//- (NSString *)debugDescription
//{
//    NSMutableString *returnString = [NSMutableString new];
//    NSString *currentIndentString = self.debugDescriptionIndentString;
//    NSString *nextLevelIndentString = [currentIndentString stringByAppendingString:@"    "];
//    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:self
//                                                 withLoopBlock:^(KNVUNDRRTPropertyDetailsModel * _Nonnull detailsModel, BOOL *stopLoop) {
//                                                     [returnString appendString:[NSString stringWithFormat:@"%@%@ (%@):\n",
//                                                                                 currentIndentString,
//                                                                                 detailsModel.propertyName,
//                                                                                 detailsModel.typeName?: @""]];
//                                                     if ([detailsModel.value isKindOfClass:[KNVUNDBaseModel class]]) {
//                                                         KNVUNDBaseModel *valueModel = (KNVUNDBaseModel *)detailsModel.value;
//                                                         valueModel.debugDescriptionIndentString = nextLevelIndentString;
//                                                         [returnString appendString:valueModel.debugDescription];
//                                                     } else {
//                                                         [returnString appendString:[NSString stringWithFormat:@"%@%@\n",
//                                                                                     nextLevelIndentString,
//                                                                                     detailsModel.value]];
//                                                     }
//                                                 }];
//    return returnString;
//}

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
    return [self isEqual:object
     exceptPropertyNames:nil
exceptPropertyShouldNotBeSame:NO];
}

@end
