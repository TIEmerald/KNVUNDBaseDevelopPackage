//
//  UICollectionViewCell+KNVUNDBasic.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 6/4/18.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (KNVUNDBasic)

#pragma mark - Class Methods
/*!
 * @discussion This method tells you which NIB is this cell come from
 * @return NSString Nib name.
 */
+ (NSString *)nibName;

/*!
 * @discussion This method tells you what is the identifier for this cell
 * @return NSString Cell Identifer
 */
+ (NSString *)cellIdentifierName;

/*!
 * @brief This method will tell you what is the size for this cell.
 * @return CGSize The size for this cell.
 */
+ (CGSize)cellSize;

/*!
 * @brief This method will register current table view cell into a target Collection View
 */
+ (void)registerSelfIntoCollectionView:(UICollectionView *)collectionView;

@end
