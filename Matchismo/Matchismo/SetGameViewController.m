//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Robert Lummis on 2/10/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "UpCardCollectionView.h"
#import "UpCardCollectionViewCell.h"

#define STARTINGCARDCOUNT 16

@interface SetGameViewController ()

@property (strong, nonatomic) SetCard *currentCard;

@end

@implementation SetGameViewController
@synthesize game = _game;   //won't compile without this - why is it needed?

- (SetMatchingGame *) game {
    LOG
    if (!!!_game) {
        _game = [[SetMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                 usingDeck:self.deck];
    }
    return _game;
}

- (void) viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUpCardCollectionView) name:@"UpCardsChanged" object:nil];
}

- (void) updateUpCardCollectionView {
    NSLog(@"# upCards: %d", [self.game.upCards count]);
    [self.upCardCollectionView reloadData];
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card {
    LOG
    if ( [cell isKindOfClass:[UpCardCollectionViewCell class]] ) {
        NSLog(@"UpCardCollectionViewCell card: %@", card);
        
        SetCardView *v = ( (UpCardCollectionViewCell *)cell ).view;
        if ( [card isKindOfClass:[SetCard class]] ) {
            SetCard *setCard = (SetCard *)card;
            v.symbol = setCard.symbol;
            v.shading = setCard.shading;
            v.number = setCard.number;
            v.color = setCard.color;
            if (setCard.isFaceUp) cell.backgroundColor = [UIColor blackColor];
            else cell.backgroundColor = [UIColor clearColor];
        }
        
    } else if ( [cell isKindOfClass:[SetCardCollectionViewCell class]] ) {
        SetCardView *v = ( (SetCardCollectionViewCell *)cell ).setCardView;
        if ( [card isKindOfClass:[SetCard class]] ) {
            SetCard *setCard = (SetCard *)card;
            v.symbol = setCard.symbol;
            v.shading = setCard.shading;
            v.number = setCard.number;
            v.color = setCard.color;
            if (setCard.isFaceUp) cell.backgroundColor = [UIColor blackColor];
            else cell.backgroundColor = [UIColor clearColor];
        }
    }
}

- (Deck *) createDeck{
    LOG
    return [[SetCardDeck alloc] init];
}

- (NSUInteger) startingCardCount {
    return STARTINGCARDCOUNT;
}

- (void) updateUI {
    LOG
    NSLog(@"[self.game.upCards count]: %d", [self.game.upCards count]);
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
        if (card.isUnplayable) {
            [self.game.cards removeObjectAtIndex:indexPath.item];
            [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    
    [self.upCardCollectionView reloadData];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.comment.text = self.game.comment;

    if (self.game.moveResultCode == newDealCode) {
        self.comment.text = @"Select 3 cards that make a set";
    }
    
    else if (self.game.moveResultCode == matchCode) {
        self.comment.text = [NSString stringWithFormat:@"That is a set. %d points", self.game.scoreThisPlay];
    }
    
    else if (self.game.moveResultCode == mismatchCode) {
        self.comment.text = [NSString stringWithFormat:@"Not a set. %d points", self.game.scoreThisPlay];
    }
    
    else if (self.game.moveResultCode == noFlipCode) {
        self.comment.text = @"Can't select more cards";
        self.flipCount--;   //was incremented without checking if flip is allowed
    }
    
    else if (self.game.moveResultCode == flipUpCode) {
        self.comment.text = @"flipped up";
    }
    
    else if (self.game.moveResultCode == flipDownCode) {
        self.comment.text = @"flipped down";
    }
    
    else NSLog(@"invalid moveResultCode: %d", self.game.moveResultCode);
    
    self.flipCountLabel.text = [NSString stringWithFormat:@"flips: %d", self.flipCount];
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %d", self.game.score];
}

//- (NSAttributedString *) makeAttributedStringWithSymbol:(NSUInteger)symbol number:(NSUInteger)number
//                                                shading:(NSUInteger)shading color:(NSUInteger)color {
//    NSString *word = @"";
//    for (int i = 0; i < number + 1; i++) {
//        word = [word stringByAppendingString:[ @[@" ■", @" ▲", @" ●"] objectAtIndex:symbol]];
//    }
//    UIColor *strokeColor = @[ [UIColor redColor], [UIColor greenColor], [UIColor purpleColor] ] [ (int)color ];
//    UIColor *fgColor = [strokeColor colorWithAlphaComponent:[@[@0.f, @0.2f, @1.0f][shading] floatValue]];
//    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:word];
//    NSRange r = NSMakeRange(0, [mat length]);
//    [mat addAttribute:NSForegroundColorAttributeName    value:fgColor       range:r];
//    [mat addAttribute:NSStrokeColorAttributeName        value:strokeColor   range:r];
//    [mat addAttribute:NSStrokeWidthAttributeName        value:@-10          range:r];
//    return [mat copy];
//}


- (void)viewDidUnload {
    LOG
    
    [self setComment:nil];
//    [self setThisScore:nil];
    [super viewDidUnload];
}
@end
