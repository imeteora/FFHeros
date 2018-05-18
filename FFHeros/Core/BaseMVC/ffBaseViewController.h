//
//  ffBaseViewController.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ffBaseViewController : UIViewController

- (void)ff_viewWillFirstAppear;
- (void)ff_viewDidFirstAppear;

#pragma mark - keyboard
- (BOOL)ff_shouldRegisterKeyboardEvent;
- (void)ff_keyboardHeightChanged:(CGFloat)newHeight;

#pragma mark - close
- (void)ff_back;

@end
