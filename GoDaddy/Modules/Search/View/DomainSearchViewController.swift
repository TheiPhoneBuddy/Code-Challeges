import Foundation
import UIKit

class DomainSearchViewController: UIViewController {
    var viewModel:DomainSearchViewModel = DomainSearchViewModel()

    @IBOutlet var searchTermsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartButton: UIButton!

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchTermsTextField.resignFirstResponder()
        let searchTerms:String? = searchTermsTextField.text
        viewModel.getData(searchTerms ?? "")
    }

    @IBAction func cartButtonTapped(_ sender: UIButton) {}
    private func configureCartButton() {
        cartButton.isEnabled = !ShoppingCart.shared.domains.isEmpty
        cartButton.backgroundColor = cartButton.isEnabled ? .black : .lightGray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureCartButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension DomainSearchViewController:DomainSearchViewModelDelegate {
    func didMakeRequestSuccess() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.tableView.reloadData()
        }
    }
    
    func didMakeRequestFailed(_ errorMsg: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "All done!", message:errorMsg, preferredStyle: .alert)

            let action = UIAlertAction(title: "Ok", style: .default) { _ in }

            controller.addAction(action)

            weak var weakSelf = self
            DispatchQueue.main.async {
                weakSelf?.present(controller, animated: true)
            }
        }
    }
}

extension DomainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        cell.textLabel!.text = viewModel.response.aryData[indexPath.row].name
        cell.detailTextLabel!.text = viewModel.response.aryData[indexPath.row].price

        let selected = ShoppingCart.shared.domains.contains(where: { $0.name == viewModel.response.aryData[indexPath.row].name })

        DispatchQueue.main.async {
            cell.setSelected(selected, animated: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.response.aryData.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension DomainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let domain = viewModel.response.aryData[indexPath.row]
        ShoppingCart.shared.domains.append(domain)

        configureCartButton()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let domain = viewModel.response.aryData[indexPath.row]
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != domain.name }

        configureCartButton()
    }
}
