Guru Guru Labyrinth(가제: 데굴데굴 미로탈출)
======================================

Ball-rolling maze game based on Swift SceneKit
----------------------------------------------

### 선택과 집중!
> - Core motion 이용한 조작 기능은 제거, 차기작에 반영하도록 하자
> - 모든 조작은 버튼으로
> - 화면 내 요소들 레이아웃에 신경쓰기
> - 화면 방향 고정(가로)
> - 시점 변경 기능 역시 불필요한 기능으로 판단, 삭제


## 현재 진행상황

> ### - n by n 미로생성 알고리즘 구현 완료(Wilson's algorithm)
> ### - SceneKit 이용한 공, 바닥, 벽, 광원, 카메라 구현 완료
> ### - 카메라의 공 1인칭 시점 구현 완료
> ### - Core Motion 이용한 공 제어 구현 완료(가속도계 데이터 받아오기)
> ### - 제스쳐 이용한 공 시점 변경 구현 완료
>> #### - Swipe left/right : 45도씩 회전
>> #### - Swipe up : 점프
>> #### - tap twice : 180도 회전
>> #### - tap when game clear : 메인 뷰로 
> ### - 탈출구 도달 시 게임 종료 팝업(subView)
> ### - 타이머
> ### - 런치 스크린 및 애니메이션
> ### - 타이틀 뷰, 세그
> ### - 로딩 바(Notification center로 구현
> ### - SceneKit 위에 SpriteKit overlay, 시간 및 버튼 표시(SKAction으로 타이머 구현)
> ### - 레벨 선택 기능
> ### - 공, 바닥, 벽 텍스쳐 선택 기능

---
#### 게임 인트로 화면
![intro](https://user-images.githubusercontent.com/63936699/113152646-4c0fdd80-9271-11eb-9109-5b6072de043c.gif)
##### 런치스크린 뷰와 메인 스토리보드의 첫 뷰를 같게 만들고 메인 뷰에서 디졸브 애니메이션을 사용하여 게임 인트로가 이어지는 느낌으로 구현함
##### 메인 뷰의 "Press Anywhere to Start" 라벨에 애니메이션 적용
---
#### 맵 선택
![selectmap](https://user-images.githubusercontent.com/63936699/113152868-82e5f380-9271-11eb-81c6-884dd20894ff.gif)
##### UICollectionView와 Custom Cell 객체를 사용하여 맵 선택창 구현
---
#### 공 모양과 벽 모양 선택
![selectball](https://user-images.githubusercontent.com/63936699/113152805-75c90480-9271-11eb-8089-b45d17682c64.gif)
##### UIPickerView와 SceneKit SCNView를 사용하여 공과 벽면 질감 선택창 구현
---
#### 게임 로딩 및 플레이
![loadandplay](https://user-images.githubusercontent.com/63936699/113152726-5d58ea00-9271-11eb-9178-366a8455065d.gif)
##### 게임 로딩 상황을 로딩 바로 보여주기 위해 UIProgressView 사용, 로딩 뷰와 게임 뷰 컨트롤러 간 Notification Center 적용하여 로딩 상황을 공유함.
##### 게임 조작 시 공의 속도는 기기의 가속도계 센서 값을 바탕으로 계산함
---
#### 플레이 중 일시정지 및 메인 메뉴로 복귀
![pauseandmenu](https://user-images.githubusercontent.com/63936699/113152757-6944ac00-9271-11eb-90ee-b1da168d7ae7.gif)
##### SceneKit SCNView 위에 SpriteKit View를 오버레이하여 일시정지 버튼과 팝업 창을 구현함
##### 메인 메뉴로 돌아갈 때 unwind segue 사용, 이 때 메모리 순환 참조가 발생하여 게임 뷰 컨트롤러가 메모리에 남아 있는 상황이 발생함(해결됨)
---
![swipetohead](https://user-images.githubusercontent.com/63936699/113152912-8d07f200-9271-11eb-8299-1c3341c21289.gif)
#### 좌우 스와이프 제스쳐 이용한 방향 조작
---
![swipetojump](https://user-images.githubusercontent.com/63936699/113152968-9c873b00-9271-11eb-9759-038a1cce4dd6.gif)
#### 위  스와이프 제스쳐 이용한 점프 조작
---

## 향후 구현해야 할 것들

> ### - 공 종류에 따른 physics 변경
> ### - 조작 방식 변경(버튼이나 탭 제스처)
> ### - 로딩 바 Delegation으로 구현해보기
> ### - 알고리즘 수정(m by n 역시 가능하도록)
> ### - 몬스터
> ### - 광고
> ### - 음악, 효과음

## 주의할 점

> ### - Memory Leak 
