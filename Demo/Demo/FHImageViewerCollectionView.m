//
//  ImageViewer.m
//  ImageViewer
//
//  Created by MADAO on 16/6/24.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerCollectionView.h"
#import "FHImageviewerCell.h"

@interface FHImageViewerCollectionView()<UIScrollViewDelegate>
{
    NSInteger _currentIndex;
}
@property (nonatomic, strong) NSArray *imagesArray;

@end

static CGFloat kPageControlInsideBottom = 20.f;
static CGFloat kPageControlHeight = 25.f;

@implementation FHImageViewerCollectionView

- (instancetype)initWithFrame:(CGRect)frame andImagesArray:(NSArray *)imagesArray selectedIndex:(NSInteger)selectedIndex;
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.itemSize = frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.imagesArray = [imagesArray copy];
        _currentIndex = selectedIndex;
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

- (void)setupUILongPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setCellInterval:(CGFloat)cellInterval
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    _cellInterval = cellInterval;
    self.frame = CGRectMake(0, 0, window.frame.size.width + _cellInterval, window.frame.size.height);
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self.collectionViewLayout invalidateLayout];
}

- (void)didMoveToSuperview
{
    [self setupPageControl];
    [self setContentOffset:CGPointMake(self.frame.size.width * _currentIndex, 0)];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    NSLog(@"set contentOffset");
}
- (void)setupPageControl
{
    if (!self.hidePageControl) {
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.frame = CGRectMake(0, self.frame.size.height - kPageControlHeight - kPageControlInsideBottom, self.frame.size.width, kPageControlHeight);
        self.pageControl.numberOfPages = self.imagesArray.count;
        self.pageControl.currentPage = _currentIndex;
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    [self.superview insertSubview:self.pageControl aboveSubview:self];
}

#pragma mark - UIGestureRecognizer
- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)pressGestureRecognizer
{
    if ([self.imageViewerDelegate respondsToSelector:@selector(handleLongPressGestureRecognizer:withCurrentImage:)]){
        [self.imageViewerDelegate handleLongPressGestureRecognizer:pressGestureRecognizer withCurrentImage:self.imagesArray[self.pageControl.currentPage]];
    }
}

@end
