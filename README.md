<h1 align="center">
  <br>
  KTS
  <br>
</h1>

<h4 align="center">Тестовое задание для кандидатов в компании KTS</h4>

<h1 align="center">
<img src="https://raw.githubusercontent.com/moridaffy/kts_test/master/Extra/screen_list.png" alt="Список фильмов" width="250"> <img src="https://raw.githubusercontent.com/moridaffy/kts_test/master/Extra/screen_details.png" alt="Детальная информация о фильме" width="250">
</h1>

<p align="center">
  <a href="#Информация">Информация</a> •
  <a href="#Как-запустить">Как запустить</a> •
  <a href="#Разработчик">Разработчик</a>
</p>

## Информация
MovieExplorer - простое приложение, позволяющее пользователю просматривать список самых популярных фильмов (по версии TMDb), а также выполнять поиск фильмов. Также есть возможность добавить фильм в список избранных фильмов и тем самым сохранить локально для просмотра оффлайн

* Информация о фильмах загружаются при помощи публичного  <a href="https://www.themoviedb.org/documentation/api">API TMDb'a</a>
* Приложение написано на Swift'e и использует следующие сторонние библиотеки: <a href="https://github.com/realm/realm-cocoa">Realm</a> для хранения данных в локальной БД, <a href="https://github.com/SDWebImage/SDWebImage">SDWebImage</a> для асинхронной загрузки изображений (постеров и фонов фильмов) и <a href="https://github.com/Alamofire/Alamofire">Alamofire</a> для выполнения сетевых запросов к API
* Интерфейсы построены в IB с использованием AutoLayout'a


## Как запустить
Чтобы приложение начало работу после fork'a/загрузки, необходимо выполнить следующие действия:
* Перейдите в директорию проекта и запустите следующую команду для установки вспомогательных библиотек (необходимо наличие <a href="https://cocoapods.org">CocoaPods</a>
```
pod install
```
* Открыть файл проекта в XCode (с расширением .workspace)
* Скомпилировать и запустить проект на симуляторе или физическом устройстве

## Разработчик
<a href="http://mskr.name">Веб-сайт</a>  
<a href="http://vk.com/morimax">ВК</a>  
<a href="http://t.me/moridaffy">Telegram</a>  
<a href="mailto:dev@mskr.name">E-Mail</a>
