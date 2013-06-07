#import "MDatabase.h"


@interface MDatabase ()

// Private interface goes here.

@end


@implementation MDatabase

// Custom logic goes here.
// This helps in debugging
//- (NSString *)description {
//    return [NSString stringWithFormat:@"%@ on %@ @ %@:%@",
//            self.name, self.plan, self.hostname, self.port];
//}

- (NSString *)titleText {
    return self.name;
}

- (NSString *)subtitleText {
    return self.plan;
}

- (NSString *)databaseID {
    return self.name;
}

- (void)setDatabaseID:(NSString *)databaseID {
    self.name = databaseID;
}

@end
