//
//  ViewController.swift
//  Starscream WebSocket
//
//  Created by Krishna Suravarapu on 03/02/22.
//

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    var socket: WebSocket!
    
    var isConnected = false
    
    let server = WebSocketServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ProcessInfo.processInfo.arguments)
        var request = URLRequest(url: URL(string: ProcessInfo.processInfo.arguments[1])!) //https://localhost:8080
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("connected")
            self.displayAlert(alertMessage: "Connected")
            isConnected = true
        case .disconnected(let reason, let code):
            print("disconnected")
            isConnected = false
        case .binary(_):
            break
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("cancelled")
            self.displayAlert(alertMessage: "Disconnected")
            isConnected = false
        case .error(_):
            print("error")
            isConnected = false
        case .text(let alertMessage):
            displayAlert(alertMessage: alertMessage ?? "Default Value")
            break
        }
    }

    @IBAction func sendMessage(_ sender: UIBarButtonItem) {
        socket.write(string: "hello there!")
    }
    
    func displayAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Response", message: alertMessage, preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func connectToggle(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
}

