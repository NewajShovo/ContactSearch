//
//  contactViewController.m
//  contactSearch
//
//  Created by Shafiq Shovo on 21/3/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "contactViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@interface contactViewController ()

@property (strong) CNContactStore *store;
@property (strong)  CNContactViewController *controller;
@property(nonatomic, copy) NSString *contactIdentifier;
@end

@implementation contactViewController

- (void)viewDidLoad {
    NSLog(@"HELLddddddddddddddddddd");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.store = [[CNContactStore alloc] init];
    [self saveContact];

   
    
    
}

-(void)saveContact
{
    CNMutableContact *mutContact = [[CNMutableContact alloc] init];
    
    NSLog(@"Howwwwwwwwwwwwwwwwww are youuuuuuuuuuu");
    NSLog(@"%@",mutContact);
    mutContact.givenName = @"GivenName";
    mutContact.familyName = @"FamilyName";
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:mutContact toContainerWithIdentifier:[self.store defaultContainerIdentifier]];
    [self.store executeSaveRequest:saveRequest error:nil];
    self.contactIdentifier = [mutContact identifier];
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
