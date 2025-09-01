//
//  ProtoUITestsLaunchTests.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import XCTest

final class ProtoUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert assertions here to verify that your app launches without crashing.
    }
}
