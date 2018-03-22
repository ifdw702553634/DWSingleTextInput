//
//  ViewController.m
//  SingleTextInput
//
//  Created by mude on 2018/3/22.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "ViewController.h"
#import "DWSingleTextInput.h"

#define kWidth  self.view.frame.size.width
#define kHeight self.view.frame.size.height

@interface ViewController ()<DWSingleTextInputDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo";
    DWSingleTextInput *inputView = [[DWSingleTextInput alloc] initWithFrame:CGRectMake(10, 300, kWidth-20, 100) withNumber:8];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)getText:(NSString *)text{
    NSLog(@"%@", [NSString stringWithFormat:@">>>>>>   输出车牌号为：%@",text]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
