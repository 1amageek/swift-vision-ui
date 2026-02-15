import OpenFoundationModels

@Generable(description: "Type of UI element")
public enum UIElementType: Sendable {
    case screen
    case navigationBar
    case tabBar
    case header
    case content
    case section
    case list
    case listItem
    case grid
    case gridItem
    case button
    case label
    case image
    case icon
    case toggle
    case input
    case modal
    case toolbar
}
