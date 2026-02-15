import OpenFoundationModels

@Generable
public struct UIScreen: Sendable {
    @Guide(description: "All UI elements visible on screen")
    public var elements: [UIElement]

    public init(elements: [UIElement]) {
        self.elements = elements
    }
}
