//
//  DWPlateKeyBoardView.m
//  SingleTextInput
//
//  Created by mude on 2018/3/22.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "DWPlateKeyBoardView.h"
#import "DWPlateKeyBoardShare.h"

#define kWidth  self.frame.size.width
#define kHeight self.frame.size.height
#define HEXCOLOR(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:alp]

@interface DWPlateKeyBoardView()<UIGestureRecognizerDelegate>
{
    UIView *_backView1; //第一个view
    UIView *_backView2; //第二个view
    //    UIView *_bottomView;
    UIButton *_btn;
}
@property (nonatomic, strong) NSArray *provinceArr; //省市简写数组
@property (nonatomic, strong) NSArray *letterArr; //车牌号码字母数字数组

@end

@implementation DWPlateKeyBoardView

- (NSArray *)provinceArr {
    if (!_provinceArr) {
        _provinceArr = [DWPlateKeyBoardShare getProvince];
    }
    return _provinceArr;
}

- (NSArray *)letterArr {
    if (!_letterArr) {
        _letterArr = [DWPlateKeyBoardShare getNumberAndLetter];
    }
    return _letterArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0x000000, 0.1);
        //注册一个通知，后面会用到，来监听abc字母键
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFAction:) name:@"abc" object:nil];
        //添加一个手势，点击键盘外面收回键盘
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGSize size = [UIScreen mainScreen].bounds.size;
    _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, size.height * 0.33)];
    _backView1.backgroundColor = HEXCOLOR(0xd2d5da, 1);
    _backView1.hidden = NO;
    
    _backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, size.height * 0.33)];
    _backView2.hidden = YES;
    _backView2.backgroundColor = HEXCOLOR(0xd2d5da, 1);
    
    [self addSubview:_backView1];
    [self addSubview:_backView2];
    
    int row = 4;
    int column = 10;
    CGFloat btnY = 4;
    CGFloat btnX = 2;
    CGFloat maginR = 5;
    CGFloat maginC = 10;
    CGFloat btnW = (size.width - maginR * (column -1) - 2 * btnX)/column;
    CGFloat btnH = (_backView1.frame.size.height - maginC * (row - 1) - 6) / row;
    CGFloat m = 12;
    CGFloat w = (size.width - 24 - 7 * btnW - 6 * maginR - 2 * btnX)/2;
    CGFloat mw = (size.width - 8 * maginR - 9 * btnW - 2 * btnX) / 2;
    NSLog(@"LY >> count - %zd", self.provinceArr.count);
    for (int i = 0; i < self.provinceArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i / column == 3) {
            if (i == 30) {
                btn.frame = CGRectMake(btnX, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_abc"] forState:UIControlStateNormal];
                btn.enabled = NO;
                _btn = btn;
            }else if (i == 38) {
                btn.frame = CGRectMake(6 * (btnW + maginR) + btnW + w + m + m, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_over"] forState:UIControlStateNormal];
            }else {
                btn.frame = CGRectMake((i % column - 1)*(btnW + maginR) + w + m + btnX, btnY + 3 * (btnH + maginC), btnW, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
            }
        }else {
            btn.frame = CGRectMake(btnW * (i % column) + i % column * maginR + btnX, btnY + i/column * (btnH + maginC), btnW, btnH);
            [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
        }
        [btn setTitleColor:HEXCOLOR(0x23262F, 1) forState:UIControlStateNormal];
        [btn setTitle:self.provinceArr[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
        [_backView1 addSubview:btn];
    }
    
    for (int i = 0; i < self.letterArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i >= 20 && i < 29) {
            
            btn.frame = CGRectMake(btnX + mw + (btnW + maginR) * (i % column), btnY + 2 * (btnH + maginC), btnW, btnH);
            [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
            
        }else if (i >= 29) {
            if (i == 29) {
                btn.frame = CGRectMake(btnX, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_back"] forState:UIControlStateNormal];
            }else if (i == 37) {
                btn.frame = CGRectMake(6 * (btnW + maginR) + btnW + w + m + m + btnX, btnY + 3 * (btnH + maginC), w, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_over"] forState:UIControlStateNormal];
            }else {
                btn.frame = CGRectMake((i % column)*(btnW + maginR) + w + m + btnX, btnY + 3 * (btnH + maginC), btnW, btnH);
                [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
            }
        }else {
            btn.frame = CGRectMake(btnW * (i % column) + i % column * maginR + btnX, btnY + i/column * (btnH + maginC), btnW, btnH);
            [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
        }
        [btn setTitleColor:HEXCOLOR(0x23262F, 1) forState:UIControlStateNormal];
        [btn setTitle:self.letterArr[i] forState:UIControlStateNormal];
        
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
        [_backView2 addSubview:btn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView1.frame;
        frame.origin.y = size.height - size.height * 0.33;
        _backView1.frame = frame;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView2.frame;
        frame.origin.y = size.height - size.height * 0.33;
        _backView2.frame = frame;
    }];
}

- (void)btn1Click:(UIButton *)sender {
    
    NSLog(@" >>> provinceArr: - %@ -- tag - %zd", self.provinceArr[sender.tag],sender.tag);
    _btn.enabled = YES;
    if (sender.tag == 30) {
        NSLog(@"点击了abc键");
        if (_backView2.hidden) {
            NSLog(@"_backView2 隐藏了");
            _backView1.hidden = YES;
            _backView2.hidden = NO;
        }else {
            sender.enabled = NO;
        }
        
    }else if (sender.tag == 38){
        NSLog(@"点击了删除键");
        if (_backView2.hidden) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnClick)]) {
                [self.delegate deleteBtnClick];
            }
        }
    }else {
        _backView1.hidden = YES;
        _backView2.hidden = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithString:)]) {
            [self.delegate clickWithString:self.provinceArr[sender.tag]];
        }
    }
}

- (void)btn2Click:(UIButton *)sender {
    
    NSLog(@" >>> letterArr: - %@ -- tag - %zd", self.letterArr[sender.tag], sender.tag);
    if (sender.tag == 29) {
        NSLog(@"点击了abc键");
        _backView1.hidden = NO;
        _backView2.hidden = YES;
        
    }else if (sender.tag == 37) {
        NSLog(@"点击了删除键");
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnClick)]) {
            [self.delegate deleteBtnClick];
        }
        
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithString:)]) {
            [self.delegate clickWithString:self.letterArr[sender.tag]];
        }
    }
}

- (void)deleteEnd {
    _backView1.hidden = NO;
    _backView2.hidden = YES;
}

//通知的监听方法
- (void)textFAction:(NSNotification *)notification {
    
    NSLog(@" >> info -- %@", notification.userInfo);
    NSString *str = notification.userInfo[@"text"];
    if (str.length == 0) {
        _btn.enabled = NO;
    }else if (str.length == 7) {
        [self hiddenView];
    }else {
        _backView1.hidden = YES;
        _backView2.hidden = NO;
        _btn.enabled = YES;
    }
}

//初次弹出键盘时
- (void)showWithString:(NSString *)string {
    NSLog(@" >> string -- %@", string);
    
    _backView1.hidden = YES;
    _backView2.hidden = NO;
    _btn.enabled = YES;
}

//收回键盘
- (void)hiddenView {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView1.frame;
        frame.origin.y = size.height;
        _backView1.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backView2.frame;
        frame.origin.y = size.height;
        _backView2.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//手势的代理方法
#pragma mark >> UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_backView1] ||
        [touch.view isDescendantOfView:_backView2] ) {
        
        return NO;
    }
    return YES;
}

//  颜色转换为背景图片
//  这个之前用，后来让美工做了几张图片，一共就需要4张图片(abc建背景图，删除键 返回键 字符键)
- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//销毁通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
