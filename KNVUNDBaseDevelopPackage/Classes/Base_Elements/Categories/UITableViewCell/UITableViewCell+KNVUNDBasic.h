//
//  UITableViewCell+KNVUNDBasic.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (KNVUNDBasic)

#pragma mark - Constant
// This is the shared key we are used to pass Model into Method - (void)setupCellBasedOnModelDictionary:
extern NSString *const KNVUNDBasicTableViewCell_BaseModel_Key;

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
 * @brief This method will tell you what is the height for this cell.
 * @return CGFloat The height for this cell.
 */
+ (CGFloat)cellHeight;

/*!
 * @brief This method will register current table view cell into a target Table View
 */
+ (void)registerSelfIntoTableView:(UITableView *)targetTableView;

#pragma mark - Object Methods for Class Methods
//// All of these methods were called from [self class]
- (NSString *)nibName;
- (NSString *)cellIdentifierName;
- (CGFloat)cellHeight;
- (void)registerSelfIntoTableView:(UITableView *)targetTableView;

#pragma mark - General Methods
/*!
 * @brief You could override this method in Sub-Classes or write your own set up Methods. This method is created to make set up methods in table view cells more consistent.
 */
- (void)setupCellBasedOnModelDictionary:(NSDictionary *)models;

/*!
 * @brief This method will be called when some trigger happend and you only want to update several UI inside the cell instead of reload the cell again.
 */
- (void)updateCellUI NS_REQUIRES_SUPER;

#pragma mark - UITableViewDelegate Related
/*!
 * @brief If you need re-use this method, you'd better call this method in
 Mehtod: - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 */
- (void)didSelectedCurrentCell;

#pragma mark - Border Related
/*!
 * @brief This method will set a border to the cell with width and color
 * @param width How width it is for the border
 * @param color What color will you set for the border
 * @param isOutSide This will tell us do you want show the border outside or inside current view
 */
- (void)setupBordeWithWidth:(CGFloat)width andColor:(UIColor *)color isOutSide:(BOOL)isOutSide;

/*!
 * @brief This method will just remove the border from current Cell
 */
- (void)removeBorder;

@end
