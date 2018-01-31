//
//  KNVUNDFSRToolHTMLLikeStringModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 31/1/18.
//

#import "KNVUNDFSRToolHTMLLikeStringModel.h"

// Categories
#import "KNVUNDFSRToolHTMLLikeStringModel+PackageInternal.h"

@interface KNVUNDFSRToolHTMLLikeStringModel(){
    NSMutableDictionary *_storingAttringbutesDic;
}

@property (nonatomic, readwrite) NSUInteger fullLength;
@property (nonatomic, strong) NSMutableArray *storedChildrenArray;

@end

@implementation KNVUNDFSRToolHTMLLikeStringModel

#pragma mark - KNVUNDBaseModel
- (BOOL)shouldShowRelatedLog
{
    return YES;
}

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSDictionary *)additionalAttribute
{
    return _storingAttringbutesDic;
}

- (NSArray *)relatdChildrenModels
{
    return self.storedChildrenArray;
}

- (NSString *)fullAttributesString
{
    NSMutableString *returnString = [NSMutableString stringWithString:@""];
    for (NSString *key in self.additionalAttribute.allKeys) {
        
        /// Step One, Get the Value String for current key.
        NSString *valueString = @"";
        id value = self.additionalAttribute[key];
        if ([value isKindOfClass:[NSString class]]) {
            valueString = [NSString stringWithFormat:@"\"%@\"",
                           value];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            valueString = [NSString stringWithFormat:@"%@",
                           value];
        } else {
            continue; /// We only support NSString or NSNumber
        }
        
        /// Step Two, Adding Attribute to return string.
        NSString *appendingString = [NSString stringWithFormat:@" %@%c%@",
                                     key,
                                     KNVUNDFSRToolHTMLLikeStringModel_Additional_Attributes_Property_Equal,
                                     valueString];
        
        [returnString appendString:appendingString];
    }
    return returnString;
}

- (NSString *)fullFormatedString
{
    switch (self.type) {
        case KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder:
            return [self generatePlaceholderTypeFormatedStringFromSelf];
        default:
            return [self generateFormatTypeFormatedStringFromSelf];
    }
}

- (NSUInteger)fullLength
{
    if (_fullLength == 0){
        /// Which means this model is not generated from read method, and it's a method we want to generate the formated string... Therefore the length should be consistent with fullFormatedString.
        _fullLength = self.fullFormatedString.length;
    }
    return _fullLength;
}

#pragma mark Support Methodss
- (NSString *_Nonnull)generateFormatTypeFormatedStringFromSelf
{
    NSString *endingWrapper = [NSString stringWithFormat:@"%c%c%@%c",
                               KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
                               KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier,
                               self.propertyName,
                               KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
    
    return [NSString stringWithFormat:@"%c%@%@%c%@%@",
            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
            self.propertyName,
            self.fullAttributesString,
            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End,
            self.contentValue ?: @"",
            endingWrapper];
}

- (NSString *_Nonnull)generatePlaceholderTypeFormatedStringFromSelf
{
    return [NSString stringWithFormat:@"%c%@%@%c",
            KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start,
            self.propertyName,
            self.fullAttributesString,
            KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End];
}

#pragma mark - Setters
- (void)setAdditionalAttribute:(NSDictionary *)additionalAttribute
{
    if (additionalAttribute == nil) {
        [_storingAttringbutesDic removeAllObjects];
    } else {
        for (NSString *keyValue in additionalAttribute.allKeys) {
            [_storingAttringbutesDic setValue:additionalAttribute[keyValue]
                                       forKey:keyValue];
        }
    }
}

- (void)setParentLevelModel:(KNVUNDFSRToolHTMLLikeStringModel *)parentLevelModel
{
    if (_parentLevelModel) {
        [_parentLevelModel.storedChildrenArray removeObject:self];
    }
    _parentLevelModel = parentLevelModel;
    [parentLevelModel.storedChildrenArray addObject:self];
}

- (void)updateAddictionalAttributeKey:(NSString *)key withValue:(id)value
{
    if (key != nil) {
        [_storingAttringbutesDic setValue:value
                                   forKey:key];
    }
}

- (void)updateFullLengthFromReading:(NSUInteger)fullLength
{
    self.fullLength = fullLength;
}

#pragma mark - NSObject
- (NSString *)description
{
    return self.fullFormatedString;
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        _storingAttringbutesDic = [NSMutableDictionary new];
        self.storedChildrenArray = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithPropertyName:(NSString *)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type andLocation:(NSUInteger)location
{
    if (self = [self init]) {
        self.propertyName = propertyName;
        self.type = type;
        self.location = location;
    }
    return self;
}

- (instancetype)initWithPropertyName:(NSString *)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type location:(NSUInteger)location attributesDictionary:(NSDictionary *)attributes andContentValue:(NSString *)contentValue
{
    if (self = [self initWithPropertyName:propertyName type:type andLocation:location]) {
        self.additionalAttribute = attributes;
        self.contentValue = contentValue;
    }
    return self;
}

#pragma mark - Getter Methods
- (id _Nullable)getAttributeValueFromAttributeKey:(NSString *_Nonnull)attributKey
{
    return [_storingAttringbutesDic valueForKey:attributKey];
}

@end
