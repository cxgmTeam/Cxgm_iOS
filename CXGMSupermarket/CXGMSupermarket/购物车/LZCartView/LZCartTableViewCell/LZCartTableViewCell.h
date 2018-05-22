//
//  LZCartTableViewCell.h
//  LZCartViewController
//


#import <UIKit/UIKit.h>

@class LZCartModel;
typedef void(^LZNumberChangedBlock)(NSInteger number);
typedef void(^LZCellSelectedBlock)(BOOL select);

@interface LZCartTableViewCell : UITableViewCell
//商品数量
@property (assign,nonatomic)NSInteger lzNumber;
@property (assign,nonatomic)BOOL lzSelected;

- (void)reloadDataWithModel:(LZCartModel*)model;
- (void)numberAddWithBlock:(LZNumberChangedBlock)block;
- (void)numberCutWithBlock:(LZNumberChangedBlock)block;
- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block;
@end
