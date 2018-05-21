//
//	ffCharacterModelResult.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

#import "ffCharacterModel.h"

@implementation ffCharacterModel
+ (NSString *)gt_aliasPropertyName:(NSString *)propertyName {
    return @{@"id": @"idField",
             @"description": @"descField"
             }[propertyName];
}

+ (Class)gt_classForPropertyName:(NSString *)propertyName {
    return @{@"urls": [ffUrlModel class],
             @"thumbnail": [ffImageModel class],
             @"comics": [ffCategoryListModel class],
             @"events": [ffCategoryListModel class],
             @"series": [ffCategoryListModel class],
             @"stories": [ffCategoryListModel class],
             }[propertyName];
}

- (NSString *)detailLink {
    return [self urlLinkWithType:@"detail"];
}

- (NSString *)wikiLink {
    return [self urlLinkWithType:@"wiki"];
}

- (NSString *)comicLink {
    return [self urlLinkWithType:@"comiclink"];
}

- (NSString *)descField {
    if ([_descField length] <= 0) {
        return @"(no description)";
    } else {
        return _descField;
    }
}


#pragma mark - private helpers
- (NSString *)urlLinkWithType:(NSString *)type {
    if ([type length] <= 0) return @"";

    __block NSString *url = @"";
    [self.urls enumerateObjectsUsingBlock:^(ffUrlModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.type isEqualToString:type]) {
            url = obj.url;
            *stop = YES;
        }
    }];
    return url;
}

@end
