//
//  profileDetailViewController.m
//  contactSearch
//
//  Created by Shafiq Shovo on 20/3/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

//#import "profileDetailViewController.h"
#import "profileDetailViewController.h"
#import <Contacts/Contacts.h>
@interface profileDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *showLast;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation profileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CNContact *value = self.data;
    //NSLog(@"%@",value.givenName);
    self.infoLabel.text = value.givenName;
    if([value.familyName length] > 0){
    self.showLast.text=  @"None";
    }
    else{
        self.showLast.text= value.familyName;
    }
    
    CNLabeledValue * email =value.emailAddresses.firstObject;
    
    NSString *emailvalue = email.value;
    NSLog(@"%@",email);
    if([emailvalue length] > 0){
        self.emailLabel.text=  @"None";
    }
    else{
        self.emailLabel.text= emailvalue;
    }
        //self.emailLabel.text= email;
   
    
    //Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
