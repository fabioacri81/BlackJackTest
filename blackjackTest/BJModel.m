//
//  BJModel.m
//  blackjackTest
//
//  Created by Fabio Acri on 13/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import "BJModel.h"
#import "Constants.h"

@implementation BJModel

- (void) initModel
{
    self.bNewGameStarted = YES;
    self.bPlayerTurn = YES;
    self.deckCardIndex = 0;
    
    self.deckCards = [[NSMutableArray alloc] initWithObjects:@"c2",@"c3",@"c4",@"c5",@"c6",@"c7",@"c8",@"c9",@"c10",@"cj",@"cq",@"ck",@"ca",
                  @"d2",@"d3",@"d4",@"d5",@"d6",@"d7",@"d8",@"d9",@"d10",@"dj",@"dq",@"dk",@"da",
                  @"h2",@"h3",@"h4",@"h5",@"h6",@"h7",@"h8",@"h9",@"h10",@"hj",@"hq",@"hk",@"ha",
                  @"s2",@"s3",@"s4",@"s5",@"s6",@"s7",@"s8",@"s9",@"s10",@"sj",@"sq",@"sk",@"sa",
                  nil];
    [self shuffleCards:self.deckCards];
    self.deckCardIndex = arc4random_uniform(DECK_CARDS-1);
    NSLog(@"[BJModel]-> initModel() deckcardIndex rand %li", (long)self.deckCardIndex);
}

- (void) shuffleCards:(NSMutableArray *) cards
{
    for (NSInteger i = cards.count - 1; i > 0; i--)
        [cards exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
}

- (void) reset
{
    self.bNewGameStarted = YES;
    self.bPlayerTurn = YES;
}

@end
