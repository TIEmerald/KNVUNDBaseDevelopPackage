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

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSString *)debugDescriptionIndentString
{
    if (_debugDescriptionIndentString == nil) {
        _debugDescriptionIndentString = @"";
    }
    return _debugDescriptionIndentString;
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

#pragma mark - Equality
- (BOOL)isEqual:(id)object
{
    return [self isEqual:object
     exceptPropertyNames:nil
exceptPropertyShouldNotBeSame:NO];
}

@end
