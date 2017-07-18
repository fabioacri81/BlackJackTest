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
@property (strong, nonatomic) UIButton *hitBtn;
@property (strong, nonatomic) UIButton *standBtn;

- (void) initView;
- (void) enableButtons:(BOOL) on;

@end
