//
//  ViewController.m
//  JFTest
//
//  Created by geeksprite on 2017/6/30.
//  Copyright © 2017年 聚风天下有限公司. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <YYKit.h>
#import <MJRefresh.h>
#import "XJMainIndexCell.h"
#import "XJMainIndexCellModel.h"

static NSString *const httpUrl = @"https://www.easy-mock.com/mock/598bd9dda1d30433d85c18f4/example/user";
static NSString *const cellID = @"tableviewcellid";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *cellItems;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {

    [self.tableView registerNib:[UINib nibWithNibName:[XJMainIndexCell className] bundle:nil] forCellReuseIdentifier:cellID];
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshDate];
    }];
    
    
}

- (void)refreshDate {

    [self.manager GET:httpUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id json = responseObject[@"data"][@"user"];
        self.cellItems = [NSArray modelArrayWithClass:[XJMainIndexCellModel class] json:json].mutableCopy;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@",@(self.cellItems.count));
    return self.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XJMainIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.cellModel = self.cellItems[indexPath.row];
    return cell;
}

#pragma mark - Getter

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSMutableArray *)cellItems {
    if (!_cellItems) {
        _cellItems = @[].mutableCopy;
    }
    return _cellItems;
}

@end
