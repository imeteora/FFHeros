//
//  ffHeroDetailTableViewCell.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHeroDetailTableViewCell.h"
#import "ffWebViewController.h"
#import "UIView+WebImage.h"
#import "UIImage+BlurEffect.h"

@interface ffHeroDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifyInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) UIImage *blurImage;

@end

@implementation ffHeroDetailTableViewCell

+ (CGFloat)heightForData:(id)object {
    return 274;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.layer.cornerRadius = 6;
    self.avatarImageView.layer.borderWidth = 0.5;
    self.avatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public helpers
- (void)setAvatar:(NSString *)avatarUri {
    weakify(self);
    [self.avatarImageView ff_setImageWithUrl:avatarUri afterComplete:^(UIImage *image) {
        strongify(self);
        self.blurImage = [image ff_blurredImageWithRadius:10 iterations:5 tintColor:[UIColor blackColor]];
        [self.bgImageView setImage:self.blurImage];
    }];
}

- (void)setName:(NSString *)name {
    [self.nameLabel setText:name];
}

- (void)setModifyInfo:(NSString *)modifyInfo {
    if ([modifyInfo length] <= 0) {
        [self.modifyInfoLabel setText:@"(Blank)"];
    } else {
        [self.modifyInfoLabel setText:modifyInfo];
    }
}

- (void)setDescriptionInfo:(NSString *)description {
    if ([description length] <= 0) {
        [self.descriptionLabel setText:@"(no description)"];
    } else {
        [self.descriptionLabel setText:description];
    }
}

- (void)setFavouriteState:(BOOL)favState {
    [self.likeButton setSelected:favState];
}

- (void)setReferenceURI:(NSString *)referenceURI {
    _referenceURI = referenceURI;
    if ([_referenceURI length] > 0) {
        [self.linkLabel setText:[NSString stringWithFormat:@"Link:%@", _referenceURI]];
    } else {
        [self.linkLabel setText:@"Link: None"];
    }
}

#pragma mark - actions & events

- (IBAction)onLinkButtonClicked:(id)sender {
    if ([self.referenceURI length] > 0 AND
        self.delegate AND
        [self.delegate respondsToSelector:@selector(heroDetailCell:showReferenceDoc:)])
    {
        [self.delegate heroDetailCell:self showReferenceDoc:self.referenceURI];
    }
}

- (IBAction)onLikeButtonClicked:(id)sender {
    if (self.delegate AND [self.delegate respondsToSelector:@selector(didSelectedLikeButtonInHeroDetail:)]) {
        [self.delegate didSelectedLikeButtonInHeroDetail:self];
    }
}

@end
