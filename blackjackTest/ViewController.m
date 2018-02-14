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
    
    self.bAppFirstRun = true;
    self.sGameState = [[NSMutableString alloc] initWithString:USER_TURN];
    
    if (self.bjModel == nil)
        self.bjModel = [[BJModel alloc] init];
    [self.bjModel initModel];
    
    self.cardsView = [[BJCardsView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 100)];
    
    self.uiView = [[BJUIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.uiView.delegate = self;
    [self.uiView initView];
    
    self.yOrigHitBtn = self.uiView.hitBtn.frame.origin.y;
    self.yOrigStandBtn = self.uiView.standBtn.frame.origin.y;
    
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
    
    [self.cardsView renderDeck];
    [self.view addSubview:self.cardsView];
    [self.view addSubview:self.uiView];
    
    // resetGameAndStarts
    [self resetGameAndStarts];
}

- (void) setButtonsForNewGame
{
    self.uiView.hitBtn.alpha = 0;
    self.uiView.standBtn.alpha = 0;
    
    CGRect btnframe = self.uiView.hitBtn.frame;
    btnframe.origin.y = [[UIScreen mainScreen] bounds].size.height - self.uiView.hitBtn.frame.size.height;
    self.uiView.hitBtn.frame = btnframe;
    btnframe = self.uiView.standBtn.frame;
    btnframe.origin.y = [[UIScreen mainScreen] bounds].size.height - self.uiView.standBtn.frame.size.height;
    self.uiView.standBtn.frame = btnframe;
}

- (void) resetGameAndStarts
{
    [self.bjModel reset];
    if (self.aUserCards == nil)
        self.aUserCards = [[NSMutableArray alloc] init];
    if (self.aDealerCards == nil)
        self.aDealerCards = [[NSMutableArray alloc] init];
    
    // safe check when looping game
    [self.aUserCards removeAllObjects];
    [self.aDealerCards removeAllObjects];
    
    // remove cards from screen
    if (self.cardsView != nil)
        [self.cardsView clearCards];
    
    [self resetText];
    
    // preparing UI
    [self.uiView enableButtons:NO];
    [self setButtonsForNewGame];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect btnframe = self.uiView.hitBtn.frame;
        btnframe.origin.y = self.yOrigHitBtn;
        self.uiView.hitBtn.frame = btnframe;
        btnframe = self.uiView.standBtn.frame;
        btnframe.origin.y = self.yOrigStandBtn;
        self.uiView.standBtn.frame = btnframe;
        
        self.uiView.hitBtn.alpha = 1;
        self.uiView.standBtn.alpha = 1;
    } completion:^(BOOL finished)
    {
        self.bjModel.bNewGameStarted = NO;
        // check for managed context core data
        if (self.bAppFirstRun)
        {
            self.bAppFirstRun = NO;
            if (![self resumeGame])
                [self dealCardsForStart];
            else
                [self handleResumeScenarios];
        }
        else
            [self dealCardsForStart];
    }];
}

- (void) handleResumeScenarios
{
    // resume scenarios
    if ([self.sGameState isEqualToString:USER_TURN])
    {
        [self animateFirstCards];
        [self.uiView enableButtons:YES];
    }
    else if ([self.sGameState isEqualToString:DEALER_TURN])
    {
        [self.uiView enableButtons:NO];
        [self animateFirstCards];
        self.bjModel.iUserScore = [self getPlayerScore:self.aUserCards];
        self.bjModel.bPlayerTurn = NO;
        [self performSelector:@selector(aiHitMove) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
    else if ([self.sGameState isEqualToString:DECIDE_WHO_WINS])
    {
        [self.uiView enableButtons:NO];
        [self animateFirstCards];
        self.bjModel.iUserScore = [self getPlayerScore:self.aUserCards];
        self.bjModel.iDealerScore = [self getPlayerScore:self.aDealerCards];
        self.bjModel.bPlayerTurn = NO;
        [self performSelector:@selector(decideWhoWins) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
}

- (void) dealCardsForStart
{
    // add cards
    for (int i = 0; i < USER_START_CARDS; i++)
        [self addCardToPlayer:self.aUserCards];
    for (int i = 0; i < HOUSE_START_CARDS; i++)
        [self addCardToPlayer:self.aDealerCards];
    
    // animation of cards
    [self animateFirstCards];
    
    [self.uiView enableButtons:YES];
    
    [self saveGameState:USER_TURN];
}

- (void) animateFirstCards
{
    [self.cardsView dealCards:self.aUserCards isDealer:NO];
    [self.cardsView dealCards:self.aDealerCards isDealer:YES];
}

- (void) hitBtnTouched:(UIButton *)sender
{
    [self addCardToPlayer:self.aUserCards];
    [self.cardsView addCardByHit:self.aUserCards isDealer:NO];
    NSLog(@"[hitBtnTouched] added new card self.aUserCards %@", self.aUserCards);
    self.bjModel.iUserScore = [self getPlayerScore:self.aUserCards];
    NSLog(@"user points = %li", (long)self.bjModel.iUserScore);
    
    if (self.bjModel.iUserScore > BJ_TOP_HIT)
    {
        [self.uiView enableButtons:NO];
        [self userBust];
    }
    else
        [self saveGameState:USER_TURN];
}
- (void) standBtnTouched:(UIButton *)sender
{
    // set user score here in case user stands straight away without hit
    self.bjModel.iUserScore = [self getPlayerScore:self.aUserCards];
    self.bjModel.bPlayerTurn = NO;
    [self.uiView enableButtons:NO];
    [self saveGameState:DEALER_TURN];
    
    [self performSelector:@selector(aiHitMove) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
}

- (void) aiHitMove
{
    [self addCardToPlayer:self.aDealerCards];
    [self.cardsView addCardByHit:self.aDealerCards isDealer:YES];
    NSLog(@"[aiMove] added new card self.aDealerCards %@", self.aDealerCards);
    self.bjModel.iDealerScore = [self getPlayerScore:self.aDealerCards];
    NSLog(@"[aiMove] dealer points = %li", (long)self.bjModel.iDealerScore);
    
    if (self.bjModel.iDealerScore < DEALER_STANDS_LIMIT)
    {
        [self saveGameState:DEALER_TURN];
        [self performSelector:@selector(aiHitMove) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
    else if (self.bjModel.iDealerScore >= DEALER_STANDS_LIMIT && self.bjModel.iDealerScore <= BJ_TOP_HIT)
    {
        [self saveGameState:DECIDE_WHO_WINS];
        [self performSelector:@selector(decideWhoWins) withObject:nil afterDelay:arc4random_uniform(DEALER_THINKS_TOPS) + 1];
    }
    else
        [self dealerBust];
}

- (void) decideWhoWins
{
    NSLog(@"[decideWhoWins] user score %li / dealer score %li", (long)self.bjModel.iUserScore, (long)self.bjModel.iDealerScore);
    if (self.bjModel.iUserScore > self.bjModel.iDealerScore)
        [self userWon];
    else if (self.bjModel.iUserScore == self.bjModel.iDealerScore)
        [self gameTie];
    else
        [self userLost];
}

- (void) dealerBust
{
    [self clearSavedData];
    
    self.uiView.tfResult.alpha = 0;
    self.uiView.tfResult.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.uiView.tfResult.text = @"Dealer BUST";
    [self animateText];
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}

- (void) userBust
{
    [self clearSavedData];
    
    self.uiView.tfResult.alpha = 0;
    self.uiView.tfResult.backgroundColor = UIColorFromRGB(0xFF0000);
    self.uiView.tfResult.text = @"BUST";
    [self animateText];
    
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}

- (void) gameTie
{
    [self clearSavedData];
    
    self.uiView.tfResult.alpha = 0;
    self.uiView.tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    self.uiView.tfResult.text = @"IT'S A TIE";
    [self animateText];
    
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}
- (void) userLost
{
    [self clearSavedData];
    
    self.uiView.tfResult.alpha = 0;
    self.uiView.tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    self.uiView.tfResult.text = [NSString stringWithFormat:@"YOU LOST %li to %li", (long)self.bjModel.iUserScore, (long)self.bjModel.iDealerScore];
    [self animateText];
    
    [self performSelector:@selector(resetGameAndStarts) withObject:nil afterDelay:arc4random_uniform(4) + 1];
}
- (void) userWon
{
    [self clearSavedData];
    
    self.uiView.tfResult.alpha = 0;
    self.uiView.tfResult.backgroundColor = UIColorFromRGB(0xC0D7E8);
    self.uiView.tfResult.text = [NSString stringWithFormat:@"YOU WON %li to %li", (long)self.bjModel.iUserScore, (long)self.bjModel.iDealerScore];
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
            self.aUserCards = obj;
        }
        NSData *dealerdata = [[aResults valueForKey:@"dealercards"] objectAtIndex:0];
        if (dealerdata != nil)
        {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:dealerdata];
            self.aDealerCards = obj;
        }
        
        NSString *state = [[aResults valueForKey:@"playstate"] objectAtIndex:0];
        [self.sGameState setString:state];
        
        return YES;
    }
    
    return NO;
}
- (void) saveGameState:(NSString *) state
{
    NSData *userdata = [NSKeyedArchiver archivedDataWithRootObject:self.aUserCards];
    NSData *dealerdata = [NSKeyedArchiver archivedDataWithRootObject:self.aDealerCards];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest * fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"BJData"];
    NSArray *aResults = [context executeFetchRequest:fetchReq error:nil];
    
    [aResults setValue:userdata forKey:@"usercards"];
    [aResults setValue:dealerdata forKey:@"dealercards"];
    [aResults setValue:state forKey:@"playstate"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"didn't save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (void) clearSavedData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deletedObjects];
}

//////////////////////////////////////////////
// Utilities /////////////////////////////////
//////////////////////////////////////////////
- (void) animateText
{
    CGRect textFrame = self.uiView.tfResult.frame;
    textFrame.origin.x = [[UIScreen mainScreen] bounds].size.width;
    self.uiView.tfResult.frame = textFrame;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect textFrame = self.uiView.tfResult.frame;
        textFrame.origin.x = 0;
        self.uiView.tfResult.frame = textFrame;
        self.uiView.tfResult.alpha = 1;
    }];
}
- (void) resetText
{
    if (self.uiView.tfResult != nil)
    {
        self.uiView.tfResult.alpha = 0;
        [self.uiView.tfResult setText:@""];
    }
}

- (void) addCardToPlayer:(NSMutableArray *) cards
{
    self.bjModel.deckCardIndex++;
    [cards addObject:[self.bjModel.deckCards objectAtIndex:(self.bjModel.deckCardIndex % self.bjModel.deckCards.count)]];
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
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    return context;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
