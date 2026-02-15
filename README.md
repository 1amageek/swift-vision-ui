# swift-vision-ui

VLM (Vision Language Model) based UI analysis library for Swift. Defines structured output types using `@Generable` for extracting UI element hierarchies from screenshots.

## Types

### UIScreen

Top-level container representing a screen's UI hierarchy.

```swift
@Generable
public struct UIScreen: Sendable {
    public var elements: [UIElement]
}
```

### UIElement

A single UI element with bounding box, type classification, and optional hierarchy.

```swift
@Generable
public struct UIElement: Sendable {
    public var name: String
    public var frame: UIFrame
    public var elementType: UIElementType
    public var label: String?
    public var parentName: String?
}
```

### UIFrame

Normalized bounding box coordinates (0.0-1.0).

```swift
@Generable
public struct UIFrame: Sendable {
    public var x1: Double
    public var y1: Double
    public var x2: Double
    public var y2: Double
}
```

### UIElementType

```swift
@Generable
public enum UIElementType: Sendable {
    case screen, navigationBar, tabBar, header, content, section
    case list, listItem, grid, gridItem
    case button, label, image, icon, toggle, input, modal, toolbar
}
```

## JSON Schema

The `@Generable` macro generates the following JSON Schema, used to guide structured output from language models.

### UIScreen

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "elements": {
      "type": "array",
      "description": "All UI elements visible on screen",
      "items": {
        "type": "object",
        "properties": {
          "elementType": {
            "type": "string",
            "description": "Element type classification",
            "enum": [
              "button",
              "content",
              "grid",
              "gridItem",
              "header",
              "icon",
              "image",
              "input",
              "label",
              "list",
              "listItem",
              "modal",
              "navigationBar",
              "screen",
              "section",
              "tabBar",
              "toggle",
              "toolbar"
            ]
          },
          "frame": {
            "type": "object",
            "description": "Bounding box in normalized coordinates",
            "properties": {
              "x1": {
                "type": "number",
                "description": "Left edge x coordinate, normalized 0.0-1.0"
              },
              "x2": {
                "type": "number",
                "description": "Right edge x coordinate, normalized 0.0-1.0"
              },
              "y1": {
                "type": "number",
                "description": "Top edge y coordinate, normalized 0.0-1.0"
              },
              "y2": {
                "type": "number",
                "description": "Bottom edge y coordinate, normalized 0.0-1.0"
              }
            },
            "required": ["x1", "x2", "y1", "y2"]
          },
          "label": {
            "type": ["string", "null"],
            "description": "Visible text content"
          },
          "name": {
            "type": "string",
            "description": "Semantic name of the element"
          },
          "parentName": {
            "type": ["string", "null"],
            "description": "Name of the parent element for hierarchy, nil if root-level"
          }
        },
        "required": ["elementType", "frame", "name"]
      }
    }
  },
  "required": ["elements"]
}
```

## Usage

```swift
import VisionUI
import OpenFoundationModels

let session = LanguageModelSession(model: model) {
    "Analyze the UI elements in this screenshot."
}

let screen: UIScreen = try await session.respond(
    to: "Describe all visible UI elements.",
    attaching: screenshot
)

for element in screen.elements {
    print("\(element.name): \(element.elementType) at (\(element.frame.x1), \(element.frame.y1))")
}
```
