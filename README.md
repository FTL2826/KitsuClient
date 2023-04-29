# KitsuClient
> MVVM + Coordinator app with Combine
> Short video demonstration of app [*link*](https://drive.google.com/file/d/1XK6zix7av208ZBINR87aXlTwXAtEQP8p/view?usp=sharing)

## Table of content:
- [General info](#general-info) 
- [Technologies used](#technologies-used)
- [Features](#features)
- [Screen map](#screen-map)
- [Setup](#setup)
- [Project status](#project-status)
- [Contact](#contact)
- [License](#license)



## General info
Simple scroll app with authorizatioт for target iOS 14. I used free API [*kitsu.io*](https://kitsu.docs.apiary.io/#reference/anime/anime/fetch-collection)

## Technologies used
- 100% Swift
- UIKit. 100% Code interface.
- MVVM Architecture
- Combine
- Navigation via pattern Coordinator
- URLSession for network layer
- UITableDiffableDataSource
- Factory pattern
- UserDefaults
- WKWebView
- Attributed string
- Unit, UI tests

## Features
1. No Xibs || Storyboard
2. Versatile Network layer (API service) in URLSession for data requests and picture downloading. Also caching pictures.
3. Type-Driven Development for login, password etc. (Custom types with init validation)
4. Pagination for views with scroll
5. Input -> Output ModelViews via Combine

## Screen map
![screens diagram](/Screenshots/ScreenDiagramm.png)

## Setup
Because no external libraries used you need only XCode for launch

## Project status
Finished

## Contact
Created by [@FTL2826](https://github.com/FTL2826)  
Feel free to contact me <gimpastrike@gmail.com>

## License
This project is open source and available under the MIT License