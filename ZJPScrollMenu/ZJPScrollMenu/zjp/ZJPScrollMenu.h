//
//  ZJPScrollMenu.h
//  ZJPScrollMenu
//
//  Created by 张俊平 on 2018/7/2.
//  Copyright © 2018年 ZHANGJUNPING. All rights reserved.
//
#import "UIViewExt/UIViewExt.h"
#import <UIKit/UIKit.h>

/// 滑动菜单栏
@class ZJPScrollMenu;

@protocol ZJPScrollMenuDelegate <NSObject>

- (void)ZJPScrollMenu:(ZJPScrollMenu *)ZJPScrollMenu didSelectTitleAtIndex:(NSInteger)index;

@end

@interface ZJPScrollMenu : UIScrollView

/** 顶部标题数组 */
@property (nonatomic, strong) NSArray *titlesArray;
/** 存入所有Label */
@property (nonatomic, strong) NSMutableArray *allTitleLb;

@property (nonatomic, weak) id<ZJPScrollMenuDelegate> ZJPScrollMenuDelegate;


/** 类方法 */
+ (instancetype)ZJPScrollMenuWithFrame:(CGRect)frame;


/** 选中label标题的标题颜色改变以及指示器位置变化（只是为了让外界去调用）*/
- (void)selectTitletLabel:(UILabel *)selectLb;

/** 选中的标题居中（只是为了让外界去调用）*/
- (void)setupTitleCenter:(UILabel *)centerLb;


@end








