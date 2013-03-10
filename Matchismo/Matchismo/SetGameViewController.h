//
//  SetGameViewController.h
//  Matchismo
//
//  Created by Robert Lummis on 2/10/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "SetMatchingGame.h"

@interface SetGameViewController : CardGameViewController;

@property (nonatomic, strong) SetMatchingGame *game;

@end
