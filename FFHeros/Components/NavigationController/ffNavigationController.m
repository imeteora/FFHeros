//
//  ffNavigationController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffNavigationController.h"
#import "NSObject+FFUtils.h"
#import "ffNavigationControllerProtocol.h"
#import <objc/runtime.h>


static char v_screenShot_flag;
@interface ffNavigationController ()
<
UINavigationControllerDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, readwrite) UIPanGestureRecognizer *dragbackGesture;
@property (nonatomic) UIImageView *fromScreenShotContainer;
@property (nonatomic) UIImageView *shadowImageView;
@property (nonatomic) UIView *fromScreenShotBlackLayerView;
@property (nonatomic) BOOL isDragingBack;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGRect startFrame;

@end

@implementation ffNavigationController

#pragma mark - override helpers
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil]) {
        [self setViewControllers:@[rootViewController]];
        self.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[[UIImage alloc] init]];
        self.delegate = self;
    }
    return self;
}

- (void)pushViewController:(UIViewController<ffNavigationControllerProtocol> *)viewController animated:(BOOL)animated {
    [viewController.navigationItem.leftBarButtonItem setTarget:self];
    [viewController.navigationItem.leftBarButtonItem setAction:@selector(_actionBackButtonClicked)];

    if (self.presentedViewController) {
        return;
    }

    /// 1, get a snapshot of current top view-controller as a bg image during pop backward by pan gesture.
    [self _setScreenShotFromLastestVc:viewController image:[self _snapShotWithUpdates:NO]];

    if ([viewController respondsToSelector:@selector(ff_allowSingleInstanceOnly)] &&
            [viewController ff_allowSingleInstanceOnly] &&
            [self.viewControllers count] > 1)
    {
        NSMutableArray *tempVcs = [NSMutableArray arrayWithArray:self.viewControllers];
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *x, NSUInteger idx, BOOL *stop) {
            if ([x isKindOfClass:[viewController class]]) {
                [tempVcs removeObject:x];
            }
        }];
        if (tempVcs.count != self.viewControllers.count) {
            [self setViewControllers:[tempVcs copy]];
        }
    }

    if (self.topViewController == viewController) return;
    [super pushViewController:viewController animated:YES];

    return;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = self.viewControllers;
    UIViewController *needPopedToVc = nil;
    if (vcs.count > 2) {
        for (NSInteger i = vcs.count - 2; i >= 0; i --) {
            UIViewController<ffNavigationControllerProtocol> * vc = vcs[i];
            if ([vc respondsToSelector:@selector(ff_needBeSkippedDuringPoping)] && [vc ff_needBeSkippedDuringPoping]) {
                continue;
            }
            needPopedToVc = vc;
            break;
        }
    }
    if (needPopedToVc) {
        [super popToViewController:needPopedToVc animated:animated];
        return needPopedToVc;
    } else {
        return [super popViewControllerAnimated:animated];
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    const int32_t vcCounts = (int32_t)[self.viewControllers count];
    self.dragbackGesture.enabled = ([self _getScreenShotFromLastestVc:viewController] && (vcCounts > 1));
    self.interactivePopGestureRecognizer.enabled = (!self.dragbackGesture.enabled && (vcCounts > 1));
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view.window];
    CGFloat x = self.view.window.frame.size.width;
    CGFloat maxTriggerx = MAX(MIN(-0.00262858*x*x+3.0995883*x-712.70197,50), 30);
    if (touchPoint.x < maxTriggerx) {
        UIViewController<ffNavigationControllerProtocol> *vc = self.viewControllers.lastObject;
        if ([vc respondsToSelector:@selector(ff_shouldAcceptDragBackGesture)]) {
            return [vc ff_shouldAcceptDragBackGesture];
        }
        return YES;
    }
    return NO;
}


#pragma mark - actions & events
- (void)_actionBackButtonClicked {
    [self popViewControllerAnimated:YES];
}

- (void)_onPanGestureReceivedEvevt:(UIPanGestureRecognizer *)recoginzer
{
    weakify(self);

    CGPoint touchPoint = [recoginzer locationInView:self.view.window];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        self.isDragingBack = YES;
        self.startPoint = touchPoint;
        self.startFrame = self.view.frame;

        self.fromScreenShotContainer.image = [self _getScreenShotFromLastestVc:self.viewControllers.lastObject];
        CGRect frame = self.view.frame;
        frame.origin.x = -frame.size.width*2/3;
        self.fromScreenShotContainer.frame = frame;
        self.fromScreenShotBlackLayerView.frame = self.fromScreenShotContainer.bounds;
        self.shadowImageView.frame = CGRectMake(-20, self.startFrame.origin.y, 20, self.startFrame.size.height);
        [self.view insertSubview:self.fromScreenShotContainer atIndex:0];
        [self.view insertSubview:self.shadowImageView aboveSubview:self.fromScreenShotContainer];

    } else if (recoginzer.state == UIGestureRecognizerStateEnded || recoginzer.state == UIGestureRecognizerStateCancelled ){
        self.isDragingBack = NO;
        CGPoint velocityP = [recoginzer velocityInView:self.view.window];
        CGFloat duration = 0.3;
        if (velocityP.x > 0 || (touchPoint.x - self.startPoint.x > self.startFrame.size.width /2 && velocityP.x == 0) )
        {
            if (velocityP.x > 0) {
                duration = MIN((self.startFrame.size.width - (touchPoint.x - self.startPoint.x))/velocityP.x,0.3);
            }
            [UIView animateWithDuration:duration animations:^{
                strongify(self);
                self.view.frame = CGRectMake(self.startFrame.size.width, self.startFrame.origin.y, self.startFrame.size.width, self.startFrame.size.height);
                self.fromScreenShotContainer.frame = CGRectMake(-self.startFrame.size.width, self.startFrame.origin.y, self.startFrame.size.width, self.startFrame.size.height);
                self.fromScreenShotBlackLayerView.alpha = 0;
                self.shadowImageView.alpha = 0;
            } completion:^(BOOL finished) {
                strongify(self);
                [self.fromScreenShotContainer removeFromSuperview];
                [self.shadowImageView removeFromSuperview];
                self.view.frame = self.startFrame;
                [self popViewControllerAnimated:NO];
            }];
        } else {
            if (velocityP.x < 0) {
                duration = MIN((touchPoint.x - _startPoint.x)/(-velocityP.x),0.3);
            }
            [UIView animateWithDuration:duration animations:^{
                strongify(self);
                self.view.frame = self.startFrame;
                self.fromScreenShotBlackLayerView.alpha = 0;
                self.shadowImageView.alpha = 0;
                self.fromScreenShotContainer.frame = CGRectMake(-self.startFrame.size.width/3, self.startFrame.origin.y, self.startFrame.size.width, self.startFrame.size.height);
            } completion:^(BOOL finished) {
                strongify(self);
                [self.fromScreenShotContainer removeFromSuperview];
                [self.shadowImageView removeFromSuperview];
            }];

        }
    } else if (recoginzer.state == UIGestureRecognizerStateChanged) {

        CGFloat offset = MAX(touchPoint.x - self.startPoint.x,0);
        self.fromScreenShotBlackLayerView.alpha = MAX(1 - offset/self.startFrame.size.width *1, 0);
        self.shadowImageView.alpha = MAX(0.5 - offset/self.startFrame.size.width *0.5, 0);
        self.view.frame = CGRectMake(offset, self.startFrame.origin.y, self.startFrame.size.width, self.startFrame.size.height);
        self.fromScreenShotContainer.frame = CGRectMake(-self.startFrame.size.width/3-offset*2/3, self.startFrame.origin.y, self.startFrame.size.width, self.startFrame.size.height);
    }
}

#pragma mark - private helpers
- (UIImage *)_snapShotWithUpdates:(BOOL)needUpdates {
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
        [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:needUpdates];
        UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return im;
    }
}

//-----------------------------------------------------------
- (UIImage *)_getScreenShotFromLastestVc:(UIViewController *)vc {
    return objc_getAssociatedObject(vc, &v_screenShot_flag);
}

- (void)_setScreenShotFromLastestVc:(UIViewController *)vc image:(UIImage *)image
{
    objc_setAssociatedObject(vc, &v_screenShot_flag, image, OBJC_ASSOCIATION_RETAIN);
}
//-----------------------------------------------------------

#pragma mark - lazy load
- (UIPanGestureRecognizer *)dragbackGesture {
    if (!_dragbackGesture) {
        _dragbackGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_onPanGestureReceivedEvevt:)];
        _dragbackGesture.delegate = self;
        [_dragbackGesture delaysTouchesBegan];
        [self.view addGestureRecognizer:_dragbackGesture];
    }
    return _dragbackGesture;
}

- (UIImageView *)fromScreenShotContainer
{
    if (!_fromScreenShotContainer) {
        _fromScreenShotContainer = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [_fromScreenShotContainer addSubview:self.fromScreenShotBlackLayerView];
    }
    return _fromScreenShotContainer;
}

- (UIImageView *)shadowImageView
{
    if (!_shadowImageView) {
        _shadowImageView = [UIImageView new];
        _shadowImageView.image = [UIImage imageNamed:(@"shadow_navigation")];
    }
    return _shadowImageView;
}

- (UIView *)fromScreenShotBlackLayerView
{
    if (!_fromScreenShotBlackLayerView) {
        _fromScreenShotBlackLayerView = [UIView new];
        _fromScreenShotBlackLayerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _fromScreenShotBlackLayerView;
}

@end


/**
 about autorotate
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
