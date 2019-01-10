//
//  ViewController.m
//  ZJPScrollMenu
//
//  Created by 张俊平 on 2018/7/2.
//  Copyright © 2018年 ZHANGJUNPING. All rights reserved.
//

#import "ViewController.h"
#import "ZJPScrollMenu.h"

@interface ViewController ()<ZJPScrollMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) ZJPScrollMenu *topScrollMenu;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titlesArray = @[@"全部分类", @"维修", @"周边游", @"休闲娱乐", @"NBA", @"新闻", @"娱乐", @"音乐", @"网络电影"];
    self.topScrollMenu = [ZJPScrollMenu ZJPScrollMenuWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    _topScrollMenu.titlesArray = [NSArray arrayWithArray:_titlesArray];
    _topScrollMenu.ZJPScrollMenuDelegate = self;
    [self.view addSubview:_topScrollMenu];
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, _topScrollMenu.bottom, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titlesArray.count, 0);
    _mainScrollView.backgroundColor = [UIColor grayColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
}

-(void)ZJPScrollMenu:(ZJPScrollMenu *)ZJPScrollMenu didSelectTitleAtIndex:(NSInteger)index {
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 1.把对应的标题选中
    UILabel *selLabel = self.topScrollMenu.allTitleLb[index];
    
    [self.topScrollMenu selectTitletLabel:selLabel];
    
    // 2.让选中的标题居中
    [self.topScrollMenu setupTitleCenter:selLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
