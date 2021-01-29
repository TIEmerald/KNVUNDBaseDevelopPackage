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

- (id)cachedData;
- (Class<UNDPopOverListTableViewCellProtocol>)relatedCellClass;
- (void)updateDisplayUIFromCell:(UITableViewCell<UNDPopOverListTableViewCellProtocol> *)aCell;

@optional
- (BOOL)isSelectable; // You could support this configuration or not. if you sepecify this value to false. Normally for some models only support for displaying purpose.

@end


#endif /* UNDPopOverListItemModelProtocol_h */
