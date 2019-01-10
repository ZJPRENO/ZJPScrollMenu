//
//  ZJPScrollMenu.m
//  ZJPScrollMenu
//
//  Created by 张俊平 on 2018/7/2.
//  Copyright © 2018年 ZHANGJUNPING. All rights reserved.
//

#import "ZJPScrollMenu.h"

#define labelFontOfSize [UIFont systemFontOfSize:17]
#define kSscreenWidth [UIScreen mainScreen].bounds.size.width

@interface ZJPScrollMenu ()

@property (nonatomic, strong) UILabel *titleLabel;
/** 选中时的label */
@property (nonatomic, strong) UILabel *selectedLabel;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation ZJPScrollMenu

/** label之间的间距 */
static CGFloat const labelMargin = 10;
/** 指示器的高度 */
static CGFloat const indicatorHeight = 2;
/** 形变的度数 */
static CGFloat const font = 14;
/** 形变的度数 */
static CGFloat const radio = 1.1;

-(NSMutableArray *)allTitleLb  {
    if (_allTitleLb == nil) {
        _allTitleLb = [NSMutableArray array];
    }
    return _allTitleLb;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

+ (instancetype)ZJPScrollMenuWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
-(void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    
    /** 创建标题Label */
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = self.frame.size.height - indicatorHeight;
	 CGFloat labelW = 0;

    for (NSUInteger i = 0; i < self.titlesArray.count; i++) {

        self.titleLabel  = [[UILabel alloc] init];
        _titleLabel.text = self.titlesArray[i];
        _titleLabel.userInteractionEnabled = YES;
        // 设置高亮文字颜色
        _titleLabel.highlightedTextColor = [UIColor orangeColor];
        _titleLabel.tag  = i;
        _titleLabel.font = [UIFont systemFontOfSize:font];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 计算内容的Size
        CGSize labelSize = [self sizeWithText:_titleLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
        // 计算内容的宽度
        labelW = labelSize.width + 2 * labelMargin;
        
        _titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 计算每个label的X值
        labelX = labelX + labelW;
        
        // 添加到titleLabels数组
        [self.allTitleLb addObject:_titleLabel];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [_titleLabel addGestureRecognizer:tap];
        
        // 默认选中第0个label
        if (i == 0) {
            [self titleClick:tap];
        }
        
        [self addSubview:_titleLabel];
    }
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    
    // 取出第一个子控件
    UILabel *firstLabel = self.subviews.firstObject;
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = [UIColor orangeColor];
    _indicatorView.height = indicatorHeight;
    _indicatorView.top = self.frame.size.height - indicatorHeight;
    _indicatorView.layer.cornerRadius  = 1;
    _indicatorView.layer.masksToBounds = YES;
    [self addSubview:_indicatorView];
    
    // 立刻根据文字内容计算第一个label的宽度
	_indicatorView.width    = [self sizeWithText:titlesArray[0] font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)].width;
    _indicatorView.centerX = firstLabel.centerX;
}

#pragma mark - - - Label的点击事件
- (void)titleClick:(UITapGestureRecognizer *)tap {
    // 0.获取选中的label
    UILabel *selectLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self selectTitletLabel:selectLabel];
    
    // 2.让选中的标题居中
    [self setupTitleCenter:selectLabel];
    
    NSInteger index = selectLabel.tag;
    if ([self.ZJPScrollMenuDelegate respondsToSelector:@selector(ZJPScrollMenu:didSelectTitleAtIndex:)]) {
        [self.ZJPScrollMenuDelegate ZJPScrollMenu:self didSelectTitleAtIndex:index];
    }
}

/** 选中label标题颜色变成红色以及指示器位置 */
- (void)selectTitletLabel:(UILabel *)selectLb {
    // 取消高亮
    _selectedLabel.highlighted = NO;
    // 取消形变
    _selectedLabel.transform = CGAffineTransformIdentity;
    // 颜色恢复
    _selectedLabel.textColor = [UIColor blackColor];
    
    // 高亮
    selectLb.highlighted = YES;
    // 形变
    selectLb.transform = CGAffineTransformMakeScale(radio, radio);
    
    _selectedLabel = selectLb;
    
    // 改变指示器位置
	 CGFloat labelH = self.frame.size.height - indicatorHeight;
    [UIView animateWithDuration:0.25 animations:^{
       self.indicatorView.width = [self sizeWithText:selectLb.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)].width;
        self.indicatorView.centerX = selectLb.centerX;
    }];
}

/** 设置选中的标题居中 */
- (void)setupTitleCenter:(UILabel *)centerLb {
    // 计算偏移量
    CGFloat offsetX = centerLb.center.x - kSscreenWidth * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - kSscreenWidth;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


@end



