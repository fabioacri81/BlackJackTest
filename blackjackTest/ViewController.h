//
//  ViewController.h
//  blackjackTest
//
//  Created by Fabio Acri on 12/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "BJModel.h"
#import "BJCardsView.h"
#import "BJUIView.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController

// collectors of image views
@property (nonatomic) NSMutableArray *aDeckCards;
@property (nonatomic) NSMutableArray *aDealerCards;
@property (nonatomic) NSMutableArray *aUserCards;

// BJ Model
@property (nonatomic) BJModel *bjModel;
// BJ Views
@property (nonatomic) BJCardsView *cardsView;
@property (nonatomic) BJUIView *uiView;

// generic
@property CGFloat yOrigHitBtn;
@property CGFloat yOrigStandBtn;
@property BOOL bAppFirstRun;
@property (nonatomic) NSMutableString *sGameState;

// exposed methods
- (void) resetGameAndStarts;
- (void) dealCardsForStart;


@end

