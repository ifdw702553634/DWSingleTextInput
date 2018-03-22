//
//  DWPlateKeyBoardShare.m
//  SingleTextInput
//
//  Created by mude on 2018/3/22.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "DWPlateKeyBoardShare.h"

@implementation DWPlateKeyBoardShare

+ (NSArray *)getProvince{
    return
    @[@"京",@"津",@"渝",@"沪",@"冀",@"晋",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"琼",@"川",@"贵",@"云",@"陕",@"甘",@"青",@"蒙",@"桂",@"宁",@"新",@"",@"藏",@"使",@"领",@"警",@"学",@"港",@"澳",@""];
}

+ (NSArray *)getNumberAndLetter{
    return
  @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@""];
}

@end
