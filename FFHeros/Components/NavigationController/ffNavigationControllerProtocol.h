//
// Created by ZhuDelun on 2018/5/18.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ffNavigationControllerProtocol <NSObject>

@optional

/**
 if YES, navigation controller will allow only one single instance in subViewControllers stack. The older current type of view-controller instance will be removed from sub-viewcontrollers stack automatically.

 @return YES means allow only one instance in sub view-controller stack.
 */
- (BOOL)ff_allowSingleInstanceOnly;

/**
 if YES, current view-controller will not be shown, and be removed when calls `-popViewCotnrollerAnimted:`.

 @return YES means current view controller will be skip, when -popViewControllerAnimated: called.
 */
- (BOOL)ff_needBeSkippedDuringPoping;

/**
 should accept the drag back gesture from view-controller

 @return YES means drag-back gesture action is acceptable.
 */
- (BOOL)ff_shouldAcceptDragBackGesture;

@end
