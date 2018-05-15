//
//  ffApiRequestQueue.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffApiRequestOperationQueue : NSOperationQueue
+ (_Nonnull instancetype)shared;
- (nonnull NSURLSession *)session;
@end
