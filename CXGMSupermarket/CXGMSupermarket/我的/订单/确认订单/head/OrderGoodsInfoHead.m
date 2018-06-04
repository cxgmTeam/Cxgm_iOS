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
@property (strong , nonatomic)UILabel *countLabel;
@end

static NSString *const GoodsScreenshotsGridCellID = @"GoodsScreenshotsGridCell";


@implementation OrderGoodsInfoHead

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
        

    }
    return self;
}

- (void)setGoodsArray:(NSArray *)goodsArray
{
    _goodsArray = goodsArray;

    self.countLabel.text = [NSString stringWithFormat:@"共%ld种",self.goodsArray.count];
    
    [self.collectionView reloadData];
}

- (void)setupUI{
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.centerY.equalTo(self);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"共3种";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(imageView.left).offset(-10);
        make.centerY.equalTo(self);
    }];
    self.countLabel = label;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.bottom.top.equalTo(self);
        make.width.equalTo(ScreenW-15-100);
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorE8E8E8E;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
    
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)]];
}

- (void)onTapGesture:(id)sender{
    !_gotoGoodsList?:_gotoGoodsList();
}

#pragma mark-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsScreenshotsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsScreenshotsGridCellID forIndexPath:indexPath];
    cell.goods = self.goodsArray[indexPath.item];
    return cell;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(80, 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        
        [_collectionView registerClass:[GoodsScreenshotsGridCell class] forCellWithReuseIdentifier:GoodsScreenshotsGridCellID];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
@end
