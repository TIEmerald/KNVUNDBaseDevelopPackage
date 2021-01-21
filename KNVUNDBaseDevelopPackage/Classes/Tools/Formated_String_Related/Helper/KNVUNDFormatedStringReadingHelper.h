//
//  KNVUNDFormatedStringReadingHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 31/1/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDFSReadingHelperSettingModel : KNVUNDBaseModel

@property (nonatomic, strong) NSMutableString *readingContent;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic) NSUInteger startCheckingLocation;
@property (nonatomic) NSUInteger maximumOutputModelCount;
@property (nonatomic) BOOL shouldRemoveContentValue;

@end

@interface KNVUNDFormatedStringReadingHelper : KNVUNDBaseModel

#pragma mark - Initial
- (instancetype)initWithSettingModel:(KNVUNDFSReadingHelperSettingModel *)settingModel;

#pragma mark - Reading Method
- (NSArray *)readAndRetrievingStringModels;

@end
