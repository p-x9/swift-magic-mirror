import Foundation

public struct MagicMirror {
    /// The static type of the subject being reflected.
    ///
    /// This type may differ from the subject's dynamic type when this mirror
    /// is the `superclassMirror` of another mirror.
    public let subjectType: Any.Type

    /// A collection of `Child` elements describing the structure of the
    /// reflected subject.
    public let children: Children

    /// A suggested display style for the reflected subject.
    public let displayStyle: DisplayStyle?

    /// A Mirror object with the same children
    public let mirror: Mirror

    internal let _makeSuperclassMirror: () -> MagicMirror?

    /// Creates a mirror that reflects on the given instance.
    ///
    /// If the dynamic type of `subject` has value semantics, subsequent
    /// mutations of `subject` will not observable in `Mirror`.  In general,
    /// though, the observability of mutations is unspecified.
    ///
    /// - Parameter subject: The instance for which to create a mirror.
    public init(reflecting subject: Any) {
        self = MagicMirror(internalReflecting: subject)
    }

    /// A mirror of the subject's superclass, if one exists.
    public var superclassMirror: MagicMirror? {
        return _makeSuperclassMirror()
    }
}

extension MagicMirror {
    /// An element of the reflected instance's structure.
    ///
    /// When the `label` component in not `nil`, it may represent the name of a
    /// stored property or an active `enum` case. If you pass strings to the
    /// `descendant(_:_:)` method, labels are used for lookup.
    public typealias Child = (label: String?, value: Any)

    /// The type used to represent substructure.
    ///
    /// When working with a mirror that reflects a bidirectional or random access
    /// collection, you may find it useful to "upgrade" instances of this type
    /// to `AnyBidirectionalCollection` or `AnyRandomAccessCollection`. For
    /// example, to display the last twenty children of a mirror if they can be
    /// accessed efficiently, you write the following code:
    ///
    ///     if let b = AnyBidirectionalCollection(someMirror.children) {
    ///         for element in b.suffix(20) {
    ///             print(element)
    ///         }
    ///     }
    public typealias Children = AnyCollection<Child>

    /// A suggestion of how a mirror's subject is to be interpreted.
    ///
    /// Playgrounds and the debugger will show a representation similar
    /// to the one used for instances of the kind indicated by the
    /// `DisplayStyle` case name when the mirror is used for display.
    public enum DisplayStyle: Sendable, Equatable {
        case `struct`, `class`, `enum`, tuple
    }
}

extension MagicMirror {
    init(internalReflecting subject: Any,
         subjectType: Any.Type? = nil) {
        let subjectType = subjectType ?? _getNormalizedType(subject, type: type(of: subject))

        let childCount = _getChildCount(subject, type: subjectType)
        let children = (0 ..< childCount).lazy.map({
            getChild(of: subject, type: subjectType, index: $0)
        })
        self.children = Children(children)

        let rawDisplayStyle = _getDisplayStyle(subject)
        switch UnicodeScalar(Int(rawDisplayStyle)) {
        case "c": self.displayStyle = .class
        case "e": self.displayStyle = .enum
        case "s": self.displayStyle = .struct
        case "t": self.displayStyle = .tuple
        case "\0": self.displayStyle = nil
        default: preconditionFailure("Unknown raw display style '\(rawDisplayStyle)'")
        }

        self._makeSuperclassMirror = {
            guard let subjectClass = subjectType as? AnyClass,
                  let superclass = class_getSuperclass(subjectClass) else {
                return nil
            }
            return MagicMirror(internalReflecting: subject,
                          subjectType: superclass)
        }

        self.subjectType = subjectType

        // Swift.Mirror
        self.mirror = .init(subject, children: children)
    }
}
