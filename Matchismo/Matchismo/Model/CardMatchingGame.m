//
//  CardMatchingGame.m
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/14/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "CardMatchingGame.h"

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    LOG
    if (!!!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    LOG
    if ( ( self = [super init] ) ) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!!!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    NSLog(@"remaining count in deck: %d", [[deck cards] count]);
    return self;
}

- (NSUInteger) numberOfCardsToMatch {    //abstract
    return 99;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    LOG
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (NSMutableArray *)upCards {
    if (!!!_upCards) {
        _upCards = [[NSMutableArray alloc] init];
    }
    return _upCards;
}

- (void)flipCardAtIndex:(NSUInteger)index { //get here only if card is playable (NOT unplayable)
    Card *card = [self cardAtIndex:index];
    if (card.isFaceUp) {
        card.faceUp = NO;
        self.moveResultCode = flipDownCode;
        [self.upCards removeObject:card];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpCardsChanged" object:self];
        return;
    }
    
        //if we get here the card is NOT unplayable and was face down before this was called
        //get array of cards that are already up
    self.upCards = nil;
    for (Card *card in self.cards) {
        if (card.isFaceUp && !!!card.isUnplayable) {
            [self.upCards addObject:card];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpCardsChanged" object:self];
    
        //don't flip up this card if too many would be up
    if ( [self.upCards count] >= self.numberOfCardsToMatch) {    //don't turn card up because too many would be up
        self.moveResultCode = noFlipCode;
        return;
    }
    
        //flip this card up
    self.moveResultCode = flipUpCode;
    card.faceUp = YES;
    [self.upCards addObject:card];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpCardsChanged" object:self];
    
    self.scoreThisPlay = self.flipPoints;
    self.score += self.scoreThisPlay;
    if ( [self.upCards count] == self.numberOfCardsToMatch ) {
        [self evaluateCards:self.upCards];
    }
}

- (void) evaluateCards:(NSArray *)cards { };    //abstract

@end
