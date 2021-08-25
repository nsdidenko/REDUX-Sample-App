import UIKit

public final class SplashViewController: UIViewController {
    var label: UILabel = {
        let label = UILabel()
        label.text = "Launch"
        label.font = UIFont.systemFont(ofSize: 45)
        return label
    }()

    var activity: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)

        view.addConstraints([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 64)
        ])
    }
}
