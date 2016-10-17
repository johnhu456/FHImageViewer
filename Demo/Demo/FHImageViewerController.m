//
//  FHImageViewerController.m
//  Demo
//
//  Created by MADAO on 16/10/9.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerController.h"
#import "FHImageViewerCollectionView.h"
#import "FHImageViewerCell.h"

@interface FHImageViewerController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, strong) FHImageViewerCollectionView *viewerCollectionView;
@end

@implementation FHImageViewerController

static NSString * const kReuseIdentifier = @"imageCell";

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame imagesArray:(NSArray *)array selectedIndex:(NSInteger)selectedIndex
{
    if (self = [super init]) {
        self.view.frame = frame;
        self.imagesArray = array;
        _selectedIndex = selectedIndex;
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

- (void)defaultInitialize
{
    [self setupFHImageViewerCollectionView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupFHImageViewerCollectionView{
    self.viewerCollectionView = [[FHImageViewerCollectionView alloc] initWithFrame:self.view.frame andImagesArray:self.imagesArray selectedIndex:_selectedIndex];
    self.viewerCollectionView.hidePageControl = YES;
    self.viewerCollectionView.parallaxDistance = self.parallaxDistance;
    self.viewerCollectionView.cellInterval = self.cellInterval;
    self.viewerCollectionView.delegate = self;
    self.viewerCollectionView.dataSource = self;
    [self.viewerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self.viewerCollectionView registerClass:[FHImageViewerCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    [self.view addSubview:self.viewerCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
//    return 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell
//    
//    return cell;
//}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FHImageViewerCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    imageCell.image = _imagesArray[indexPath.row];
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
    //pageControl处理
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.viewerCollectionView.pageControl.currentPage = index;
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
#pragma mark - PublicMethod
- (void)showInViewController:(UIViewController *)viewController withAnimated:(BOOL)animated
{
    if (self.view == nil) {
        [self loadView];
    }
//    [viewController.parentViewController addChildViewController:self];
    [viewController.navigationController pushViewController:self animated:YES];
//    [self.parentViewController transitionFromViewController:viewController toViewController:self duration:1.f options:UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];
//    [viewController presentViewController:self animated:YES completion:nil];
}

@end
