//
//  ffHeroInfoTableViewCell.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ffBaseTableViewCell.h"

@class ffHeroInfoTableViewCell;


@protocol ffHeroInfoTableViewCellDelegate <NSObject>
@optional
- (void)heroInfoItem:(ffHeroInfoTableViewCell *)cell likeButtonDidClicked:(int32_t)index;
@end


@interface ffHeroInfoTableViewCell : ffBaseTableViewCell
@property (nonatomic, weak) id<ffHeroInfoTableViewCellDelegate> delegate;
@property (nonatomic, assign) int32_t index;

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *heroDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;

@end
