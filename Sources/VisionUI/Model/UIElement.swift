import OpenFoundationModels

@Generable
public struct UIElement: Sendable {
    @Guide(description: "Semantic name of the element")
    public var name: String

    @Guide(description: "Bounding box in normalized coordinates")
    public var frame: UIFrame

    @Guide(description: "Element type classification")
    public var elementType: UIElementType

    @Guide(description: "Visible text content")
    public var label: String?

    @Guide(description: "Name of the parent element for hierarchy, nil if root-level")
    public var parentName: String?

    public init(
        name: String,
        frame: UIFrame,
        elementType: UIElementType,
        label: String? = nil,
        parentName: String? = nil
    ) {
        self.name = name
        self.frame = frame
        self.elementType = elementType
        self.label = label
        self.parentName = parentName
    }
}
