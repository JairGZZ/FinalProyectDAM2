//
//  ViewController.swift
//  FinalProyectDAM2
//
//  Created by DAMII on 4/04/25.
//
import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        // Configuración adicional de UI
        passwordLbl.isSecureTextEntry = true
        signInBtn.layer.cornerRadius = 8
    }
    
    
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        guard let email = emailLbl.text, !email.isEmpty,
              let password = passwordLbl.text, !password.isEmpty else {
            showAlert(title: "Campos vacíos", message: "Por favor completa todos los campos")
            return
        }
        
        // Mostrar indicador de carga (opcional)
        showLoadingIndicator()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            // Ocultar indicador de carga
            self.hideLoadingIndicator()
            
            if let error = error {
                self.handleAuthError(error)
                return
            }
            
            // Navegar a la pantalla principal
            self.navigateToHomeScreen()
        }
    }
    private func handleAuthError(_ error: Error) {
        let errorMessage: String
        
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.wrongPassword.rawValue:
                errorMessage = "Contraseña incorrecta"
            case AuthErrorCode.userNotFound.rawValue:
                errorMessage = "Usuario no encontrado"
            case AuthErrorCode.invalidEmail.rawValue:
                errorMessage = "Correo electrónico inválido"
            default:
                errorMessage = "Error al iniciar sesión: \(error.localizedDescription)"
            }
        } else {
            errorMessage = "Error desconocido"
        }
        
        showAlert(title: "Error", message: errorMessage)
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
    
    private func showLoadingIndicator() {
        // Implementar lógica de indicador de carga
    }
    
    private func hideLoadingIndicator() {
        // Implementar lógica para ocultar indicador
    }
    
    private func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            print("Error: No se encontró el UITabBarController")
            return
        }
        
        // Selecciona el tab deseado (ej. índice 1)
        tabBarController.selectedIndex = 0
        
        // Animación de transición
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarController
            }, completion: nil)
        }

    
    }
}
