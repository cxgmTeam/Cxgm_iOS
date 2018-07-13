//
//  MidAdGoodsViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MidAdGoodsViewCell.h"
#import "GoodsListGridCell.h"

@interface MidAdGoodsViewCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (strong , nonatomic)UIImageView *adImageView;

@property (strong , nonatomic)UICollectionView *collectionView;
/* 底部 */
@property (strong , nonatomic)UIView *bottomLineView;
@end

static NSString *const GoodsListGridCellID = @"GoodsListGridCell";

@implementation MidAdGoodsViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUpUI];
    }
    return self;
}

- (void)setAdBannar:(AdBannarModel *)adBannar{
    _adBannar = adBannar;
    
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:adBannar.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    [self.collectionView reloadData];
}

- (void)onTapImageView:(UITapGestureRecognizer *)gesture
{
    !_tapAdImageHandler?:_tapAdImageHandler();
}

- (void)setUpUI
{
    _adImageView = [[UIImageView alloc] init];
    _adImageView.layer.cornerRadius = 4;
    _adImageView.layer.masksToBounds = YES;
    _adImageView.image = [UIImage imageNamed:@"temp_meat"];
    _adImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_adImageView];
    [_adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(ScreenW*159/375.f);
    }];
    _adImageView.userInteractionEnabled = YES;
    [_adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageView:)]];
    
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = RGB(245,245,245);
    [self addSubview:_bottomLineView];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(10);
    }];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.adImageView.bottom).offset(10);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomLineView.top).offset(-10);
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.adBannar.productList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsListGridCellID forIndexPath:indexPath];
    cell.showOldPrice = NO;
    cell.goodsModel = self.adBannar.productList[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    GoodsModel* goods = self.adBannar.productList[indexPath.item];
    !self.showGoodsDetail?:self.showGoodsDetail(goods);
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(96, 212-30);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[GoodsListGridCell class] forCellWithReuseIdentifier:GoodsListGridCellID];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _collectionView;
}
@end
