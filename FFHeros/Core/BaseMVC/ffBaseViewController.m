//
//  ffBaseViewController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseViewController.h"

@interface ffBaseViewController () {
    BOOL _firstWillAppeared;
    BOOL _firstDidAppeared;
}
@end

@implementation ffBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_firstWillAppeared == NO) {
        _firstWillAppeared = YES;
        [self ff_viewWillFirstAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_firstDidAppeared == NO) {
        _firstDidAppeared = YES;
        [self ff_viewDidFirstAppear];
    }

    if ([self ff_shouldRegisterKeyboardEvent]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ff_showKeyboardHandler:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ff_hideKeyboardHandler:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ff_showKeyboardHandler:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self ff_shouldRegisterKeyboardEvent]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}


- (void)ff_viewWillFirstAppear {
    // EMPTY
}

- (void)ff_viewDidFirstAppear {
    // EMPTY
}

- (void)ff_back {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - keyboard
- (BOOL)ff_shouldRegisterKeyboardEvent {
    return NO;
}

- (void)ff_keyboardHeightChanged:(CGFloat)newHeight {
    // EMPTY
}

- (void)ff_showKeyboardHandler:(NSNotification *)notif {
    CGRect kbframe = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self ff_keyboardHeightChanged:MIN(CGRectGetHeight(kbframe), CGRectGetWidth(kbframe))];
}

- (void)ff_hideKeyboardHandler:(NSNotification *)notif {
    [self ff_keyboardHeightChanged:0];
}

#if DEBUG
- (void)dealloc {
    NSLog(@"%@ released", [[self class] description]);
}
#endif  // DEBUG

@end
