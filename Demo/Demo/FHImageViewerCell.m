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
#warning todo
    _imageScrollView.backgroundColor = [UIColor yellowColor];
    
    _imageMaskView = [[UIView alloc] initWithFrame:_imageScrollView.frame];
    _imageMaskView.clipsToBounds = YES;
#warning todo
    _imageMaskView.backgroundColor = [UIColor redColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:_imageScrollView.frame];
    _imageView.userInteractionEnabled = YES;
    _imageView.frame = CGRectMake(0, 0, _imageScrollView.bounds.size.width, _imageScrollView.frame.size.height);
    _imageView.center = _imageMaskView.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
#warning todo
    _imageView.backgroundColor = [UIColor redColor];
    
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
    CGFloat newHeight = _imageView.frame.size.width * image.scale;
    _imageMaskView.frame = CGRectMake(_imageView.frame.origin.x, (self.frame.size.height - newHeight)/2.f, _imageView.frame.size.width , _imageView.frame.size.width * image.scale);
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
//        [_imageScrollView setZoomScale:1.f animated:YES];
//        [_imageScrollView setContentOffset:CGPointMake(center.x - _imageView.center.x, center.y - _imageView.center.y)];
        _enlarge = NO;
    }
    else{
        [_imageScrollView zoomToRect:[self zoomRectForScale:_imageScrollView.maximumZoomScale withCenter:center] animated:YES];
        NSLog(@"%@",NSStringFromCGRect([self zoomRectForScale:2.f withCenter:center]));
//        [_imageScrollView setContentOffset:CGPointMake(center.x - _imageView.center.x, center.y - _imageView.center.y)];
//        [_imageScrollView setZoomScale:2.f animated:YES];
        _enlarge = YES;
    }
}

#pragma mark - ScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageMaskView;
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
//    zoomRect.origin.x = _imageView.frame.size.width - center.x;
//    zoomRect.origin.y = _imageView.frame.size.height - center.y + 64.f;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
//    zoomRect.origin.x = (center.x * (2 - _imageScrollView.minimumZoomScale) - (zoomRect.size.width / 2.0));
//    zoomRect.origin.y = (center.y * (2 - _imageScrollView.minimumZoomScale) - (zoomRect.size.height / 2.0));
//    zoomRect.origin.x = center.x/scale - (_imageScrollView.frame.size.width/2) +_imageScrollView.contentOffset.x/scale;
//    zoomRect.origin.y = center.y/scale - (_imageScrollView.frame.size.height/2) + _imageScrollView.contentOffset.y/scale;
    return zoomRect;
    
//    
//    CGSize contentSize;
//    contentSize.width = (_imageScrollView.contentSize.width/scale);
//    contentSize.height = ((_imageScrollView.contentSize.height - 64)/scale);
//    
//    //translate the zoom point to relative to the content rect
//    center.x = (center.x / self.bounds.size.width) * contentSize.width;
//    center.y = (center.y / (self.bounds.size.height - 64)) * contentSize.height;
//    
//    //derive the size of the region to zoom to
//    CGSize zoomSize;
//    zoomSize.width = self.bounds.size.width / scale;
//    zoomSize.height = (self.bounds.size.height - 64) / scale;
//    
//    //offset the zoom rect so the actual zoom point is in the middle of the rectangle
//    CGRect zoomRect;
//    zoomRect.origin.x = center.x - zoomSize.width / 2.0f;
//    zoomRect.origin.y = center.y - zoomSize.height / 2.0f;
//    zoomRect.size.width = zoomSize.width;
//    zoomRect.size.height = zoomSize.height;
    return zoomRect;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageView.transform = CGAffineTransformMakeTranslation(0, 0);
}

#pragma mark - UIGestureRecognizer
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (otherGestureRecognizer == _imageScrollView.panGestureRecognizer) {
//        return YES;
//    }
//    return YES;
//}
@end
