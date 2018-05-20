//
//  ffFavItemTableViewCell.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ffBaseTableViewCell.h"

@interface ffFavItemTableViewCell : ffBaseTableViewCell

- (void)setAvatar:(NSString *)avatarUrl;
- (void)setName:(NSString *)name;
- (void)setDetail:(NSString *)detailInfo;

@end
