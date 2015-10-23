//
//  PostDM.m
//  Anyare
//
//  Created by Nikki Fernandez on 10/22/15.
//  Copyright © 2015 SourcePad. All rights reserved.
//

#import "PostDM.h"

@implementation PostDM

+ (NSArray *)getPostsFromArray:(NSArray *)array
{
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    for(NSDictionary *postDict in array)
        [posts addObject:[self getPostFromDictionary:[postDict objectForKey:@"post"]]];
    return posts;
}

+ (PostDM *)getPostFromDictionary:(NSDictionary *)dict
{
    PostDM *post = [[PostDM alloc] init];
    
    post.postId = [[dict objectForKey:@"id"] intValue];
    post.address = [dict objectForKey:@"address"];
    post.category = [dict objectForKey:@"category"];
    post.details = [dict objectForKey:@"description"];
    
    post.largeImageUrl = [dict objectForKey:@"large"];
    post.mediumImageUrl = [dict objectForKey:@"medium"];
    post.smallImageUrl = [dict objectForKey:@"small"];
    
    post.resolved = [[dict objectForKey:@"resolved"] boolValue];
    
    post.latitude = [[dict objectForKey:@"latitude"] floatValue];
    post.longitude = [[dict objectForKey:@"longitude"] floatValue];
    
    //post.dateTime = [[dict objectForKey:@"update_at"] longValue];
    post.dateTime = [dict objectForKey:@"updated_at"];
    
    // Save user
    
    return post;
}
@end
