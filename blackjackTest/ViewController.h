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
@property (strong, nonatomic) NSMutableArray *aDeckCards;
@property (strong, nonatomic) NSMutableArray *aDealerCards;
@property (strong, nonatomic) NSMutableArray *aUserCards;

// BJ Model
@property (strong) BJModel *bjModel;
// BJ Views
@property (strong, nonatomic) BJCardsView *cardsView;
@property (strong, nonatomic) BJUIView *uiView;
@property (strong, nonatomic) UITextField* tfResult;

// generic
@property CGFloat yOrigHitBtn;
@property CGFloat yOrigStandBtn;
@property BOOL bAppFirstRun;
@property (nonatomic) NSMutableString *sGameState;
@property (strong) NSManagedObject *device;

- (void) hitBtnTouched:(UIButton *)sender;
- (void) standBtnTouched:(UIButton *)sender;
 
- (void) setButtonsForNewGame;
- (void) resetGameAndStarts;
- (void) dealCardsForStart;
- (void) aiHitMove;

- (void) clearSavedData;
- (BOOL) resumeGame;
- (void) saveGameState:(NSString *) state;

- (void) resetText;
- (void) userBust;
- (void) dealerBust;
- (void) decideWhoWins;
- (void) gameTie;
- (void) userLost;
- (void) userWon;

- (NSInteger) getPlayerScore:(NSMutableArray *) cards;
- (void) addCardToPlayer:(NSMutableArray *) cards;


@end

