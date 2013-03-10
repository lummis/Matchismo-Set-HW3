//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "UpCardCollectionView.h"

@interface CardGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UpCardCollectionView *upCardCollectionView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger startingCardCount; //abstract
@property (nonatomic) NSUInteger numberOfCardsToMatch;  //abstract
@property (nonatomic) NSUInteger matchBonus;   //abstract
@property (nonatomic) NSUInteger mismatchPenalty;   //abstract
@property (nonatomic) NSUInteger flipCost;  //abstract
@property (nonatomic) NSUInteger numberOfCardsToAdd;    //abstract
@property (nonatomic, strong) Deck *deck;
@property (weak, nonatomic) IBOutlet UILabel *comment;
//@property (weak, nonatomic) IBOutlet UILabel *thisScore;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSUInteger flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipCountLabel;

- (Deck *) createDeck;   //abstract

- (IBAction) newCard;  //abstract
- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card;    //abstract
//- (void) updateLastFlipStatusView:(UIView *)view usingLastFlipResult:(NSArray *)flipResults infoLabel:(UILabel *)infoLabel; //abstract

//- (void) deleteCards:(NSArray *)cards;
@end
