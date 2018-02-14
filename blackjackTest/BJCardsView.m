//
//  BJCardsView.m
//  blackjackTest
//
//  Created by Fabio Acri on 15/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import "BJCardsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BJCardsView

- (void) renderDeck
{
    UIImageView *deckCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backCard"]];
    
    CGFloat availableHei = [[UIScreen mainScreen] bounds].size.height - UI_VIEW_HEI - TOP_PADDING*3; //  3 is top padding from screen, padding from deck north, padding south
    self.cardHeight = availableHei / 3;
    self.cardWidth = self.cardHeight * 0.69; // ratio of original card image dimensions
    
    [deckCard setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - self.cardWidth / 2,
                                  ([[UIScreen mainScreen] bounds].size.height - 100) / 2 - self.cardHeight / 2,
                                  self.cardWidth, self.cardHeight)];
    
    [self addSubview:deckCard];
}

- (void) dealCards:(NSMutableArray *) cards isDealer:(BOOL) dealer
{
    if (dealer)
        self.aAICards = [[NSMutableArray alloc] init];
    else
        self.aUserCards = [[NSMutableArray alloc] init];
    
    UIImageView *card;
    CGFloat xFirstPos = ([[UIScreen mainScreen] bounds].size.width - CARDS_SPACE_BETWEEN - self.cardWidth*cards.count) / 2;
    
    for (int i = 0; i < cards.count; i++)
    {
        // not showing first initial card of dealer
        //card = [[UIImageView alloc] initWithImage:[UIImage imageNamed: !dealer ? cards[i] : @"backCard"]];
        // showing all cards
        card = [[UIImageView alloc] initWithImage:[UIImage imageNamed: cards[i]]];
        [card setFrame:[self getOrigFrame]];
        [self addCardToScreen:card user:dealer];
        
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect cardFrame = card.frame;
            cardFrame.origin.x = xFirstPos + (self.cardWidth + CARDS_SPACE_BETWEEN) * i;
            cardFrame.origin.y = [self getYPosCardToAdd:dealer];
            card.frame = cardFrame;
            
        } completion:^(BOOL finished){
            // nothing here for now
        }];
    }
}

- (void) addCardByHit:(NSMutableArray *) cards isDealer:(BOOL) dealer
{
    long maxCards = cards.count;
    
    CGFloat xFirstPos = ([[UIScreen mainScreen] bounds].size.width - CARDS_SPACE_BETWEEN*(maxCards-1) - self.cardWidth*maxCards) / 2;
    
    UIImageView* card = [[UIImageView alloc] initWithImage:[UIImage imageNamed: cards[maxCards - 1]]];
    [card setFrame:[self getOrigFrame]];
    [self addCardToScreen:card user:dealer];
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // set new card pos
        CGRect cardFrame = card.frame;
        cardFrame.origin.x = xFirstPos + (self.cardWidth + CARDS_SPACE_BETWEEN) * (maxCards - 1);
        cardFrame.origin.y = [self getYPosCardToAdd:dealer];
        card.frame = cardFrame;
        
        // move previous cards
        for (long i = cards.count - 1; i >= 0; i--)
        {
            if (!dealer)
            {
                cardFrame = [(UIImageView*)self.aUserCards[i] frame];
                cardFrame.origin.x = xFirstPos + (self.cardWidth + CARDS_SPACE_BETWEEN) * i;
                [(UIImageView*)self.aUserCards[i] setFrame:cardFrame];
            }
            else
            {
                cardFrame = [(UIImageView*)self.aAICards[i] frame];
                cardFrame.origin.x = xFirstPos + (self.cardWidth + CARDS_SPACE_BETWEEN) * i;
                [(UIImageView*)self.aAICards[i] setFrame:cardFrame];
            }
        }
        
    } completion:^(BOOL finished){
        // nothing here for now
    }];
}

- (CGFloat) getYPosCardToAdd:(BOOL) dealer
{
    return dealer ? TOP_PADDING : ([[UIScreen mainScreen] bounds].size.height - UI_VIEW_HEI) / 2 + self.cardHeight / 2 + TOP_PADDING;
}

- (void) addCardToScreen:(UIImageView *) card user:(BOOL) isDealer
{
    [self addSubview:card];
    if (!isDealer)
        [self.aUserCards addObject:card];
    else
        [self.aAICards addObject:card];
}

- (CGRect) getOrigFrame
{
    return CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - self.cardWidth / 2,
                      ([[UIScreen mainScreen] bounds].size.height - UI_VIEW_HEI) / 2 - self.cardHeight / 2,
                      self.cardWidth, self.cardHeight);
}

- (void) clearCards
{
    if (self.aUserCards != nil && self.aUserCards.count > 0)
    {
        for (long i = self.aUserCards.count - 1; i >= 0; i--)
             [((UIImageView*) self.aUserCards[i]) removeFromSuperview];
    }
    [self.aUserCards removeAllObjects];
    
    if (self.aAICards != nil && self.aAICards.count > 0)
    {
        for (long i = self.aAICards.count - 1; i >= 0; i--)
            [((UIImageView*) self.aAICards[i]) removeFromSuperview];
    }
    [self.aAICards removeAllObjects];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
