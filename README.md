# flutter_ml_workshop_1

Это репозиторий содержит пустой проект со всеми настройками, плагинами и зависимостями для разработки простого приложения Flutter + Mlkit.
Вам нужно будет завершить реализацию для из 10 шагов.


При запуске пустого проекта у вас будет крассный экран. В первых нескольких шагах мы поправим все проблемы добавив функционал, тем самым научимся выходить из таких ситуаций.

# Пункты по которым будем идти

Step 1: **Реализовываем переходы внутри приложения.</br>**
Step 2: **Реализуем внешний вид карточки для списка всех функций в MlKit.</br>**
Step 3: **Реализуем список всех CustomCard</br>**
Step 4: **Обрабатываем возвращение на предыдущий экран</br>**
Step 5: **Реализуем вывод изображение и наложение боксов с текстом</br>**
Step 6: **Реализуем логику запуска ML на новом изображении или фото из галереи</br>**
Step 7: **Рисуем боксы у распозного текста.</br>**
Step 8: **Реализуем бриджинг между Flutter и нативной платформой.</br>**
Step 9: **Делаем приобразования для ML</br>**
Step 10: **Запускам ML на вашем устройстве!</br>**


## Хэши каждого из этапов
Если вы не успеваете или по каким-то причинам не смогли реализовать код, то при помощи 
```sh
git checkout 'commit-hash'
```
вы можете пропустить этап.

Step 1: 22df48c757ae15338e5ae780277c0a1443505e18</br>
Step 2: 9a898709ee261c0b356e416bb48ea35f471ffe9e</br>
Step 3: ecc67ab16b337c6a6999ac3a4dfbb96d48051679</br>
Step 4: f598410eabf0c50420a31520dda58075d2ca923d</br>
Step 5: 16d9cca9600ac96e15714d20206586519fe5e337</br>
Step 6: 5a6ef844e36221df0e1049b52e6857bd3858c0be</br>
Step 7: d08d5c60e142eaf6ba569ea6db98a8febd06e6f2</br>
Step 8: bb3ba50aefd54cd1714ac6c5315b7bb3c235438e</br>
Step 9: 94292798e9ef0060a44bfed568c3dda6a211b273</br>
Step 10: ee6e9a239635632fba6d13623960f971f4830260</br>


Проект с самого начала содержит несколько утилит для настройки основных функций приложения, таких как просмотр камеры и управление разрешениями.

В проекте были использованы такие зависимости:
```yaml
  image_picker: ^0.6.2+3
  camera: ^0.5.7+2  
  toast: ^0.1.5
  flutter_image_compress: ^0.6.3
  image:
  cupertino_icons: ^0.1.2
  url_launcher: ^5.2.7
```



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
