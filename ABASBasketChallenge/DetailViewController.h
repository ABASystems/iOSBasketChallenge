//
//  DetailViewController.h
//  ABASBasketChallenge
//
//  Created by Sean O'Connor on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABASBasketChallenge+CoreDataModel.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Event *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

