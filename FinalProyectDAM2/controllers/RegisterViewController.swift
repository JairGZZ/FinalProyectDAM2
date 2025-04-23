//
//  RegisterViewController.swift
//  FinalProyectDAM2
//
//  Created by DAMII on 15/04/25.
//
import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
        registerBtn.layer.cornerRadius = 8
    }
    
    @IBAction func register(_ sender: Any) {
        guard let email = emailTF.text?.trimmingCharacters(in: .whitespaces),
              let password = passwordTF.text,
              let confirmPassword = confirmPasswordTF.text,
              let name = nameTF.text?.trimmingCharacters(in: .whitespaces),
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty,
              !name.isEmpty else {
            showAlert(title: "Campos incompletos", message: "Por favor completa todos los campos")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "Contraseñas no coinciden", message: "Las contraseñas ingresadas deben ser iguales")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Email inválido", message: "Por favor ingresa un email válido")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Contraseña débil", message: "La contraseña debe tener al menos 6 caracteres")
            return
        }
        
        showLoading()
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            self.hideLoading()
            
            if let error = error {
                self.handleRegistrationError(error)
                return
            }
            
            // Actualizar nombre del usuario
            self.updateUserName(name: name)
            
            // Navegar a pantalla principal
            self.navigateToHomeScreen()
        }
    }
    
    private func updateUserName(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Error actualizando nombre: \(error.localizedDescription)")
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func handleRegistrationError(_ error: Error) {
        let errorMessage: String
        
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                errorMessage = "El email ya está registrado"
            case AuthErrorCode.weakPassword.rawValue:
                errorMessage = "La contraseña es demasiado débil"
            case AuthErrorCode.invalidEmail.rawValue:
                errorMessage = "Formato de email inválido"
            default:
                errorMessage = "Error al registrar: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "Error desconocido"
        }
        
        showAlert(title: "Error de registro", message: errorMessage)
    }
    
    private func showLoading() {
        // Implementar lógica de carga (ej: UIAlertController con actividad)
    }
    
    private func hideLoading() {
        // Ocultar indicador de carga
    }
    
    private func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            print("Error: No se encontró el UITabBarController")
            return
        }
        
        // Selecciona el tab deseado (ej. índice 1)
        tabBarController.selectedIndex = 1
        
        // Animación de transición
        if let window = UIApplication.shared.windows.first {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarController
            }, completion: nil)
        }
    
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
