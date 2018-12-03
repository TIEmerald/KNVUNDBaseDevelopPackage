//
//  UITableViewCell+KNVUNDETVRelatedBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 7/8/18.
//

#import "UITableViewCell+KNVUNDETVRelatedBasic.h"

/// Libs
#import <objc/runtime.h>

/// Tools
#import "KNVUNDColourRelatedTool.h"

@implementation UITableViewCell (KNVUNDETVRelatedBasic) 

#pragma mark - Getters & Setters
static void * UITableViewCell_RelatedModel = &UITableViewCell_RelatedModel;
static void * UITableViewCell_HasUIInitialised = &UITableViewCell_HasUIInitialised;

#pragma mark - Getters
- (KNVUNDExpendingTableViewRelatedModel *)relatedModel
{
    return objc_getAssociatedObject(self, UITableViewCell_RelatedModel);
}

- (BOOL)hasUIInitialised // This property will tell use that if the Cell's UI has initialised or not.... If the UI has Initialised.... there are several UI updating Method won't be called anymore.
{
    return ((NSNumber *)objc_getAssociatedObject(self, UITableViewCell_HasUIInitialised)).boolValue;
}

#pragma mark - Setters
- (void)setHasUIInitialised:(BOOL)hasUIInitialised
{
    objc_setAssociatedObject(self, UITableViewCell_HasUIInitialised, @(hasUIInitialised), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Methods for Override

/// Theme Related

NSString *const KNVUNDETVRelatedBasicTableViewCell_SelectedBackendColour = @"#7babf744";
NSString *const KNVUNDETVRelatedBasicTableViewCell_UnSelectedBackendColour = @"#eeeeee";

- (NSString *)selectedBackendColour
{
    return KNVUNDETVRelatedBasicTableViewCell_SelectedBackendColour;
}

- (NSString *)unSelectedBackendColour
{
    return KNVUNDETVRelatedBasicTableViewCell_UnSelectedBackendColour;
}

/// Actions
- (void)setupExpendedStatusUI
{
    [self setupExpendedStatusUIWithFirstTimeCheck:!self.hasUIInitialised];
}

- (void)setupExpendedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    
}

- (void)setupGeneralUIBasedOnModel
{
    [self setupGeneralUIBasedOnModelWithFirstTimeCheck:!self.hasUIInitialised];
}

- (void)setupGeneralUIBasedOnModelWithFirstTimeCheck:(BOOL)isFirstTime
{
    
}

- (void)setupSelectedStatusUI
{
    [self setupSelectedStatusUIWithFirstTimeCheck:!self.hasUIInitialised];
}

- (void)setupSelectedStatusUIWithFirstTimeCheck:(BOOL)isFirstTime
{
    if (self.relatedModel.isSelected) {
        self.backgroundColor = [KNVUNDColourRelatedTool colorWithHexString:[self selectedBackendColour]];
    } else {
        self.backgroundColor = [KNVUNDColourRelatedTool colorWithHexString:[self unSelectedBackendColour]];;
    }
}

#pragma mark - Set up
- (void)setupCellWitKNVUNDWithModel:(KNVUNDExpendingTableViewRelatedModel *)associatdModel
{
    associatdModel.relatedCellDelegate = self;
    if (self.relatedModel != associatdModel) {
        objc_setAssociatedObject(self, UITableViewCell_RelatedModel, associatdModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.hasUIInitialised = NO;
        [self updateCellUI];
        self.hasUIInitialised = YES;
    } else {
        [self updateCellUI];
    }
}

@end
