//
//  UITableViewCell+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

#import "UITableViewCell+KNVUNDBasic.h"

@implementation UITableViewCell (KNVUNDBasic)

#pragma mark - Constant
NSString *const KNVUNDBasicTableViewCell_BaseModel_Key = @"KNVUNDBasicTableViewCellBaseModelKey";

#pragma mark - Class Methods
+ (NSString *)nibName
{
    return @"";
}

+ (NSString *)cellIdentifierName
{
    return @"";
}

+ (CGFloat)cellHeight
{
    return 44.0;
}

+ (void)registerSelfIntoTableView:(UITableView *)targetTableView
{
    NSBundle *usingBundle = [NSBundle bundleForClass:[self classForCoder]];
    [targetTableView registerNib:[UINib nibWithNibName:[self nibName]
                                                bundle:usingBundle]
          forCellReuseIdentifier:[self cellIdentifierName]];
}

#pragma mark - Object Methods for Class Methods
//// All of these methods were called from [self class]
- (NSString *)nibName
{
    return [[self class] nibName];
}

- (NSString *)cellIdentifierName
{
    return [[self class] cellIdentifierName];
}

- (CGFloat)cellHeight
{
    return [[self class] cellHeight];
}

- (void)registerSelfIntoTableView:(UITableView *)targetTableView
{
    NSBundle *usingBundle = [NSBundle bundleForClass:[self classForCoder]];
    [targetTableView registerNib:[UINib nibWithNibName:[self nibName]
                                                bundle:usingBundle]
          forCellReuseIdentifier:[self cellIdentifierName]];
}

#pragma mark - General Methods
- (void)setupCellBasedOnModelDictionary:(NSDictionary *)models
{
    
}

- (void)updateCellUI
{
    
}

#pragma mark - UITableViewDelegate Related
- (void)didSelectedCurrentCell
{
    
}

#pragma mark - Border Related
- (void)setupBordeWithWidth:(CGFloat)width andColor:(UIColor *)color isOutSide:(BOOL)isOutSide
{
    if (isOutSide) {
        self.frame = CGRectInset(self.frame, -width, -width);
    }
    
    self.contentView.layer.borderWidth = width;
    self.contentView.layer.borderColor = color.CGColor;
}

- (void)removeBorder
{
    self.contentView.layer.borderWidth = 0;
}


@end
