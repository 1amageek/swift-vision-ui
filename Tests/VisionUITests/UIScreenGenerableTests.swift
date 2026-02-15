import Testing
import OpenFoundationModels
@testable import VisionUI

@Suite("UIScreen Generable Tests")
struct UIScreenGenerableTests {

    @Test("UIFrame round-trip via GeneratedContent")
    func frameRoundTrip() throws {
        let frame = UIFrame(x1: 0.0, y1: 0.1, x2: 1.0, y2: 0.5)
        let content = frame.generatedContent
        let restored = try UIFrame(content)
        #expect(restored.x1 == 0.0)
        #expect(restored.y1 == 0.1)
        #expect(restored.x2 == 1.0)
        #expect(restored.y2 == 0.5)
    }

    @Test("UIElementType round-trip")
    func elementTypeRoundTrip() throws {
        let type = UIElementType.button
        let content = type.generatedContent
        let restored = try UIElementType(content)
        #expect(restored == .button)
    }
}
