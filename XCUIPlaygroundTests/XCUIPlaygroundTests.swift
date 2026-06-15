import Testing
@testable import XCUIPlayground

struct XCUIPlaygroundTests {

    @Test func appModuleLoads() {
        // Smoke: @testable import compiles and module is accessible
        #expect(Bool(true))
    }

}
