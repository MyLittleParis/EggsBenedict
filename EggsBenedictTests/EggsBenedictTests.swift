//
//  EggsBenedictTests.swift
//  EggsBenedictTests
//
//  Created by JPMartha on 2015/12/28.
//  Copyright © 2015 JPMartha. All rights reserved.
//

import XCTest
@testable import EggsBenedict

class EggsBenedictTests: XCTestCase {
    
    func testInitSharingFlowIGPhoto() {
        let sharingFlow = SharingFlow(type: .igPhoto)
        XCTAssertEqual(sharingFlow.filenameExtension, ".ig")
        XCTAssertEqual(sharingFlow.UTI,"com.instagram.photo")
        let temporaryDirectory = NSTemporaryDirectory() as NSString
        XCTAssertEqual(sharingFlow.imagePath, temporaryDirectory.appendingPathComponent("jpmarthaeggsbenedict.ig"))
    }
    
    func testInitSharingFlowIGOExclusivegram() {
        let sharingFlow = SharingFlow(type: .igoExclusivegram)
        XCTAssertEqual(sharingFlow.filenameExtension,".igo")
        XCTAssertEqual(sharingFlow.UTI, "com.instagram.exclusivegram")
        let temporaryDirectory = NSTemporaryDirectory() as NSString
        XCTAssertEqual(sharingFlow.imagePath, temporaryDirectory.appendingPathComponent("jpmarthaeggsbenedict.igo"))
    }
    
    func testHasInstagramApp() {
        let result = UIApplication.shared.canOpenURL(URL(string: "instagram://")!)
        let sharingFlow = SharingFlow(type: .igoExclusivegram)
        XCTAssertEqual(sharingFlow.hasInstagramApp, result)
    }
    
    func testWriteTemporaryImageIGPhoto() {
        guard let image = UIImage(named: "EggsBenedict.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Image is nil.")
            return
        }
        
        let sharingFlow = SharingFlow(type: .igPhoto)
        do {
            try sharingFlow.writeTemporaryImage(image)
        } catch let error as NSError {
            XCTFail(error.debugDescription)
            return
        }
        let temporaryDirectory = NSTemporaryDirectory() as NSString
        let testImagePath = temporaryDirectory.appendingPathComponent("jpmarthaeggsbenedict.ig")
        XCTAssertTrue(FileManager.default.fileExists(atPath: testImagePath), testImagePath)
    }
    
    func testWriteTemporaryImageIGOExclusivegram() {
        guard let image = UIImage(named: "EggsBenedict.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Image is nil.")
            return
        }
        
        let sharingFlow = SharingFlow(type: .igoExclusivegram)
        do {
            try sharingFlow.writeTemporaryImage(image)
        } catch let error as NSError {
            XCTFail(error.debugDescription)
            return
        }
        let temporaryDirectory = NSTemporaryDirectory() as NSString
        let testImagePath = temporaryDirectory.appendingPathComponent("jpmarthaeggsbenedict.igo")
        XCTAssertTrue(FileManager.default.fileExists(atPath: testImagePath), testImagePath)
    }
    
    func testWriteTemporaryImageNil() {
        let sharingFlow = SharingFlow(type: .igoExclusivegram)
        do {
            try sharingFlow.writeTemporaryImage(UIImage())
        } catch let sharingFlowError as SharingFlowError {
            XCTAssertEqual(sharingFlowError, SharingFlowError.imageJPEGRepresentationFailed)
            return
        } catch let error as NSError {
            XCTFail(error.debugDescription)
            return
        }
        XCTFail("An unknown error occurred.")
    }
    
    func testPresentOpenInMenuWithImageInViewCompletion() {
        let sharingFlow = SharingFlow(type: .igoExclusivegram)
        sharingFlow.presentOpenInMenuWithImage(UIImage(), inView: UIView()) { (sharingFlowResult) -> Void in
            switch sharingFlowResult {
            case .success(_):
                XCTFail("An unknown error occurred.")
            case let .failure(_, sharingFlowError as SharingFlowError):
                XCTAssertEqual(sharingFlowError, SharingFlowError.notFoundInstagramApp)
            case let .failure(_, error as NSError):
                XCTFail(error.debugDescription)
            default:
                XCTFail("An unknown error occurred.")
            }
        }
    }
    
    func testPresentOpenInMenuWithImageInViewDocumentInteractionDelegateCompletion() {
        let sharingFlow = SharingFlow(type: .igoExclusivegram)
        sharingFlow.presentOpenInMenuWithImage(UIImage(), inView: UIView(), documentInteractionDelegate: nil) { (sharingFlowResult) -> Void in
            switch sharingFlowResult {
            case .success(_):
                XCTFail()
            case let .failure(_, sharingFlowError as SharingFlowError):
                XCTAssertEqual(sharingFlowError, SharingFlowError.notFoundInstagramApp)
            case let .failure(_, error as NSError):
                XCTFail(error.debugDescription)
            default:
                XCTFail("An unknown error occurred.")
            }
        }
    }
    
    func testRemoveTemporaryImageIG() {
        guard let image = UIImage(named: "EggsBenedict.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Image is nil.")
            return
        }
        
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            XCTFail(SharingFlowError.imageJPEGRepresentationFailed.debugDescription)
            return
        }
        
        let temporaryDirectory = NSTemporaryDirectory() as NSString
        let testImagePath = temporaryDirectory.appendingPathComponent("jpmarthaeggsbenedict.ig")
        guard (try? imageData.write(to: URL(fileURLWithPath: testImagePath), options: [.atomic])) != nil else {
            XCTFail(SharingFlowError.writeToFileFailed.debugDescription)
            return
        }
        
        let sharingFlow = SharingFlow.init(type: .igPhoto)
        sharingFlow.removeTemporaryImage { (sharingFlowResult) -> Void in
            XCTAssertFalse(FileManager.default.fileExists(atPath: testImagePath), testImagePath)
        }
    }
    
    func testRemoveTemporaryImageIGO() {
        guard let image = UIImage(named: "EggsBenedict.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Image is nil.")
            return
        }
        
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            XCTFail(SharingFlowError.imageJPEGRepresentationFailed.debugDescription)
            return
        }
        
        let temporaryDirectory = NSTemporaryDirectory() as NSString
        let testImagePath = temporaryDirectory.appendingPathComponent("jpmarthaeggsbenedict.igo")
        guard (try? imageData.write(to: URL(fileURLWithPath: testImagePath), options: [.atomic])) != nil else {
            XCTFail(SharingFlowError.writeToFileFailed.debugDescription)
            return
        }
        
        let sharingFlow = SharingFlow.init(type: .igoExclusivegram)
        sharingFlow.removeTemporaryImage { (sharingFlowResult) -> Void in
            XCTAssertFalse(FileManager.default.fileExists(atPath: testImagePath), testImagePath)
        }
    }
    
    func testSharingFlowErrorDebugDescriptionNotFoundInstagramApp() {
        XCTAssertEqual(SharingFlowError.notFoundInstagramApp.debugDescription,
            "Not found Instagram app.")
    }
    
    func testSharingFlowErrorDebugDescriptionUTIisEmpty() {
        XCTAssertEqual(SharingFlowError.utIisEmpty.debugDescription,
            "UTI is empty.")
    }
    
    func testSharingFlowErrorDebugDescriptionImageJPEGRepresentationFailed() {
        XCTAssertEqual(SharingFlowError.imageJPEGRepresentationFailed.debugDescription,
            "\"UIImageJPEGRepresentation::\" method failed.")
    }
    
    func testSharingFlowErrorDebugDescriptionWriteToFileFailed() {
        XCTAssertEqual(SharingFlowError.writeToFileFailed.debugDescription,
            "\"writeToFile:atomically:\" method failed.")
    }
    
    func testSharingFlowErrorDebugDescriptionImagePathIsEmpty() {
        XCTAssertEqual(SharingFlowError.imagePathIsEmpty.debugDescription,
            "ImagePath is empty.")
    }
}
