//
//  FHImageViewerCell.h
//  ImageViewer
//
//  Created by MADAO on 16/6/24.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHImageViewerCell : UICollectionViewCell

/**default is 0*/
@property (nonatomic, assign) CGFloat parallaxDistance;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (nonatomic, copy) void(^onceTapBlock)();

- (void)setParallaxValue:(CGFloat)value;

- (void)setOnceTapBlock:(void (^)())onceTapBlock;
@end
