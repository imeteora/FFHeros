//
//  ffFetchCharacterComicsApi.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "gt_Modelizable.h"
#import "ffComicsModel.h"

/**
 Fetches lists of comics containing a specific character, with optional filters. See notes on individual parameters below.
 */
@interface ffFetchCharacterComicsApi : gt_Modelizable

/**
 Filter by the issue format (e.g. comic, digital comic, hardcover).
 */
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *formatType;
@property (nonatomic, strong) NSNumber *noVariants;
@property (nonatomic, copy) NSString *dateDescriptor;

/**
 Return comics within a predefined date range. Dates must be specified as date1,date2 (e.g. 2013-01-01,2013-01-02). Dates are preferably formatted as YYYY-MM-DD but may be sent as any common date format.
 */
@property (nonatomic, copy) NSString *dateRange;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleStartsWith;
@property (nonatomic, strong) NSNumber *startYear;
@property (nonatomic, strong) NSNumber *issueNumber;
@property (nonatomic, copy) NSString *diamondCode;
@property (nonatomic, strong) NSNumber *digitalId;

@property (nonatomic, copy) NSString *upc;
@property (nonatomic, copy) NSString *isbn;
@property (nonatomic, copy) NSString *ean;
@property (nonatomic, copy) NSString *issn;

/**
 Include only results which are available digitally.
 */
@property (nonatomic, strong) NSNumber *hasDigitalIssue;    // true or false
@property (nonatomic, strong) NSString *modifiedSince;

@property (nonatomic, strong) NSNumber *creators;
@property (nonatomic, strong) NSNumber *series;
@property (nonatomic, strong) NSNumber *events;
@property (nonatomic, strong) NSNumber *stories;
@property (nonatomic, strong) NSNumber *sharedAppearances;
@property (nonatomic, strong) NSNumber *collaborators;

/**
 Order the result set by a field or fields. Add a "-" to the value sort in descending order. Multiple values are given priority in the order in which they are passed.
 */
@property (nonatomic, strong) NSString *orderBy;

@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSNumber *offset;


/**
 Fetches lists of comics containing a specific character, with optional filters. See notes on individual parameters below.

 @param cid character's id
 @param completeHandler the success callback lambda function
 @param errorHandler the error callback lambda function
 */
- (void)requestWithCharacterId:(NSString *)cid afterComplete:(void (^__nullable)(ffComicsModel * _nullable))completeHandler ifError:(void (^__nullable)(NSError * __nullable, id __nullable))errorHandler;

@end
