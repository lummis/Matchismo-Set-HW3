//
//  PlayingCardCollectionViewCell.h
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/23/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
