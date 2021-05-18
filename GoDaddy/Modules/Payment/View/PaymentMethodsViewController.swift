import UIKit

protocol PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod()
}

class PaymentMethodsViewController: UIViewController {
    var viewModel:PaymentMethodsViewModel = PaymentMethodsViewModel()
    @IBOutlet var tableView: UITableView!

    var delegate: PaymentMethodsViewControllerDelegate?
    var paymentMethods: [PaymentMethod]?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getData()
    }
}

extension PaymentMethodsViewController:PaymentMethodsViewModelDelegate {
    func didMakeRequestSuccess() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.tableView.reloadData()
        }
    }
    
    func didMakeRequestFailed(_ errorMsg: String) {
        print(errorMsg)
    }
}

extension PaymentMethodsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.response.aryPaymentMethod.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        let method = viewModel.response.aryPaymentMethod[indexPath.row]
        cell.textLabel!.text = method.name

        if let lastFour = method.lastFour {
            cell.detailTextLabel!.text = "Ending in \(lastFour)"
        } else {
            cell.detailTextLabel!.text = method.displayFormattedEmail!
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let method = viewModel.response.aryPaymentMethod[indexPath.row]
        PaymentsManager.shared.selectedPaymentMethod = method
        dismiss(animated: true) {
            self.delegate?.didSelectPaymentMethod()
        }
    }
}
