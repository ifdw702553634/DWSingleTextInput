//
//  DWSingleTextInput.h
//  SingleTextInput
//
//  Created by mude on 2018/3/22.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>

//键盘view的代理，用来监控键盘输入
@protocol DWSingleTextInputDelegate <NSObject>
//获取输入的内容
- (void)getText:(NSString *)text;
@end

@interface DWSingleTextInput : UIView

@property (nonatomic, weak) id<DWSingleTextInputDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withNumber:(NSUInteger)number;

@end
