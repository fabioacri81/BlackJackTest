//
//  BJCardsView.h
//  blackjackTest
//
//  Created by Fabio Acri on 15/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

#define TOP_PADDING 10
#define UI_VIEW_HEI 100
#define CARDS_SPACE_BETWEEN -40

@interface BJCardsView : UIView

@property (nonatomic) NSMutableArray *aUserCards;
@property (nonatomic) NSMutableArray *aAICards;

@property CGFloat cardWidth;
@property CGFloat cardHeight;

- (void) renderDeck;
- (void) dealCards:(NSMutableArray *) cards isDealer:(BOOL) dealer;
- (void) addCardByHit:(NSMutableArray *) cards isDealer:(BOOL) dealer;
- (void) clearCards;

@end
