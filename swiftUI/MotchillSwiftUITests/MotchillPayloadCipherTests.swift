import XCTest
@testable import MotchillSwiftUI

final class MotchillPayloadCipherTests: XCTestCase {
    func testDecryptsOpenSSLSaltedPayload() throws {
        let ciphertext = "U2FsdGVkX1/7NAIkqPsPOrC/sxteu9mz8hZBx2FaPzQSh6Q5dVB+Hfd0csC+mhn5"

        let plaintext = try MotchillPayloadCipher.decrypt(ciphertext)

        XCTAssertEqual(plaintext, #"{"hello":"world"}"#)
    }

    func testRejectsMissingSaltedHeader() {
        XCTAssertThrowsError(try MotchillPayloadCipher.decrypt("eyJoZWxsbyI6IndvcmxkIn0=")) { error in
            guard case MotchillPayloadCipherError.missingSaltedHeader = error else {
                return XCTFail("Expected missingSaltedHeader, got \(error)")
            }
        }
    }
}
