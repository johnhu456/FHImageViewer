//
//  FHImageViewerController.h
//  Demo
//
//  Created by MADAO on 16/10/9.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHImageViewerTransition.h"

@interface FHImageViewerController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame imagesArray:(NSArray *)array selectedIndex:(NSInteger)selectedIndex;

- (void)showInViewController:(UIViewController *)viewController withAnimated:(BOOL)animated;

@end
