import Foundation

func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// The factory pattern is a creational pattern that provides a way to make objects without exposing creation logic. It involves two types:
// - The factory creates objects.
// - The products are the objects that are created.

// Technically, there are multiple “flavors” of this pattern, including simple factory, abstract factory and others. However, each of these share a common goal: to isolate object creation logic within its own construct.

// MARK: - When should you use it?
// Use the factory pattern whenever you want to separate out product creation logic, instead of having consumers create products directly.
// A factory is very useful when you have a group of related products, such as polymorphic subclasses or several objects that implement the same protocol. For example, you can use a factory to inspect a network response and turn it into a concrete model subtype.
// A factory is also useful when you have a single product type, but it requires dependencies or information to be provided to create it. For example, you can use a factory to create a “job applicant response” email: The factory can generate email details depending on whether the candidate was accepted, rejected or needs to be interviewed.

// MARK: - Factory example
// lets create a factory to generate job applicant response emails

// Here, we define JobApplicant and Email models. An applicant has a name, email, and four types of status. The email’s subject and messageBody will be different depending on an applicant’s status.
struct JobApplicant {
    let name: String
    let email: String
    var status: Status
    
    enum Status {
        case new
        case interview
        case hired
        case rejected
    }
}

struct Email {
    let subject: String
    let messageBody: String
    let recipientEmail: String
    let senderEmail: String
}

// 1 - Create an EmailFactory struct.
struct EmailFactory {
    
    // 2 - Create a property for senderEmail. You set this property within the EmailFactory initializer.
    let senderEmail: String
    
    // 3 - Create a function named createEmail that takes a JobApplicant and returns an Email. Inside createEmail, you’ve added a switch case for the JobApplicant’s status to populate the subject and messageBody variables with appropriate data for the email.
    func createEmail(to recipient: JobApplicant) -> Email {
        let subject: String
        let messageBody: String
        
        switch recipient.status {
        case .new:
            subject = "We Received Your Application"
            messageBody =
            "Thanks for applying for a job here! " +
            "You should hear from us in 17-42 business days."
            
        case .interview:
            subject = "We Want to Interview You"
            messageBody =
            "Thanks for your resume, \(recipient.name)! " +
            "Can you come in for an interview in 30 minutes?"
            
        case .hired:
            subject = "We Want to Hire You"
            messageBody =
            "Congratulations, \(recipient.name)! " +
            "We liked your code, and you smelled nice. " +
            "We want to offer you a position! Cha-ching! $$$"
            
        case .rejected:
            subject = "Thanks for Your Application"
            messageBody =
            "Thank you for applying, \(recipient.name)! " +
            "We have decided to move forward " +
            "with other candidates. " +
            "Please remember to wear pants next time!"
        }
        
        return Email(
            subject: subject,
            messageBody: messageBody,
            recipientEmail: recipient.email,
            senderEmail: senderEmail
        )
    }
}

example(of: "Factory") {
    
    // Here, we are creating a new JobApplicant named “Jackson Smith”.
    // Next, you create a new EmailFactory instance, and finally, you use the instance to generate emails based on the JobApplicant object status property.
    var jackson = JobApplicant(
        name: "Jackson Smith",
        email: "jackson.smith@example.com",
        status: .new
    )
    
    let emailFactory = EmailFactory(senderEmail: "george@win.com")
    
    // New
    print(emailFactory.createEmail(to: jackson), "\n")
    
    // Interview
    jackson.status = .interview
    print(emailFactory.createEmail(to: jackson), "\n")
    
    // Hired
    jackson.status = .hired
    print(emailFactory.createEmail(to: jackson), "\n")
}

// MARK: - What should you be careful about?
// Not all polymorphic objects require a factory. If your objects are very simple, you can always put the creation logic directly in the consumer, such as a view controller itself.
// Alternatively, if your object requires a series of steps to build it, you may be better off using the builder pattern or another pattern instead.

// MARK: - Here are its key points:
// - A factory’s goal is to isolate object creation logic within its own construct.
// - A factory is most useful if you have a group of related products, or if you cannot create an object until more information is supplied (such as completing a network call, or waiting on user input).
// - The factory method adds a layer of abstraction to create objects, which reduces duplicate code.
