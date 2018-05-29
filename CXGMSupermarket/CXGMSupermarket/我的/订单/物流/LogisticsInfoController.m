//
//  LogisticsInfoController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/29.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "LogisticsInfoController.h"
#import "CourierViewCell.h"
#import "logisticsProcessCell.h"
#import "BlankCollectionFootView.h"

@interface LogisticsInfoController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@end

static NSString *const CourierViewCellID = @"CourierViewCell";
static NSString *const logisticsProcessCellID = @"logisticsProcessCell";

static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";

@implementation LogisticsInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物流状态";
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}

#pragma mark-
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 5;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        CourierViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CourierViewCellID forIndexPath:indexPath];
        gridcell = cell;
        
    }else if (indexPath.section == 1) {
        logisticsProcessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:logisticsProcessCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            BlankCollectionFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenW , 63);
    }
    if (indexPath.section == 1 ) {
        return CGSizeMake(ScreenW, 63);
    }

    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenW, 10);
    }
    return CGSizeZero;
}

#pragma mark- init
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[CourierViewCell class] forCellWithReuseIdentifier:CourierViewCellID];
        [_collectionView registerClass:[logisticsProcessCell class] forCellWithReuseIdentifier:logisticsProcessCellID];

        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
@end
