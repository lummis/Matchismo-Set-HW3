//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "UpCardCollectionView.h"
#import "UpCardCollectionViewCell.h"

@interface CardGameViewController () <UICollectionViewDataSource>

@end

@implementation CardGameViewController

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    LOG
    if ( [collectionView isKindOfClass:[UpCardCollectionView class]] ) {
        return [self.game.upCards count];
    } else {
        return [self.game.cards count];
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( [collectionView isKindOfClass:[UpCardCollectionView class]] ) {
        UpCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpCell" forIndexPath:indexPath];
        Card *card = [self.game.upCards objectAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
        return cell;
    }
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card {
    LOG
        //abstract
}

- (Deck *) deck {
    LOG
    if (!!!_deck) {
        _deck = [self createDeck];
    }
    return _deck;
}

- (Deck *) createDeck { //abstract
    return nil; 
}

-(void) viewDidLoad {
    LOG
    [super viewDidLoad];
    [self updateUI];
}

- (void) updateUI { } //abstract

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
    NSLog(@"in CardGameViewController / flipCard; self: %@", self);
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {    //could be nil if tap is between items
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        [self updateUI];
    }
}

- (IBAction)deal:(id)sender {
    self.game = nil;
    self.flipCount = 0;
    [self.cardCollectionView reloadData];
    [self updateUpCardCollectionView];
    self.comment.text = @"";
}

- (void) updateUpCardCollectionView { } //abstract

- (IBAction)newCard {
    Card *card = [self.deck drawRandomCard];
    if (card) {
        [self.game.cards addObject:card];
//        [self.cardCollectionView reloadItemsAtIndexPaths:[self.cardCollectionView visibleCells]];
        [self.cardCollectionView reloadData];
    } else {
        self.comment.text = @"No more cards";
    }
}


- (void)setFlipCount:(NSUInteger)flipCount {
    LOG
    _flipCount = flipCount;
    self.flipCountLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)viewDidUnload {

    [self setTitle:nil];
    [self setScoreLabel:nil];
    [self setCardCollectionView:nil];
    [self setComment:nil];
    [self setUpCardCollectionView:nil];
    [super viewDidUnload];
}

@end
