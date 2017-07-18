//
//  ViewController.m
//  blackjackTest
//
//  Created by Fabio Acri on 12/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _bAppFirstRun = true;
    _sGameState = [[NSMutableString alloc] initWithString:USER_TURN];
    
    if (_bjModel == nil)
        _bjModel = [[BJModel alloc] init];
    [_bjModel initModel];
    
    _cardsView = [[BJCardsView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 100)];
    
    _uiView = [[BJUIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 100, [[UIScreen mainScreen] bounds].size.width, 100)];
    _uiView.delegate = self;
    [_uiView initView];
    
    _yOrigHitBtn = _uiView.hitBtn.frame.origin.y;
    _yOrigStandBtn = _uiView.standBtn.frame.origin.y;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImageView *table = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bjTablePhone"]];
    [self.view addSubview:table];
    CGRect tableFrame = table.frame;
    tableFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    tableFrame.size.height = [[UIScreen mainScreen] bounds].size.height;
    table.frame = tableFrame;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_cardsView renderDeck];
    [self.view addSubview:_cardsView];
    
    [self.view addSubview:_uiView];
    
    // ideally this component should stay in the uiview..
    _tfResult = [[UITextField alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height / 2 - 25, [[UIScreen mainScreen]bounds].size.width, 50)];
    _tfResult.borderStyle = UITextBorderStyleRoundedRect;
    _tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    _tfResult.textAlignment = NSTextAlignmentCenter;
    _tfResult.textColor = [UIColor blackColor];
    _tfResult.font = [UIFont fontWithName:@"Gill Sans" size:40];
    _tfResult.alpha = 0;
    [_tfResult setText:@""];
    
    [self.view addSubview:_tfResult];
    
    // resetGameAndStarts
    [self resetGameAndStarts];
}

- (void) setButtonsForNewGame
{
    _uiView.hitBtn.alpha = 0;
    _uiView.standBtn.alpha = 0;
    
    CGRect btnframe = _uiView.hitBtn.frame;
    btnframe.origin.y = [[UIScreen mainScreen] bounds].size.height - _uiView.hitBtn.frame.size.height;
    _uiView.hitBtn.frame = btnframe;
    btnframe = _uiView.standBtn.frame;
    btnframe.origin.y = [[UIScreen mainScreen] bounds].size.height - _uiView.standBtn.frame.size.height;
    _uiView.standBtn.frame = btnframe;
}

- (void) resetGameAndStarts
{
    [_bjModel reset];
    if (_aUserCards == nil)
        _aUserCards = [[NSMutableArray alloc] init];
    if (_aDealerCards == nil)
        _aDealerCards = [[NSMutableArray alloc] init];
    
    // safe check when looping game
    [_aUserCards removeAllObjects];
    [_aDealerCards removeAllObjects];
    
    // remove cards from screen
    if (_cardsView != nil)
        [_cardsView clearCards];
    
    [self resetText];
    
    // preparing UI
    [_uiView enableButtons:NO];
    [self setButtonsForNewGame];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect btnframe = _uiView.hitBtn.frame;
        btnframe.origin.y = _yOrigHitBtn;
        _uiView.hitBtn.frame = btnframe;
        btnframe = _uiView.standBtn.frame;
        btnframe.origin.y = _yOrigStandBtn;
        _uiView.standBtn.frame = btnframe;
        
        _uiView.hitBtn.alpha = 1;
        _uiView.standBtn.alpha = 1;
    } completion:^(BOOL finished)
    {
        _bjModel.bNewGameStarted = NO;
        // check for managed context core data
        //if (_bAppFirstRun)
        //{
        //    _bAppFirstRun = NO;
        //    if ([self resumeGame] == NO)
                [self dealCardsForStart];
        /*    else
            {
                [self handleResumeScenarios];
            }
        }
        else
            [self dealCardsForStart];*/
    }];
}

- (void) handleResumeScenarios
{
    // resume scenarios
    if ([_sGameState isEqualToString:USER_TURN])
    {
        [self animateFirstCards];
        [_uiView enableButtons:YES];
    }
    else if ([_sGameState isEqualToString:DEALER_TURN])
    {
        [_uiView enableButtons:NO];
        [self animateFirstCards];
        _bjModel.iUserScore = [self getPlayerScore:_aUserCards];
        _bjModel.bPlayerTurn = NO;
        [self performSelector:@selector(aiHitMove) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
    else if ([_sGameState isEqualToString:DECIDE_WHO_WINS])
    {
        [_uiView enableButtons:NO];
        [self animateFirstCards];
        _bjModel.iUserScore = [self getPlayerScore:_aUserCards];
        _bjModel.iDealerScore = [self getPlayerScore:_aDealerCards];
        _bjModel.bPlayerTurn = NO;
        [self performSelector:@selector(decideWhoWins) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
}

- (void) dealCardsForStart
{
    // add cards
    for (int i = 0; i < USER_START_CARDS; i++)
        [self addCardToPlayer:_aUserCards];
    for (int i = 0; i < HOUSE_START_CARDS; i++)
        [self addCardToPlayer:_aDealerCards];
    
    // animation of cards
    [self animateFirstCards];
    
    [_uiView enableButtons:YES];
    
    [self saveGameState:USER_TURN];
}

- (void) animateFirstCards
{
    [_cardsView dealCards:_aUserCards isDealer:NO];
    [_cardsView dealCards:_aDealerCards isDealer:YES];
}

- (void) hitBtnTouched:(UIButton *)sender
{
    [self addCardToPlayer:_aUserCards];
    [_cardsView addCardByHit:_aUserCards isDealer:NO];
    NSLog(@"[hitBtnTouched] added new card _aUserCards %@", _aUserCards);
    _bjModel.iUserScore = [self getPlayerScore:_aUserCards];
    NSLog(@"user points = %li", (long)_bjModel.iUserScore);
    
    if (_bjModel.iUserScore > BJ_TOP_HIT)
    {
        [_uiView enableButtons:NO];
        [self userBust];
    }
    else
        [self saveGameState:USER_TURN];
}
- (void) standBtnTouched:(UIButton *)sender
{
    // set user score here in case user stands straight away without hit
    _bjModel.iUserScore = [self getPlayerScore:_aUserCards];
    _bjModel.bPlayerTurn = NO;
    [_uiView enableButtons:NO];
    [self saveGameState:DEALER_TURN];
    
    [self performSelector:@selector(aiHitMove) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
}

- (void) aiHitMove
{
    [self addCardToPlayer:_aDealerCards];
    [_cardsView addCardByHit:_aDealerCards isDealer:YES];
    NSLog(@"[aiMove] added new card _aDealerCards %@", _aDealerCards);
    _bjModel.iDealerScore = [self getPlayerScore:_aDealerCards];
    NSLog(@"[aiMove] dealer points = %li", (long)_bjModel.iDealerScore);
    
    if (_bjModel.iDealerScore < DEALER_STANDS_LIMIT)
    {
        [self saveGameState:DEALER_TURN];
        [self performSelector:@selector(aiHitMove) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
    else if (_bjModel.iDealerScore >= DEALER_STANDS_LIMIT && _bjModel.iDealerScore <= BJ_TOP_HIT)
    {
        [self saveGameState:DECIDE_WHO_WINS];
        [self performSelector:@selector(decideWhoWins) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
    else
        [self dealerBust];
}

- (void) decideWhoWins
{
    NSLog(@"[decideWhoWins] user score %li / dealer score %li", (long)_bjModel.iUserScore, (long)_bjModel.iDealerScore);
    if (_bjModel.iUserScore > _bjModel.iDealerScore)
        [self userWon];
    else if (_bjModel.iUserScore == _bjModel.iDealerScore)
        [self gameTie];
    else
        [self userLost];
}

- (void) dealerBust
{
    [self clearSavedData];
    
    _tfResult.alpha = 0;
    _tfResult.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _tfResult.text = @"Dealer BUST";
    [self animateText];
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}

- (void) userBust
{
    [self clearSavedData];
    
    _tfResult.alpha = 0;
    _tfResult.backgroundColor = UIColorFromRGB(0xFF0000);
    _tfResult.text = @"BUST";
    [self animateText];
    
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}

- (void) gameTie
{
    [self clearSavedData];
    
    _tfResult.alpha = 0;
    _tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    _tfResult.text = @"IT'S A TIE";
    [self animateText];
    
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}
- (void) userLost
{
    [self clearSavedData];
    
    _tfResult.alpha = 0;
    _tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    _tfResult.text = [NSString stringWithFormat:@"YOU LOST %li to %li", (long)_bjModel.iUserScore, (long)_bjModel.iDealerScore];
    [self animateText];
    
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}
- (void) userWon
{
    [self clearSavedData];
    
    _tfResult.alpha = 0;
    _tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    _tfResult.text = [NSString stringWithFormat:@"YOU WON %li to %li", (long)_bjModel.iUserScore, (long)_bjModel.iDealerScore];
    [self animateText];
    
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
    
}

- (BOOL) resumeGame
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"BJData"];
    
    NSArray *aResults = [context executeFetchRequest:fetchReq error:nil];
    if (aResults != nil && aResults.count > 0)
    {
        NSData *userdata = [[aResults valueForKey:@"usercards"] objectAtIndex:0];
        if (userdata != nil)
        {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
            _aUserCards = obj;
        }
        NSData *dealerdata = [[aResults valueForKey:@"dealercards"] objectAtIndex:0];
        if (dealerdata != nil)
        {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:dealerdata];
            _aDealerCards = obj;
        }
        
        NSString *state = [[aResults valueForKey:@"playstate"] objectAtIndex:0];
        [_sGameState setString:state];
        
        return YES;
    }
    
    return NO;
}
- (void) saveGameState:(NSString *) state
{
    NSData *userdata = [NSKeyedArchiver archivedDataWithRootObject:_aUserCards];
    NSData *dealerdata = [NSKeyedArchiver archivedDataWithRootObject:_aDealerCards];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BJData" inManagedObjectContext:context];
    self.device = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    [self.device setValue:userdata forKey:@"usercards"];
    [self.device setValue:dealerdata forKey:@"dealercards"];
    [self.device setValue:state forKey:@"playstate"];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"didn't save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (void) clearSavedData
{
    
}

//////////////////////////////////////////////
// Utilities /////////////////////////////////
//////////////////////////////////////////////
- (void) animateText
{
    CGRect textFrame = _tfResult.frame;
    textFrame.origin.x = [[UIScreen mainScreen] bounds].size.width;
    _tfResult.frame = textFrame;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect textFrame = _tfResult.frame;
        textFrame.origin.x = 0;
        _tfResult.frame = textFrame;
        _tfResult.alpha = 1;
    }];
}
- (void) resetText
{
    if (_tfResult != nil)
    {
        _tfResult.alpha = 0;
        [_tfResult setText:@""];
    }
}

- (void) addCardToPlayer:(NSMutableArray *) cards
{
    _bjModel.deckCardIndex++;
    [cards addObject:[_bjModel.deckCards objectAtIndex:(_bjModel.deckCardIndex % _bjModel.deckCards.count)]];
}

- (NSInteger) getPlayerScore:(NSMutableArray *) cards
{
    int iResult = 0;
    NSMutableString *substr = [[NSMutableString alloc] init];
    for (int i = 0; i < cards.count; i++)
    {
        [substr setString:[((NSString *) cards[i]) substringFromIndex:1]];
        if ([substr isEqualToString:@"j"] == YES)
            iResult += JACK;
        else if ([substr isEqualToString:@"q"] == YES)
            iResult += QUEEN;
        else if ([substr isEqualToString:@"k"] == YES)
            iResult += KING;
        else if ([substr isEqualToString:@"a"] == YES)
        {
            if (iResult > BJ_TOP_HIT) iResult += 1;
            else iResult += ACE;
        }
        else
            iResult += [[((NSString *) cards[i]) substringFromIndex:1] integerValue];
    }
    
    return iResult;
}

- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    return context;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
