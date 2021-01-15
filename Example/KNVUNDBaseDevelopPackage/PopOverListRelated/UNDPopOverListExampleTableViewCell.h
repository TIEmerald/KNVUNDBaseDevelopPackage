//
//  UNDPopOverListExampleTableViewCell.h
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by UNDaniel on 2021/1/15.
//  Copyright © 2021 niyejunze.j@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UNDPopOverListExampleTableViewCellDelegate <NSObject>

- (NSArray *)fetchingOriginArray;
- (UIView *)popoverListPresentingView;

@end


@interface UNDPopOverListExampleTableViewCell : UITableViewCell

@property (nonatomic, weak) id<UNDPopOverListExampleTableViewCellDelegate> delegate;

+ (NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
