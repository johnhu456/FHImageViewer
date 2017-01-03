//
//  FHImageViewerCell.m
//  ImageViewer
//
//  Created by MADAO on 16/6/24.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerCell.h"

@interface FHImageViewerCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *_imageScrollView;
    UIView *_imageMaskView;
    BOOL _enlarge;
}
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (nonatomic, strong) UITapGestureRecognizer *oneTapGestureRecognizer;

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
    _imageScrollView.canCancelContentTouches = NO;
    _imageScrollView.maximumZoomScale = 2.f;
    _imageScrollView.minimumZoomScale = 1.f;
    _imageScrollView.bouncesZoom = NO;
    _imageScrollView.showsVerticalScrollIndicator = _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.clipsToBounds = YES;
    
    _imageMaskView = [[UIView alloc] initWithFrame:_imageScrollView.frame];
    _imageMaskView.clipsToBounds = YES;
    
    _imageView = [[UIImageView alloc] initWithFrame:_imageScrollView.frame];
    _imageView.userInteractionEnabled = YES;
    _imageView.frame = CGRectMake(0, 0, _imageScrollView.bounds.size.width, _imageScrollView.frame.size.height);
    _imageView.center = _imageMaskView.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    
    [_imageScrollView addSubview:_imageMaskView];
    [_imageMaskView addSubview:_imageView];
    [self.contentView addSubview:_imageScrollView];
    
    self.oneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneTapGestureRecognizer:)];
    self.oneTapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.oneTapGestureRecognizer];
    
    self.doubleTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestureRecognizer:)];
    self.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    self.doubleTapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.doubleTapGestureRecognizer];
    [self.oneTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
}

#pragma mark - Setter
- (void)setParallaxDistance:(CGFloat)parallaxDistance
{
    _parallaxDistance = parallaxDistance;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
    CGFloat newHeight = _imageView.frame.size.width * image.size.height/image.size.width;
    _imageMaskView.frame = CGRectMake(_imageView.frame.origin.x, (self.frame.size.height - newHeight)/2.f, _imageView.frame.size.width , newHeight);
    _imageView.frame = CGRectMake(0, 0, _imageMaskView.frame.size.width, _imageMaskView.frame.size.height);
    _imageScrollView.maximumZoomScale = _imageScrollView.frame.size.height/_imageView.frame.size.height;
    [_imageScrollView setZoomScale:1.f animated:NO];
}

- (void)setOnceTapBlock:(void (^)())onceTapBlock {
    _onceTapBlock = onceTapBlock;
}

#pragma mark - TapGestureRecognizer
- (void)handleOneTapGestureRecognizer:(UITapGestureRecognizer *)tapGR {
    if (self.onceTapBlock) {
        self.onceTapBlock();
    }
}

- (void)handleDoubleTapGestureRecognizer:(UITapGestureRecognizer *)tapGR {
    CGPoint center = [tapGR locationInView:_imageView];
    if (_enlarge) {
        [_imageScrollView zoomToRect:[self zoomRectForScale:1.f withCenter:center] animated:YES];
        _enlarge = NO;
    }
    else{
        [_imageScrollView zoomToRect:[self zoomRectForScale:_imageScrollView.maximumZoomScale withCenter:center] animated:YES];
        _enlarge = YES;
    }
}

#pragma mark - ScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageMaskView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageMaskView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
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
    zoomRect.size.height =_imageView.frame.size.height/scale;
    zoomRect.size.width  =_imageView.frame.size.width/scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /scale);
    zoomRect.origin.y = center.y - (zoomRect.size.height /scale);
    return zoomRect;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.transform = CGAffineTransformMakeTranslation(0, 0);
}
@end
