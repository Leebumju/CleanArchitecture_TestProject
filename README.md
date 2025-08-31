# 프로젝트 개요

본 프로젝트는 Github 사용자 검색 및 즐겨찾기 기능을 가진 앱입니다.

# 아키텍처 및 구조 설명

본 프로젝트는 MVVM + Clean Architecture + Coordinator Pattern을 기반으로 설계되었습니다. 각 레이어와 역할은 다음과 같습니다.

## 1. Presentation Layer (MVVM)

### ViewController

UI 구성 및 사용자 이벤트 처리 담당

ViewModel과 데이터 바인딩(CCombine)을 통해 UI 갱신

Coordinator를 통해 화면 전환 흐름만 관리


### ViewModel

화면 단위의 상태(State) 관리

UseCase 호출을 통해 데이터를 가져오고, Combine Publisher를 통해 ViewController에 전달

로딩 상태, 에러 상태 등 UI 반영이 필요한 상태 관리

## 2. Domain Layer (UseCase)

### UseCase

앱의 핵심 비즈니스 로직을 담당

Repository와 통신하여 데이터 처리

Pagination, 즐겨찾기 토글 등 화면에 필요한 비즈니스 로직 수행

비즈니스 규칙을 캡슐화하여 ViewModel과 Repository의 의존성을 낮춤

## 3. Data Layer (Repository & DataFetcher)

### Repository

Domain Layer와 Data Layer 사이 인터페이스 역할

RemoteDataFetcher / LocalDataFetcher와 통신하여 데이터를 가져오고, Combine Publisher를 통해 UseCase에 전달

Favorite Users와 같이 앱 전역에서 공유되는 데이터는 Repository 내부 Publisher로 관리

### RemoteDataFetcher / LocalDataFetcher

네트워크 요청 및 로컬 데이터 저장/조회 책임

Entity와 Response 모델 간 매핑 처리


## 4. Coordinator Pattern

ViewController 간 화면 전환 로직을 중앙에서 관리

각 화면의 결합도를 낮추고 재사용성 향상

Navigation 흐름과 모달 전환을 안전하게 분리


# 기술 스택 및 아키텍처

UI Framework: UIKit (SnapKit + Then 기반 코드 UI)

아키텍처: MVVM + Coordinator Pattern + Clean Architecture

의존성 관리: Swift Package Manager

지원 iOS 버전: iOS 15 이상


# 사용한 라이브러리

Swinject: 의존성 주입(DI) 관리 → 객체 간 결합도를 낮추고 테스트 용이성 확보

Moya: 네트워크 레이어 추상화 → API 통신 모듈화 및 가독성 향상

Realm: 로컬 데이터베이스 저장소로 사용 → 즐겨찾기 사용자 캐싱 및 오프라인 데이터 관리

Kingfisher: 비동기 이미지 다운로드 및 캐싱 처리 → 사용자 아바타 이미지 로딩 최적화

Combine: 비동기 이벤트 스트림 및 상태 관리

# 향후 개선 사항

UI 테스트 및 Unit Test 추가 예정

사용자 경험 개선 및 접근성 보완


#실행 방법

Xcode에서 프로젝트 열기

Deployment Target iOS 15 이상 확인

빌드 후 시뮬레이터 또는 실제 기기에서 실행
