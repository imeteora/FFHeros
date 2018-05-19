//
//  ffSummeryTableViewCell.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffSummeryTableViewCell.h"

@interface ffSummeryTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameAndLinkLabel;
@property (nonatomic, copy) NSString *urlString;
@end

@implementation ffSummeryTableViewCell

+ (CGFloat)heightForData:(id)object {
    return 30.0;
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
- (void)setTitle:(NSString *)title withReferenceLink:(NSString *)link {
    [self.nameAndLinkLabel setText:title];
    self.urlString = link;
}


#pragma mark - action & events
- (IBAction)onSummaryLinkClicked:(id)sender {
    if ([self.urlString length] > 0 AND
        self.delegate AND
        [self.delegate respondsToSelector:@selector(summeryItem:didClickWithLink:)])
    {
        [self.delegate summeryItem:self didClickWithLink:self.urlString];
    }
}

@end
