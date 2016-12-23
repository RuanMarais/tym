//
//  CameraCaptureViewController.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/23.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    //MARK: Properties - UI elements
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureButton: RoundButton!
    @IBOutlet weak var albumButton: RoundButton!
    @IBOutlet weak var cancelButton: RoundButton!
    
    //MARK: Properties - Image capture variables
    
    var captureSession: AVCaptureSession?
    var sessionOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var capturedImage: UIImage?
    
    // Set up preview of image capture
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetMedium
        let device = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (captureSession?.canAddInput(input))! {
                captureSession?.addInput(input)
                if (captureSession?.canAddOutput(sessionOutput))! {
                    captureSession?.addOutput(sessionOutput)
                    captureSession?.startRunning()
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewLayer?.position = CGPoint(x: cameraView.frame.width / 2.0, y: cameraView.frame.height / 2)
                    previewLayer?.bounds = cameraView.frame
                    
                    cameraView.layer.addSublayer(previewLayer!)
                }
            }
            
        } catch {
            print("error")
        }
    }
    
    //MARK: Delegate method - capture image
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil else {
            print("error")
            return
        }
        
        if let sampleBuffer = photoSampleBuffer {
            if let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil) {
                let dataProvider = CGDataProvider(data: imageData as CFData)
                let cgImage = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.absoluteColorimetric)
                let image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: UIImageOrientation.up)
                capturedImage = image
            }
        }
    }
    
    //MARK: Button methods
    
    @IBAction func capturePhotoAction(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
        self.sessionOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func openAlbumAction(_ sender: Any) {
    }
    
    @IBAction func cancelPhotoCaptureAction(_ sender: Any) {
    }
    
}
