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
    _cardHeight = availableHei / 3;
    _cardWidth = _cardHeight * 0.69; // ratio of original card image dimensions
    
    [deckCard setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - _cardWidth / 2,
                                  ([[UIScreen mainScreen] bounds].size.height - 100) / 2 - _cardHeight / 2,
                                  _cardWidth, _cardHeight)];
    
    [self addSubview:deckCard];
}

- (void) dealCards:(NSMutableArray *) cards isDealer:(BOOL) dealer
{
    if (dealer)
        _aAICards = [[NSMutableArray alloc] init];
    else
        _aUserCards = [[NSMutableArray alloc] init];
    
    UIImageView *card;
    CGFloat xFirstPos = ([[UIScreen mainScreen] bounds].size.width - CARDS_SPACE_BETWEEN - _cardWidth*cards.count) / 2;
    
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
            cardFrame.origin.x = xFirstPos + (_cardWidth + CARDS_SPACE_BETWEEN) * i;
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
    
    CGFloat xFirstPos = ([[UIScreen mainScreen] bounds].size.width - CARDS_SPACE_BETWEEN*(maxCards-1) - _cardWidth*maxCards) / 2;
    
    UIImageView* card = [[UIImageView alloc] initWithImage:[UIImage imageNamed: cards[maxCards - 1]]];
    [card setFrame:[self getOrigFrame]];
    [self addCardToScreen:card user:dealer];
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // set new card pos
        CGRect cardFrame = card.frame;
        cardFrame.origin.x = xFirstPos + (_cardWidth + CARDS_SPACE_BETWEEN) * (maxCards - 1);
        cardFrame.origin.y = [self getYPosCardToAdd:dealer];
        card.frame = cardFrame;
        
        // move previous cards
        for (long i = cards.count - 1; i >= 0; i--)
        {
            if (!dealer)
            {
                cardFrame = [(UIImageView*)_aUserCards[i] frame];
                cardFrame.origin.x = xFirstPos + (_cardWidth + CARDS_SPACE_BETWEEN) * i;
                [(UIImageView*)_aUserCards[i] setFrame:cardFrame];
            }
            else
            {
                cardFrame = [(UIImageView*)_aAICards[i] frame];
                cardFrame.origin.x = xFirstPos + (_cardWidth + CARDS_SPACE_BETWEEN) * i;
                [(UIImageView*)_aAICards[i] setFrame:cardFrame];
            }
        }
        
    } completion:^(BOOL finished){
        // nothing here for now
    }];
}

- (CGFloat) getYPosCardToAdd:(BOOL) dealer
{
    return dealer ? TOP_PADDING : ([[UIScreen mainScreen] bounds].size.height - UI_VIEW_HEI) / 2 + _cardHeight / 2 + TOP_PADDING;
}

- (void) addCardToScreen:(UIImageView *) card user:(BOOL) isDealer
{
    [self addSubview:card];
    if (!isDealer)
        [_aUserCards addObject:card];
    else
        [_aAICards addObject:card];
}

- (CGRect) getOrigFrame
{
    return CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - _cardWidth / 2,
                      ([[UIScreen mainScreen] bounds].size.height - UI_VIEW_HEI) / 2 - _cardHeight / 2,
                      _cardWidth, _cardHeight);
}

- (void) clearCards
{
    if (_aUserCards != nil && _aUserCards.count > 0)
    {
        for (long i = _aUserCards.count - 1; i >= 0; i--)
             [((UIImageView*) _aUserCards[i]) removeFromSuperview];
    }
    [_aUserCards removeAllObjects];
    
    if (_aAICards != nil && _aAICards.count > 0)
    {
        for (long i = _aAICards.count - 1; i >= 0; i--)
            [((UIImageView*) _aAICards[i]) removeFromSuperview];
    }
    [_aAICards removeAllObjects];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
