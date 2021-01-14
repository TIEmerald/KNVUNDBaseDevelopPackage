//
//  UNDPopOverListItemModelProtocol.h
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#ifndef UNDPopOverListItemModelProtocol_h
#define UNDPopOverListItemModelProtocol_h

// Protocols
#import "UNDPopOverListTableViewCellProtocol.h"

@protocol UNDPopOverListItemModelProtocol <NSObject>

- (Class<UNDPopOverListTableViewCellProtocol>)relatedCellClass;
- (void)updateDisplayUIFromCell:(UITableViewCell<UNDPopOverListTableViewCellProtocol> *)aCell;

@end


#endif /* UNDPopOverListItemModelProtocol_h */
