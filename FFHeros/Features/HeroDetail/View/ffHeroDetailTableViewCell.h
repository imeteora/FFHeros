//
//  ffHeroDetailTableViewCell.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseTableViewCell.h"

@class ffHeroDetailTableViewCell;

@protocol ffHeroDetailTableViewCellDelegate <NSObject>
@optional
- (void)heroDetailCell:(ffHeroDetailTableViewCell *)cell showReferenceDoc:(NSString *)url;
@end

@interface ffHeroDetailTableViewCell : ffBaseTableViewCell
@property (nonatomic, weak) id<ffHeroDetailTableViewCellDelegate> delegate;
@property (nonatomic, copy) NSString *referenceURI;

- (void)setAvatar:(NSString *)avatarUri;
- (void)setName:(NSString *)name;
- (void)setModifyInfo:(NSString *)modifyInfo;
- (void)setDescriptionInfo:(NSString *)description;

@end
