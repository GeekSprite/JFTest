//
//  ViewController.m
//  XJFishing
//
//  Created by liuxj on 2017/6/12.
//  Copyright © 2017年 XRA. All rights reserved.
//

#import "ViewController.h"
#import "XJHappyFishViewController.h"
#import "XJFishBetViewController.h"
#import "CCommon.h"
#import <objc/runtime.h>
#import "XJTestModel.h"
#import "XJTestCell.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "XJTestTranslation.h"
#import "XJTestViewController.h"

static NSString *const cellIdentifier = @"cellIdentifier";



static void *keyAssociatedObject = &keyAssociatedObject;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSString *_myName;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;




@end

@implementation ViewController

+ (void)load {

    Method origin = class_getInstanceMethod([self class], @selector(testLog));
    Method change = class_getInstanceMethod([self class], @selector(ex_textLog));
    method_exchangeImplementations(origin, change);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureViews];
    [self testLog];
    [self loadDataWithCompletion:^{
        [self.tableView reloadData];
    }];
    
    
    NSError *err = nil;
    
    
    [self setChangeError:&err];
    objc_setAssociatedObject(self, keyAssociatedObject, @"20", OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    NSLog(@"%@",err.localizedDescription);
    
    NSString *str = objc_getAssociatedObject(self, keyAssociatedObject);
    
    NSLog(@"%@",str);
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        while (1) {
//            [NSThread sleepForTimeInterval:0.1];
//            self->_myName = @"111";
//            NSLog(@"1:%@",self->_myName);
//        }
//    });
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        while (1) {
//            [NSThread sleepForTimeInterval:0.1];
//            self->_myName = @"22";
//            NSLog(@"2 :%@",self->_myName);
//        }
//    });
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        while (1) {
//            [NSThread sleepForTimeInterval:0.1];
//            self->_myName = @"33";
//            NSLog(@"3 :%@",self->_myName);
//        }
//    });
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        while (1) {
//            self->_myName = @"444";
//            [NSThread sleepForTimeInterval:0.1];
//            NSLog(@"4:%@",self->_myName);
//        }
//    });
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeInfoDark];
    

    if ([btn class] == [UIButton class]) {
        NSLog(@"======");
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    
}


- (void)configureViews {
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadDataWithCompletion:(void(^)(void))handler {
    [self.dataArray removeAllObjects];
    
    
    NSString *baseUrlString = @"http://dict.youdao.com/jsonapi";

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"q"] = @"时间";
    params[@"doctype"] = @"json";
    

    [self.sessionManager GET:baseUrlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        XJTestTranslation *translation = [XJTestTranslation yy_modelWithJSON:responseObject];
        
        for (NSInteger index = 0; index < 10; index ++) {
            
            XJTestModel *model = [[XJTestModel alloc] init];
            model.title = @"标题党";
            model.iconUrl = [NSURL URLWithString:@"https://imgsa.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=6dd0e357e01190ef15f69a8daf72f673/4afbfbedab64034f9015f1bca8c379310b551dab.jpg"];
            model.desc = translation.baike.summarys[0].summary;
            
            [self.dataArray addObject:model];
        }
        
        if (handler) {
            handler();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
   
    
}


- (void)testLog {
    NSLog(@"fuck pinssible");
}

- (void)ex_textLog {
    [self ex_textLog];

}


- (void)setChangeError:(NSError **)err {
    NSError *error = [NSError errorWithDomain:@"test" code:200 userInfo:nil];
    
    *err = error;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XJTestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.cellModel = self.dataArray[indexPath.row];

    return cell;
};

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIViewController *fishVC = nil;
    
    if (indexPath.row % 3 == 0) {
        fishVC = [[XJHappyFishViewController alloc] init];
    }else if (indexPath.row % 3 == 1){
        fishVC = [[XJFishBetViewController alloc] init];
    }else {
        fishVC = [[XJTestViewController alloc] init];
    }
    
    [self.navigationController pushViewController:fishVC animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XJTestCell class] forCellReuseIdentifier:cellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 200;
        
    }
    return _tableView;
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        
        AFHTTPResponseSerializer *manager = [[AFHTTPResponseSerializer alloc] init];
        manager.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        _sessionManager.responseSerializer = manager;
    }
    return _sessionManager;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
