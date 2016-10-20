//
//  ImageViewer.h
//  ImageViewer
//
//  Created by MADAO on 16/6/24.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHImageViewerCell.h"

@protocol FHImageViewerCollectionDelegate <NSObject>

#warning 功能待加
- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)pressGestureRecognizer withCurrentImage:(UIImage *)image;

@end

extern NSString *const kFHImageViewerCellReuseIdentifier;

@interface FHImageViewerCollectionView : UICollectionView

#warning wait to use
@property (nonatomic, weak) id<FHImageViewerCollectionDelegate> imageViewerDelegate;

#pragma mark - User Interface

@property (nonatomic, assign) NSUInteger currentIndex;

/** Distance between 2 images,default is 10;
 
    两张图片的间距,默认为10.
 */
@property (nonatomic, assign) CGFloat cellInterval;

/**
    Whether to display pagecontrol,setting in FHImageViewerController
 
    是否显示PageControl,在FHImageViewerController设置
 */
@property (nonatomic, assign, getter=isPageControlHidden) BOOL hidePageControl;

#pragma mark - Control
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

- (instancetype)initWithFrame:(CGRect)frame currentIndex:(NSUInteger)currentIndex totalCount:(NSUInteger)totalCount;

@end
