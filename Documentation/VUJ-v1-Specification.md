# Visual UI JSON (VUJ) v1 Specification

## 0. Purpose / Scope

- スクリーンショットに**表示されているもの（viewport）だけ**をJSONで表現する
- platformフィールドは存在しない（プラットフォームは無関係）
- 非表示・画面外のコンテンツは含めない（レスポンシブバリアント、z-index、スクロール外コンテンツなど）
- すべてのNodeおよびLeafにバウンディングボックス（座標）が必須
- 構造はオブジェクトキー（`screen`/`header`/`content`/`list`/`grid`/`modal`など）で表現し、`type`や`children`は使用しない
- 予約キーワードは最小限に保つ：`ref`のみが特別扱い

## 1. Top-Level Object

JSONドキュメントは以下のキーを持つオブジェクトでなければならない（MUST）。

### Required

| Key | Type | Description |
|-----|------|-------------|
| `viewport` | `[width, height]` | 整数（ピクセル単位） |
| `screen` | `Node \| Ref` | 通常はNode。モジュール参照にする場合はRef |

### Optional

| Key | Type | Description |
|-----|------|-------------|
| `modules` | `{ ModuleId: Node, ... }` | サブUIをモジュールとして切り出す場合に使用。モーダル/ダイアログ/シートなどのオーバーレイが典型的な用途。ModuleIdは任意の文字列キー（推奨: `m:<name>.<variant>`） |

### Minimal Example

```json
{
  "viewport": [1170, 2532],
  "screen": [[0, 0, 1170, 2532], { ... }]
}
```

## 2. Core Types

### 2.1 Frame（必須）

```
Frame := [x1, y1, x2, y2]
```

- 整数、ピクセル単位
- 制約: `x2 > x1` かつ `y2 > y1`

### 2.2 Node（必須）

```
Node := [Frame, Body]
```

- 正確に2要素の配列
- 第1要素: Frame
- 第2要素: Body

### 2.3 Body

```
Body := ObjectBody | LeafArray
```

## 3. Body Variants

### 3.1 ObjectBody（構造的合成）

```
ObjectBody := { Key: Value, ... }
```

**Key**
- UI構成を表現する文字列（例: `header`, `toolbar`, `content`, `list`, `grid`, `table`, `modal`）
- `type`フィールドは使用しない。Key自体が構造の概念を担う

**Value** は以下のいずれか:

| Value Type | Description |
|------------|-------------|
| `Node` | 子ノード |
| `Ref` | モジュール参照 |
| `Array` | 行/タイル/セルなどの順序付きコレクション |
| Primitive | 表示リテラルとして明示的に使う場合のみ（LeafPropsでの表現を推奨） |

同一Keyの複数インスタンスが必要な場合は配列で表現する:

```json
"modal": [{ "ref": "m:modal.1" }, { "ref": "m:modal.2" }]
```

### 3.2 LeafArray（順序付きリーフプリミティブのリスト）

```
LeafArray := [Leaf, Leaf, ...]
```

- 順序に意味がある（JSONオブジェクトのキー順序に依存できない場合に有用）

## 4. Leaf Definition

### 4.1 Leaf Shape

```
Leaf := { LeafKind: [Frame, LeafProps] }
```

**LeafKind** は文字列。推奨最小セット:

| LeafKind | Description |
|----------|-------------|
| `text` | テキスト要素 |
| `icon` | アイコン要素 |
| `image` | 画像要素 |
| `shape` | 図形要素 |
| `button` | ボタン要素（視覚的にボタンである場合のみ） |

### 4.2 LeafProps（推奨フィールド）

| LeafKind | Props |
|----------|-------|
| `text` | `{ "value": "<visible text>" }` |
| `icon` | `{ "name": "<icon identifier>" }` （不明な場合は `"unknown"` または省略） |
| `image` | `{ "src": "<asset reference or hash>" }` （optional） |
| `shape` | `{ "role": "divider\|bg\|border\|field\|unknown" }` （optional） |
| `button` | `{ "text": "<label>" }` and/or `{ "icon": "<icon name>" }` |

### 4.3 Text Rule

- `text.value`にはviewport内で**視覚的に読み取れるもの**だけを含めなければならない（MUST）
- 省略記号（例: `…`）が表示されている場合はそのまま保持する

## 5. Reference（唯一の予約キーワード）

### 5.1 Ref Shape

```
Ref := { "ref": ModuleId }
```

- `ref`はVUJ v1における**唯一の予約キーワード**

### 5.2 ModuleId

- トップレベルの`modules`内のエントリを参照する文字列キー
- Refが出現する場合、トップレベルの`modules`は存在しなければならず（MUST）、参照されるModuleIdを含まなければならない

## 6. Visible-Only Rules（厳格な制約）

### Producer が含めてはならないもの（MUST NOT）

- viewport完全外の要素
- 現在表示されていない要素（折りたたまれたコンテンツ、画面外スクロールコンテンツ、閉じたメニュー）
- このスクリーンショットに存在しない仮定的/レスポンシブバリアント

### Producer が含めてよいもの（MAY）

- 部分的に表示されている要素（viewportでクリップされているもの）
  - Frameは表示されている部分のバウンディング矩形を表す

## 7. Ordering Without Reserved Keys

- レンダリング/読み取り順序にJSONオブジェクトのキー順序を依存してはならない
- 順序が重要な場合は兄弟要素を配列で表現する

推奨される順序付きコレクションキー:

| Key | Usage |
|-----|-------|
| `rows` | `[Node, Node, ...]` |
| `tiles` | `[Node, Node, ...]` |
| `cells` | `[Node, Node, ...]` |

コンテナ内の順序付きリーフ要素にはLeafArrayを使用する。

## 8. Recommended Structural Vocabulary（非予約）

これらは予約キーワードではなく、慣例的な構成キーである。

### Core

| Key | Usage |
|-----|-------|
| `screen` | 画面全体 |
| `header` | ヘッダー領域 |
| `navigation` | ナビゲーション領域 |
| `content` | メインコンテンツ領域 |
| `tabbar` | タブバー |
| `footer` | フッター領域 |

### Containers

| Key | Usage |
|-----|-------|
| `toolbar` | ツールバー |
| `list` | リスト |
| `grid` | グリッド |
| `table` | テーブル |
| `modal` | モーダル |
| `sheet` | シート |
| `dialog` | ダイアログ |

### Collections

| Key | Usage |
|-----|-------|
| `rows` | 行コレクション |
| `tiles` | タイルコレクション |
| `cells` | セルコレクション |

必要に応じて追加のキー（例: `sidebar`, `splitView`, `titlebar`）を導入可能。ただし表示されている構成を表現するものに限る。

## 9. Complete Example

モーダルをモジュールとして切り出した完全な例:

```json
{
  "viewport": [1170, 2532],

  "screen": [
    [0, 0, 1170, 2532],
    {
      "header": [
        [0, 0, 1170, 180],
        {
          "toolbar": [
            [0, 0, 1170, 180],
            [
              { "icon": [[16, 60, 80, 140], { "name": "chevron_left" }] },
              { "text": [[520, 70, 650, 130], { "value": "設定" }] }
            ]
          ]
        }
      ],

      "content": [
        [0, 180, 1170, 2532],
        {
          "list": [
            [0, 180, 1170, 2532],
            {
              "rows": [
                [
                  [0, 200, 1170, 320],
                  [
                    { "text": [[80, 235, 240, 285], { "value": "通知" }] },
                    { "icon": [[1080, 245, 1120, 285], { "name": "chevron_right" }] }
                  ]
                ]
              ]
            }
          ]
        }
      ],

      "modal": { "ref": "m:confirm.delete" }
    }
  ],

  "modules": {
    "m:confirm.delete": [
      [90, 760, 1080, 1320],
      {
        "dialog": [
          [90, 760, 1080, 1320],
          [
            { "text": [[140, 810, 1030, 870], { "value": "削除しますか？" }] },
            { "button": [[140, 1160, 560, 1280], { "text": "キャンセル" }] },
            { "button": [[610, 1160, 1030, 1280], { "text": "削除" }] }
          ]
        ]
      }
    ]
  }
}
```

## 10. Extension Rules（将来のバージョン向け）

- 予約キーワードは最小限に保つ。v1では`ref`のみが予約
- 新しい予約キーワードを導入するよりも、新しい構成キー（例: `popover`）や新しいLeafPropsフィールドの追加を優先する
- `Node = [Frame, Body]`の不変条件を変更しないことで後方互換性を維持する
