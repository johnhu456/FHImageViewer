//
//  FHImageViewerController.h
//  Demo
//
//  Created by MADAO on 16/10/9.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHImageViewerCollectionView.h"
#import "FHImageViewerTransition.h"

#pragma mark - Protocol
@protocol FHImageViewerControllerDelegate <NSObject>

@required
/**
    Returns the ImageView within Cells with index，
    you can directly return to the cell's imageview in indexPath， when the number of sections is not 1, careful handling this method.
    e.g.
    - (UIImageView *)imageViewForIndex:(NSInteger)index{
        SomeCustomCell *cell = (SomeCustomCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        return cell.imageView;
    }
 
    返回每个Index中的ImageView的信息，
    你可以直接根据tableview或者collectionView中的indexPath信息来返回指定cell的imageView，当section的数量不为1的时候，需要谨慎处理。
    举一个例子：
    - (UIImageView *)imageViewForIndex:(NSInteger)index{
        SomeCustomCell *cell = (SomeCustomCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        return cell.imageView;
    }
 */
- (UIImageView *)imageViewForIndex:(NSInteger)index;
/**
    Returns the total number of images you want to view.
 
    返回你所希望浏览的图片总数
 */
- (NSInteger)totalImageNumber;

@optional
/**
    Returns the original size image in each index.
    Optional, if it's not implemented, then use the required method: imageViewForIndex:(NSInteger)index to return  the image within imageView, maybe it's a thumbnail and not be clear enough.
 
    返回每个Index对应的原尺寸的UIImage，
    可选，如果不实现，则使用方法 imageViewForIndex:(NSInteger)index 返回的imageView中的图片，可能是缩略图不够清楚。
*/
- (UIImage *)originalSizeImageForIndex:(NSInteger)index;
@end

@interface FHImageViewerController : UIViewController

@property (nonatomic, weak) id<FHImageViewerControllerDelegate>delegate;

@property (nonatomic, strong, readonly) FHImageViewerCollectionView *viewerCollectionView;

#pragma mark - UserInterface

@property (nonatomic, assign, readonly) NSInteger currentIndex;

/** Parallax is the effect whereby the position or direction of an object appears to differ when viewed from different positions
    you could set the property 'parallaxDistance' to change the effect of strength.
 
    视差是一种因为观察角度而出现观察对象有所不同的视觉效果。
    设置parallaxDistance可以改变视差效果的强弱。
 */
@property (nonatomic, assign) CGFloat parallaxDistance;
/** distance between 2 images
 
    两张图片的间距
 */
@property (nonatomic, assign) CGFloat cellInterval;

/**
    Tap to pop, default is on
 
    轻按一下返回开关，默认为开。
 */
@property (nonatomic, assign) BOOL tapToPopEnabled;

#pragma mark - Use For Transition
/** An object used to describe the transition animation，readonly。
 
    一个用来描述转场动画的对象，只读。
 */
@property (nonatomic, strong, readonly) FHImageViewerTransition *transition;

#warning to delete
/** The beginning UIView of the animation,
    you should exactly assign the UIImageView where you want starting transition to the transFromViw property.
    Because the FHImageViewerController needs to know exactly which UIImageView the animation starts,
    including it's frame and image size, otherwise the animation will be inaccurate.
    For example, pass the imageView in selelcted cell to transFromView:
    e.g.
    self.fhImageViewerController.transFromView = selectedCell.imageView;
 
    动画的起始View（一般都是UIImageView）
    需要明确的指定你希望动画从哪个UIImageView开始，并且用这个UIImageView给transFromView属性赋值。
    因为FHImageViewerController需要确切知道动画从哪里开始的，需要这个UIImageView的信息,包括frame和图片大小，否则动画将会不准确.
    举例，当一个cell中imageView被点击选中的时候：
    self.fhImageViewerController.transFromView = selectedCell.imageView;
*/
@property (nonatomic, weak) UIImageView *transFromView;

#pragma mark - Public Method
- (instancetype)initWithFrame:(CGRect)frame currentIndex:(NSInteger)currentIndex;

- (void)showInViewController:(UIViewController *)viewController withAnimated:(BOOL)animated;

@end
