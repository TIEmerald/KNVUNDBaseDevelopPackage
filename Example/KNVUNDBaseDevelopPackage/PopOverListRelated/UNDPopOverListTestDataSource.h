//
//  UNDPopOverListTestDataSource.h
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by UNDaniel on 2021/1/15.
//  Copyright © 2021 niyejunze.j@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/// TableViewCell
#import "UNDPopOverListExampleTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UNDPopOverListTestDataSource : NSObject

@property (nonatomic, weak) id <UNDPopOverListExampleTableViewCellDelegate> passingDelegate;

#pragma mark - General Methods
- (void)registerTableView:(UITableView *)linkedTableView;

@end

NS_ASSUME_NONNULL_END
