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

- (void)setParallaxValue:(CGFloat)value;

@end
