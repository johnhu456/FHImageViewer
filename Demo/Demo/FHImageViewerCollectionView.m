//
//  ImageViewer.m
//  ImageViewer
//
//  Created by MADAO on 16/6/24.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerCollectionView.h"
#import "FHImageviewerCell.h"

@interface FHImageViewerCollectionView()
{
    NSUInteger _totalCount;
}
#pragma mark - Public Property
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@end

NSString *const kFHImageViewerCellReuseIdentifier = @"FHImageViewerCellReuseIdentifier";

//Parameters for setting the pagecontrol's position
static CGFloat kPageControlInsideBottom = 20.f;
static CGFloat kPageControlHeight = 25.f;

@implementation FHImageViewerCollectionView

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame currentIndex:(NSUInteger)currentIndex totalCount:(NSUInteger)totalCount;
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.itemSize = frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        _totalCount = totalCount;
        self.hidePageControl = NO; /**Default is NO*/
        self.currentIndex = currentIndex;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = CGRectMake(0, 0, self.frame.size.width + _cellInterval, self.frame.size.height);
    [self registerClass:[FHImageViewerCell class] forCellWithReuseIdentifier:kFHImageViewerCellReuseIdentifier];
    [self setupUILongPressGestureRecognizer];
}

#pragma mark - LazyInit
- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, self.frame.size.height - kPageControlHeight - kPageControlInsideBottom, self.frame.size.width, kPageControlHeight);
        _pageControl.numberOfPages = _totalCount;
        _pageControl.currentPage = _currentIndex;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self.superview insertSubview:_pageControl aboveSubview:self];
    }
    return _pageControl;
}

- (void)setupUILongPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setupPageControl
{
    [self pageControl];
}

#pragma mark - LifeCycle
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self setupPageControl];
    [self setContentOffset:CGPointMake(self.frame.size.width * _currentIndex, 0)];
}

#pragma mark - Setter

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self positionTheFocus];
}
- (void)setCellInterval:(CGFloat)cellInterval
{
    _cellInterval = cellInterval;
    //Relayout.
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    self.frame = CGRectMake(0, 0, window.frame.size.width + _cellInterval, window.frame.size.height);
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self.collectionViewLayout invalidateLayout];
    [self positionTheFocus];
}

- (void)setHidePageControl:(BOOL)hidePageControl
{
    _hidePageControl = hidePageControl;
    _pageControl.hidden = _hidePageControl;
}

#pragma mark - PrivateMethod
//Reposition the selected image
- (void)positionTheFocus{
    self.contentOffset = CGPointMake(self.frame.size.width * _currentIndex, 0);
}

#pragma mark - UIGestureRecognizer
- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)pressGestureRecognizer
{
//    if ([self.imageViewerDelegate respondsToSelector:@selector(handleLongPressGestureRecognizer:withCurrentImage:)]){
//        [self.imageViewerDelegate handleLongPressGestureRecognizer:pressGestureRecognizer withCurrentImage:self.imagesArray[self.pageControl.currentPage]];
//    }
}

@end
