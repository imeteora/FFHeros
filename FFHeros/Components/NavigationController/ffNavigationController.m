//
//  ffNavigationController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffNavigationController.h"
#import "NSObject+FFUtils.h"

@interface ffNavigationController ()

@end

@implementation ffNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


/**
 about autorotation
 */
@implementation ffNavigationController (FFAutorotate)

- (BOOL)shouldAutorotate {
    if ([self ff_checkObject:self.topViewController overrideSelector:@"shouldAutorotate"]) {
        return self.topViewController.shouldAutorotate;
    } else {
        return NO;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self ff_checkObject:self.topViewController overrideSelector:@"supportedInterfaceOrientations"]) {
        return self.topViewController.supportedInterfaceOrientations;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self ff_checkObject:self.topViewController overrideSelector:@"preferredInterfaceOrientationForPresentation"]) {
        return self.topViewController.preferredInterfaceOrientationForPresentation;
    } else {
        return UIInterfaceOrientationPortrait;
    }
}

@end
