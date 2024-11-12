export default {
  "$schema": "vscode://schemas/color-theme",
  "name": "edark",
  "colors": {
    "activityBar.activeBackground": "#3f00ff",
    "activityBar.background": "#000000",
    "activityBar.border": "#3f00ff",
    "activityBar.foreground": "#ffffff",
    "activityBar.inactiveForeground": "#3f00ff",
    "activityBarBadge.background": "#00000000",
    "button.background": "#3f00ff",
    "button.hoverBackground": "#3f00ff",
    "dropdown.background": "#000000",
    "dropdown.border": "#3f00ff",
    "dropdown.listBackground": "#000000",
    "editor.background": "#000000",
    "editor.foreground": "#ffffff",
    "editor.hoverHighlightBackground": "#3f00ff3f",
    "editor.lineHighlightBackground": "#00000000",
    "editor.lineHighlightBorder": "#3f00ff7f",
    "editor.selectionBackground": "#3f00ff7f",
    "editor.selectionHighlightBorder": "#00000000",
    "editorBracketHighlight.foreground1": "#f80",
    "editorBracketHighlight.foreground2": "#0f9",
    "editorBracketHighlight.foreground3": "#03f",
    "editorGroupHeader.tabsBackground": "#000000",
    "editorGutter.background": "#000000",
    "editorIndentGuide.activeBackground1": "#3f00ffbf",
    "editorIndentGuide.background1": "#3f00ff7f",
    "editorInlayHint.background": "#00000000",
    "editorInlayHint.foreground": "#3f00ff7f",
    "editorLineNumber.activeForeground": "#ffffff",
    "editorWhitespace.foreground": "#3f00ff",
    "editorWidget.background": "#000000",
    "editorWidget.border": "#3f00ff",
    "focusBorder": "#3f00ff",
    "foreground": "#ffffff",
    "input.background": "#000000",
    "input.border": "#3f00ff",
    "inputOption.activeBorder": "#3f00ff",
    "list.activeSelectionBackground": "#3f00ffbf",
    "list.hoverBackground": "#00000000",
    "menu.background": "#000000",
    "menu.border": "#3f00ff",
    "minimap.selectionHighlight": "#3f00ff7f",
    "notificationCenter.border": "#3f00ff",
    "notificationCenterHeader.background": "#3f00ff",
    "notifications.background": "#000000",
    "notificationToast.border": "#3f00ff",
    "panelTitle.activeBorder": "#3f00ff",
    "quickInput.background": "#000000",
    "scrollbar.shadow": "#00000000",
    "scrollbarSlider.activeBackground": "#3f00ff7f",
    "scrollbarSlider.background": "#3f00ff3f",
    "scrollbarSlider.hoverBackground": "#3f00ffbf",
    "sideBar.background": "#000000",
    "sideBar.border": "#3f00ff",
    "sideBarSectionHeader.background": "#3f00ff",
    "sideBarTitle.foreground": "#ffffff",
    "statusBar.background": "#3f00ff",
    "statusBar.border": "#00000000",
    "tab.activeBackground": "#3f00ff",
    "tab.activeBorder": "#00000000",
    "tab.border": "#00000000",
    "tab.hoverBackground": "#00000000",
    "tab.inactiveBackground": "#000000",
    "titleBar.activeBackground": "#000000",
    "titleBar.inactiveBackground": "#000000",
    "window.activeBorder": "#3f00ff"
  },
  "tokenColors": [
    {
      "name": "Comment",
      "scope": ["comment", "string.comment"],
      "settings": {
        "foreground": "#ffffff",
        "fontStyle": "italic"
      }
    },
    {
      "name": "String",
      "scope": "string",
      "settings": {
        "foreground": "#b2bec3",
        "fontStyle": "italic"
      }
    },
    {
      "name": "js template-expression",
      "scope": "punctuation.definition.template-expression.begin.js,punctuation.definition.template-expression.end.js,punctuation.definition.template-expression.begin.ts,punctuation.definition.template-expression.end.ts",
      "settings": {
        "foreground": "#833471"
      }
    },
    {
      "name": "TemplateString",
      "scope": "string.template.js",
      "settings": {
        "foreground": "#C4E538"
      }
    },
    {
      "name": "TemplateString",
      "scope": "meta.template.expression.js",
      "settings": {
        "foreground": "#f8f8f0"
      }
    },
    {
      "name": "Number",
      "scope": "constant.numeric",
      "settings": {
        "foreground": "#EE5A24"
      }
    },
    {
      "name": "Embeded String Begin and End",
      "scope": ["string.embedded.begin", "string.embedded.end"],
      "settings": {
        "foreground": "#FFAB40"
      }
    },
    {
      "name": "Embeded String",
      "scope": "string.embedded",
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "Built-in constant",
      "scope": "constant.language",
      "settings": {
        "foreground": "#FFAB40"
      }
    },
    {
      "name": "User-defined constant",
      "scope": ["constant.character", "constant.other"],
      "settings": {
        "foreground": "#FFAB40"
      }
    },
    {
      "name": "Language Variable",
      "scope": "variable.language",
      "settings": {
        "foreground": "#FFAB40",
        "fontStyle": ""
      }
    },
    {
      "name": "Variable",
      "scope": ["variable.readwrite", "variable.readwrite.other.block"],
      "settings": {
        "foreground": "#6F1E51"
      }
    },
    {
      "name": "Variable and parameter name",
      "scope": [
        "variable",
        "meta.definition.variable.name",
        "support.variable",
        "entity.name.variable"
      ],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "Variables (local)",
      "scope": [
        "keyword.other.base",
        "keyword.other.this",
        "variable.other.object.property",
        "variable.language.base",
        "variable.language.this"
      ],
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "Variables (UnityEngine)",
      "scope": ["support.variable.UnityEngine"],
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "Variables (UnityEditor)",
      "scope": ["support.variable.UnityEditor"],
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "Keyword",
      "scope": [
        "keyword",
        "keyword.operator.logical",
        "keyword.operator.constructor"
      ],
      "settings": {
        "foreground": "#b90b93",
        "fontStyle": ""
      }
    },
    {
      "name": "Keyword Operator",
      "scope": "keyword.operator",
      "settings": {
        "foreground": "#f53b57",
        "fontStyle": ""
      }
    },
    {
      "name": "Storage",
      "scope": "storage",
      "settings": {
        "foreground": "#a06040",
        "fontStyle": "bold"
      }
    },
    {
      "name": "Storage type",
      "scope": "storage.type",
      "settings": {
        "foreground": "#a06040"
      }
    },
    {
      "name": "Class name",
      "scope": [
        "entity.name.class",
        "entity.name.module",
        "entity.name.type",
        "storage.identifier",
        "support.class"
      ],
      "settings": {
        "foreground": "#43c4e1",
        "fontStyle": "bold"
      }
    },
    {
      "name": "Other variable",
      "scope": ["variable.other.property", "variable.other.block"],
      "settings": {
        "foreground": "#1B9CFC"
      }
    },
    {
      "name": "Inherited class",
      "scope": "entity.other.inherited-class",
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "Function name",
      "scope": ["entity.name.function", "support.function"],
      "settings": {
        "foreground": "#7d5fff"
      }
    },
    {
      "name": "Function argument",
      "scope": "variable.parameter",
      "settings": {
        "fontStyle": "",
        "foreground": "#e0c040"
      }
    },
    {
      "name": "Function call",
      "scope": "entity.name.function-call",
      "settings": {
        "foreground": "#f8f8f0"
      }
    },
    {
      "name": "Builtin Functions",
      "scope": ["function.support.builtin", "function.support.core"],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "Tag name",
      "scope": [
        "entity.name.tag",
        "entity.name.tag.class.js",
        "entity.name.tag.class.jsx"
      ],
      "settings": {
        "foreground": "#e080c0",
        "fontStyle": "bold"
      }
    },
    {
      "name": "Tag Class and ID",
      "scope": ["entity.name.tag.class", "entity.name.tag.id"],
      "settings": {
        "foreground": "#1e35ff"
      }
    },
    {
      "name": "Tag attribute",
      "scope": "entity.other.attribute-name",
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "Library constant",
      "scope": "support.constant",
      "settings": {
        "foreground": "#e0e000"
      }
    },
    {
      "name": "Library class/type",
      "scope": ["support.type", "support.variable"],
      "settings": {
        "foreground": "#E040FB"
      }
    },
    {
      "name": "Json Property",
      "scope": "support.dictionary.json",
      "settings": {
        "foreground": "#a06040"
      }
    },
    {
      "name": "JSON Key - Punctuation",
      "scope": [
        "source.json meta.structure.dictionary.json string.quoted.double.json punctuation.definition.string"
      ],
      "settings": {
        "foreground": "#a06040"
      }
    },
    {
      "name": "JSON Key - String",
      "scope": "source.json string.quoted.double.json",
      "settings": {
        "foreground": "#ff55c8"
      }
    },
    {
      "name": "JSON Key - Level 0",
      "scope": [
        "source.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#a06040"
      }
    },
    {
      "name": "JSON Key - Level 1",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "JSON Key - Level 2",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "JSON Key - Level 3",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "JSON Key - Level 4",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#E040FB"
      }
    },
    {
      "name": "JSON Key - Level 5",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#FFAB40"
      }
    },
    {
      "name": "JSON Key - Level 6",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "JSON Key - Level 7",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "JSON Key - Level 8",
      "scope": [
        "source.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json meta.structure.dictionary.value.json meta.structure.dictionary.json support.type.property-name.json"
      ],
      "settings": {
        "foreground": "#E040FB"
      }
    },
    {
      "name": "StyleSheet Property name",
      "scope": [
        "support.type.property-name.css",
        "support.type.property-name.scss",
        "support.type.property-name.less",
        "support.type.property-name.sass"
      ],
      "settings": {
        "foreground": "#61caff"
      }
    },
    {
      "name": "StyleSheet Property value",
      "scope": [
        "support.constant.css",
        "support.constant.scss",
        "support.constant.less",
        "support.constant.sass"
      ],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "StyleSheet Variable",
      "scope": [
        "variable.css",
        "variable.scss",
        "variable.less",
        "variable.sass"
      ],
      "settings": {
        "foreground": "#E040FB"
      }
    },
    {
      "name": "StyleSheet Variable String",
      "scope": [
        "variable.css.string",
        "variable.scss.string",
        "variable.less.string",
        "variable.sass.string"
      ],
      "settings": {
        "foreground": "#FFFF00"
      }
    },
    {
      "name": "StyleSheet Unit",
      "scope": ["unit.css", "unit.scss", "unit.less", "unit.sass"],
      "settings": {
        "foreground": "#a06040"
      }
    },
    {
      "name": "StyleSheet Number",
      "scope": [
        "constant.numeric.css",
        "constant.numeric.scss",
        "constant.numeric.less",
        "constant.numeric.sass"
      ],
      "settings": {
        "foreground": "#ffa361"
      }
    },
    {
      "name": "StyleSheet Function",
      "scope": [
        "function.css",
        "function.scss",
        "function.less",
        "function.sass"
      ],
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "Library variable",
      "scope": "support.other.variable",
      "settings": {
        "fontStyle": "",
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "Invalid",
      "scope": "invalid",
      "settings": {
        "foreground": "#f8f8f0"
      }
    },
    {
      "name": "Invalid deprecated",
      "scope": "invalid.deprecated",
      "settings": {
        "foreground": "#f8f8f0"
      }
    },
    {
      "name": "Link",
      "scope": "string.detected-link",
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "diff.header",
      "scope": ["meta.diff", "meta.diff.header"],
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "diff.deleted",
      "scope": "markup.deleted",
      "settings": {
        "foreground": "#a06040"
      }
    },
    {
      "name": "diff.inserted",
      "scope": "markup.inserted",
      "settings": {
        "foreground": "#FFFF00"
      }
    },
    {
      "name": "diff.changed",
      "scope": "markup.changed",
      "settings": {
        "foreground": "#FFFF00"
      }
    },
    {
      "scope": "constant.numeric.line-number.find-in-files - match",
      "settings": {
        "foreground": "#40C4FFA0"
      }
    },
    {
      "scope": "entity.name.filename.find-in-files",
      "settings": {
        "foreground": "#FFFF00"
      }
    },
    {
      "name": "Markup: Emphasis",
      "scope": "markup.normal, markup.normal.markdown",
      "settings": {
        }
    },
    {
      "name": "Markup: Emphasis Punctuation",
      "scope": "punctuation.definition.normal.markdown",
      "settings": {
        "fontStyle": "",
        "foreground": "#696969"
      }
    },
    {
      "name": "Markdown: Link",
      "scope": "markup.underline.link.markdown",
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "Markdown: Bold",
      "scope": "markup.bold.markdown",
      "settings": {
        "fontStyle": "bold"
      }
    },
    {
      "name": "Markdown: Bold Punctuation",
      "scope": "punctuation.definition.bold.markdown",
      "settings": {
        "fontStyle": "",
        "foreground": "#7f8c8d"
      }
    },
    {
      "name": "Control flow keywords",
      "scope": "keyword.control",
      "settings": {
        "foreground": "#f368e0",
        "fontStyle": "bold"
      }
    },
    {
      "name": "Markdown: Heading",
      "scope": "markup.heading.markdown",
      "settings": {
        "fontStyle": "bold",
        "foreground": "#a06040"
      }
    },
    {
      "name": "Markdown: Heading",
      "scope": "punctuation.definition.heading.markdown",
      "settings": {
        "fontStyle": "",
        "foreground": "#7f8c8d"
      }
    },
    {
      "name": "Markdown: Quote",
      "scope": "markup.quote.markdown",
      "settings": {
        "foreground": "#00b894"
      }
    },
    {
      "name": "Markdown: Separator",
      "scope": "meta.separator.markdown",
      "settings": {
        "foreground": "#a06040",
        "fontStyle": "bold"
      }
    },
    {
      "name": "Markdown: Raw",
      "scope": "markup.raw.inline.markdown, markup.raw.block.markdown",
      "settings": {
        "foreground": "#40C4FF"
      }
    },
    {
      "name": "Markdown: List Punctuation",
      "scope": "punctuation.definition.list_item.markdown",
      "settings": {
        "fontStyle": "bold",
        "foreground": "#f8f8f0"
      }
    }
  ]
}
