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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
