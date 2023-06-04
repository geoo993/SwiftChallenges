import PlaygroundSupport
import UIKit

// Model-View-ViewModel (MVVM) is a structural design pattern that separates objects into three distinct groups:

// 1- Models hold app data. They’re usually structs or simple classes.
// 2- Views display visual elements and controls on the screen. They’re typically subclasses of UIView.
// 3- View models transform model information into values that can be displayed on a view. They’re usually classes, so they can be passed around as references.

// Does this pattern sound familiar? Yep, it’s very similar to Model-View-Controller (MVC). View controllers do exist in MVVM, but their role is minimized.

// MARK: - When should you use it?
// - Use this pattern when you need to transform models into another representation for a view. For example, you can use a view model to transform a Date into a date-formatted String, a Decimal into a currency-formatted String, or many other useful transformations.
//  - This pattern compliments MVC especially well. Without view models, you’d likely put model-to-view transformation code in your view controller. However, view controllers are already doing quite a bit: handling viewDidLoad and other view lifecycle events, handling view callbacks via IBActions and several other tasks as well.
// This leads to what developers jokingly refer to as “MVC: Massive View Controller”.
// How can you avoid overstuffing your view controllers? It’s easy — use other patterns besides MVC!
// MVVM is a great way to slim down massive view controllers that require several model-to-view transformations.

// MARK: - MVVM example
// Lets make a “Pet View” as part of an app that adopts pets.

// - Model
// Here, we define a model named Pet. Every pet has a name, birthday, rarity and image. we need to show these properties on a view, but birthday and rarity aren’t directly displayable. They’ll need to be transformed by a view model first.
struct Pet {
    enum Rarity {
        case common
        case uncommon
        case rare
        case veryRare
    }
    
    let name: String
    let birthday: Date
    let rarity: Rarity
    let image: UIImage
    
    init(
        name: String,
        birthday: Date,
        rarity: Rarity,
        image: UIImage
    ) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
}

// - ViewModel
final class PetViewModel {
    
    // 1 - First, we created two private properties called pet and calendar, setting both within init(pet:).
    private let pet: Pet
    private let calendar: Calendar
    
    init(pet: Pet) {
        self.pet = pet
        self.calendar = Calendar(identifier: .gregorian)
    }
    
    // 2 - Next, we declared two computed properties for name and image, where you return the pet’s name and image respectively. This is the simplest transformation you can perform: returning a value without modification. If you wanted to change the design to add a prefix to every pet’s name, you could easily do so by modifying name here.
    var name: String {
        return pet.name
    }
    
    var image: UIImage {
        return pet.image
    }
    
    // 3 - Next, we declared ageText as another computed property, where you used calendar to calculate the difference in years between the start of today and the pet’s birthday and return this as a String followed by "years old". we will be able to display this value directly on a view without having to perform any other string formatting.
    var ageText: String {
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents(
            [.year],
            from: birthday,
            to: today
        )
        guard let age = components.year else { return "" }
        return "\(age) years old"
    }
    
    // 4 - Finally, we created adoptionFeeText as a final computed property, where you determine the pet’s adoption cost based on its rarity. Again, we return this as a String so you can display it directly.
    var adoptionFeeText: String {
        switch pet.rarity {
        case .common:
            return "$50.00"
        case .uncommon:
            return "$75.00"
        case .rare:
            return "$150.00"
        case .veryRare:
            return "$500.00"
        }
    }
}

// Now we need a UIView to display the pet’s information. Add the following code to the end of the playground:

//  - View
// Here, we create a PetView with four subviews: an imageView to display the pet’s image and three other labels to display the pet’s name, age and adoption fee.
class PetView: UIView {
    let imageView: UIImageView
    let nameLabel: UILabel
    let ageLabel: UILabel
    let adoptionFeeLabel: UILabel
    
    // We create and position each view within init(frame:).
    override init(frame: CGRect) {
        var childFrame = CGRect(
            x: 0,
            y: 16,
            width: frame.width,
            height: frame.height / 2
        )
        imageView = UIImageView(frame: childFrame)
        imageView.contentMode = .scaleAspectFit
        
        childFrame.origin.y += childFrame.height + 16
        childFrame.size.height = 30
        nameLabel = UILabel(frame: childFrame)
        nameLabel.textAlignment = .center
        
        childFrame.origin.y += childFrame.height
        ageLabel = UILabel(frame: childFrame)
        ageLabel.textAlignment = .center
        
        childFrame.origin.y += childFrame.height
        adoptionFeeLabel = UILabel(frame: childFrame)
        adoptionFeeLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(adoptionFeeLabel)
    }
    
    // Lastly, you throw a fatalError within init?(coder:) to indicate it’s not supported.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}

// There’s one final improvement you can make to this example.
// We will use this method to configure the view using the view model instead of doing this inline.
extension PetViewModel {
    
    // This is a neat way to put all of the view configuration logic into the view model.
    // You may or may not want to do this in practice. If you’re only using the view model with one view, then it can be useful to put the configure method into the view model. However, if you’re using the view model with more than one view, then you might find that putting all that logic in the view model clutters it. Having the configure code separately for each view may be simpler in that case.
    func configure(_ view: PetView) {
        view.nameLabel.text = name
        view.imageView.image = image
        view.ageLabel.text = ageText
        view.adoptionFeeLabel.text = adoptionFeeText
    }
}

// 1 - First, we create a new Pet named stuart.
let birthday = Date(timeIntervalSinceNow: (-2 * 86400 * 366))
let image = UIImage(named: "stuart")!
let stuart = Pet(
    name: "Stuart",
    birthday: birthday,
    rarity: .veryRare,
    image: image
)

// 2 - Next, we create a viewModel using stuart.
let viewModel = PetViewModel(pet: stuart)

// 3 - Next, we create a view by passing a common frame size on iOS.
let frame = CGRect(x: 0, y: 0, width: 300, height: 420)
let view = PetView(frame: frame)

// 4 - Next, we configure the subviews of view using viewModel.
viewModel.configure(view)

// 5 - Finally, qw set view to the PlaygroundPage.current.liveView, which tells the playground to render it within the standard Assistant editor.
PlaygroundPage.current.liveView = view

// What type of pet is Stuart exactly? He’s a cookie monster, of course! They’re very rare.

// MARK: - What should you be careful about?
// - MVVM works well if your app requires many model-to-view transformations. However, not every object will neatly fit into the categories of model, view or view model. Instead, you should use MVVM in combination with other design patterns.
// - Furthermore, MVVM may not be very useful when you first create your application. MVC may be a better starting point. As your app’s requirements change, you’ll likely need to choose different design patterns based on your changing requirements. It’s okay to introduce MVVM later in an app’s lifetime when you really need it.
// - Don’t be afraid of change — instead, plan ahead for it.


// MARK: - Here are its key points:
// - MVVM helps slim down view controllers, making them easier to work with. Thus combatting the “Massive View Controller” problem.
// - View models are classes that take objects and transform them into different objects, which can be passed into the view controller and displayed on the view. They’re especially useful for converting computed properties such as Date or Decimal into a String or something else that actually can be shown in a UILabel or UIView.
// - If you’re only using the view model with one view, it can be good to put all the configurations into the view model. However, if you’re using more than one view, you might find that putting all the logic in the view model clutters it. Having the configure code separated into each view may be simpler.
// - MVC may be a better starting point if your app is small. As your app’s requirements change, you’ll likely need to choose different design patterns based on your changing requirements.
