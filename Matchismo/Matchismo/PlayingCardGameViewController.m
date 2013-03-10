//
//  PlayingCardGameViewController.m
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/24/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"   //the little box

#define STARTINGCARDCOUNT 8
#define NUMBEROFCARDSTOMATCH 2

@implementation PlayingCardGameViewController

@synthesize game = _game;   //why is this needed? _game is not declared without it
- (PlayingcardMatchingGame *) game {
    LOG
    if (!!!_game) {
        _game = [[PlayingcardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                         usingDeck:self.deck];
    }
    return _game;
}

- (Deck *) createDeck{
    LOG
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger) startingCardCount {
    return STARTINGCARDCOUNT;
}

- (NSUInteger) numberOfCardsToMatch {
    return NUMBEROFCARDSTOMATCH;
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card{
    LOG
    if ( [cell isKindOfClass:[PlayingCardCollectionViewCell class]] ) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ( [card isKindOfClass:[PlayingCard class]] ) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)updateUI {
    LOG
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
        if (card.isUnplayable) {
            [self.game.cards removeObjectAtIndex:indexPath.item];
            [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.comment.text = self.game.comment;
//    self.thisScore.text = [NSString stringWithFormat:@"This move: %d", self.game.scoreThisPlay];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
