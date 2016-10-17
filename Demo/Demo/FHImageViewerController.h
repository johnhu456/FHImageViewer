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

/** parallax is the effect whereby the position or direction of an object appears to differ when viewed from different positions
    you could set the property 'parallaxDistance' to change the effect of strength
 */
@property (nonatomic, assign) CGFloat parallaxDistance;
/** 
    distance between 2 images
 */
@property (nonatomic, assign) CGFloat cellInterval;

- (instancetype)initWithFrame:(CGRect)frame imagesArray:(NSArray *)array selectedIndex:(NSInteger)selectedIndex;

- (void)showInViewController:(UIViewController *)viewController withAnimated:(BOOL)animated;

@end
