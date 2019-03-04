# Animation

At a Grance
----
   ```
  leftButton.rx.tap.map{ Animation.left }
			.bind(to: boxView.rx.animation).disposed(by: disposeBag)
		rightButton.rx.tap.map{ Animation.right }
			.bind(to: boxView.rx.animation).disposed(by: disposeBag)
		upButton.rx.tap.map{ Animation.up }
			.bind(to: boxView.rx.animation).disposed(by: disposeBag)
		downButton.rx.tap.map{ Animation.down }
			.bind(to: boxView.rx.animation).disposed(by: disposeBag)
   ```

Getting Stated
----
* View의 Animation을 동작하는 코드

button의 tab 이벤트를 stream으로 연결하여 Animation이 동작하도록 bind(to:) 연결

* bind(to:)는 두 스트림을 연결시켜주는 역활

 예로 
 ```
 textField.rx.text.bind(to:label.rx.text)
 ```
 
 위 코드는 아래의 코드와 같은 역활을 한다.
 
 ```
 textField.rx.text.subscribe(.onNext {
     self.textLabel.text = $0
 })
 ```
 
 위 코드는 각 스트림이 비동기로 동작을 한다.
 
 그리고, textField의 값이 입력 될 때마다, label의 값은 변경된다.
 textField의 text가 stream으로 label의 text로 흘러가는(push) 것.
 
 기존의 pull 방식을 통한 값을 읽어 와서 대입하는 것과의 차이가 있다.
 기존 방식으로 처리 하려면 textField의 delegate 해당 textfield인지를 체크 하고,
 이후 textfield에서 입력값을 읽어 와서 label에 text를 표시.

Requiments
----
```
pod 'RxSwift'
pod 'RxCocoa'
```
