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
    NSInteger _currentIndex;
}
@property (nonatomic, strong) NSArray *imagesArray;

@end

static CGFloat kPageControlInsideBottom = 20.f;
static CGFloat kPageControlHeight = 25.f;

@implementation FHImageViewerCollectionView

- (instancetype)initWithFrame:(CGRect)frame andImagesArray:(NSArray *)imagesArray;
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.itemSize = frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.imagesArray = [imagesArray copy];
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.pagingEnabled = YES;
    _cellInterval = 10.f;
    _currentIndex = 0;
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
}

- (void)didMoveToSuperview
{
    [self setupPageControl];
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

//#pragma mark - UICollectionViewDataSource
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.imagesArray.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    FHImageViewerCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:kFHImageViewerCellReuseIdentifier forIndexPath:indexPath];
//    imageCell.image = _imagesArray[indexPath.row];
//    return imageCell;
//}

#pragma mark - UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    //视差处理
    if (_parallax){
        NSArray *cells = [self visibleCells];
        for (FHImageViewerCell *cell in cells) {
            CGFloat value;
            value = 40 * (cell.frame.origin.x - self.contentOffset.x)/window.frame.size.width/1.f;
            [cell setParallaxValue:value];
        }
    }
    //pageControl处理
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}

#pragma mark - UIGestureRecognizer
- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)pressGestureRecognizer
{
    if ([self.imageViewerDelegate respondsToSelector:@selector(handleLongPressGestureRecognizer:withCurrentImage:)]){
        [self.imageViewerDelegate handleLongPressGestureRecognizer:pressGestureRecognizer withCurrentImage:self.imagesArray[self.pageControl.currentPage]];
    }
}

@end
