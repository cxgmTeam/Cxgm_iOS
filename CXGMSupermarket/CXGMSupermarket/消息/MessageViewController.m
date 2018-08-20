//
//  MessageViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"

#import "GoodsDetailViewController.h"
#import "WebViewController.h"

#import "EmptyView.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* dataArray;

@property(nonatomic,strong)EmptyView * emptyView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    self.dataArray = [NSMutableArray array];
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray* array = [userDefault objectForKey:RemoteNotification_KEY];
    if (array.count > 0) {
        [self.dataArray addObjectsFromArray:array];
    }
    
    NSLog(@"%@",self.dataArray);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    

    _emptyView = [EmptyView new];
    _emptyView.imageView.image = [UIImage imageNamed:@"mesage_empty"];
    _emptyView.textLabel.text = @"您还没有任何消息哦~";
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(ScreenH/5.f);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(250, 250));
    }];
    _emptyView.hidden = self.dataArray.count > 0? YES:NO;
}

#pragma mark-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageTableViewCell"];
    }
    NSDictionary* dic = self.dataArray[indexPath.row];
    
    NSArray* arr = @[@"限时抢购",@"客服助手",@"通知消息",@"最新资讯"];
    
    for (NSString * key in arr)
    {
        NSString * string = [dic objectForKey:key];
        
        if (string.length > 0 && [string isKindOfClass:[NSString class]])
        {
            
            if ([key isEqualToString:@"限时抢购"]) {
                cell.iconView.image = [UIImage imageNamed:@"message_0"];
            }
            if ([key isEqualToString:@"客服助手"]) {
                cell.iconView.image = [UIImage imageNamed:@"message_1"];
            }
            if ([key isEqualToString:@"通知消息"]) {
                cell.iconView.image = [UIImage imageNamed:@"message_2"];
            }
            if ([key isEqualToString:@"最新资讯"]) {
                cell.iconView.image = [UIImage imageNamed:@"message_3"];
            }
            cell.titleLabel.text = key;
            

            NSArray * array = [Utility toArrayOrNSDictionary:string];
            
            if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
                NSDictionary* dictionary = [array firstObject];
                cell.descLabel.text = [dictionary objectForKey:@"content"];
                cell.timeLabel.text = [dictionary objectForKey:@"time"];
            }
            
            break;
        }

    }
    
    
    
    
//    NSDictionary* apsDic = [dic objectForKey:@"aps"];
//
//    if (apsDic)
//    {
//        NSString* alert = [apsDic objectForKey:@"alert"];
//        if (alert && [alert isKindOfClass:[NSString class]])
//        {
//            if ([alert isEqualToString:@"限时抢购"]) {
//                cell.iconView.image = [UIImage imageNamed:@"message_0"];
//            }
//            if ([alert isEqualToString:@"客服助手"]) {
//                cell.iconView.image = [UIImage imageNamed:@"message_1"];
//            }
//            if ([alert isEqualToString:@"通知消息"]) {
//                cell.iconView.image = [UIImage imageNamed:@"message_2"];
//            }
//            if ([alert isEqualToString:@"最新资讯"]) {
//                cell.iconView.image = [UIImage imageNamed:@"message_3"];
//            }
//
//            cell.titleLabel.text = alert;
//            NSString * string = [dic objectForKey:alert];
//
//            if ([string isKindOfClass:[NSString class]]) {
//                NSArray * array = [Utility toArrayOrNSDictionary:string];
//
//                if (array.count > 0) {
//                    NSDictionary* dictionary = [array firstObject];
//                    cell.descLabel.text = [dictionary objectForKey:@"content"];
//                    cell.timeLabel.text = [dictionary objectForKey:@"time"];
//                }
//            }
//        }
//    }
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.dataArray forKey:RemoteNotification_KEY];
        [userDefault synchronize];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary* dic = self.dataArray[indexPath.row];

    NSArray* arr = @[@"限时抢购",@"客服助手",@"通知消息",@"最新资讯"];
    
    for (NSString * key in arr)
    {
        NSString * string = [dic objectForKey:key];
        
        if (string.length > 0 && [string isKindOfClass:[NSString class]])
        {
            NSArray * array = [Utility toArrayOrNSDictionary:string];
            
            if ([array isKindOfClass:[NSArray class]] && array.count > 0)
            {
                NSDictionary* dictionary = [array firstObject];
                
                if ([dictionary[@"urlType"] intValue] == 2)
                {
                    GoodsDetailViewController* vc = [GoodsDetailViewController new];
                    vc.goodsId = dictionary[@"goodcode"];
                    vc.shopId = dictionary[@"shopId"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if ([dictionary[@"urlType"] intValue] == 1)
                {
                    WebViewController* vc = [WebViewController new];
                    vc.urlString = dictionary[@"notifyUrl"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        }
        
    }
    
    
    
    
//    NSDictionary* apsDic = [dic objectForKey:@"aps"];
//    
//    if (apsDic)
//    {
//        NSString* alert = [apsDic objectForKey:@"alert"];
//        if (alert)
//        {
//            NSString * string = [dic objectForKey:alert];
//            
//            if ([string isKindOfClass:[NSString class]]) {
//                NSArray * array = [Utility toArrayOrNSDictionary:string];
//                
//                if (array.count > 0) {
//                    NSDictionary* dictionary = [array firstObject];
//                    
//                    if ([dictionary[@"urlType"] intValue] == 2)
//                    {
//                        GoodsDetailViewController* vc = [GoodsDetailViewController new];
//                        vc.goodsId = dictionary[@"goodcode"];
//                        vc.shopId = dictionary[@"shopId"];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                    else if ([dictionary[@"urlType"] intValue] == 1 && [dictionary[@"goodcode"] length] > 0)
//                    {
//                        WebViewController* vc = [WebViewController new];
//                        vc.urlString = dictionary[@"goodcode"];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                }
//            }
//        }
//    }
}

#pragma mark- init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 63;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
