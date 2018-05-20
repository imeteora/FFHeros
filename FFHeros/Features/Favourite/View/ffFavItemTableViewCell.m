//
//  ffFavItemTableViewCell.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFavItemTableViewCell.h"
#import "UIView+WebImage.h"

@interface ffFavItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation ffFavItemTableViewCell

+ (CGFloat)heightForData:(id)object {
    return 60;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public helpers
- (void)setAvatar:(NSString *)avatarUrl {
    [self.avatarImageView ff_setImageWithUrl:avatarUrl afterComplete:nil];
}

- (void)setName:(NSString *)name {
    [self.nameLabel setText:name];
}

- (void)setDetail:(NSString *)detailInfo {
    [self.descriptionLabel setText:detailInfo];
}

@end
