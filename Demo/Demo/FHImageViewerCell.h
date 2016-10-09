//
//  FHImageViewerCell.h
//  ImageViewer
//
//  Created by MADAO on 16/6/24.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHImageViewerCell : UICollectionViewCell

/**视差范围*/
@property (nonatomic, assign) CGFloat parallaxDistance;
/**图片*/
@property (nonatomic, strong) UIImage *image;
/**调整视差*/
- (void)setParallaxValue:(CGFloat)value;

@end
