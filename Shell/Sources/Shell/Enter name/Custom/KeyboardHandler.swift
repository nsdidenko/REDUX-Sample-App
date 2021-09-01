import UIKit

final class KeyboardHandler {
    private var keyboardHeight: CGFloat?

    private let view: UIView
    private let constraint: NSLayoutConstraint

    init(in view: UIView, constraint: NSLayoutConstraint) {
        self.view = view
        self.constraint = constraint

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardSelector(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }

    @objc private func keyboardSelector(_ notification: Notification) {
        let userInfo = notification.userInfo!

        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        let extraSpaceAboveKeyboard: CGFloat = 8.0

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let bottomPadding = window?.safeAreaInsets.bottom {
            keyboardHeight = keyboardViewEndFrame.height - bottomPadding + extraSpaceAboveKeyboard
        }
        constraint.constant = keyboardHeight!
    }
}
