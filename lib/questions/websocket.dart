import '../model/qa_model.dart';

final List<QA> websocket = [
  const QA(
    q: 'Отличие WebSocket от HTTP',
    a: '''

Протокол WebSocket и протокол HTTP — это два разных сетевых протокола.

Назначение
HTTP:      Запрос-ответ
WebSocket: Двусторонняя связь в реальном времени Full-duplex (двусторонняя)

Подключение
HTTP:      Краткосрочное (на каждый запрос)
WebSocket: Долгоживущее

Заголовки
HTTP:      Передаются в каждом запросе
WebSocket: Только при открытии соединения

Безопасность
HTTP: использует HTTPS для шифрования
WebSocket: использует WSS (WebSocket Secure) для шифрования через TLS.
''',
  ),

  const QA(
    q: 'Протокол инициализации (handshake)',
    a: '''
WebSocket начинает с рукопожатия через HTTP:

- Клиент отправляет запрос Updgrade: websocket
- Сервер отправляет ответ 101 Switching Protocols
- После этого соединение переходит на WebSocket

Пример запроса на открытие WebSocket:

1. HTTP Upgrade Request (клиент → сервер):
GET /chat HTTP/1.1
Host: example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13

2. HTTP Upgrade Response (сервер → клиент):
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=

Ключевые заголовки

- Sec-WebSocket-Key - случайный base64 ключ (16 байт)
- Sec-WebSocket-Accept - SHA1 hash от (key + magic string)
- 101 Switching Protocols - успешный upgrade
''',
  ),

  const QA(
    q: 'Приведи пример полного цикла работы WebSocket',
    a: r'''

1.Установка соединения (WebSocket Handshake)

```
Запрос от клиента (HTTP Upgrade):

1. HTTP Upgrade Request (клиент → сервер):
GET /chat HTTP/1.1
Host: example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13

2. HTTP Upgrade Response (сервер → клиент):
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=

После handshake

- HTTP соединение → WebSocket соединение
- TCP уровень остается тот же
- Новый протокол поверх TCP
- Frame-based messaging


// dart:io автоматически выполняет handshake
final socket = await WebSocket.connect('wss://example.com/ws');

// web_socket_channel тоже скрывает детали
final channel = WebSocketChannel.connect(Uri.parse('wss://example.com/ws'));
```

2. Обмен сообщениями после установки соединения

⚠️ Важно: После handshake все данные передаются в бинарном формате WebSocket фреймов, а не в виде обычного текста HTTP!

Структура WebSocket фрейма:

0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-------+-+-------------+-------------------------------+
|F|R|R|R| opcode|M| Payload len |    Extended payload length    |
|I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
|N|V|V|V|       |S|             |   (if payload len==126/127)   |
| |1|2|3|       |K|             |                               |
+-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
|     Extended payload length continued, if payload len == 127  |
+ - - - - - - - - - - - - - - - +-------------------------------+
|                               |Masking-key, if MASK set to 1  |
+-------------------------------+-------------------------------+
| Masking-key (continued)       |          Payload Data         |
+-------------------------------- - - - - - - - - - - - - - - - +
:                     Payload Data continued ...                :
+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
|                     Payload Data continued ...                |
+---------------------------------------------------------------+

3. Примеры сообщений в приложении чата

Клиент → Сервер: Отправка сообщения

{
  "type": "message",
  "data": {
    "text": "Привет всем!",
    "user_id": "user123",
    "timestamp": "2025-07-31T10:30:00Z"
  }
}

Сервер → Клиент: Уведомление о новом сообщении

{
  "type": "new_message",
  "data": {
    "message_id": "msg456",
    "text": "Привет всем!",
    "user_id": "user123",
    "username": "Алексей",
    "timestamp": "2025-07-31T10:30:00Z",
    "room_id": "room789"
  }
}

Клиент → Сервер: Присоединение к комнате

{
  "type": "join_room",
  "data": {
    "room_id": "room789",
    "user_id": "user123"
  }
}

Сервер → Клиент: Подтверждение присоединения

{
  "type": "room_joined",
  "data": {
    "room_id": "room789",
    "participants_count": 15,
    "participants": [
      {"user_id": "user123", "username": "Алексей"},
      {"user_id": "user456", "username": "Мария"}
    ]
  }
}

4. Системные сообщения

Клиент → Сервер: Ping (проверка соединения)
{
  "type": "ping",
  "timestamp": "2025-07-31T10:30:00Z"
}


Сервер → Клиент: Pong (ответ на ping)
json{
  "type": "pong",
  "timestamp": "2025-07-31T10:30:00Z"
}

{
  "type": "error",
  "data": {
    "code": "INVALID_ROOM",
    "message": "Комната не существует",
    "details": {
      "room_id": "nonexistent_room"
    }
  }
}

Пример

import 'dart:convert';
import 'dart:io';

class ChatWebSocketClient {
  WebSocket? _socket;

  Future<void> connect() async {
    _socket = await WebSocket.connect('ws://localhost:8080/chat');

    // Слушаем входящие сообщения
    _socket!.listen((data) {
      final message = jsonDecode(data);
      _handleMessage(message);
    });
  }

  // Отправка сообщения в чат
  void sendMessage(String text) {
    final message = {
      'type': 'message',
      'data': {
        'text': text,
        'user_id': 'user123',
        'timestamp': DateTime.now().toIso8601String(),
      }
    };
    _socket?.add(jsonEncode(message));
  }

  // Присоединение к комнате
  void joinRoom(String roomId) {
    final message = {
      'type': 'join_room',
      'data': {
        'room_id': roomId,
        'user_id': 'user123',
      }
    };
    _socket?.add(jsonEncode(message));
  }

  void _handleMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'new_message':
        print('Новое сообщение: ${message['data']['text']}');
        break;
      case 'room_joined':
        print('Присоединились к комнате: ${message['data']['room_id']}');
        break;
      case 'error':
        print('Ошибка: ${message['data']['message']}');
        break;
      case 'pong':
        print('Соединение активно');
        break;
    }
  }
}
''',
  ),

  const QA(
    q: 'Сценарий уведомления клиента через WebSocket',
    a: '''

Предусловия:
  Мобильное приложение запущено и активно
  Установлено WebSocket соединение с сервером
  Сервер знает идентификатор клиента (userId/deviceId)
  Сервер имеет mapping: clientId → активное WebSocket соединение

Процесс уведомления:
  На стороне сервера:
    Происходит событие, требующее уведомления клиента
    Сервер определяет, какой клиент должен получить уведомление
    Сервер находит активное WebSocket соединение для этого клиента
    Сервер отправляет сообщение через найденное соединение

  На стороне клиента:
    Приложение получает сообщение через активный WebSocket канал
    Сообщение десериализуется в объект уведомления
    BLoC/ViewModel обрабатывает уведомление
    UI обновляется соответствующим образом

  Критические аспекты:
    Идентификация: Сервер должен однозначно идентифицировать клиента
    Состояние соединения: WebSocket должен быть активен и не разорван
    Формат сообщений: Согласованный протокол обмена (JSON/proto)
    Обработка ошибок: Что делать, если соединение разорвано в момент отправки

Альтернативные сценарии:
  Если WebSocket разорван → fallback на push-уведомления
  Если клиент offline → очередь сообщений на сервере
  Если несколько устройств → broadcast уведомления на все активные соединения

Ключевое преимущество: мгновенная доставка без polling'а.


Polling - регулярный опрос сервера

Как работает:
  Клиент периодически отправляет HTTP-запросы на сервер для проверки наличия новых данных.

Типы polling:
  1. Regular Polling (фиксированный интервал)
      Запросы отправляются строго по таймеру
      Интервал: 5-30 секунд
      Постоянная нагрузка на сервер

  2. Adaptive Polling (адаптивный интервал)
      Интервал изменяется в зависимости от активности
      При активности - чаще, при бездействии - реже
      Экономит ресурсы

  3. Long Polling
      Клиент отправляет запрос и сервер держит его открытым
      Сервер отвечает только при наличии данных или таймауте
      Ближе к push-уведомлениям по UX

  Либо уведомить клиент, отправив нотификацию на мобильное приложение
''',
  ),
];
