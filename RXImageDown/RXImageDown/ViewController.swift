//
//  ViewController.swift
//  RXImageDown
//
//  Created by CHOI MIN KYU on 04/03/2019.
//  Copyright © 2019 RX Samples. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class ViewController: UIViewController {
	@IBOutlet weak var urlTextField: UITextField!
	@IBOutlet weak var goButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		bind()
	}
}

extension ViewController {
	func bind() {
		goButton.rx.tap.withLatestFrom(self.urlTextField.rx.text.orEmpty)
			.map { text -> URL in
				return try text.asURL()
			}
			.filter { (url: URL) -> Bool in
				let imageExtension = ["jpg", "jpeg", "gif", "png"]
				return imageExtension.contains(url.pathExtension)
			}.flatMap { (url: URL) -> Observable<String> in
				return Observable<String>.create({ anyObserver -> Disposable in
					let destination: DownloadRequest.DownloadFileDestination = { _, _ in
						let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
						let file = directoryURL.appendingPathComponent(url.relativeString, isDirectory: false)
						return (file, [.createIntermediateDirectories, .removePreviousFile])
					}
					
					let download = Alamofire.download(url, to: destination)
						.response { (response: DefaultDownloadResponse) in
							if let data = response.destinationURL {
								anyObserver.onNext(data.path)
								anyObserver.onCompleted()
							} else {
								anyObserver.onError(RxError.unknown)
							} }
					return Disposables.create {
						download.cancel()
					}
				})
			}.map { (data: String) -> UIImage in
				guard let image = UIImage(contentsOfFile: data)
					else { throw RxError.noElements }
				return image
			}.bind(to: imageView.rx.image)
			.disposed(by: disposeBag)
	}
}

