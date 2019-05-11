//
//  DemoProjectMoviesTests.swift
//  DemoProjectTests
//
//  Created by GEORGE QUENTIN on 07/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import Quick
import Nimble

@testable import DemoProject

class DemoProjectMoviesTests: QuickSpec {
 
    override func spec() {
        var subject: MovieDetailController!
        
        describe("MovieDetailController") {
            beforeEach {
                subject = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailController") as! MovieDetailController)
                
                _ = subject.view
            }
            
            context("when view is loaded") {
                it("should have Justice League loaded") {
                    expect(subject.movieNameLabel.text!).to(equal("Justice League"))
                }
                it("should show movie title and genre") {
                    expect(subject.movies[1].title).to(equal("The Emoji Movie"))
                    expect(subject.movies[1].genre).to(equal(Genre.Animation))
                }
            }
            
            
        }
    }
}
