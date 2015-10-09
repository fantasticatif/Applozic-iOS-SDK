//
//  ALContactCell.h
//  ChatApp
//
//  Copyright (c) 2015 AppLozic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView * mUserImageView;

@property (weak, nonatomic) IBOutlet UILabel *mUserNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *mMessageLabel;

@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mLastMessageStatusImageView;

@end