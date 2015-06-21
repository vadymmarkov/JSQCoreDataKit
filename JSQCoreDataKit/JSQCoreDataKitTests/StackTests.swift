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


class StackTests: XCTestCase {
    
    override func setUp() {
        let model = CoreDataModel(name: modelName, bundle: modelBundle)

        do {
            try model.removeExistingModelStore()
        } catch { }

        super.setUp()
    }

    func test_ThatStack_InitializesSuccessfully() {
        // GIVEN: a SQLite model
        let model = CoreDataModel(name: modelName, bundle: modelBundle)

        // WHEN: we create a stack
        let stack = CoreDataStack(model: model)

        // THEN: it is setup as expected
        XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(model.storeURL!.path!), "Model store should exist on disk")
        XCTAssertEqual(stack.context.concurrencyType, .MainQueueConcurrencyType)
    }

    func test_ThatChildContext_IsCreatedSuccessfully() {
        // GIVEN: a model and stack
        let model = CoreDataModel(name: modelName, bundle: modelBundle)
        let stack = CoreDataStack(model: model)

        // WHEN: we create a child context
        let childContext = stack.childManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType, mergePolicyType: .ErrorMergePolicyType)

        // THEN: it is initialized as expected
        XCTAssertEqual(childContext.parentContext!, stack.context)
        XCTAssertEqual(childContext.concurrencyType, .PrivateQueueConcurrencyType)
        XCTAssertEqual(childContext.mergePolicy.mergeType, .ErrorMergePolicyType)
    }
    
    func test_ThatStack_HasDescription() {
        let model = CoreDataModel(name: modelName, bundle: modelBundle)
        let stack = CoreDataStack(model: model)
        XCTAssertNotNil(stack.description)
        print("Description = \(stack.description)")
    }

}
