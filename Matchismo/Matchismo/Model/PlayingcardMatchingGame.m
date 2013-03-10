//
//  PlayingcardMatchingGame.m
//  Matchismo
//
//  Created by Robert Lummis on 2/5/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "PlayingcardMatchingGame.h"
#import "PlayingCard.h"

#define NUMBEROFCARDSTOMATCH 2
#define RANKMATCHBONUS 12
#define SUITMATCHBONUS 4
#define FLIPPOINTS -1
#define MISMATCHPENALTY -3

@implementation PlayingcardMatchingGame

- (NSUInteger) numberOfCardsToMatch {
    return NUMBEROFCARDSTOMATCH;
}

- (NSInteger) flipPoints {
    return FLIPPOINTS;
}

    //handle the 2 cards that are turned up
- (void) evaluateCards:(NSArray *)upCards {
    if ( [upCards count] != NUMBEROFCARDSTOMATCH ) {
        NSLog(@"error: evaluateCards received %d cards", [upCards count]);
        return;
    }   //this should never happen
    
    NSMutableArray *cardsThatMatchByRank = [[NSMutableArray alloc] init];
    NSMutableArray *cardsThatMatchBySuit = [[NSMutableArray alloc] init];
    for (PlayingCard *card in upCards) {
        if ( [card matchByRank:upCards] ) [cardsThatMatchByRank addObject:card];
        if ( [card matchBySuit:upCards] ) [cardsThatMatchBySuit addObject:card];
    }
    
        //count cards that match by rank, cards that match by suit, and put the cards in a set
    NSUInteger rankMatches = [cardsThatMatchByRank count];
    NSUInteger suitMatches = [cardsThatMatchBySuit count];
    NSMutableSet *matchedCards = [NSMutableSet setWithCapacity:3];
    [matchedCards addObjectsFromArray:cardsThatMatchByRank];
    [matchedCards addObjectsFromArray:cardsThatMatchBySuit];
    
        //disable the cards that matched something
    for (PlayingCard *card in matchedCards) {   
        card.unplayable = YES;
    }
    
        //get score for this play
    self.scoreThisPlay = [self scoreForRankMatches:rankMatches suitMatches:suitMatches];
    
        //construct comment including the list of cards that match something (without saying
        //if it's by rank or by suit) and the score for this move
    if ( [matchedCards count] == 0 ) {
        self.comment = [NSString stringWithFormat:@"No match! %d points", self.scoreThisPlay];
    } else {
        self.comment = @"";
        for (PlayingCard *card in matchedCards) {   //change to Card *card ??
            self.comment = [self.comment stringByAppendingString:[NSString stringWithFormat:@"%@ ", card.contents]];
        }
        self.comment = [self.comment stringByAppendingString:@" match. You got "];
        self.comment = [self.comment stringByAppendingString:[NSString stringWithFormat:@"%d points", self.scoreThisPlay]];
    }
    
        //increment score
    self.score += self.scoreThisPlay;
}

-(NSInteger) scoreForRankMatches:(NSUInteger)r suitMatches:(NSUInteger)s {
        if (r == 0 && s == 0) return MISMATCHPENALTY;    //no match
        else if (r == 2) return RANKMATCHBONUS;
        else if (s == 2) return SUITMATCHBONUS;
        else return 0;
}

@end
