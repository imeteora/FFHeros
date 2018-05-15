//
//  ffApiRequestOperation.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffAPIConfig.h"

@class ffApiRequestOperation;

@protocol ffApiRequestOperationDelegate <NSObject>
@required
- (void)didCanceledRequestOperation:(nonnull ffApiRequestOperation *)operation;
@end



@interface ffApiRequestOperation : NSOperation

@property (nonatomic, strong, nonnull) NSURLRequest *request;
@property (nonatomic, strong, nullable) ffAPIConfig *config;
@property (nonatomic, weak, nullable) id<ffApiRequestOperationDelegate> delegate;

@property (nonatomic, strong, nonnull) BOOL (^preRequestHandler)(void);
@property (nonatomic, strong, nonnull) void (^postRequestHandler)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);


- (void)establish:(BOOL)nowOrNot;

@end
