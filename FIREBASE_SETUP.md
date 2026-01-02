# Подробная инструкция по настройке Firebase для онлайн-режима

## Шаг 1: Создание проекта в Firebase

1. Откройте браузер и перейдите на https://console.firebase.google.com/
2. Войдите в свой Google аккаунт (если не вошли)
3. Нажмите кнопку **"Создать проект"** или **"Add project"**
4. Введите название проекта (например: `snake-io-game`)
5. Нажмите **"Продолжить"** или **"Continue"**
6. (Опционально) Отключите Google Analytics, если не нужен
7. Нажмите **"Создать проект"** или **"Create project"**
8. Дождитесь создания проекта (обычно 10-30 секунд)
9. Нажмите **"Продолжить"** или **"Continue"**

## Шаг 2: Включение Realtime Database

1. В левом меню Firebase Console найдите раздел **"Build"** (Сборка)
2. Нажмите на **"Realtime Database"** (База данных в реальном времени)
3. Нажмите кнопку **"Создать базу данных"** или **"Create Database"**
4. Выберите расположение (например: `us-central1` или ближайший к вам регион)
5. Нажмите **"Далее"** или **"Next"**
6. **ВАЖНО:** Выберите режим **"Начать в режиме тестирования"** или **"Start in test mode"**
   - Это позволит читать и писать данные без аутентификации (для тестирования)
   - ВНИМАНИЕ: Для продакшена нужно настроить правила безопасности!
7. Нажмите **"Готово"** или **"Done"**
8. Дождитесь создания базы данных

## Шаг 3: Получение конфигурационных данных

1. В левом верхнем углу Firebase Console нажмите на **шестеренку** (⚙️) рядом с "Project Overview"
2. Выберите **"Project settings"** (Настройки проекта)
3. Прокрутите вниз до раздела **"Your apps"** (Ваши приложения)
4. Если у вас еще нет веб-приложения, нажмите на иконку **`</>`** (Web)
5. Введите название приложения (например: `Snake.io Web`)
6. (Опционально) Отметьте "Also set up Firebase Hosting"
7. Нажмите **"Register app"** (Зарегистрировать приложение)
8. Скопируйте конфигурационный объект, который выглядит так:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "your-project-id.firebaseapp.com",
  databaseURL: "https://your-project-id-default-rtdb.firebaseio.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890"
};
```

## Шаг 4: Настройка правил безопасности (ВАЖНО!)

1. Вернитесь в раздел **"Realtime Database"**
2. Перейдите на вкладку **"Rules"** (Правила)
3. Замените правила на следующие (для тестирования):

```json
{
  "rules": {
    "players": {
      ".read": true,
      ".write": true,
      "$playerId": {
        ".validate": "newData.hasChildren(['name', 'x', 'y', 'mass', 'level', 'timestamp'])",
        "name": {
          ".validate": "newData.isString() && newData.val().length > 0 && newData.val().length <= 20"
        },
        "x": {
          ".validate": "newData.isNumber() && newData.val() >= 0"
        },
        "y": {
          ".validate": "newData.isNumber() && newData.val() >= 0"
        },
        "mass": {
          ".validate": "newData.isNumber() && newData.val() > 0"
        },
        "level": {
          ".validate": "newData.isNumber() && newData.val() > 0"
        },
        "timestamp": {
          ".validate": "newData.isNumber()"
        }
      }
    }
  }
}
```

4. Нажмите **"Publish"** (Опубликовать)

## Шаг 5: Обновление кода в index.html

1. Откройте файл `index.html` в редакторе
2. Найдите функцию `initFirebase()` (примерно строка 1920)
3. Найдите этот код:

```javascript
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    databaseURL: "https://YOUR_PROJECT_ID-default-rtdb.firebaseio.com/",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};
```

4. Замените все значения на те, что вы скопировали из Firebase Console:
   - `YOUR_API_KEY` → ваша `apiKey`
   - `YOUR_PROJECT_ID` → ваш `projectId` (встречается в нескольких местах)
   - `YOUR_MESSAGING_SENDER_ID` → ваш `messagingSenderId`
   - `YOUR_APP_ID` → ваш `appId`

5. Пример того, как должно выглядеть (с вашими данными):

```javascript
const firebaseConfig = {
    apiKey: "AIzaSyC1234567890abcdefghijklmnopqrstuv",
    authDomain: "snake-io-game.firebaseapp.com",
    databaseURL: "https://snake-io-game-default-rtdb.firebaseio.com/",
    projectId: "snake-io-game",
    storageBucket: "snake-io-game.appspot.com",
    messagingSenderId: "123456789012",
    appId: "1:123456789012:web:abcdef1234567890"
};
```

## Шаг 6: Активация онлайн-режима в коде

1. Найдите функцию `initGame()` (примерно строка 277)
2. Найдите эту строку (она закомментирована):

```javascript
// Инициализация онлайн режима (если еще не инициализирован)
if (!isOnline && typeof firebase !== 'undefined') {
    // Раскомментируйте следующую строку после настройки Firebase
    // initFirebase();
}
```

3. Раскомментируйте строку `// initFirebase();`:

```javascript
// Инициализация онлайн режима (если еще не инициализирован)
if (!isOnline && typeof firebase !== 'undefined') {
    // Раскомментируйте следующую строку после настройки Firebase
    initFirebase();
}
```

## Шаг 7: Проверка работы

1. Сохраните файл `index.html`
2. Откройте игру в браузере
3. Откройте консоль разработчика (F12)
4. Нажмите кнопку "Играть"
5. В консоли должно появиться сообщение: `Firebase инициализирован`
6. Если открыть игру в другом окне/браузере, вы должны увидеть:
   - Уведомление "Игрок присоединился!"
   - Другого игрока на карте

## Возможные проблемы и решения

### Проблема: "Firebase is not defined"
**Решение:** Убедитесь, что скрипты Firebase загружены в `<head>`:
```html
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-database-compat.js"></script>
```

### Проблема: "Permission denied"
**Решение:** Проверьте правила безопасности в Realtime Database. Они должны разрешать чтение и запись.

### Проблема: Игроки не видят друг друга
**Решение:** 
- Убедитесь, что оба игрока используют один и тот же проект Firebase
- Проверьте консоль браузера на ошибки
- Убедитесь, что `databaseURL` правильный (должен заканчиваться на `/`)

### Проблема: Данные не сохраняются
**Решение:** Проверьте, что база данных создана в режиме тестирования или правила безопасности разрешают запись.

## Дополнительные настройки (опционально)

### Очистка неактивных игроков
Firebase автоматически удалит игроков, которые не обновляли свою позицию более 30 секунд (можно настроить в коде).

### Безопасность для продакшена
Для продакшена рекомендуется:
1. Настроить аутентификацию пользователей
2. Обновить правила безопасности
3. Ограничить доступ только авторизованным пользователям

## Готово!

Теперь ваша игра поддерживает онлайн-режим! Игроки смогут видеть друг друга и играть вместе в реальном времени.

