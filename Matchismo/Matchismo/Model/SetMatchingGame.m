//
//  SetMatchingGame.m
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/14/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "SetMatchingGame.h"
#import "SetCard.h"

@implementation SetMatchingGame

#define FLIPPOINTS -2
#define MATCH_POINTS 24
#define MISMATCH_POINTS -12
#define CARDSTOMATCH 3

- (NSUInteger) numberOfCardsToMatch {
    return CARDSTOMATCH;
}

- (NSInteger) matchPoints {
    return MATCH_POINTS;
}

- (NSInteger) mismatchPoints {
    return MISMATCH_POINTS;
}

- (NSInteger) flipPoints {
    return FLIPPOINTS;
}

-(void) flipCardAtIndex:(NSUInteger)index {
    [super flipCardAtIndex:index];
    
    switch (self.moveResultCode) {
        case noFlipCode:
        case flipDownCode:
            return;
            break;
        case flipUpCode:
            self.scoreThisPlay = self.flipPoints;
            self.score += self.scoreThisPlay;
            if ( [self.upCards count] == self.numberOfCardsToMatch ) {
                [self evaluateCards:self.upCards];
            }
            break;
    };
}

    //handle the 3 cards that are turned up
- (void)evaluateCards:(NSArray *)upCards {
    if ( [upCards count] != 3 ) {
        NSLog(@"error: evaluateCards received %d cards", [upCards count]);
        return;
    }   //this should never happen
    
    if ( [self matchBySymbol:upCards] && [self matchByColor:upCards]
        && [self matchByShading:upCards] && [self matchByNumber:upCards] ) {
        self.moveResultCode = matchCode;
        self.scoreThisPlay = MATCH_POINTS;
        for (SetCard *card in upCards) {
            card.unplayable = YES;  //disable cards that were matched
        }
        self.comment = [NSString stringWithFormat:@"You found a set %d points", self.scoreThisPlay];
    } else {
        self.moveResultCode = mismatchCode;
        self.scoreThisPlay = MISMATCH_POINTS;
        self.comment = [NSString stringWithFormat:@"Not a set %d points", self.scoreThisPlay];
    }
    self.score += self.scoreThisPlay;
}

- (BOOL) setCardsMatchOne:(int)valueOne two:(int)valueTwo three:(int)valueThree {
    int sum = valueOne + valueTwo + valueThree;
    switch (sum) {  //they are all different or all the same iff the sum is 3, 6, or 9 
        case 0:
        case 3:
        case 6:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL) matchBySymbol:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.symbol two:c2.symbol three:c3.symbol];
}

- (BOOL) matchByNumber:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.number two:c2.number three:c3.number];
}

- (BOOL) matchByColor:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.color two:c2.color three:c3.color];
}

- (BOOL) matchByShading:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.shading two:c2.shading three:c3.shading];
}

@end
