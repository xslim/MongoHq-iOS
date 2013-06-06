// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MDatabase.m instead.

#import "_MDatabase.h"


const struct MDatabaseAttributes MDatabaseAttributes = {
    .hostname = @"hostname",
    .name     = @"name",
    .plan     = @"plan",
    .port     = @"port",
};



const struct MDatabaseRelationships MDatabaseRelationships = {
    .collections = @"collections",
};






@implementation MDatabaseID
@end

@implementation _MDatabase

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription insertNewObjectForEntityForName:@"Database" inManagedObjectContext:moc_];
}

+ (NSString *)entityName
{
    return @"Database";
}

+ (NSEntityDescription *)entityInManagedObjectContext:(NSManagedObjectContext *)moc_
{
    NSParameterAssert(moc_);
    return [NSEntityDescription entityForName:@"Database" inManagedObjectContext:moc_];
}

- (MDatabaseID *)objectID
{
    return (MDatabaseID *)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

    if ([key isEqualToString:@"portValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"port"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }

    return keyPaths;
}

@dynamic hostname;






@dynamic name;






@dynamic plan;






@dynamic port;



- (int16_t)portValue
{
    NSNumber *result = [self port];
    return [result shortValue];
}

- (void)setPortValue:(int16_t)value_
{
    [self setPort:@(value_)];
}

- (int16_t)primitivePortValue
{
    NSNumber *result = [self primitivePort];
    return [result shortValue];
}

- (void)setPrimitivePortValue:(int16_t)value_
{
    [self setPrimitivePort:@(value_)];
}

@dynamic collections;


- (NSMutableSet *)collectionsSet
{
    [self willAccessValueForKey:@"collections"];

    NSMutableSet *result = (NSMutableSet *)[self mutableSetValueForKey:@"collections"];

    [self didAccessValueForKey:@"collections"];
    return result;
}

@end
