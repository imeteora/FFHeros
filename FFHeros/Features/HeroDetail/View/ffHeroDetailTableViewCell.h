//
//  ffHeroDetailTableViewCell.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseTableViewCell.h"

@interface ffHeroDetailTableViewCell : ffBaseTableViewCell

- (void)setAvatar:(NSString *)avatarUri;
- (void)setName:(NSString *)name;
- (void)setModifyInfo:(NSString *)modifyInfo;
- (void)setDescriptionInfo:(NSString *)description;

@end
