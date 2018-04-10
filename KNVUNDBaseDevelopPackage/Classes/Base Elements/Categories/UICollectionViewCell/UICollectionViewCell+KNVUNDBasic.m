//
//  UICollectionViewCell+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 6/4/18.
//

#import "UICollectionViewCell+KNVUNDBasic.h"

@implementation UICollectionViewCell (KNVUNDBasic)

#pragma mark - Class Methods
+ (NSString *)nibName
{
    return @"";
}

+ (NSString *)cellIdentifierName
{
    return @"";
}

+ (CGSize)cellSize
{
    return CGSizeMake(50.0, 50.0);
}

+ (void)registerSelfIntoCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerNib:[UINib nibWithNibName:[self nibName]
                                               bundle:nil]
     forCellWithReuseIdentifier:[self cellIdentifierName]];
}

@end
