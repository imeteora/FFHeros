//
//  ffSummeryTableViewCell.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseTableViewCell.h"

@class ffSummeryTableViewCell;

@protocol ffSummeryTableViewCellDelegate <NSObject>
@optional
- (void)summeryItem:(ffSummeryTableViewCell *)cell didClickWithLink:(NSString *)url;
@end

@interface ffSummeryTableViewCell : ffBaseTableViewCell
@property (nonatomic, weak) id<ffSummeryTableViewCellDelegate> delegate;
- (void)setTitle:(NSString *)title withReferenceLink:(NSString *)link;
@end
