//
//  ffNavigationController.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ffNavigationController : UINavigationController
@property (nonatomic, readonly) UIPanGestureRecognizer *dragbackGesture;

@end



@interface ffNavigationController (FFAutorotate)
@end
