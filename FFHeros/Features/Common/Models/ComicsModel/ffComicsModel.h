//
//	ffComicsModel.h
//
//	Create by 德伦 朱 on 17/5/2018
//	Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gtModelizable.h"
#import "ffCategoryListModel.h"
#import "ffDateModel.h"
#import "ffPriceModel.h"
#import "ffSummaryModel.h"
#import "ffImageModel.h"
#import "ffUrlModel.h"
#import "ffTextObjectModel.h"

@interface ffComicsModel : gtModelizable

@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * diamondCode;
@property (nonatomic, assign) NSInteger digitalId;
@property (nonatomic, strong) NSString * ean;
@property (nonatomic, strong) ffCategoryListModel * events;
@property (nonatomic, strong) NSString * format;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSArray<ffImageModel *> * images;
@property (nonatomic, strong) NSString * isbn;
@property (nonatomic, strong) NSString * issn;
@property (nonatomic, assign) NSInteger issueNumber;
@property (nonatomic, strong) NSString * modified;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSArray<ffPriceModel *> * prices;
@property (nonatomic, strong) NSString * resourceURI;
@property (nonatomic, strong) ffSummaryModel * series;
@property (nonatomic, strong) ffCategoryListModel * characters;
@property (nonatomic, strong) ffCategoryListModel * stories;
@property (nonatomic, strong) ffCategoryListModel * creators;
@property (nonatomic, strong) NSArray<ffTextObjectModel *> * textObjects;
@property (nonatomic, strong) ffImageModel * thumbnail;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * upc;
@property (nonatomic, strong) NSArray<ffUrlModel *> * urls;
@property (nonatomic, strong) NSString * variantDescription;
@property (nonatomic, strong) NSArray<ffDateModel *> * dates;
@property (nonatomic, strong) NSArray<ffSummaryModel *> * collectedIssues;
@property (nonatomic, strong) NSArray<ffSummaryModel *> * collections;
@property (nonatomic, strong) NSArray<ffSummaryModel *> * variants;

@end
