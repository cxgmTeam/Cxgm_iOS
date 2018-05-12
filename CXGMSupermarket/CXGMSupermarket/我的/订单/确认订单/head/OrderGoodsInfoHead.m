//
//  OrderGoodsInfoHead.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/29.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "OrderGoodsInfoHead.h"
//cell
#import "GoodsScreenshotsGridCell.h"

@interface OrderGoodsInfoHead ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@end

static NSString *const GoodsScreenshotsGridCellID = @"GoodsScreenshotsGridCell";


@implementation OrderGoodsInfoHead

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(80, 80);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[GoodsScreenshotsGridCell class] forCellWithReuseIdentifier:GoodsScreenshotsGridCellID];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    UIButton* btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-5);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"共3种";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(btn.left);
        make.centerY.equalTo(self);
    }];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(15);
        make.bottom.equalTo(-15);
        make.width.equalTo(ScreenW-15-100);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
}

- (void)onTapButton:(id)sender{
    !_gotoGoodsList?:_gotoGoodsList();
}
#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsScreenshotsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsScreenshotsGridCellID forIndexPath:indexPath];
    return cell;
}
@end
