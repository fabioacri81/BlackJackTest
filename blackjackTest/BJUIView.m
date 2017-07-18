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
    [_hitBtn setFrame:CGRectMake(38, 8, 116, 55)];
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
    [_standBtn setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - (116+38), 8, 116, 55)];
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
    
    [self addSubview:_hitBtn];
    [self addSubview:_standBtn];
}

- (void) enableButtons:(BOOL) on
{
    _hitBtn.userInteractionEnabled = on;
    _standBtn.userInteractionEnabled = on;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
