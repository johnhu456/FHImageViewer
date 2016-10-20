//
//  FHImageViewerTransition.h
//  Demo
//
//  Created by MADAO on 16/10/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHImageViewerTransition : NSObject<UIViewControllerAnimatedTransitioning>
/** The beginning UIImageView of the animation,
    you should exactly assign the UIImageView where you want starting transition to the transFromViw property.
    For example, pass the imageView in selelcted cell to transFromView:
    e.g.
    [FHImageViewerTransition alloc] initWithTranFromView:selectedCell.imageView];
 
    动画的起始UIImageView。
    你需要明确的指定一个你期望动画开始的UIImageView给这个属性。
    举个例子，选中一个cell开始动画的时候，传一个这个cell里面,希望进行变换的UIImageView.
    举例：
    [FHImageViewerTransition alloc] initWithTranFromView:selectedCell.imageView];
 */
@property (nonatomic, strong) UIImageView *transFromView;
/** The ending UIImageView of the animation,
    you should exactly assign the UIImageView where you want ending transition to the transFromViw property.
 
    动画的结束UIImageView。
    你需要明确的指定一个你期望动画结束的UIImageView给这个属性。
*/
@property (nonatomic, strong) UIImageView *transToView;

/**
    The duration of the animation,readonly.
    You can set this property by setting the animationDuration of the FHImageViewerController.
 
    动画的持续时间,只读.
    可以通过设置FHImageViewerController的animationDuration来设定这个属性。
 */

@property (nonatomic, assign, readonly) NSTimeInterval animationDuration;

- (instancetype)initWithTranFromView:(UIImageView *)transFromView
                         transToView:(UIImageView *)transToView
                   animationDuration:(NSTimeInterval)animationDuration;

@end
