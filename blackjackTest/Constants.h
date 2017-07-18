//
//  Constants.h
//  blackjackTest
//
//  Created by Fabio Acri on 12/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#define BJ_TOP_HIT 21
#define USER_START_CARDS 2
#define HOUSE_START_CARDS 1
#define DECK_CARDS 52
#define DEALER_THINKS_TOPS 3
#define DEALER_STANDS_LIMIT 14
#define CARD_ORIG_WID 116
#define CARD_ORIG_HEI 160
#define UI_VIEW_Y_PADDING 100

// play states
#define USER_TURN @"USER TURN"
#define DEALER_TURN @"DEALER TURN"
#define DECIDE_WHO_WINS @"DECIDE WHO WINS"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define JACK 10
#define QUEEN 10
#define KING 10
#define ACE 11
