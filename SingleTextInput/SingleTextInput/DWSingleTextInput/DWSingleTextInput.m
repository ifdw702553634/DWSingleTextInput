//
//  DWSingleTextInput.m
//  SingleTextInput
//
//  Created by mude on 2018/3/22.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "DWSingleTextInput.h"
#import "DWPlateKeyBoardView.h"

#define SPACE 10.f
#define LABELWIDTH ((_frame.size.width-(_labelNumber+1)*SPACE)/_labelNumber)
#define LABELHEIGHT (LABELWIDTH*4/3)

@interface DWSingleTextInput()<DWPlateKeyBoardViewDelegate>{
    CGRect _frame;
    NSUInteger _labelNumber;
}

@property (nonatomic, strong) DWPlateKeyBoardView *keyboardView;

@property (nonatomic, strong) NSString *plateStr;

@end

@implementation DWSingleTextInput

- (instancetype)initWithFrame:(CGRect)frame withNumber:(NSUInteger)number {
    _frame = frame;
    _labelNumber = number;
    if (self = [super initWithFrame:frame]) {
        [self prepareView];
        _plateStr = @"";
    }
    return self;
}

- (void)prepareView{
    for (int i = 0; i < _labelNumber; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SPACE+i*(LABELWIDTH + SPACE), (_frame.size.height- LABELHEIGHT)/2, LABELWIDTH, LABELHEIGHT)];
        label.tag = 100 + i;
        label.layer.borderWidth = 2.f;
        label.layer.borderColor = [UIColor orangeColor].CGColor;
        label.layer.cornerRadius = 4.f;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        [label addGestureRecognizer:labelTapGestureRecognizer];
        label.userInteractionEnabled = YES; // 可以理解为设置label可被点击
        [label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew  context:nil];
    }
}

- (void)dealloc {
    //添加观察者之后 监听完毕之后要删除观察者
    for (int i = 0; i < _labelNumber; i ++) {
        UILabel *label = [self viewWithTag:100 +i];
        [label removeObserver:self forKeyPath:@"text"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@" >>>>>  text --- %@", change[@"new"]);
    NSLog(@" >>>>>  self.plateTF.text --- %@", self.plateStr);
    //发送通知并把textfield的值传过去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"abc" object:nil userInfo:@{@"text": change[@"new"]}];
    
}

- (void)labelClick:(UILabel *)label{
    self.keyboardView = [[DWPlateKeyBoardView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.keyboardView.delegate = self;
    [self.window addSubview:self.keyboardView];
    //先判断下textfield上有没有之前输入的车牌号码，主要是来初始化view用的，结合键盘view的代码看下，很容易懂的
    if (self.plateStr.length > 0) {
        [self.keyboardView showWithString:self.plateStr];
    }
}

#pragma mark >> LYPlateKeyBoardViewDelegate
- (void)clickWithString:(NSString *)string {
    
    NSLog(@"carNumTF -- %@", self.plateStr);
    //输入一个字符拼接到后面
    _plateStr = [_plateStr stringByAppendingString:string];
    //判断车牌号码大于8位的时候，怎么输入就输不进去了
    if (_plateStr.length > _labelNumber) {
        NSString *str = [_plateStr substringToIndex:_plateStr.length - 1];
        NSLog(@" >>> str --- %@", str);
        _plateStr = str;
    }else{
        UILabel *label = [self viewWithTag:100 + self.plateStr.length - 1];
        label.text = string;
    }
    [self.delegate getText:_plateStr];
}

- (void)deleteBtnClick {
    //这里要多个判断，不然会崩的，一直点击删除键的情况下
    if (self.plateStr.length == 0) {
        
    }else if (self.plateStr.length == 1) {
        //删除完了，没有字符可以删除了，切换显示的view
        [self.keyboardView deleteEnd];
        UILabel *label = [self viewWithTag:100 + _plateStr.length - 1];
        label.text = @"";
        _plateStr = [_plateStr substringToIndex:[_plateStr length] - 1];
    }else {
        UILabel *label = [self viewWithTag:100 + _plateStr.length - 1];
        label.text = @"";
        _plateStr = [_plateStr substringToIndex:[_plateStr length] - 1];
    }
}

@end
