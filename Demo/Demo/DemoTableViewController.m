//
//  DemoTableViewController.m
//  Demo
//
//  Created by MADAO on 16/10/9.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "DemoTableViewController.h"

@interface DemoTableViewController ()<UITableViewDelegate,UITableViewDataSource>

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

@end
