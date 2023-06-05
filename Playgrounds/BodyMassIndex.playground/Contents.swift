import UIKit

/*
    The body mass index (BMI) is a measure used to quantify a person’s mass as well as interpret their body composition.
    It is defined as the mass (Kg) divided by height (m) squared.
    
    On Earth, a 1 kg object weighs 9.8 Newtons, so to find the weight of an object in N simply multiply the mass by 9.8 N. Or, to find the mass in kg, divide the weight by 9.8 N
 */

func bmiResult (_ bmi : Double) -> String {
    // we want to round of everything to two decimal places
    let shorternedBMI = String(format: "%.2f", bmi)
    let interpretation : String
    
    if bmi > 25.0 {
        interpretation = "you are overweight"
    }else if bmi < 25.0 && bmi > 18.5 {
        interpretation = "you have a normal weight"
    }else {
        interpretation = "you are underweight"
    }
    
    return "Your BMI is \(shorternedBMI) kg/m² and " + interpretation
}

// returns kilograms per meters squared (kg/m²)
func BMI(weight : Double, height : Double ) -> String {
    let mass : Double = weight /// 9.8
    let bmi = mass / pow(height, 2)
    
    return bmiResult(bmi)
}

func imperialUnitsBMI(weight : Double, heightInFeet : Double, inches : Double) -> String {
    let weightInKG = weight * 0.45359237
    let totalInches = heightInFeet * 12 + inches
    let heightInMeters = totalInches * 0.0254
    
    let mass : Double = weightInKG /// 9.8
    let bmi = mass / pow(heightInMeters, 2)
    return bmiResult(bmi)
}

let bmi = BMI(weight: 253, height: 2.3)
let imperialBmi = imperialUnitsBMI(weight: 230, heightInFeet: 5, inches: 10)
print(imperialBmi)
print()
