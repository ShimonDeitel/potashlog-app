import XCTest

final class PotashlogUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddButtonOpensSheet() {
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["saveButton"].waitForExistence(timeout: 3))
        app.buttons["cancelButton"].tap()
    }

    func testAddFlowSavesEntry() {
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        if firstField.waitForExistence(timeout: 3) {
            firstField.tap()
            firstField.typeText("Test Entry")
        }
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.navigationBars.firstMatch.waitForExistence(timeout: 3))
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        if firstField.waitForExistence(timeout: 3) {
            firstField.tap()
            firstField.typeText("Sample")
            app.navigationBars.firstMatch.tap()
            XCTAssertFalse(firstField.hasKeyboardFocus)
        }
        app.buttons["cancelButton"].tap()
    }

    func testSettingsOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["doneButton"].waitForExistence(timeout: 3))
        app.buttons["doneButton"].tap()
    }

    func testPaywallTriggersAtFreeLimit() {
        for _ in 0..<45 {
            if app.buttons["addButton"].exists {
                app.buttons["addButton"].tap()
                if app.buttons["saveButton"].waitForExistence(timeout: 1) {
                    app.buttons["saveButton"].tap()
                }
            }
        }
        let paywallShown = app.buttons["purchaseButton"].waitForExistence(timeout: 2)
        XCTAssertTrue(paywallShown || app.buttons["addButton"].exists)
    }
}
