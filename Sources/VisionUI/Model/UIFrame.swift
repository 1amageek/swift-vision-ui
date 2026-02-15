import OpenFoundationModels

@Generable
public struct UIFrame: Sendable {
    @Guide(description: "Left edge x coordinate, normalized 0.0-1.0")
    public var x1: Double

    @Guide(description: "Top edge y coordinate, normalized 0.0-1.0")
    public var y1: Double

    @Guide(description: "Right edge x coordinate, normalized 0.0-1.0")
    public var x2: Double

    @Guide(description: "Bottom edge y coordinate, normalized 0.0-1.0")
    public var y2: Double

    public init(x1: Double, y1: Double, x2: Double, y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
}
