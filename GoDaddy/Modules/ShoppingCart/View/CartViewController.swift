import UIKit

class CartViewController: UIViewController {
    var viewModel:CartViewModel = CartViewModel()

    @IBOutlet var payButton: UIButton!
    @IBOutlet var tableView: UITableView!

    @IBAction func payButtonTapped(_ sender: UIButton) {
        if PaymentsManager.shared.selectedPaymentMethod == nil {
            self.performSegue(withIdentifier: "showPaymentMethods", sender: self)
        } else {
            performPayment()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self

        tableView.register(UINib(nibName: "CartItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartItemCell")
        updatePayButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func updatePayButton() {
        payButton.setTitle(viewModel.getPayButtonText(), for: .normal)
    }

    func performPayment() {
        payButton.isEnabled = false
        
        let auth:String = AuthManager.shared.token ?? ""
        let token:String = PaymentsManager.shared.selectedPaymentMethod?.token ?? ""
        viewModel.shoppingCart(auth, token: token)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentMethodsViewController
        vc.delegate = self
    }
}

extension CartViewController:CartViewModelDelegate {
    func didMakeRequestSuccess() {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "All done!", message: "Your purchase is complete!", preferredStyle: .alert)

            let action = UIAlertAction(title: "Ok", style: .default) { _ in }

            controller.addAction(action)

            weak var weakSelf = self
            DispatchQueue.main.async {
                weakSelf?.present(controller, animated: true)
            }
        }
    }
    
    func didMakeRequestFailed(_ errorMsg: String) {
        let controller = UIAlertController(title: "Oops!", message: errorMsg, preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.payButton.isEnabled = true
        }

        controller.addAction(action)

        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.present(controller, animated: true)
        }
    }
}

extension CartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingCart.shared.domains.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell

        cell.delegate = self

        cell.nameLabel.text = ShoppingCart.shared.domains[indexPath.row].name
        cell.priceLabel.text = ShoppingCart.shared.domains[indexPath.row].price

        return cell
    }
}

extension CartViewController: CartItemTableViewCellDelegate {
    func didRemoveFromCart() {
        updatePayButton()
        tableView.reloadData()
    }
}

extension CartViewController: PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod() {
        updatePayButton()
    }
}
