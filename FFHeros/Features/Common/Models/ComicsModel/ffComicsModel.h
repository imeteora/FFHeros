//
//	ffComicsModel.h
//
//	Create by 德伦 朱 on 17/5/2018
//	Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gt_Modelizable.h"
#import "ffCategoryListModel.h"
#import "ffDateModel.h"
#import "ffPriceModel.h"
#import "ffSummaryModel.h"
#import "ffImageModel.h"
#import "ffUrlModel.h"
#import "ffTextObjectModel.h"

@interface ffComicsModel : gt_Modelizable

/**
 The preferred description of the comic.
 */
@property (nonatomic, strong) NSString * descriptionField;

/**
 The Diamond code for the comic
 */
@property (nonatomic, strong) NSString * diamondCode;

/**
 The ID of the digital comic representation of this comic. Will be 0 if the comic is not available digitally.,
 */
@property (nonatomic, assign) NSInteger digitalId;

/**
 The EAN barcode for the comic
 */
@property (nonatomic, strong) NSString * ean;

/**
 A resource list containing the events in which this comic appears.
 */
@property (nonatomic, strong) ffCategoryListModel * events;

/**
 The publication format of the comic e.g. comic, hardcover, trade paperback.
 */
@property (nonatomic, strong) NSString * format;

/**
 The unique ID of the comic resource.,
 */
@property (nonatomic, assign) NSInteger idField;

/**
  A list of promotional images associated with this comic.
 */
@property (nonatomic, strong) NSArray<ffImageModel *> * images;

/**
 The ISBN for the comic (generally only populated for collection formats).
 */
@property (nonatomic, strong) NSString * isbn;

/**
 The ISSN barcode for the comic
 */
@property (nonatomic, strong) NSString * issn;

/**
 The number of the issue in the series (will generally be 0 for collection formats).
 */
@property (nonatomic, assign) NSInteger issueNumber;

/**
 The date the resource was most recently modified.
 */
@property (nonatomic, strong) NSString * modified;

/**
 The number of story pages in the comic.
 */
@property (nonatomic, assign) NSInteger pageCount;

/**
 A list of prices for this comic.
 */
@property (nonatomic, strong) NSArray<ffPriceModel *> * prices;

/**
 The canonical URL identifier for this resource.
 */
@property (nonatomic, strong) NSString * resourceURI;

/**
  A summary representation of the series to which this comic belongs.
 */
@property (nonatomic, strong) ffSummaryModel * series;

/**
 A resource list containing the characters which appear in this comic.
 */
@property (nonatomic, strong) ffCategoryListModel * characters;

/**
 A resource list containing the stories which appear in this comic
 */
@property (nonatomic, strong) ffCategoryListModel * stories;

/**
 A resource list containing the creators associated with this comic.
 */
@property (nonatomic, strong) ffCategoryListModel * creators;

/**
 A set of descriptive text blurbs for the comic.
 */
@property (nonatomic, strong) NSArray<ffTextObjectModel *> * textObjects;

/**
 The representative image for this comic.
 */
@property (nonatomic, strong) ffImageModel * thumbnail;

/**
 The canonical title of the comic.
 */
@property (nonatomic, strong) NSString * title;

/**
 The UPC barcode number for the comic (generally only populated for periodical formats).
 */
@property (nonatomic, strong) NSString * upc;

/**
 A set of public web site URLs for the resource.
 */
@property (nonatomic, strong) NSArray<ffUrlModel *> * urls;

/**
 If the issue is a variant (e.g. an alternate cover, second printing, or director’s cut), a text description of the variant.
 */
@property (nonatomic, strong) NSString * variantDescription;

/**
 A list of key dates for this comic.
 */
@property (nonatomic, strong) NSArray<ffDateModel *> * dates;

/**
 A list of issues collected in this comic (will generally be empty for periodical formats such as "comic" or "magazine").
 */
@property (nonatomic, strong) NSArray<ffSummaryModel *> * collectedIssues;

/**
 A list of collections which include this comic (will generally be empty if the comic's format is a collection).
 */
@property (nonatomic, strong) NSArray<ffSummaryModel *> * collections;

/**
 A list of variant issues for this comic (includes the "original" issue if the current issue is a variant)
 */
@property (nonatomic, strong) NSArray<ffSummaryModel *> * variants;

@end
