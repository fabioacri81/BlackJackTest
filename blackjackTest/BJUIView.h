//
//  BJUIView.h
//  blackjackTest
//
//  Created by Fabio Acri on 16/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface BJUIView : UIView

@property (weak, nonatomic) id delegate;

// view components
@property (nonatomic) UIButton *hitBtn;
@property (nonatomic) UIButton *standBtn;
@property (nonatomic) UITextField* tfResult;

- (void) initView;
- (void) enableButtons:(BOOL) on;

@end
