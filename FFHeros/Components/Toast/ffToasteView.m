//
//  ffToasteView.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffToasteView.h"

static ffToasteView *gLoadingTV = nil;

@interface ffToasteView ()
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *loadingBgView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

@implementation ffToasteView

+ (void)showToaste:(NSString *)info {
    ffToasteView *toaste = [[ffToasteView alloc] init];
    toaste.loadingIndicator.hidden = toaste.loadingBgView.hidden = YES;
    toaste.frame = [UIScreen mainScreen].bounds;
    toaste.infoLabel.text = info;
    CGSize size = [info boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 2 / 3, INT_MAX)
                                     options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics)
                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]
                                               }
                                     context:nil].size;
    size.width += 20;
    size.height += 20;

    CGRect frame = CGRectMake(0.5 * (toaste.frame.size.width - size.width), 0.5 * (toaste.frame.size.height - size.height), size.width, size.height);
    toaste.infoLabel.frame = frame;


    [[ffToasteView topWindow] addSubview:toaste];
    toaste.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        toaste.alpha = 1;
    }];

    weakify(toaste);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        strongify(toaste);
        [UIView animateWithDuration:0.3 animations:^{
            toaste.alpha = 0;
        } completion:^(BOOL finished) {
            [toaste dismiss];
        }];
    });
}

+ (void)showLoading {
    if (gLoadingTV != nil) return;

    gLoadingTV = [[ffToasteView alloc] init];
    gLoadingTV.frame = [UIScreen mainScreen].bounds;
    gLoadingTV.infoLabel.hidden = YES;

    gLoadingTV.loadingBgView.frame =
    gLoadingTV.loadingIndicator.frame =
        CGRectMake(0.5 * (gLoadingTV.frame.size.width - 70), 0.5 * (gLoadingTV.frame.size.height - 70), 70, 70);

    [gLoadingTV.loadingIndicator startAnimating];

    [[ffToasteView topWindow] addSubview:gLoadingTV];

    gLoadingTV.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        gLoadingTV.alpha = 1;
    }];
}

+ (void)stopLoading {
    if (gLoadingTV == nil) return;

    gLoadingTV.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        gLoadingTV.alpha = 0;
    } completion:^(BOOL finished) {
        [gLoadingTV removeFromSuperview];
        gLoadingTV = nil;
    }];
}


+ (UIWindow *)topWindow {
    return [[UIApplication sharedApplication].delegate window];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.infoLabel];
        [self addSubview:self.loadingBgView];
        [self addSubview:self.loadingIndicator];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.layer.cornerRadius = 6;
        _infoLabel.layer.borderWidth = 0;
        _infoLabel.layer.masksToBounds = YES;
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

- (UIView *)loadingBgView {
    if (!_loadingBgView) {
        _loadingBgView = [[UIView alloc] init];
        _loadingBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _loadingBgView.layer.cornerRadius = 6;
        _loadingBgView.layer.masksToBounds = YES;
    }
    return _loadingBgView;
}

- (UIActivityIndicatorView *)loadingIndicator {
    if (!_loadingIndicator) {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _loadingIndicator.hidesWhenStopped = YES;
    }
    return _loadingIndicator;
}
@end
