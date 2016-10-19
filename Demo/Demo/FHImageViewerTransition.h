//
//  FHImageViewerTransition.h
//  Demo
//
//  Created by MADAO on 16/10/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHImageViewerTransition : NSObject<UIViewControllerAnimatedTransitioning>
/** The beginning UIView of the animation,
    you should exactly assign the UIImageView where you want starting transition to the transFromViw property.
    For example, pass the imageView in selelcted cell to transFromView:
    e.g.
    [FHImageViewerTransition alloc] initWithTranFromView:selectedCell.imageView];
 */
@property (nonatomic, strong) UIImageView *transFromView;
/** The ending UIView of the animation,
    you should exactly assign the UIImageView where you want ending transition to the transFromViw property.
*/
@property (nonatomic, strong) UIImageView *transToView;

- (instancetype)initWithTranFromView:(UIImageView *)transFromView andTransToView:(UIImageView *)transToView;

@end
