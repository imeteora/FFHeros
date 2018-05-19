//
//  ffBaseTableViewCell.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ffBaseTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (UINib *)nibClass;
+ (CGFloat)heightForData:(id __nullable)object;

@end
