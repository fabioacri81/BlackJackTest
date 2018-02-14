//
//  BJUIView.m
//  blackjackTest
//
//  Created by Fabio Acri on 16/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import "BJUIView.h"

#pragma GCC diagnostic ignored "-Wundeclared-selector"

@implementation BJUIView

- (void) initView
{
    _hitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hitBtn.backgroundColor = UIColorFromRGB(0xC0D7E8);
    [_hitBtn setFrame:CGRectMake(38, [[UIScreen mainScreen]bounds].size.height - 92, 116, 55)];
    [_hitBtn setTitle:@"HIT" forState:UIControlStateNormal];
    [_hitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_hitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _hitBtn.titleLabel.font = [UIFont fontWithName:@"Gill Sans" size:26];
    _hitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _hitBtn.userInteractionEnabled = YES;
    _hitBtn.showsTouchWhenHighlighted = YES;
    
    _hitBtn.tag = 0;
    _hitBtn.clipsToBounds = YES;
    _hitBtn.layer.cornerRadius = 20;
    [_hitBtn addTarget:self.delegate action:@selector(hitBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    _standBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _standBtn.backgroundColor = UIColorFromRGB(0xC0D7E8);
    [_standBtn setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - (116+38), [[UIScreen mainScreen]bounds].size.height - 92, 116, 55)];
    [_standBtn setTitle:@"STAND" forState:UIControlStateNormal];
    [_standBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_standBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _standBtn.titleLabel.font = [UIFont fontWithName:@"Gill Sans" size:26];
    _standBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _standBtn.userInteractionEnabled = YES;
    _standBtn.showsTouchWhenHighlighted = YES;
    
    _standBtn.tag = 1;
    _standBtn.clipsToBounds = YES;
    _standBtn.layer.cornerRadius = 20;
    [_standBtn addTarget:self.delegate action:@selector(standBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    _hitBtn.alpha = 0;
    _standBtn.alpha = 0;
    
    // ideally this component should stay in the uiview..
    _tfResult = [[UITextField alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height / 2 - 25, [[UIScreen mainScreen]bounds].size.width, 50)];
    _tfResult.borderStyle = UITextBorderStyleRoundedRect;
    _tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    _tfResult.textAlignment = NSTextAlignmentCenter;
    _tfResult.textColor = [UIColor blackColor];
    _tfResult.font = [UIFont fontWithName:@"Gill Sans" size:40];
    _tfResult.adjustsFontSizeToFitWidth = YES;
    _tfResult.alpha = 0;
    [_tfResult setText:@""];
    
    [self addSubview:self.hitBtn];
    [self addSubview:self.standBtn];
    [self addSubview:self.tfResult];
}

- (void) enableButtons:(BOOL) on
{
    self.hitBtn.userInteractionEnabled = on;
    self.standBtn.userInteractionEnabled = on;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
