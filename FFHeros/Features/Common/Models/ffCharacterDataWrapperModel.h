//
//	ffCharacterModel.h
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

// 

#import <UIKit/UIKit.h>
#import "gt_Modelizable.h"
#import "ffCharacterDataContainerModel.h"

@interface ffCharacterDataWrapperModel : gt_Modelizable

@property (nonatomic, copy) NSString * attributionHTML;
@property (nonatomic, copy) NSString * attributionText;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString * copyright;
@property (nonatomic, strong) ffCharacterDataContainerModel * data;
@property (nonatomic, copy) NSString * etag;
@property (nonatomic, copy) NSString * status;

@end
