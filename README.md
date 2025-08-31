# 📱 Github User Search App

Github 사용자 검색 및 즐겨찾기 기능을 제공하는 iOS 앱입니다.

---

## 🏗 아키텍처 및 구조

본 프로젝트는 **MVVM + Clean Architecture + Coordinator Pattern** 기반으로 설계되었습니다.  
각 레이어의 역할은 다음과 같습니다.

### 1. Presentation Layer (MVVM)

#### ViewController
- UI 구성 및 사용자 이벤트 처리 담당  
- ViewModel과 Combine을 통한 데이터 바인딩  
- 화면 전환은 Coordinator에 위임  

#### ViewModel
- 화면 단위의 상태 관리  
- UseCase 호출을 통해 데이터 가져오기  
- Combine Publisher를 통해 ViewController에 데이터 전달  
- 로딩/에러 상태 관리
- VC에 보여지는 데이터 정렬  

---

### 2. Domain Layer (UseCase)
- 앱의 핵심 비즈니스 로직 담당  
- Repository와 통신하여 데이터 처리  
- **Pagination, 즐겨찾기 토글** 등 화면에 필요한 로직 수행    

---

### 3. Data Layer (Repository & DataFetcher)

#### Repository
- Domain Layer와 Data Layer 사이 인터페이스 역할  
- RemoteDataFetcher / LocalDataFetcher와 통신  
- 특정 화면들에서 공유되는 데이터(Favorite Users)는 Repository 내부 Publisher에서 관리  

#### RemoteDataFetcher / LocalDataFetcher
- 네트워크 요청 및 로컬 데이터 저장/조회 담당  
- Entity ↔ Response, Entity ↔ Object 모델 매핑 처리 

---

### 4. Coordinator Pattern
- ViewController 간 화면 전환 로직 중앙 관리  
- 화면 결합도 최소화 및 재사용성 확보  

---

## 🛠 기술 스택

- **UI Framework**: UIKit (SnapKit + Then 기반 코드 UI)  
- **아키텍처**: MVVM + Coordinator Pattern + Clean Architecture  
- **의존성 관리**: Swift Package Manager  
- **지원 버전**: iOS 15 이상  

---

## 📦 사용한 라이브러리

- **Swinject** → 의존성 주입(DI) 관리  
- **Moya** → 네트워크 레이어 추상화  
- **Realm** → 로컬 DB (즐겨찾기/오프라인 데이터 관리)  
- **Kingfisher** → 이미지 다운로드 및 캐싱 처리  
- **Combine** → 비동기 이벤트 스트림 및 상태 관리  

---

## 🚀 실행 방법

1. Xcode에서 프로젝트 열기  
2. Deployment Target이 iOS 15 이상인지 확인  
3. 빌드 후 시뮬레이터 또는 실제 기기에서 실행  

---

## 🔮 향후 개선 사항

- [ ] **테스트 강화**: Unit Test 및 UI Test 추가  
- [ ] **에러 처리 고도화**: 사용자 친화적인 에러 메시지 제공  
- [ ] **UX 개선**: 즐겨찾기 사용자 정렬/검색 기능 강화      

---
