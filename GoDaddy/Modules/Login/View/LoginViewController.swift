import UIKit

class LoginViewController: UIViewController,
                           UITextFieldDelegate {
    var viewModel:LoginViewModel = LoginViewModel()

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.login(usernameTextField.text ?? "",
                        password: passwordTextField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
}

extension LoginViewController:LoginViewModelDelegate {
    //didMakeRequestSuccess
    func didMakeRequestSuccess() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showDomainSearch", sender: self)
        }
    }
    
    //didMakeRequestFailed
    func didMakeRequestFailed(_ errorMsg: String) {
        print(errorMsg)
    }
}
