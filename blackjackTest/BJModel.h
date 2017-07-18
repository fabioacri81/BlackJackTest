//
//  BJModel.h
//  blackjackTest
//
//  Created by Fabio Acri on 13/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJModel : NSObject

@property (strong, nonatomic) NSMutableArray *deckCards;

@property NSInteger iUserScore;
@property NSInteger iDealerScore;
@property NSInteger deckCardIndex;

@property BOOL bNewGameStarted;
@property BOOL bPlayerTurn;

// functions
- (void) initModel;
- (void) reset;
- (void) shuffleCards:(NSMutableArray *) cards;

@end
