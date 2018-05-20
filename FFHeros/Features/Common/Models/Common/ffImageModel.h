//
//	ffImageModel.h
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gt_Modelizable.h"

@interface ffImageModel : gt_Modelizable

@property (nonatomic, copy) NSString * extension;
@property (nonatomic, copy) NSString * path;

- (NSString *)pathWithPortraitSize:(CGSize)size;
- (NSString *)pathWithSquareSize:(CGSize)size;
- (NSString *)pathWithLandscapeSize:(CGSize)size;

@end
