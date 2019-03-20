//
//  contactSearchViewController.m
//  contactSearch
//
//  Created by Shafiq Shovo on 20/3/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "contactSearchViewController.h"
#import <Contacts/Contacts.h>
#import "profileDetailViewController.h"
@interface contactSearchViewController ()

@end

@implementation contactSearchViewController

- (void)viewDidLoad {
     NSLog(@"Hello"); 
    [super viewDidLoad];
    
    allItems = [ [ NSMutableArray alloc]  init];
    onlyShow = [ [ NSMutableArray alloc] init];
    passItem = [ [ NSMutableArray alloc] init];
    changeItem = [ [ NSMutableArray alloc] init];
    
CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *firstName;
               // NSString *lastName;
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    //lastName = contact.familyName;
                    NSLog(@"%@",firstName);
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
   NSLog(@"%@",onlyShow);
   displayItems =  [ [ NSMutableArray alloc] initWithArray:onlyShow];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
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
    return [ displayItems count];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   profileDetailViewController *profileViewController = [ [ profileDetailViewController alloc] init];
    
    CNContact *value =changeItem[ indexPath.row];
    NSLog(@"*****%@",value);
    profileViewController.data= value;
    //profileViewController. = selectedItem;
    //detailViewController.item = selectedItem;
    [ self.navigationController pushViewController:profileViewController animated:YES];
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
