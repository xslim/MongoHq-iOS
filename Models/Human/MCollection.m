#import "MCollection.h"

@interface MCollection ()

// Private interface goes here.

@end


@implementation MCollection

// Custom logic goes here.
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.subtitleText];
}

- (NSString *)titleText {
    return self.name;
}

- (NSString *)subtitleText
{
    return [NSString stringWithFormat:@"count: %@, indexCount: %@, storageSize: %@",
            self.count, self.indexCount, self.storageSize];
}

- (NSString *)collectionID {
    return self.name;
}

- (void)setCollectionID:(NSString *)collectionID {
    self.name = collectionID;
}

@end
