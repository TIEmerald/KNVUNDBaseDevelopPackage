//
//  UNDPopOverListTestDataSource.m
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by UNDaniel on 2021/1/15.
//  Copyright © 2021 niyejunze.j@gmail.com. All rights reserved.
//

#import "UNDPopOverListTestDataSource.h"

@interface UNDPopOverListTestDataSource()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation UNDPopOverListTestDataSource

#pragma mark - General Methods
- (void)registerTableView:(UITableView *)linkedTableView {
    [linkedTableView registerClass:[UNDPopOverListExampleTableViewCell class]
            forCellReuseIdentifier:[UNDPopOverListExampleTableViewCell cellIdentifier]];
    linkedTableView.delegate = self;
    linkedTableView.dataSource = self;
    [linkedTableView reloadData];
}

#pragma mark - Delegates
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNDPopOverListExampleTableViewCell *returnCell =
    [tableView dequeueReusableCellWithIdentifier:[UNDPopOverListExampleTableViewCell cellIdentifier]
                                    forIndexPath:indexPath];
    if (returnCell == nil) {
        returnCell = [UNDPopOverListExampleTableViewCell new];
    }
    returnCell.delegate = self.passingDelegate;
    return returnCell;
}

@end
