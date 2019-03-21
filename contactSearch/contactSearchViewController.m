//
//  contactSearchViewController.m
//  contactSearch
//
//  Created by Shafiq Shovo on 20/3/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "contactSearchViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "profileDetailViewController.h"
#import "contactViewController.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
@interface contactSearchViewController ()<CNContactViewControllerDelegate>


@end

@implementation contactSearchViewController




- (void)viewDidLoad {
     //NSLog(@"Hello");
    [super viewDidLoad];
    
    allItems = [ [ NSMutableArray alloc]  init];
    onlyShow = [ [ NSMutableArray alloc] init];
    passItem = [ [ NSMutableArray alloc] init];
    changeItem = [ [ NSMutableArray alloc] init];
    //UIView *header = self.headerView;
    /*
    store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
            NSString *containerId = self->store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [self->store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *firstName;
               // NSString *lastName;
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    //lastName = contact.familyName;
                    ///NSLog(@"%@",firstName);
                    if([firstName length] > 0){
                    [self->allItems addObject:contact];
                    [self->onlyShow addObject:firstName];
                    [self-> passItem addObject:contact];
                    [self ->changeItem addObject:contact];
                    }
                }
            }
            //NSLog(@"%@",onlyShow);
        }
    }];
   //NSLog(@"%@",onlyShow);
    NSLog(@"%@",onlyShow);
    displayItems =  [ [ NSMutableArray alloc] initWithArray:onlyShow];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
   */
    [self loadContact];
}
-(void)reloadContactList {
    [displayItems removeAllObjects];
    [changeItem removeAllObjects];
    [onlyShow removeAllObjects];
     
    [self loadContact];
}

- (void) loadContact{

    store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSLog(@"HELLO");
            NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
            NSString *containerId = self->store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [self->store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *firstName;
                // NSString *lastName;
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    //lastName = contact.familyName;
                    ///NSLog(@"%@",firstName);
                    if([firstName length] > 0){
                       [self->allItems addObject:contact];
                        [self->onlyShow addObject:firstName];
                        [self-> passItem addObject:contact];
                        [self ->changeItem addObject:contact];
                    }
                }
            }
            //NSLog(@"%@",onlyShow);
        }
    }];
    
    
    displayItems =  [ [ NSMutableArray alloc] initWithArray:onlyShow];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [ tableView reloadData];
     NSLog(@"%lu",(unsigned long)displayItems.count);
}

- (instancetype) init
{
    //self = [ super initWithStyle: UITableViewStylePlain];
    
    if (self)
    {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"contactSearch";
        
        UIBarButtonItem *bbi = [ [ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector (addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
    
}
- (instancetype) inintWithStyle: (UITableViewStyle) style
{
    return [ self init];
}



- (IBAction) addNewItem:(id)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add"
                                          message:@"New Contact"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Firstname";
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"PhoneNumber";
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *firstname = alertController.textFields.firstObject;
                                   UITextField *phonenumber = alertController.textFields.lastObject;
                                   
                                   [self saveContact:firstname.text givenName:@"" phoneNumber:phonenumber.text];
                                   [self loadContact];
                                   [tableView reloadData];
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *value = onlyShow[indexPath.row];
        NSLog(@"%lu",(unsigned long)onlyShow.count);
        [onlyShow removeObject:value];
        NSLog(@"%lu",(unsigned long)onlyShow.count);
       
        displayItems.removeAllObjects;
        NSLog(@"%lu",(unsigned long)displayItems.count);
        for ( NSString *val in onlyShow)
        {
            [displayItems addObject:val];
        }
        NSLog(@"%lu",displayItems.count);
        
        
       
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
    }
}

- (void) keyboardShown: (NSNotification *) note
{
    CGRect keyboardFrame;
    [[ [ note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGRect tableViewFrame = tableView.frame;
    tableViewFrame.size.height -= keyboardFrame.size.height;
    [tableView setFrame:tableViewFrame];
}
- (void) keyboardHidden: (NSNotification *) note
{
    [tableView setFrame:self.view.bounds];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayItems count];
}
- (UITableViewCell *) tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
   // NSLog(@"how are you");
     if(!cell)
     {
         cell = [ [ UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
     
     }
    cell.textLabel.text = [displayItems objectAtIndex:indexPath.row];
    return cell;
    

}
-(void)updateContact:(CNContact*)contact memo:(NSString*)memo{
    CNMutableContact *mutableContact = contact.mutableCopy;
    
    mutableContact.note = memo;
    
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest updateContact:mutableContact];
    
    NSError *error;
    if([store executeSaveRequest:saveRequest error:&error]) {
        NSLog(@"save");
        
    }else {
        NSLog(@"save error : %@", [error description]);
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    profileDetailViewController *profileViewController = [ [ profileDetailViewController alloc] init];
    CNContact *value =changeItem[ indexPath.row];
    NSLog(@"*****%@",value);
    profileViewController.data= value;
    //profileViewController. = selectedItem;
    //detailViewController.item = selectedItem;
    [ self.navigationController pushViewController:profileViewController animated:YES];
    */
    
    CNContact *value = changeItem [ indexPath.row];
    
  
    
   
   
    
    
    
  //  [self newContact:(id)];
    
    NSLog(@"%@",value);
    NSLog(@"DLJLDJSLJLKJKL");
    CNContactViewController *contactView = [ CNContactViewController viewControllerForContact:value];
    NSLog(@"hessssss");
    contactView.delegate =self;
    contactView.allowsEditing = YES;
    contactView.allowsActions = YES;

    [ self.navigationController pushViewController:contactView animated:YES];
    
    
   // contactView.contactStore = store;
    
    
    
    
    
}


-(void)saveContact:(NSString*)familyName givenName:(NSString*)givenName phoneNumber:(NSString*)phoneNumber {
    CNMutableContact *mutableContact = [[CNMutableContact alloc] init];
    
    NSLog(@"%@",familyName);
    mutableContact.givenName = familyName;
    mutableContact.familyName = familyName;
    CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:phoneNumber];
    
    mutableContact.phoneNumbers = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:phone], nil];
    CNContactStore *store1 = [[CNContactStore alloc] init];
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:mutableContact toContainerWithIdentifier:store.defaultContainerIdentifier];
    
    NSError *error;
    if([store1 executeSaveRequest:saveRequest error:&error]) {
        NSLog(@"save");
        [self reloadContactList];
    }else {
        NSLog(@"save error");
    }
}

-(void)deleteContact:(CNContact*)contact {
    CNMutableContact *mutableContact = contact.mutableCopy;
    
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *deleteRequest = [[CNSaveRequest alloc] init];
    [deleteRequest deleteContact:mutableContact];
    
    NSError *error;
    if([store executeSaveRequest:deleteRequest error:&error]) {
        NSLog(@"delete complete");
      [tableView reloadData];
    }else {
        NSLog(@"delete error : %@", [error description]);
    }
    
}


- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
   if ( [searchText length]==0)
   {
       [displayItems removeAllObjects];
       [ displayItems addObjectsFromArray:onlyShow];
       
   } else{
       [changeItem removeAllObjects];
       [displayItems removeAllObjects];
       for (CNContact * val in passItem)
       {
           NSString * string = val.givenName;
           NSRange  r = [ string rangeOfString:searchText options:NSCaseInsensitiveSearch];
           if(r.location != NSNotFound)
           {
               [changeItem addObject:val];
               [displayItems addObject:string];
           }
           
           
       }
   
   
   }
    [tableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar
{
    NSLog(@"searchBar");
    [ asearchBar resignFirstResponder];
}



-(IBAction)newContact:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add"
                                          message:@"New Contact"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Firstname";
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"PhoneNumber";
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *firstname = alertController.textFields.firstObject;
                                   UITextField *phonenumber = alertController.textFields.lastObject;
                                   
                                   [self saveContact:firstname.text givenName:@"" phoneNumber:phonenumber.text];
                               }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
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
