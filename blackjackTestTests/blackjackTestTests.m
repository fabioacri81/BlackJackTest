//
//  blackjackTestTests.m
//  blackjackTestTests
//
//  Created by Fabio Acri on 12/07/2017.
//  Copyright © 2017 Fabio Acri. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface blackjackTestTests : XCTestCase
@property (nonatomic) ViewController *testInstance;
@end

@implementation blackjackTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _testInstance = [[ViewController alloc] init];
    [self.testInstance viewDidLoad];
    [self.testInstance resetGameAndStarts];
    [self.testInstance dealCardsForStart];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInitProgram
{
    XCTAssertEqual(self.testInstance.bjModel.bPlayerTurn, YES, "it's player's turn!");
}

- (void) testDealingCardsAndHit
{
    XCTAssertTrue(self.testInstance.aUserCards.count == 2);
    XCTAssertTrue(self.testInstance.aDealerCards.count == 1);
    
    [self.testInstance hitBtnTouched:self.testInstance.uiView.hitBtn];
    XCTAssertTrue(self.testInstance.aUserCards.count == 3);
    [self.testInstance hitBtnTouched:self.testInstance.uiView.hitBtn];
    XCTAssertFalse(self.testInstance.aUserCards.count == 3);
}

- (void) testUserBust
{
    [self.testInstance hitBtnTouched:self.testInstance.uiView.hitBtn];
    [self.testInstance hitBtnTouched:self.testInstance.uiView.hitBtn];
    [self.testInstance hitBtnTouched:self.testInstance.uiView.hitBtn];
    [self.testInstance hitBtnTouched:self.testInstance.uiView.hitBtn];
    
    XCTAssertTrue(self.testInstance.bjModel.iUserScore > BJ_TOP_HIT); // this might actually also fail..
}


@end
