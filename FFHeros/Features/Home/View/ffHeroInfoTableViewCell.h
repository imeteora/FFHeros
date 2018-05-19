//
//  ffHeroInfoTableViewCell.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ffBaseTableViewCell.h"

@interface ffHeroInfoTableViewCell : ffBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *heroDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;

@end
