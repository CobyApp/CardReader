//
//  CameraView.swift
//  CardReader
//
//  Created by Coby Kim on 6/10/24.
//

import SwiftUI
import AVFoundation
import Vision

struct CameraView: UIViewControllerRepresentable {
    @Binding var recognizedText: String
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            
            self.parent.detectCard(in: ciImage)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoDeviceInput) else { return viewController }
        
        session.addInput(videoDeviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(videoOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = viewController.view.bounds
        viewController.view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    
    func detectCard(in image: CIImage) {
        let request = VNDetectRectanglesRequest { (request, error) in
            guard let results = request.results as? [VNRectangleObservation] else { return }
            
            for result in results {
                let boundingBox = result.boundingBox
                // Predefined area check
                if self.isWithinPredefinedArea(boundingBox: boundingBox) {
                    // Create a cropped image based on the detected rectangle
                    let croppedImage = self.cropImage(image: image, boundingBox: boundingBox)
                    self.recognizeText(in: croppedImage)
                }
            }
        }
        
        request.minimumConfidence = 0.8
        request.minimumAspectRatio = 0.5
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        try? handler.perform([request])
    }
    
    func isWithinPredefinedArea(boundingBox: CGRect) -> Bool {
        // Define your predefined area in normalized coordinates (0 to 1)
        let predefinedArea = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
        return predefinedArea.contains(boundingBox)
    }
    
    func cropImage(image: CIImage, boundingBox: CGRect) -> CIImage {
        let scaleX = image.extent.width
        let scaleY = image.extent.height
        let rect = CGRect(
            x: boundingBox.origin.x * scaleX,
            y: (1 - boundingBox.origin.y - boundingBox.height) * scaleY,
            width: boundingBox.width * scaleX,
            height: boundingBox.height * scaleY
        )
        return image.cropped(to: rect)
    }
    
    func recognizeText(in image: CIImage) {
        let request = VNRecognizeTextRequest { (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            
            for result in results {
                guard let candidate = result.topCandidates(1).first else { continue }
                print("Recognized text: \(candidate.string)")
                // Update your SwiftUI view or state with the recognized text
            }
        }
        
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        try? handler.perform([request])
    }
}
