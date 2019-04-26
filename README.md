<h1 align="center">
  <br>
  <br>
  <img src="https://raw.githubusercontent.com/moridaffy/movieexplorer-ios/master/Extra/logo.png" alt="App Icon" width="300">
  MovieExplorer
  <br>
</h1>

<h4 align="center">Explore various films using TMDb API</h4>

<h1 align="center">
<img src="https://raw.githubusercontent.com/moridaffy/movieexplorer-ios/master/Extra/screen_list.png" alt="Film list" width="250"> <img src="https://raw.githubusercontent.com/moridaffy/movieexplorer-ios/master/Extra/screen_details.png" alt="Detailed info" width="250">
</h1>

<p align="center">
  <a href="#Info">Info</a> •
  <a href="#TODO">TODO</a> •
  <a href="#How-to-install">How to install</a> •
  <a href="#Developer">Developer</a>
</p>

## Info
MovieExplorer is a simple app, which allows you to browse information about the most popular films (according to TMDb data) and also search information about any other film. User also can save films locally to access it's information later without internet connection by adding them to "Favorites"

* Information is taken from public <a href="https://www.themoviedb.org/documentation/api">TMDb API</a>
* Code is written in Swift using MVVM architecture
* Application is using <a href="https://github.com/ReactiveX/RxSwift">RxSwift</a> and <a href="https://github.com/RxSwiftCommunity/RxDataSources">RxDataSources</a> for data binding, <a href="https://github.com/Alamofire/Alamofire">Alamofire</a> for networking, <a href="https://github.com/onevcat/Kingfisher">Kingfisher</a> for asynchronous image loading and caching and <a href="https://github.com/realm/realm-cocoa">Realm</a> for creating local DB
* UI adapts to different screen sizes using AutoLayout

## How to install
* Fork/clone the repo
* Install pods by running ```pod install``` in terminal from project's folder
* Open the project using ```.xcworkspace``` file
* Provide your own API keys in ```APIManager.swift``` file (line 16 and 17)

## Developer
This app was created by Maxim Skryabin as a simple portfolio project. Feel free to contact me using <a href="http://mskr.name/contact/">my website</a>.
