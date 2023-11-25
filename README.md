# MagicMirror

Implementation of `Mirror` not affected by `CustomReflectable`.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/c)](https://github.com/p-x9/swift-magic-mirror/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/swift-magic-mirror)](https://github.com/p-x9/swift-magic-mirror/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/swift-magic-mirror)](https://github.com/p-x9/swift-magic-mirror/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/swift-magic-mirror)](https://github.com/p-x9/swift-magic-mirror/)

## About

Normal `Mirror` may not correctly yield property information if the object conforms to `CustomReflectable`.

For example, the following structure returns empty children.

```swift
struct Item: CustomReflectable {
    let title: String
    let value: Int

    var customMirror: Mirror {
        .init(self, children: [])
    }
}
```

I created `MagicMirror` so that information can be obtained correctly in such cases!

## Usage

Simply replace `MagicMirror` in place of regular `Mirror`.

## License

MagicMirror is released under the MIT License. See [LICENSE](./LICENSE)
