//
//  FHImageViewerController.m
//  Demo
//
//  Created by MADAO on 16/10/9.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerController.h"
#import "FHImageViewerCell.h"


@interface FHImageViewerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>
/**Delegate Flag*/
{
    struct{
        unsigned int totalImageNumberFlag:1;
        unsigned int imageViewIndexFlag:1;
        unsigned int originalImageIndexFlag:1;
    }_delegateFlag;
    
    BOOL _isShowing;
    NSUInteger _selectedIndex;
}

#pragma mark - Public Property
@property (nonatomic, strong, readwrite) FHImageViewerCollectionView *viewerCollectionView;

@property (nonatomic, assign, readwrite) NSUInteger currentIndex;

@property (nonatomic, strong, readwrite) FHImageViewerTransition *transition;

#pragma mark - Private Property
@property (nonatomic, strong) UITapGestureRecognizer *tapToPopGesture;
@end

@implementation FHImageViewerController

static NSString * const kReuseIdentifier = @"imageCell";

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame currentIndex:(NSInteger)currentIndex
{
    if (self = [super init]) {
        self.view.frame = frame;
        self.currentIndex = currentIndex;
        self.tapToPopEnabled = YES;   /**Default is YES*/
        [self defaultInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultInitialize];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self defaultInitialize];
    }
    return self;
}

- (void)defaultInitialize
{
    [self setupFHImageViewerCollectionView];
    [self setupResignGestureRecognizer];
}

//Set the FHImageViewCollectionView
- (void)setupFHImageViewerCollectionView{
#warning to change
    self.viewerCollectionView = [[FHImageViewerCollectionView alloc] initWithFrame:self.view.frame andImagesArray: @[ImageInName(@"0"),
                                                                                                                     ImageInName(@"1"),
                                                                                                                     ImageInName(@"2"),
                                                                                                                     ImageInName(@"3"),
                                                                                                                     ImageInName(@"4"),
                                                                                                                     ImageInName(@"5"),
                                                                                                                     ImageInName(@"6")
                                                                                                                     ] selectedIndex:self.currentIndex];
    self.viewerCollectionView.delegate = self;
    self.viewerCollectionView.dataSource = self;
    [self.viewerCollectionView registerClass:[FHImageViewerCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    [self.view addSubview:self.viewerCollectionView];
}

//Add a tap gestureRecognizer, tap to pop
- (void)setupResignGestureRecognizer{
    UITapGestureRecognizer *resignTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popSelf)];
    [self.view addGestureRecognizer:resignTapGestureRecognizer];
}

#pragma mark - Lazt Init
- (UITapGestureRecognizer *)tapToPopGesture
{
    if (_tapToPopGesture == nil) {
        _tapToPopGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popSelf)];
    }
    return _tapToPopGesture;
}

#pragma mark - Setter

- (void)setDelegate:(id<FHImageViewerControllerDelegate>)delegate
{
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(totalImageNumber)]){
        //Required
        _delegateFlag.totalImageNumberFlag = YES;
    }
    if ([_delegate respondsToSelector:@selector(imageViewForIndex:)]) {
        //Required
        _delegateFlag.imageViewIndexFlag = YES;
    }
    if ([_delegate respondsToSelector:@selector(originalSizeImageForIndex:)]) {
        _delegateFlag.originalImageIndexFlag = YES;
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
}

- (void)setParallaxDistance:(CGFloat)parallaxDistance
{
    _parallaxDistance = parallaxDistance;
    self.viewerCollectionView.parallaxDistance = _parallaxDistance;
}

- (void)setCellInterval:(CGFloat)cellInterval
{
    _cellInterval = cellInterval;
    self.viewerCollectionView.cellInterval = _cellInterval;
}

- (void)setTapToPopEnabled:(BOOL)tapToPopEnabled
{
    _tapToPopEnabled = tapToPopEnabled;
    if(_tapToPopEnabled){
        //Init the tap gestureRecognizer
        [self.view addGestureRecognizer:self.tapToPopGesture];
    }
    else{
        //Remove the gestureRecognizer
        if (_tapToPopGesture != nil) {
            [self.view removeGestureRecognizer:_tapToPopGesture];
            _tapToPopGesture = nil;
        }
    }
}

#pragma mark - Getter
- (FHImageViewerTransition *)transition{
    //The animation to be used depends on the end of the transition
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    FHImageViewerCell *toViewCell = (FHImageViewerCell *)[self collectionView:self.viewerCollectionView cellForItemAtIndexPath:currentIndexPath];
    UIImageView *imageView = [_delegate imageViewForIndex:self.currentIndex];
    if (_isShowing) {
        _transition = [[FHImageViewerTransition alloc] initWithTranFromView:imageView transToView:toViewCell.imageView animationDuration:self.animationDuration];
    }else{
        _transition = [[FHImageViewerTransition alloc] initWithTranFromView:toViewCell.imageView transToView:imageView animationDuration:self.animationDuration];
    }
    return _transition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isShowing = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isShowing = NO;
    self.navigationController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_delegateFlag.totalImageNumberFlag) {
        //return the total image number by delegate;
        return [_delegate totalImageNumber];
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FHImageViewerCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    //If delegate implemented method "originalSizeImageForIndex: ", get the original size image,elsewise get the default image.
    if (_delegateFlag.originalImageIndexFlag) {
        imageCell.image = [_delegate originalSizeImageForIndex:indexPath.row];
    }else{
        imageCell.image = [_delegate imageViewForIndex:indexPath.row].image;
    }
    imageCell.parallaxDistance = self.parallaxDistance;
    return imageCell;
}

#pragma mark <UICollectionViewDelegate>
#pragma mark - UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    //set cell's parallax
    if (self.parallaxDistance > 0){
        NSArray *cells = [self.viewerCollectionView visibleCells];
        for (FHImageViewerCell *cell in cells) {
            CGFloat value;
            value = 40 * (cell.frame.origin.x - self.viewerCollectionView.contentOffset.x)/window.frame.size.width/1.f;
            [cell setParallaxValue:value];
        }
    }
    //pageControl
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.viewerCollectionView.pageControl.currentPage = index;
}

#pragma mark - PrivateMethod
- (void)popSelf
{
    if (self.tapToPopEnabled) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}

#pragma mark - PublicMethod
- (void)showInViewController:(UIViewController *)viewController withAnimated:(BOOL)animated
{
    if (self.view == nil) {
        [self loadView];
    }
    [viewController.navigationController pushViewController:self animated:YES];
}

@end
