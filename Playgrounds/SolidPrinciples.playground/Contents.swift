import Foundation

/*
- Single Responsibility
A class should have one, and only one, reason to change.

Each class or type you define should have only one job to do. That doesn’t mean you can only implement one method, but each class needs to have a focused, specialized role.
*/

/*
- Open-Closed
Software entities, including classes, modules and functions, should be open for extension but closed for modification.

This means you should be able to expand the capabilities of your types without having to alter them drastically to add what you need.
*/

/*
- Liskov Substitution
Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.

In other words, if you replace one object with another that’s a subclass and this replacement could break the affected part, then you’re not following this principle.
*/

/*
- Interface Segregation
Clients should not be forced to depend upon interfaces they do not use.

When designing a protocol you’ll use in different places in your code, it’s best to break that protocol into multiple smaller pieces where each piece has a specific role. That way, clients depend only on the part of the protocol they need.
*/

/*
- Dependency Inversion
Depend upon abstractions, not concretions.

Different parts of your code should not depend on concrete classes. They don’t need that knowledge. This encourages the use of protocols instead of using concrete classes to connect parts of your app.
*/
