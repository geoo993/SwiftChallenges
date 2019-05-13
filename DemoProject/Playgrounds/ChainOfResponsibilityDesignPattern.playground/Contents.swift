/*
 
 The Chain of responsibility design pattern is used to process varied requests, each of which may be dealt with by a different handler. Basically meaning that it let us pass the requests among a chain of handlers where each handler decides either to process the request or to pass it along the chain.
 Think of this pattern as the actual chain of objects (technically it’s a linked list) where every object knows about its successor (but not predecessor). So every object has a link to the next object in the chain. When a sender creates a request the first object in the chain is called and it has the opportunity to process the request. If the first object in the chain can’t process the request it will pass on the request to the next object. And so on until the request reaches the end of the chain.

 */
class Salary {
    private var _amount = Int()
    var amount : Int{
        get{
            return _amount
        }
        
        set {
            _amount = newValue
        }
    }
    
    init(amount : Int) {
        self.amount = amount
    }
}

enum EmploymentLevel: Int {
    case ceo                = 250000
    case cto                = 180000
    case manager            = 130000
    case supervisor         = 90000
    case seniorengineer     = 78000
    case engineer           = 50000
    case staff              = 25000
}

protocol Chain {
    var nextManagementLevel : Chain { get set }
    func requestedSalary(salary : Salary)
}

class CEO : Chain {
    
    private var _nextManagementLevel : Chain?
    var nextManagementLevel : Chain{
        set{
            _nextManagementLevel = newValue
        }
        get{
            return _nextManagementLevel!
        }
    }
    
    func requestedSalary(salary : Salary) {
        if salary.amount > 200001 && salary.amount <= 300000 {
            print("The CEO can approve this expenditure")
        } else {
            print("This expenditure is too large and won't get approved")
        }
    }
}

class CTO : Chain {
    private var _nextManagementLevel : Chain?
    var nextManagementLevel : Chain{
        set{
            _nextManagementLevel = newValue
        }
        get{
            return _nextManagementLevel!
        }
    }
    
    func requestedSalary(salary : Salary) {
        if salary.amount > 150000 && salary.amount <= 200000 {
            print("Your CEO can approve this expenditure")
        } else {
            if _nextManagementLevel == nil {
                print("Passing \(salary.amount) salary request to CEO")
                nextManagementLevel = CEO()
            }
            nextManagementLevel.requestedSalary(salary: salary)
        }
    }
}

class Manager : Chain {
    private var _nextManagementLevel : Chain?
    var nextManagementLevel : Chain{
        set{
            _nextManagementLevel = newValue
        }
        get{
            return _nextManagementLevel!
        }
    }
    
    func requestedSalary(salary : Salary) {
        if salary.amount > 100000 && salary.amount <= 150000 {
            print("Your CTO can approve this expenditure")
        } else {
            if _nextManagementLevel == nil {
                print("Passing \(salary.amount) salary request to CTO")
                nextManagementLevel = CTO()
            }
            nextManagementLevel.requestedSalary(salary: salary)
        }
    }
}

class Supervisor : Chain {
    
    private var _nextManagementLevel : Chain?
    var nextManagementLevel : Chain{
        set{
            _nextManagementLevel = newValue
        }
        get{
            return _nextManagementLevel!
        }
    }
    
    func requestedSalary(salary : Salary) {
        if salary.amount > 80000 && salary.amount <= 100000 {
            print("Your Manager can approve this expenditure")
        } else {
            if _nextManagementLevel == nil {
                print("Passing \(salary.amount) salary request to Manager")
                nextManagementLevel = Manager()
            }
            nextManagementLevel.requestedSalary(salary: salary)
        }
    }
}
class SeniorEngineer : Chain {
    
    private var _nextManagementLevel : Chain?
    var nextManagementLevel : Chain{
        set{
            _nextManagementLevel = newValue
        }
        get{
            return _nextManagementLevel!
        }
    }
    
    func requestedSalary(salary : Salary) {
        if salary.amount > 60000 && salary.amount <= 80000 {
            print("Your Supervisor  can approve this expenditure")
        } else {
            if _nextManagementLevel == nil {
                print("Passing \(salary.amount) salary request to Supervisor")
                nextManagementLevel = Supervisor()
            }
            nextManagementLevel.requestedSalary(salary: salary)
        }
    }
}
class Engineer : Chain {
    
    private var _nextManagementLevel : Chain?
    var nextManagementLevel : Chain{
        set{
            _nextManagementLevel = newValue
        }
        get{
            return _nextManagementLevel!
        }
    }
    
    func requestedSalary(salary : Salary) {
        if salary.amount > 40000 && salary.amount <= 60000 {
            print("Your Senior Engineer can approve this expenditure")
        } else {
            if _nextManagementLevel != nil{
                print("Passing \(salary.amount) salary request to SeniorEngineer")
                nextManagementLevel = SeniorEngineer()
            }
            nextManagementLevel.requestedSalary(salary: salary)
        }
    }
}
class Staff : Chain {
    
    private var _nextManagementLevel : Chain?
    var nextManagementLevel : Chain{
        set{
            _nextManagementLevel = newValue
        }
        get{
            return _nextManagementLevel!
        }
    }
    
    func requestedSalary(salary : Salary) {
        if salary.amount > 0 && salary.amount <= 40000 {
            print("Your Engineer can approve this expenditure")
        } else {
            if _nextManagementLevel != nil {
                print("Passing \(salary.amount) salary request to Engineer")
                nextManagementLevel = Engineer()
            }
            nextManagementLevel.requestedSalary(salary: salary)
        }
    }
}

let ceo = CEO()
let senior = SeniorEngineer()
let staff = Staff()

//employee.nextManagementLevel = boss
//senior.nextManagementLevel = ceo

senior.requestedSalary(salary: Salary(amount: 100000))
