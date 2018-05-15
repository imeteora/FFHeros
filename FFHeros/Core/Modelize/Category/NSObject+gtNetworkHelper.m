//
//  NSObject+VLNetworkHelper.m
//  VanBuren Plan
//
//  Created by Zhu Delun on 15-4-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import "NSObject+gtNetworkHelper.h"
@import ObjectiveC.runtime;

@implementation NSObject (NetworkHelper)

#pragma mark - Private Methods

// http://stackoverflow.com/questions/754824/get-an-object-properties-list-in-objective-c

static const char *getPropertyType(objc_property_t property) {
    
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
    
}

#pragma mark - Interface Methods

+ (NSArray *)obj_allPropertyKeys:(BOOL)includeSuper {
    
    Class clazz = self.class;
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    
    NSMutableArray *propertyArray = [NSMutableArray array];
    for (int i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    if (includeSuper) {
        Class superClass = class_getSuperclass(self.class);
        if (superClass != [NSObject class]) {
            NSArray *superPropertyArray = [superClass obj_allPropertyKeys:YES];
            [propertyArray addObjectsFromArray:superPropertyArray];
        }
    }
    
    return [NSArray arrayWithArray:propertyArray];
}

+ (NSString*)obj_classNameForPropertyName:(NSString *)propertyName
{
    objc_property_t property = class_getProperty(self.class, propertyName.UTF8String);
    if (property) {
        return [NSString stringWithUTF8String:getPropertyType(property)];
    }
    return nil;
}

+ (Class)obj_classForPropertyName:(NSString *)propertyName
{
    return NSClassFromString([self obj_classNameForPropertyName:propertyName]);
}

@end
