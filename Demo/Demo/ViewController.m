//
//  ViewController.m
//  Demo
//
//  Created by MADAO on 16/10/9.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "ViewController.h"

#import "DemoTableViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static NSString *const kTitle = @"title";
static NSString *const kSelector = @"selector";
static NSString *const kCellReuseIdentifier = @"cellReuseIdentifier";
@implementation ViewController

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray =  @[
                        @{
                            kTitle:@"TranslationFromTableView",
                            kSelector:@"handleButtonTableViewOnClick"
                            },
                        @{
                            kTitle:@"TranslationFromCollectionView",
                            kSelector:@"handleButtonCollectionOnClick"
                            }
                        ];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Register Cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];

}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    NSDictionary *rowData = self.dataArray[indexPath.row];
    if (rowData[kTitle]) {
        cell.textLabel.text = rowData[kTitle];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = self.dataArray[indexPath.row];
    if (rowData[kSelector]) {
        [self performSelector:NSSelectorFromString(rowData[kSelector]) withObject:nil afterDelay:0];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - PushToNewVC
- (void)handleButtonTableViewOnClick
{
    DemoTableViewController *demoTableVC = [[DemoTableViewController alloc] init];
    [self.navigationController pushViewController:demoTableVC animated:YES];
}

- (void)handleButtonCollectionOnClick
{
    MYLog(@"2");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
