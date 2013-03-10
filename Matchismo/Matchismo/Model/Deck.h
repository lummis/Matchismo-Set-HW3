//
//  Deck.h
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

@property (strong, nonatomic) NSMutableArray *cards;

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(Card *)drawRandomCard;

@end
