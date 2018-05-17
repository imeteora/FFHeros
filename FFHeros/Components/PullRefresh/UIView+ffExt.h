//
//  UIView+ffExt.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ffExt)

@property (nonatomic, assign) CGFloat viewLeft;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, assign, readonly) CGFloat viewRight;
@property (nonatomic, assign, readonly) CGFloat viewBottom;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;


@end
