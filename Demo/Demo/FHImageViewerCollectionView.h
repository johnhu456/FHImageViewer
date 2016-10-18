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

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)pressGestureRecognizer withCurrentImage:(UIImage *)image;

@end
static NSString *const kFHImageViewerCellReuseIdentifier = @"FHImageViewerCellReuseIdentifier";

@interface FHImageViewerCollectionView : UICollectionView

@property (nonatomic, assign) CGFloat parallaxDistance;

@property (nonatomic, assign) CGFloat cellInterval; //Default is 10.f;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign, getter=isPageControlHidden) BOOL hidePageControl;

@property (nonatomic, weak) id<FHImageViewerCollectionDelegate> imageViewerDelegate;

- (instancetype)initWithFrame:(CGRect)frame andImagesArray:(NSArray *)imagesArray selectedIndex:(NSInteger)selectedIndex;

@end
