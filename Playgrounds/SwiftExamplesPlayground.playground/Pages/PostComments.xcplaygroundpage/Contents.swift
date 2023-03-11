import Foundation

/*:

## iOS Swift Exercise

A blogging platform stores the following information that is available through separate API endpoints:
+ user accounts
+ blog posts for each user
+ comments for each blog post

### Objective
The organization needs to identify the 3 most engaging bloggers on the platform. Using only Swift and the Foundation library, output the top 3 users with the highest average number of comments per post in the following format:

&nbsp;&nbsp;&nbsp; User: `[name]` - `[id]` - `[date joined (in dd/mm/yy format)]`, Score: `[average_comments_per_post]`

Instead of connecting to a remote API, we are providing this data in form of JSON files, which have been made accessible through a custom Resource enum with a `data` method that provides the contents of the file.

Note the internal style guide for Swift specifies property names must be camel case.

### What we're looking to evaluate
1. How you choose to model your data
2. How you transform the provided JSON data to your data model
3. How you use your models to calculate this average value
4. How you use this data point to sort the users

 ### Instructions
 1. Clone this repo
 2. Address each step of the problem above and commit as necessary
 3. Once you are finished, zip up the project and email it back to us.

 ### Duration
 Out of respect for your time, we ask that you limit the amount you spend on this assignment to just a few hours. However, out of respect for us, we also expect you to submit the completed exercise within a week of it being assigned to you. Thank you, and best of luck!

*/


/*:
1. First, start by modeling the data objects that will be used.
*/

/*:
2. Next, decode the JSON source using `Resource.users.data()`.
*/

let apiClient = APIClient()

func getComments(for postId: Int, with comments: [APIClient.Comment]) -> [Comment] {
    comments
        .filter { $0.postId == postId }
        .map(Comment.init)
}

func getPosts(
    for userId: Int,
    with posts: [APIClient.Post],
    and comments: [APIClient.Comment]
) -> [Post] {
    posts
        .filter{ $0.userId == userId }
        .map {
            Post(
                model: $0,
                comments: getComments(for: $0.id, with: comments)
            )
        }
}

func users() throws -> [User] {
    let comments = try apiClient.execute(request: FetchCommentsRequest())
    let posts = try apiClient.execute(request: FetchPostsRequest())
    let result = try apiClient.execute(request: FetchUsersRequest())
    return result.map {
        User(
            id: $0.id,
            name: $0.name,
            dateJoined: $0.dateJoined,
            posts: getPosts(for: $0.id, with: posts, and: comments)
        )
    }
}

func topMostEngagingBloggers(from bloggers: [Blogger]) -> [Blogger] {
    let results = bloggers
        .sorted { $0.averageNumberOfCommentsPerPost > $1.averageNumberOfCommentsPerPost }
        .prefix(3)
    return Array(results)
}

do {
    /*:
     3. Next, use your populated models to calculate the average number of comments per user.
     */
    print("ALL BLOGGERS SCORE")
    let users = try users()
    let bloggers = users.map(Blogger.init)
    
    // for each blogger -> per post get, the average number of comments
    bloggers.forEach {
        print(
            "[\($0.user.name)]",
            "- [\($0.user.id)]",
            "- [date joined \($0.user.dateJoinedFormatted)],",
            "- [total comments \($0.totalCommentsInPosts)]",
            "Score: [\($0.averageNumberOfCommentsPerPost)]"
        )
    }
    
    /*:
     4. Finally, use your calculated metric to find the 3 most engaging bloggers, sort order, and output the result.
     */
    print("\nTOP 3 MOST ENGAGING BLOGGERS")
    let topEngagedBloggers = topMostEngagingBloggers(from: bloggers)
    topEngagedBloggers.forEach {
        print(
            "[\($0.user.name)]",
            "- [\($0.user.id)]",
            "- [date joined \($0.user.dateJoinedFormatted)],",
            "- [total comments \($0.totalCommentsInPosts)]",
            "Score: [\($0.averageNumberOfCommentsPerPost)]"
        )
    }
} catch {
    print("Oops, the following error occured: \(error)")
}
