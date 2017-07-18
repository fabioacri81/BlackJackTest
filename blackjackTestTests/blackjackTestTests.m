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
    [_testInstance viewDidLoad];
    [_testInstance resetGameAndStarts];
    [_testInstance dealCardsForStart];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInitProgram
{
    XCTAssertEqual(_testInstance.bjModel.bPlayerTurn, YES, "it's player's turn!");
}

- (void) testDealingCardsAndHit
{
    XCTAssertTrue(_testInstance.aUserCards.count == 2);
    XCTAssertTrue(_testInstance.aDealerCards.count == 1);
    
    [_testInstance hitBtnTouched:_testInstance.uiView.hitBtn];
    XCTAssertTrue(_testInstance.aUserCards.count == 3);
    [_testInstance hitBtnTouched:_testInstance.uiView.hitBtn];
    XCTAssertFalse(_testInstance.aUserCards.count == 3);
}

- (void) testUserBust
{
    [_testInstance hitBtnTouched:_testInstance.uiView.hitBtn];
    [_testInstance hitBtnTouched:_testInstance.uiView.hitBtn];
    [_testInstance hitBtnTouched:_testInstance.uiView.hitBtn];
    [_testInstance hitBtnTouched:_testInstance.uiView.hitBtn];
    
    XCTAssertTrue(_testInstance.bjModel.iUserScore > BJ_TOP_HIT); // this might actually also fail..
}


@end
