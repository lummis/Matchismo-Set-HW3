//
//  PlayingCardGameViewController.h
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/24/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

    // This is a concrete subclass of the abstract class CardGameViewController

#import "CardGameViewController.h"
#import "PlayingcardMatchingGame.h"

@interface PlayingCardGameViewController : CardGameViewController

@property (nonatomic, strong) PlayingcardMatchingGame *game;

@end
