//
//  contactSearchViewController.h
//  contactSearch
//
//  Created by Shafiq Shovo on 20/3/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
NS_ASSUME_NONNULL_BEGIN

@interface contactSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate >
{
    
    IBOutlet UISearchBar *searcBar;
    IBOutlet UITableView *tableView;
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *changeItem;
    NSMutableArray * allItems;
    NSMutableArray *onlyShow;
    NSMutableArray * displayItems;
    NSMutableArray * passItem;
    NSMutableArray * searchItem;
    CNContactStore *store ;
    bool check ;
    NSMutableArray *index;
    NSMutableArray *multiple;
}

@end

NS_ASSUME_NONNULL_END
