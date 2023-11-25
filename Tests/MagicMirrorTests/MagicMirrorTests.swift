import XCTest
@testable import MagicMirror

final class MagicMirrorTests: XCTestCase {
    let shiba = ShibaInu(name: "mugi", age: 2, color: "red")
    let item = Item(title: "hello")

    func testClass() throws {
        let magicMirror = MagicMirror(reflecting: shiba)
        let children = Array(magicMirror.children)

        XCTAssertTrue(magicMirror.subjectType == ShibaInu.self)
        XCTAssertEqual(magicMirror.displayStyle, .class)

        XCTAssertEqual(children.count, 1)
        XCTAssertEqual(children[0].label, "color")
        XCTAssertEqual(children[0].value as? String, "red")

        let mirror = Mirror(reflecting: shiba)
        XCTAssertEqual(mirror.children.count, 0)
    }

    func testSuperClass() throws {
        guard let magicMirror = MagicMirror(reflecting: shiba).superclassMirror else {
            XCTFail("superclassMirror is nil")
            return
        }
        let children = Array(magicMirror.children)

        XCTAssertTrue(magicMirror.subjectType == Dog.self)
        XCTAssertEqual(magicMirror.displayStyle, .class)

        XCTAssertEqual(children.count, 1)
        XCTAssertEqual(children[0].label, "breed")
        XCTAssertEqual(children[0].value as? DogBreed, .shibaInu)
    }

    func testItem() throws {
        let magicMirror = MagicMirror(reflecting: item)
        let children = Array(magicMirror.children)

        XCTAssertTrue(magicMirror.subjectType == Item.self)
        XCTAssertEqual(magicMirror.displayStyle, .struct)

        XCTAssertEqual(children.count, 1)
        XCTAssertEqual(children[0].label, "title")
        XCTAssertEqual(children[0].value as? String, "hello")

        let mirror = Mirror(reflecting: item)
        XCTAssertEqual(mirror.children.count, 5)
    }

    func testEnum() throws {
        let magicMirror = MagicMirror(reflecting: shiba.breed)
        let children = Array(magicMirror.children)

        XCTAssertTrue(magicMirror.subjectType == DogBreed.self)
        XCTAssertEqual(magicMirror.displayStyle, .enum)

        XCTAssertEqual(children.count, 0)
    }

    func testTuple() throws {
        let tuple = (title: "hello", value: 8, "!@#$")
        let magicMirror = MagicMirror(reflecting: tuple)
        let children = Array(magicMirror.children)

        XCTAssertTrue(magicMirror.subjectType == (title: String, value: Int, String).self)
        XCTAssertEqual(magicMirror.displayStyle, .tuple)

        XCTAssertEqual(children.count, 3)
        XCTAssertEqual(children[0].label, "title")
        XCTAssertEqual(children[0].value as? String, "hello")
        XCTAssertEqual(children[1].label, "value")
        XCTAssertEqual(children[1].value as? Int, 8)
        XCTAssertEqual(children[2].label, ".2")
        XCTAssertEqual(children[2].value as? String, "!@#$")
    }
}

