//
//  FHImageViewerCell.m
//  ImageViewer
//
//  Created by MADAO on 16/6/24.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerCell.h"

@interface FHImageViewerCell()<UIScrollViewDelegate>
{
    UIScrollView *_imageScrollView;
    UIView *_imageMaskView;
    UITapGestureRecognizer *_doubleTapGestureRecognizer;
    BOOL _enlarge;
}

@end

@implementation FHImageViewerCell

- (instancetype)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    _enlarge = NO; /**是否放大状态*/
    
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, self.bounds.size.height)];
    _imageScrollView.delegate = self;
    _imageScrollView.maximumZoomScale = 2.f;
    _imageScrollView.minimumZoomScale = 1.f;
    _imageScrollView.showsVerticalScrollIndicator = _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.clipsToBounds = YES;

    _imageMaskView = [[UIView alloc] initWithFrame:_imageScrollView.frame];
    _imageMaskView.clipsToBounds = YES;
    
    _imageView = [[UIImageView alloc] initWithFrame:_imageScrollView.frame];
    _imageView.frame = CGRectMake(- _parallaxDistance, 0, _imageScrollView.bounds.size.width + 2 * _parallaxDistance, _imageView.frame.size.height);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    
    [_imageScrollView addSubview:_imageMaskView];
    [_imageMaskView addSubview:_imageView];
    [self.contentView addSubview:_imageScrollView];
    
    _doubleTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestureRecognizer:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [_imageScrollView addGestureRecognizer:_doubleTapGestureRecognizer];
}

- (void)setParallaxDistance:(CGFloat)parallaxDistance
{
    _parallaxDistance = parallaxDistance;
    _imageView.frame = CGRectMake(-_parallaxDistance, 0, _imageScrollView.bounds.size.width + 2 * _parallaxDistance, _imageView.frame.size.height);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
    [_imageScrollView setZoomScale:1.f animated:NO];
}

#pragma mark - TapGestureRecognizer
- (void)handleDoubleTapGestureRecognizer:(UITapGestureRecognizer *)tapGR
{
    CGPoint center = [tapGR locationInView:_imageScrollView];
    if (_enlarge) {
        [_imageScrollView zoomToRect:[self zoomRectForScale:1.f withCenter:center] animated:YES];
        _enlarge = NO;
    }
    else{
        [_imageScrollView zoomToRect:[self zoomRectForScale:2.f withCenter:center] animated:YES];
        _enlarge = YES;
    }

}

#pragma mark - ScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageMaskView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat imageScale = _image.size.height/_image.size.width/1.f;
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.width * imageScale);
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _imageMaskView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

#pragma mark - PublicMethod
- (void)setParallaxValue:(CGFloat)value
{
    _imageView.transform = CGAffineTransformMakeTranslation(value, 0);
}

#pragma mark - PrivateMethods
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.transform = CGAffineTransformMakeTranslation(0, 0);
}

@end
