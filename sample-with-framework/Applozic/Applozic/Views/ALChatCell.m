//
//  ALChatCell.m
//  ChatApp
//
//  Copyright (c) 2015 AppLozic. All rights reserved.
//

#import "ALChatCell.h"
#import "ALUtilityClass.h"
#import "ALConstant.h"
#import "ALUITextView.h"
#import "UIImageView+WebCache.h"
#import "ALContactDBService.h"
// Constants
#define MT_INBOX_CONSTANT "4"
#define MT_OUTBOX_CONSTANT "5"


@implementation ALChatCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
        
        
        self.mUserProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
        
        self.mUserProfileImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.mUserProfileImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.mUserProfileImageView];
        
    
        
        self.mBubleImageView = [[UIImageView alloc] init];
        
//        self.mBubleImageView.frame = CGRectMake(5, 5, 100, 44);
        
        self.mBubleImageView.frame = CGRectMake(self.mUserProfileImageView.frame.origin.x+self.mUserProfileImageView.frame.size.width+5 , 5, self.frame.size.width-110, self.frame.size.width-110);
        
        self.mBubleImageView.contentMode = UIViewContentModeScaleToFill;
        
        self.mBubleImageView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.mBubleImageView];
        


        self.mMessageLabel =[[ALUITextView alloc] init];
        self.mMessageLabel.delegate = self.mMessageLabel;
        NSString *fontName = [ALUtilityClass parsedALChatCostomizationPlistForKey:APPLOZIC_CHAT_FONTNAME];
        
        if (!fontName) {
            fontName = DEFAULT_FONT_NAME;
        }
        
        self.mMessageLabel.font = [UIFont fontWithName:fontName size:15];
        
        self.mMessageLabel.textColor = [UIColor grayColor];
        
        self.mMessageLabel.selectable = YES;
        self.mMessageLabel.editable = NO;
        self.mMessageLabel.scrollEnabled = NO;
        self.mMessageLabel.textContainerInset = UIEdgeInsetsZero;
        self.mMessageLabel.textContainer.lineFragmentPadding = 0;
        self.mMessageLabel.dataDetectorTypes = UIDataDetectorTypeLink;

        [self.contentView addSubview:self.mMessageLabel];
        

        self.mDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 25)];
        
        self.mDateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        
        self.mDateLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:.5];
        
        self.mDateLabel.numberOfLines = 1;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0  blue:242/255.0  alpha:1];
        
        [self.contentView addSubview:self.mDateLabel];

        
        self.mMessageStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.mDateLabel.frame.origin.x+self.mDateLabel.frame.size.width, self.mDateLabel.frame.origin.y, 20, 20)];
        
        self.mMessageStatusImageView.contentMode = UIViewContentModeScaleToFill;
        
        self.mMessageStatusImageView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mMessageStatusImageView];
        
        self.contentView.userInteractionEnabled=YES;
      
    }
    
    return self;
    
}


-(instancetype)populateCell:(ALMessage*) alMessage viewSize:(CGSize)viewSize {
    
     self.mUserProfileImageView.alpha=1;
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:[NSDate dateWithTimeIntervalSince1970:[alMessage.createdAtTime doubleValue]/1000]];
    
    NSString * theDate = [NSString stringWithFormat:@"%@",[alMessage getCreatedAtTime:today]];
    
    self.mMessage = alMessage;
    
    CGSize theTextSize = [self getSizeForText:alMessage.message maxWidth:viewSize.width-115 font:self.mMessageLabel.font.fontName fontSize:self.mMessageLabel.font.pointSize];
    
    CGSize theDateSize = [self getSizeForText:theDate maxWidth:150 font:self.mDateLabel.font.fontName fontSize:self.mDateLabel.font.pointSize];
    
    //MT_INBOX(Short.valueOf("4")),
   // MT_OUTBOX(Short.valueOf("5")),
    if ([alMessage.type isEqualToString:@MT_INBOX_CONSTANT]/*[alMessage.type isEqualToString:@"4"]*/) { //Recieved Message
        
        self.mUserProfileImageView.frame = CGRectMake(8, 0, 45, 45);
        self.mUserProfileImageView.image = [UIImage imageNamed:@"ic_contact_picture_holo_light.png"];
        
        self.mMessageLabel.frame = CGRectMake(65 , 5, theTextSize.width, theTextSize.height);
        
        int imgVwWidth = theTextSize.width>150?theTextSize.width+20+14:150;
        
        int imgVwHeight = theTextSize.height+21>45?theTextSize.height+21+10:45;
        
        self.mBubleImageView.frame = CGRectMake(58 , 0, imgVwWidth , imgVwHeight);
        
        self.mDateLabel.frame = CGRectMake(65 , self.mMessageLabel.frame.origin.y+ self.mMessageLabel.frame.size.height + 3, theDateSize.width , 21);
        
        self.mDateLabel.textAlignment = NSTextAlignmentLeft;
        
        self.mDateLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:.5];
        
        self.mMessageStatusImageView.frame = CGRectMake(self.mDateLabel.frame.origin.x+self.mDateLabel.frame.size.width, self.mDateLabel.frame.origin.y, 20, 20);
        
        self.mMessageStatusImageView.alpha =0;
        
        ALContactDBService *theContactDBService = [[ALContactDBService alloc] init];
        ALContact *alContact = [theContactDBService loadContactByKey:@"userId" value: alMessage.to];
       
        if (alContact.localImageResourceName)
        {
            self.mUserProfileImageView.image = [UIImage imageNamed:alContact.localImageResourceName];
            
        }
        else  if(alContact.contactImageUrl)
        {
            NSURL * theUrl1 = [NSURL URLWithString:alContact.contactImageUrl];
            [self.mUserProfileImageView sd_setImageWithURL:theUrl1];
        }
        else
        {
            self.mUserProfileImageView.image = [UIImage imageNamed:@"ic_contact_picture_holo_light.png"];
            NSLog(@"Default Image for this chat/profile ");
        }

        
        
    }
    else    //Sent Message
    {
        self.mUserProfileImageView.alpha=0;
        self.mUserProfileImageView.frame = CGRectMake(viewSize.width-53, 0, 45, 45);
//        self.mUserProfileImageView.image = [UIImage imageNamed:@"ic_contact_picture_holo_light.png"];
        
        int imgVwWidth = theTextSize.width>150?theTextSize.width+14:150;
        
        int imgVwHeight = theTextSize.height+21>45?theTextSize.height+21+10:45;
                
        self.mBubleImageView.frame = CGRectMake(viewSize.width - imgVwWidth -10 , 0 ,imgVwWidth  ,imgVwHeight);
        self.mBubleImageView.frame = CGRectMake(viewSize.width - imgVwWidth -10 , 0 ,imgVwWidth  ,imgVwHeight);
        self.mMessageLabel.frame = CGRectMake(self.mBubleImageView.frame.origin.x+8, 5, theTextSize.width, theTextSize.height);
        
        self.mDateLabel.frame = CGRectMake(self.mBubleImageView.frame.origin.x + 8, self.mMessageLabel.frame.origin.y + self.mMessageLabel.frame.size.height +3 , theDateSize.width, 21);
        
        self.mDateLabel.textAlignment = NSTextAlignmentLeft;
        
        self.mDateLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:.5];
        
        self.mMessageStatusImageView.frame = CGRectMake(self.mDateLabel.frame.origin.x+self.mDateLabel.frame.size.width+10, self.mDateLabel.frame.origin.y, 20, 20);
        
    }
    
    if ([alMessage.type isEqualToString:@MT_OUTBOX_CONSTANT]/*[alMessage.type isEqualToString:@"5"]*/) {
        self.mMessageStatusImageView.alpha =1;
        if(alMessage.delivered==YES){
            self.mMessageStatusImageView.image = [UIImage imageNamed:@"ic_action_message_delivered.png"];
        }
        else if(alMessage.sent==YES){
             self.mMessageStatusImageView.image = [UIImage imageNamed:@"ic_action_message_sent.png"];
        }else{
            self.mMessageStatusImageView.image = [UIImage imageNamed:@"ic_action_about.png"];
            
        }
    }
    
    self.mMessageLabel.text = alMessage.message;
    
    self.mDateLabel.text = theDate;
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width font:(NSString *)fontName fontSize:(float)fontSize {
    
    CGSize constraintSize;
    
    constraintSize.height = MAXFLOAT;
    
    constraintSize.width = width;
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:fontName size:fontSize], NSFontAttributeName,
                                          nil];
    
    CGRect frame = [text boundingRectWithSize:constraintSize
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributesDictionary
                                      context:nil];
    
    CGSize stringSize = frame.size;
    
    return stringSize;
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:) || action == @selector(delete:));
}




// Default copy method
- (void)copy:(id)sender {
    
    NSLog(@"Copy in ALCHATCELL, messageId: %@", self.mMessage.message);
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    //[pasteBoard setString:cell.textLabel.text];
    [pasteBoard setString:self.mMessage.message];
    
}

-(void) delete:(id)sender {
    [ self.delegate deleteMessageFromView:self.mMessage];
}


@end