//
//  DemoTableViewController.m
//  Demo
//
//  Created by MADAO on 16/10/9.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "DemoTableViewController.h"
#import "FHImageViewerController.h"

@interface DemoTableViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *imageDataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *const kCellReuseIdentifier = @"cellReuseIdentifier";

static CGFloat const kCellHeight = 100.f;

@implementation DemoTableViewController

- (NSArray *)imageDataArray
{
    if (_imageDataArray == nil) {
        _imageDataArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    }
    return _imageDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //Register Cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.imageView.image = ImageInName(self.imageDataArray[indexPath.row]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imageArray = @[ImageInName(self.imageDataArray[0]),
                            ImageInName(self.imageDataArray[1]),
                            ImageInName(self.imageDataArray[2]),
                            ImageInName(self.imageDataArray[3]),
                            ImageInName(self.imageDataArray[4]),
                            ImageInName(self.imageDataArray[5]),
                            ImageInName(self.imageDataArray[6])
                            ];
    FHImageViewerController *vc = [[FHImageViewerController alloc] initWithFrame:self.view.frame imagesArray:imageArray selectedIndex:indexPath.row];
    vc.parallaxDistance = 20.f;
    vc.cellInterval = 10.f;
    [vc showInViewController:self withAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[FHImageViewerController class]]) {
        UITableViewCell *transiFromCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        return [[FHImageViewerTransition alloc] initWithTranFromView:transiFromCell.imageView];
    }else{
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
