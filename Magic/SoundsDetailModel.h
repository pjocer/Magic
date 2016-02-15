//
//  SoundsDetailModel.h
//  Magic
//
//  Created by mxl on 16/1/10.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DetailChannel : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *tag_id2;
@property (nonatomic, copy) NSString *sound_count;
@property (nonatomic, copy) NSString *follow_count;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *update_user_id;
@property (nonatomic, copy) NSString *list_order;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *encrypt_level;
@property (nonatomic, copy) NSString *desp;
@property (nonatomic, copy) NSString *commend_time;
@property (nonatomic, copy) NSString *check_visition;
@end


@interface DetailUser : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *pay_class;
@property (nonatomic, copy) NSString *pay_status;
@property (nonatomic,copy)  NSString *famous_status;
@property (nonatomic, copy) NSString *followed_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *avatar_100;
@property (nonatomic, copy) NSString *avatar_50;
@property (nonatomic, copy) NSString *is_follow;
@end


@interface DetailResult : JSONModel
@property (nonatomic, copy) NSString *hot_status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *backup_id;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *original;
@property (nonatomic, copy) NSString *source2;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *exchage_count;
@property (nonatomic, copy) NSString *commend_time;
@property (nonatomic, copy) NSString *hls_key;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *check_status;
@property (nonatomic, copy) NSString *crosstalk_id;
@property (nonatomic, copy) NSString *status_mask;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *h5_clickbtn_count;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *comment_count;
@property (nonatomic, copy) NSString *download_count;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *updta_user_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *view_count;
@property (nonatomic, copy) NSString *relay_count;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, strong) DetailUser *user;

@end

@interface SoundsDetailModel : JSONModel

@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) DetailResult *result;

@end
