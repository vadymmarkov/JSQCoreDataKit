//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://www.jessesquires.com/JSQCoreDataKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQCoreDataKit
//
//
//  License
//  Copyright (c) 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest
import CoreData

import JSQCoreDataKit


class DeleteTests: TestCase {

    func test_ThatDelete_Succeeds_WithManyObjects() {

        // GIVEN: a stack and objects in core data
        let stack = CoreDataStack(model: inMemoryModel)

        let count = 10
        var objects = [MyModel]()
        for _ in 1...count {
            objects.append(MyModel(context: stack.context))
        }

        let request = FetchRequest<MyModel>(entity: entity(name: MyModelEntityName, context: stack.context))
        let results = try! fetch(request: request, inContext: stack.context)
        XCTAssertEqual(results.count, count)

        // WHEN: we delete the objects
        deleteObjects(objects, inContext: stack.context)

        // THEN: the objects are removed from the context
        let resultAfterDelete = try! fetch(request: request, inContext: stack.context)
        XCTAssertEqual(resultAfterDelete.count, 0, "Fetch should return 0 objects")

        saveContext(stack.context) { error in
            XCTAssertNil(error, "Save should not error")
        }
    }

    func test_ThatDelete_Succeeds_WithSpecificObject() {

        // GIVEN: a stack and objects in core data
        let stack = CoreDataStack(model: inMemoryModel)

        let count = 10
        var objects = [MyModel]()
        for _ in 1..<count {
            objects.append(MyModel(context: stack.context))
        }

        let myModel = MyModel(context: stack.context)

        let request = FetchRequest<MyModel>(entity: entity(name: MyModelEntityName, context: stack.context))
        let results = try! fetch(request: request, inContext: stack.context)
        XCTAssertEqual(results.count, count, "Fetch should return all \(count) objects")

        let requestForObject = FetchRequest<MyModel>(entity: entity(name: MyModelEntityName, context: stack.context))
        requestForObject.predicate = NSPredicate(format: "myString == %@", myModel.myString)

        let resultForObject = try! fetch(request: requestForObject, inContext: stack.context)
        XCTAssertEqual(resultForObject.count, 1, "Fetch should return specific object \(myModel.description)")
        XCTAssertEqual(resultForObject.first!, myModel, "Fetched object should equal expected model")

        // WHEN: we delete a specific object
        deleteObjects([myModel], inContext: stack.context)

        // THEN: the specific object is removed from the context
        let resultAfterDelete = try! fetch(request: request, inContext: stack.context)
        XCTAssertEqual(resultAfterDelete.count, count - 1, "Fetch should return remaining objects")

        let resultForObjectAfterDelete = try! fetch(request: requestForObject, inContext: stack.context)
        XCTAssertEqual(resultForObjectAfterDelete.count, 0, "Fetch for specific object should return no objects")

        saveContext(stack.context) { error in
            XCTAssertNil(error, "Save should not error")
        }
    }

    func test_ThatDelete_Succeeds_WithEmptyArray() {

        // GIVEN: a stack
        let stack = CoreDataStack(model: inMemoryModel)

        // WHEN: we delete an empty array of objects
        deleteObjects([], inContext: stack.context)

        // THEN: the operation is ignored
        saveContext(stack.context) { error in
            XCTAssertNil(error, "Save should not error")
        }
    }
    
}
