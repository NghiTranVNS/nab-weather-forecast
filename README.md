# nab-weather-forecast
This is the iOS demo source code for my iOS Development Challenge at NAB. Follow the expected outputs, I have the check list below. All items that marked [Supported] are implemented. 

#### [Supported] 1. Programming language: Swift is required, Objective-C is optional.
  - I use Swift for all coding tasks
#### [Supported] 2. Design app's architecture (recommend VIPER or MVP, MVVM but not mandatory)
  - I apply MVVM combine with Clean Architecture
  - Also use Dependency Injecction to virtualize model, repository, service
  - For UI state hander, I apply Flux and React Programming. See the ReactorKit github: https://github.com/ReactorKit/ReactorKit
#### [Supported] 3. UI should be looks like in attachment.
#### [Supported] 4. Write UnitTests
  - Just write a mock repository to test the local store service
  - The real repository can run with the same way
#### [Not yet] 5. Acceptance Tests
#### [Supported] 6. Exception handling
#### [Supported] 7. Caching handling
  - Aplly Core Data to caching
  - I clean Local Database (CoreData) everytime launching a new section (kill app the re-launch) for testing.
  - For a searched key/city, app will store to CoreData and retrieve it for next searches. App won't have to call Cloud API anymore.
#### [Not yet] 8. Accessibility for Disability Supports: screen, adjust the display size or font size.
#### [Supported] 9. Entity relationship diagram for the database and solution diagrams for the components, infrastructure design if any
  - See the compoment diagram in the commenent #10.a below. If we have more time, I can add more entity, flowchart, sequence diagram.


### 10. Readme file includes:
#### a. Brief explanation for the software development principles, patterns & practices being applied
  - See the pic for the detailed. I just drawed it in hurry, will get back to update it if needed
 https://drive.google.com/file/d/1uX8dz6Weer80uoByXvm8hD3HX_tsggZx/view?usp=sharing
 
#### b.  Brief explanation for the code folder structure and the key Objective-C/Swift libraries and frameworks being used
  - From the project root, you can see 3 folders reflecting MVVM parttern: Models, Views, ViewModels
  - Next to the 3 MVVM components are folders for Clean Architecture: Repositories (Data Handder), Services (Data Providers)
  - Under the Services folder, we have folders for Local DB and Cloud API services that handle providing data from different sources.
  - Under the mvlTests are mocked repository and service classes that are also data provider. But they are used for unit testing.
  ##### Library used:
  - RxSwift, RxCocoa, ReactorKit for react programing support
  - Alamofire, ObjectMapper for https API call and JSON parser
  - MagicalRecord for CoreData
  - Kingfisher for image download and caching.
#### c.  All the required steps in order to get the application run on local computer
  - 1. Please use CocoaPods to install third-party dependencies from root project first. See it if you are not familiar with Pod: https://guides.cocoapods.org/using/getting-started.html
  - 2. Open the `mvl.xcworkspace` in Xcode, just build and run it on any simulator. If you want to use a real devices, please re-configure the team and bundle ID with your own information.
#### d.  Checklist of items the candidate has done.
  - See the check list above
