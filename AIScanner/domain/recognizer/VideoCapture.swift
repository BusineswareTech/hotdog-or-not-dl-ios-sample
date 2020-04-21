//
//  VideoCapture.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 09.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class VideoCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    private var videoDevice: AVCaptureDevice!
    private var deviceInput: AVCaptureDeviceInput!
    private var videoConnection: AVCaptureConnection!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var videoPrefs: VideoPrefs!
    private var startMeasuringTime: CFTimeInterval = CACurrentMediaTime()
    
    var imageCallback: ((_ buffer: CVPixelBuffer) -> Void)?
    
    init(videoPrefs: VideoPrefs, layer: CALayer) {
        super.init()
        
        self.videoPrefs = videoPrefs
        
        videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        
        guard videoDevice != nil else { return }
        
        videoDevice.set(frameRate: Double(videoPrefs.fps))
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        setupSession()
        setupPreviewLayer(layer: layer)
    }
    
    func startCapture() {
        print("\(self.classForCoder)/" + #function)
        if session.isRunning {
            print("already running")
            return
        }
        session.startRunning()
    }
    
    func stopCapture() {
        print("\(self.classForCoder)/" + #function)
        if !session.isRunning {
            print("already stopped")
            return
        }
        session.stopRunning()
    }
    
    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .hd1280x720 // Model image size is smaller.
        
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        
        session.addInput(deviceInput)
        
        let videoDataOutput = configureVideoOutput()
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        setupConnection(videoDataOutput)
        
        session.commitConfiguration()
    }
    
    private func configureVideoOutput() -> AVCaptureVideoDataOutput {
        let videoDataOutput = AVCaptureVideoDataOutput()
        let videoDataOutputQueue = DispatchQueue(label: "mlrecognizer")
        
        // Add a video data output
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        return videoDataOutput
    }
    
    private func setupConnection(_ videoDataOutput: AVCaptureVideoDataOutput) {
        
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
    }
    
    private func setupPreviewLayer(layer: CALayer) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        previewLayer.frame = layer.bounds
        layer.addSublayer(previewLayer)
    }
    
    func resizePreview() {
        if let previewLayer = previewLayer {
            guard let superlayer = previewLayer.superlayer else {return}
            
            previewLayer.frame = superlayer.bounds
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let delay = CACurrentMediaTime() - startMeasuringTime
        let frameInterval = 1.0 / Double(videoPrefs.fps)
        
        if frameInterval > delay {
            return
        }
        
        startMeasuringTime = CACurrentMediaTime()

        imageCallback?(pixelBuffer)
    }
}

extension AVCaptureDevice {
    func set(frameRate: Double) {
        guard let range = activeFormat.videoSupportedFrameRateRanges.first,
            range.minFrameRate...range.maxFrameRate ~= frameRate
            else {
                print("Requested FPS is not supported by the device's activeFormat !")
                return
        }
        
        do { try lockForConfiguration()
            activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
            activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
            unlockForConfiguration()
        } catch {
            print("LockForConfiguration failed with error: \(error.localizedDescription)")
        }
    }
}
