//
//  ffToasteView.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ffToasteView : UIView

+ (void)showToaste:(NSString *)toaste;
+ (void)showLoading;
+ (void)showLoadingInView:(UIView *)view;
+ (void)stopLoading;

@end
