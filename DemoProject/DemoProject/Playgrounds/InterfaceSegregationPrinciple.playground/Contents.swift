// the idea of the interface segragation principle is to get you to not create interfaces that are too large, which requires the implemneted to implement too much


struct Document {
    
}

// if you make a mahcine that can print, scan and fax, there is absolutely no problem
protocol Machine {
    func print(document: Document)
    func scan(document: Document)
    func fax(document: Document)
}

// we can create a Multi Function Printer
struct MFP: Machine {
    func print(document: Document) {
        // ok
    }
    func scan(document: Document) {
        // ok
    }
    func fax(document: Document) {
        // ok
    }
}

// what happens if you just need to implement just a scanner from the machine
// as a result we voilate the ISP, as we are sending our client the wrong message that we can infact print and fax as well, so why give them the print and fax API
struct Scanner: Machine {
    func print(document: Document) {
        // not needed, what do I put inside print?
    }
    
    func scan(document: Document) {
        // ok
    }
    
    func fax(document: Document) {
        // not needed, what do I put inside fax?
    }
}

// we need to Segregate the interfaces to fix this ISP voilation
// so having the interfaces segregated, we can now implement them seperately for greater flexibility
protocol IPrinter {
    func print(document: Document)
}

protocol IScanner {
    func scan(document: Document)
}

protocol IFax {
    func fax(document: Document)
}

// this means we just have to implement the properties of IPrinter, and we do not have to implement any other extra functionality
struct Printer: IPrinter {
    func print(document: Document) {
        // ok
    }
}
struct Fax: IFax {
    func fax(document: Document) {
        // ok
    }
}

// even if you do want to implement a more complicated machine, you can still do that.
// This allow goes in line with the Decorator where you can cobine all your complex API into one object
struct ComplicatedMachine: IPrinter, IFax {
    let printer: Printer
    let fax: Fax
    func print(document: Document) {
        // ok
        printer.print(document: document)
    }
    func fax(document: Document) {
        // ok
        fax.fax(document: document)
    }
}

// the goel of ISP is to avoid stuffing too much into one interface and instead break that interface into seperate and smaller interfaces to make your object more flexible and not force client to implement unecessary fucntionality
