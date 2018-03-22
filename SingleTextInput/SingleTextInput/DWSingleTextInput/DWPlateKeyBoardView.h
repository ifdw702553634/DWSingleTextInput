//
//  DWPlateKeyBoardView.h
//  SingleTextInput
//
//  Created by mude on 2018/3/22.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>

//键盘view的代理，用来监控键盘输入
@protocol DWPlateKeyBoardViewDelegate <NSObject>

//点击键盘上的按钮
- (void)clickWithString:(NSString *)string;
//删除按钮
- (void)deleteBtnClick;

@end

@interface DWPlateKeyBoardView : UIView

@property (nonatomic, weak) id<DWPlateKeyBoardViewDelegate> delegate;

//字符串已经删除完毕
- (void)deleteEnd;
- (void)showWithString:(NSString *)string;

@end
