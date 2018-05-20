//
//  ffHeroInfoTableViewCell.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHeroInfoTableViewCell.h"


@implementation ffHeroInfoTableViewCell

+ (CGFloat)heightForData:(id)object {
    return 138;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSeparatorStyleNone;

    self.avatarView.layer.cornerRadius = 6;
    self.avatarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.avatarView.layer.borderWidth = 1.0;
    self.avatarView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionLikeButtonClicked:(id)sender {
    if (self.delegate AND [self.delegate respondsToSelector:@selector(heroInfoItem:likeButtonDidClicked:)]) {
        [self.delegate heroInfoItem:self likeButtonDidClicked:self.index];
    }
}

@end
