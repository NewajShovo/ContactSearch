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
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
@interface contactSearchViewController ()<CNContactViewControllerDelegate>


@end

@implementation contactSearchViewController




- (void)viewDidLoad {
     //NSLog(@"Hello");
    tableView.allowsMultipleSelection = true;
    check =true;
    [super viewDidLoad];
    
    allItems = [ [ NSMutableArray alloc]  init];
    onlyShow = [ [ NSMutableArray alloc] init];
    passItem = [ [ NSMutableArray alloc] init];
    changeItem = [ [ NSMutableArray alloc] init];
    index = [ [ NSMutableArray alloc] init];
    store= [ [ NSMutableArray alloc] init];

    [self loadContact];
}
-(void)reloadContactList {
    [displayItems removeAllObjects];
    //[changeItem removeAllObjects];
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
                    }
                }
            }
            //NSLog(@"%@",onlyShow);
        }
    }];
    
    
    displayItems =  [ [ NSMutableArray alloc] initWithArray:onlyShow];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [tableView reloadData];
     NSLog(@"%lu",(unsigned long)displayItems.count);
}

- (instancetype) init
{
    //self = [ super initWithStyle: UITableViewStylePlain];
    
    if (self)
    {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"ContactSearch";
        
        UIBarButtonItem *bbi = [ [ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector (addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        UIBarButtonItem *bbi1 = [ [ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit   target:self action:@selector (buttonClicked:)];
        navItem.leftBarButtonItem = bbi1;
    }
    
    return self;
    
}
#pragma mark - buttonClicked method

- (IBAction) buttonClicked:(id)sender
{
    NSLog(@"HELLO00000000");
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(donebuttonClicked:)];
    backBtn.title = @"Delete";
    self.navigationItem.leftBarButtonItem = backBtn;
    
    ///UIBarButtonItem *change = "Done";
   // item.leftBarButtonItem=
    check =false;
    NSLog(@"%d",check);
    
    
}
- (void) multipledelete: (CNContact *) temp
{
    NSLog(@"DDDDDDDDDDDD");
    NSLog(@"%@",temp);
    changeItem.removeAllObjects;
    onlyShow.removeAllObjects;
    displayItems.removeAllObjects;
    for ( CNContact *con in allItems)
    {
        if( con.identifier ==temp.identifier)
        {
            continue;
        }
        else{
            
            [displayItems addObject:con.givenName];
            [onlyShow addObject:con.givenName];
            [changeItem addObject:con];
            
        }
        
        
        
    }
    allItems.removeAllObjects;
    allItems = [ [ NSMutableArray alloc] initWithArray:changeItem];
    changeItem.removeAllObjects;
    NSLog(@"%lu",displayItems.count);
    //[ self.navigationController popViewControllerAnimated:YES];
    
    //[tableView deleteRowsAtIndexPaths:@[] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
    
    
    
    check=1;
    
}




#pragma mark - doneButtonClicked:

- (IBAction) donebuttonClicked:(id)sender
{
    
    NSLog(@"%@",index);

    
    for (CNContact *i in index)
    {
        
        [ self multipledelete:i ];
        
    }
    [self init];

    
    NSLog(@"HI There");
    
}




- (instancetype) inintWithStyle: (UITableViewStyle) style
{
    return [ self init];
}

#pragma mark - this is add item
- (IBAction) addNewItem:(id)sender
{
    
        CNContactViewController *addContactVC = [CNContactViewController viewControllerForNewContact:nil];
        addContactVC.delegate=self;
        ///UINavigationController *navController   = [[UINavigationController alloc] initWithRootViewController:addContactVC];
        NSLog(@"%@",addContactVC);
        [ self.navigationController pushViewController:addContactVC animated:YES];
        NSLog(@"I am in addItem");
    
    
    NSLog(@"HELLLo");
    
    ///[UIViewControllers presentViewController:navController];
     ///[ pushViewController:navController animated:YES];
    
}
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
 
  if ( contact == NULL)
  {
      NSLog(@"Done");
       [ self.navigationController popViewControllerAnimated:YES];
  }
 
    else
    {
       //CNMutableContact *mutableContact = [[CNMutableContact alloc] init];
        
        [self reloadContactList];
        
    }
    
    
    
    //You will get the callback here
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CNContact *value = allItems[indexPath.row];
        changeItem.removeAllObjects;
        onlyShow.removeAllObjects;
        displayItems.removeAllObjects;
        //NSLog(@"%lu",(unsigned long)displayItems.count);
        for ( CNContact *con in allItems)
        {
            if( con.identifier ==value.identifier)
            {
                continue;
            }
            else{
            
                [displayItems addObject:con.givenName];
                [onlyShow addObject:con.givenName];
                [changeItem addObject:con];
            
            }
            
            
            
        }
        allItems.removeAllObjects;
        allItems = [ [ NSMutableArray alloc] initWithArray:changeItem];
        changeItem.removeAllObjects;
        NSLog(@"%lu",displayItems.count);
        
        
       
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
        //[self reloadContactList];
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
#pragma mark - table view did select

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CNContact *value = allItems[ indexPath.row];
    
    if( check == true){
    NSLog(@"%@",value);
    NSLog(@"DLJLDJSLJLKJKL");
    CNContactViewController *contactView = [ CNContactViewController viewControllerForContact:value];
    NSLog(@"hessssss");
    contactView.delegate =self;
    contactView.allowsEditing = YES;
    contactView.allowsActions = YES;

    [ self.navigationController pushViewController:contactView animated:YES];
    }
    else
    {
        NSLog(@"aaaaaaaaaa");
        NSLog(@"%@",value);
        [index addObject:value];
        NSLog(@"%@",index);
    }
    
    
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



- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchItem removeAllObjects];
    searchItem = [ [ NSMutableArray alloc] initWithArray:allItems];
   if ( [searchText length]==0)
   {
       NSLog(@"Hello");
       [displayItems removeAllObjects];
       [displayItems addObjectsFromArray:onlyShow];
       
   } else{
       NSLog(@"%lu",(unsigned long)allItems.count);
       [changeItem removeAllObjects];
       [displayItems removeAllObjects];
       for (CNContact * val in allItems)
       {
           NSString * string = val.givenName;
           NSRange  r = [ string rangeOfString:searchText options:NSCaseInsensitiveSearch];
           if(r.location != NSNotFound)
           {
              [changeItem addObject:val];
              [displayItems addObject:string];
           }
           
           
       }
       allItems = [ [NSMutableArray alloc] initWithArray:changeItem];
       changeItem.removeAllObjects;
       NSLog(@"%@",allItems);
   
   [tableView reloadData];
   }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar
{
    NSLog(@"searchBar");
    allItems.removeAllObjects;
    allItems= [ [ NSMutableArray alloc] initWithArray:searchItem];
    searchItem.removeAllObjects;
    [ tableView reloadData];
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
