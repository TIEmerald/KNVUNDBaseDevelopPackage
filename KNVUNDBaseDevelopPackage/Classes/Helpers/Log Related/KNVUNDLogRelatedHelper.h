//
//  KNVUNDLogRelatedHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 11/1/18.
//

#import "KNVUNDBaseModel.h"

@protocol KNVUNDLogRelatedModelProtocol

@required
- (NSString *_Nonnull)getSelfLogStringWithTitle:(NSString *_Nonnull)titleString andIndentString:(NSString *_Nullable)indentString andCurrentIndentLevel:(NSUInteger)currentIndentLevel;

@end

@interface KNVUNDLogRelatedHelperContentModel : KNVUNDBaseModel

@property (nonatomic, strong, nonnull) NSString *descriptionString;
@property (nonatomic, nonnull) id contentValue;

#pragma mark - Initial
- (instancetype _Nonnull)initWithDescriptionString:(NSString *_Nonnull)descriptionString andContentValue:(id _Nonnull)contentValue;

@end

@interface KNVUNDLogRelatedHelper : KNVUNDBaseModel

@property (nonatomic, strong, nonnull) NSString *indentString;

#pragma mark - General Methods
#pragma mark - Appending
- (void)appendLogStringWithTitle:(NSString *_Nonnull)titleString andCurrentIndentLevel:(NSUInteger)currentIndentLevel;
- (void)appendLogStringWithTitle:(NSString *_Nonnull)titleString contentModelArrays:(NSArray *_Nonnull)contentArray andCurrentIndentLevel:(NSUInteger)currentIndentLevel;

#pragma mark - Clearing
- (void)clearTempStoredString;

#pragma mark - Retrieving
- (NSString *_Nonnull)retrieveResultString;

@end
