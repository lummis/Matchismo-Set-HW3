//
//  Deck.m
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@end

@implementation Deck

-(NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (!card) {
        return;
    }
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

-(Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    NSLog(@"in drawRandomCard remaining cards: %d", [self.cards count]);
    return randomCard;
}

@end
