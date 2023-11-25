//
//  Types.swift
//
//
//  Created by p-x9 on 2023/11/25.
//  
//

import Foundation

class Animal: CustomReflectable {
    var customMirror: Mirror {
        .init(self, children: [])
    }

    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Dog: Animal {
    var breed: DogBreed

    init(name: String, age: Int, breed: DogBreed) {
        self.breed = breed
        super.init(name: name, age: age)
    }
}

class Cat: Animal {
    var color: String

    init(name: String, age: Int, color: String) {
        self.color = color
        super.init(name: name, age: age)
    }
}

class ShibaInu: Dog {
    var color: String

    init(name: String, age: Int, color: String) {
        self.color = color
        super.init(name: name, age: age, breed: .shibaInu)
    }
}

enum DogBreed: CustomReflectable {
    case shibaInu
    case poodle
    case germanShepherd
    case goldenRetriever
    case bulldog
    case beagle
    case rottweiler
    case siberianHusky
    case dachshund
    case boxer
    case greatDane
    case chihuahua
    case labradorRetriever

    case other

    var customMirror: Mirror {
        .init(self, children: [])
    }
}

struct Item: CustomReflectable {
    let title: String
    
    var customMirror: Mirror {
        .init(reflecting: [1, 2, 3, 4, 5])
    }
}
