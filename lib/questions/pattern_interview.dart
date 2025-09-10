import '../model/qa_model.dart';

const List<QA> patternQuestions = [
  QA(
    q: 'Как реализовать Singleton в Dart?',
    a: r'''
class MySingleton {
  static final MySingleton _singleton = MySingleton._internal();

  MySingleton._internal();

  factory MySingleton() => _singleton;
}

void main() {
  // Все вызовы возвращают ОДИН И ТОТ ЖЕ объект
  var instance1 = MySingleton();
  var instance2 = MySingleton();
  var instance3 = MySingleton();

  print(identical(instance1, instance2)); // true
  print(identical(instance2, instance3)); // true
  print(instance1.hashCode);              // Один хеш-код
  print(instance2.hashCode);              // Тот же хеш-код
}



🎯 Расширенная версия с функциональностью

class MySingleton {
  static final MySingleton _singleton = MySingleton._internal();

  // Приватные поля экземпляра
  late String _data;
  int _counter = 0;

  MySingleton._internal() {
    // Инициализация выполняется только один раз
    _data = 'Singleton initialized at ${DateTime.now()}';
    print('Singleton создан!');
  }

  factory MySingleton() => _singleton;

  // Публичные методы
  String get data => _data;
  int get counter => _counter;

  void increment() => _counter++;

  void updateData(String newData) {
    _data = newData;
  }
}

void main() {
  var s1 = MySingleton();
  print(s1.data);        // Данные инициализации
  s1.increment();

  var s2 = MySingleton();
  print(s2.counter);     // 1 (тот же объект!)
  s2.increment();

  print(s1.counter);     // 2 (изменения видны везде)
}

''',
  ),
  QA(
    q: 'Что такое паттерн "Адаптер" и для чего он используется?',
    a: '''
Адаптер (Adapter) — это структурный паттерн, который позволяет объектам с несовместимыми интерфейсами работать вместе.
Он оборачивает один интерфейс в другой, ожидаемый клиентом.
Применяется, когда нужно интегрировать старый код, сторонние библиотеки или нестандартизированные интерфейсы.

// Data layer: ответ от API

class UserDto {
  final String id;
  final String name;
  final String email;

  UserDto({required this.id, required this.name, required this.email});
}

// Domain layer: бизнес-модель, независимая от источника данных

class User {
  final String userId;
  final String fullName;

  User({required this.userId, required this.fullName});
}

// Адаптер: преобразует DTO в Domain-модель

class UserDtoAdapter {
  static User toDomain(UserDto dto) {
    return User(
      userId: dto.id,
      fullName: dto.name,
    );
  }
}

''',
  ),

  QA(
    q: 'Чем отличается паттерн Adapter от паттерна Decorator?',
    a: '''
Adapter изменяет интерфейс объекта, чтобы он соответствовал другому интерфейсу.
Decorator сохраняет интерфейс, но добавляет дополнительное поведение.

Adapter = "переводит" интерфейс,
Decorator = "оборачивает" с добавками.
''',
  ),

  QA(
    q: 'Что такое паттерн "Мост" и в чём его основное назначение?',
    a: '''
Паттерн "Мост" (Bridge) — это структурный паттерн, который отделяет абстракцию от её реализации, позволяя изменять их независимо друг от друга.

Он полезен, когда:
- нужно избежать жёсткой зависимости между абстракцией и реализацией,
- абстракции и реализации развиваются независимо,
- используется композиция вместо наследования.

Пример: UI-компонент (абстракция) и разные платформенные рендереры (реализация).
''',
  ),

  QA(
    q: 'Приведи пример применения паттерна Bridge в архитектуре Flutter-приложения.',
    a: '''
Bridge может использоваться, когда нужно поддерживать разные источники данных (например, REST и Firebase):

Абстракция:
abstract class UserRepository {
  Future<User> getUser();
}

Реализации:
class RestUserRepository implements UserRepository { ... }
class FirebaseUserRepository implements UserRepository { ... }

ViewModel зависит от UserRepository, но не знает, какая конкретная реализация используется — это и есть "мост".
''',
  ),

  QA(
    q: 'Что такое паттерн "Компоновщик" (Composite)?',
    a: '''
Облегчает создание иерархий объектов, где каждый объект может рассматриваться независимо или как набор вложенных объектов через один и тот же интерфейс.
''',
  ),

  QA(
    q: 'Приведи пример использования паттерна Composite во Flutter.',
    a: '''
Flutter сам реализует Composite в дереве виджетов:

- `Widget` — базовый интерфейс.
- `Text`, `Image` — листовые (примитивные) узлы.
- `Column`, `Row`, `Stack` — составные (композитные) виджеты, которые содержат другие виджеты.

Все они обрабатываются одинаково во фреймворке, через общий интерфейс `Widget`.

Composite позволяет создавать гибкие иерархии с вложенностью без взрывного роста подклассов.

Он использует композицию (объекты внутри объектов), а не наследование, и делает структуру масштабируемой и легко модифицируемой.
''',
  ),
  QA(
    q: 'Что такое паттерн "Декоратор" и зачем он нужен?',
    a: '''
Позволяет добавлять объектам новое поведение, не изменяя их исходный класс.

Он оборачивает объект в другой объект с тем же интерфейсом, но с расширенным функционалом.

Пример: логгирование, кеширование, валидация без изменения основной логики.

Flutter сам активно использует паттерн Декоратор: большинство виджетов UI оборачиваются в другие виджеты.

Примеры:
- Padding(child: ...)
- Center(child: ...)
- DecoratedBox(child: ...)
- Scrollbar(child: ListView(...))

Все они добавляют поведение/визуал без изменения внутреннего виджета.
''',
  ),

  QA(
    q: 'Что такое паттерн "Фасад"?',
    a: '''
Предоставляет упрощённый интерфейс к сложной подсистеме.

Он скрывает детали реализации и взаимодействия между объектами, позволяя клиенту работать с системой через единый, удобный API.

Применяется для:
- уменьшения связанности кода,
- изоляции сложной логики,
- упрощения интерфейсов.

Пример: единый сервис для авторизации.

class AuthFacade {
  final FirebaseAuthService _firebase;
  final GoogleSignInService _google;

  AuthFacade(this._firebase, this._google);

  Future<User> signInWithGoogle() async {
    final googleToken = await _google.getToken();
    return await _firebase.signInWithGoogleToken(googleToken);
  }

  Future<void> logout() async {
    await _firebase.logout();
    await _google.logout();
  }
}

В UI используется только AuthFacade — остальная логика скрыта.
''',
  ),

  QA(
    q: 'Что такое паттерн "Flyweight"?',
    a: '''
позволяет экономить память за счёт повторного использования уже существующих объектов с одинаковым внутренним состоянием.

В Dart часто используют `static` для реализации FlyweightFactory, потому что:

- удобно кэшировать объекты в `static Map`;
- можно обращаться без создания инстанса фабрики.
''',
  ),
  QA(
    q: 'Что такое паттерн "Прокси"?',
    a: '''
Прокси управляет доступом к исходному объекту, позволяя делать что-то до или после обращения к нему

Interceptor в Dio можно рассматривать как реализацию паттерна Proxy , но с некоторыми нюансами.
''',
  ),

  QA(
    q: '''Паттерны проектирования''',
    a: '''

## Порождающие паттерны (Creational) 5 шт

- Абстрактная фабрика — позволяет создавать семейства связанных объектов, не привязываясь к конкретным классам создаваемых объектов.
- Фабричный метод — определяет общий интерфейс для создания объектов в суперклассе, позволяя подклассам изменять тип создаваемых объектов.
- Singleton —  гарантирует, что у класса есть только один экземпляр, и предоставляет к нему глобальную точку доступа.
- Builder — создавать сложные объекты пошагово. Строитель даёт возможность использовать один и тот же код строительства для получения разных представлений объектов.
- Prototype — позволяет копировать объекты, не вдаваясь в подробности их реализации.

## Структурные паттерны (Structural) 7 шт

- Adapter — позволяет объектам с несовместимыми интерфейсами работать вместе.
- Decorator — позволяет динамически добавлять объектам новую функциональность, оборачивая их в полезные «обёртки».
- Facade — предоставляет простой интерфейс к сложной системе.
- Composite —  позволяет сгруппировать множество объектов в древовидную структуру, а затем работать с ней так, как будто это единичный объект.
- Proxy (Заместитель) — позволяет подставлять вместо реальных объектов специальные объекты-заменители. Эти объекты перехватывают вызовы к оригинальному объекту, позволяя сделать что-то до или после передачи вызова оригиналу.
- Мост - разделяет один или несколько классов на две отдельные иерархии — абстракцию и реализацию, позволяя изменять их независимо друг от друга.
- Легковес — позволяет вместить бóльшее количество объектов в отведённую оперативную память. Легковес экономит память, разделяя общее состояние объектов между собой, вместо хранения одинаковых данных в каждом объекте.

## Поведенческие паттерны (Behavioral) 10 шт

- Observer — создаёт механизм подписки, позволяющий одним объектам следить и реагировать на события, происходящие в других объектах.
- Command — превращает запросы в объекты, позволяя передавать их как аргументы при вызове методов, ставить запросы в очередь, логировать их, а также поддерживать отмену операций.
- State — позволяет объектам менять поведение в зависимости от своего состояния. Извне создаётся впечатление, что изменился класс объекта.
- Strategy — определяет семейство схожих алгоритмов и помещает каждый из них в собственный класс, после чего алгоритмы можно взаимозаменять прямо во время исполнения программы.
- Mediator (Посредник) — позволяет уменьшить связанность множества классов между собой, благодаря перемещению этих связей в один класс-посредник.
- Итератор — даёт возможность последовательно обходить элементы составных объектов, не раскрывая их внутреннего представления.
- Шаблонный метод — определяет скелет алгоритма, перекладывая ответственность за некоторые его шаги на подклассы. Паттерн позволяет подклассам переопределять шаги алгоритма, не меняя его общей структуры.
- Цепочка обязанностей — позволяет передавать запросы последовательно по цепочке обработчиков. Каждый последующий обработчик решает, может ли он обработать запрос сам и стоит ли передавать запрос дальше по цепи.
- Посетитель — позволяет добавлять в программу новые операции, не изменяя классы объектов, над которыми эти операции могут выполняться.
- Снимок — позволяет сохранять и восстанавливать прошлые состояния объектов, не раскрывая подробностей их реализации.

''',
  ),

  QA(
    q: 'Что такое Абстрактная фабрика?',
    a: '''

позволяет создавать семейства связанных объектов без указания их конкретных классов.

class AndroidButton implements Button {}
class IosButton implements Button {}

abstract class CheckBox {}

class AndroidCheckBox implements CheckBox {}
class IosCheckBox implements CheckBox {}

abstract class WidgetFactory {}

class AndroidWidgetFactory implements WidgetFactory {
  AndroidButton createButton() => AndroidButton();
  AndroidCheckBox createCheckBox() => AndroidCheckBox();
}

class IosWidgetFactory implements WidgetFactory {
  IosButton createButton() => IosButton();
  IosCheckBox createCheckBox() => IosCheckBox();
}

void main() {
  final widgetFactory = IosWidgetFactory();
  final button = widgetFactory.createButton();
  final checkBox = widgetFactory.createCheckBox();
}

''',
  ),

  QA(
    q: '''Что такое Фабричный метод?''',
    a: '''
делегирует создание объектов подклассам,

abstract class NotificationWidget {}
class SuccessNotification extends NotificationWidget {}
class ErrorNotification extends NotificationWidget {}

enum NotificationType { success, error }

class NotificationFactory {
  static NotificationWidget create(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return SuccessNotification();
      case NotificationType.error:
        return ErrorNotification();
    }
  }
}

''',
  ),
  QA(
    q: 'Паттерн медиатор',
    a: r'''

// Медиатор - централизует коммуникацию между компонентами
abstract class ChatMediator {
  void sendMessage(String message, User sender);
  void addUser(User user);
}

// Конкретный медиатор
class ChatRoom implements ChatMediator {
  final List<User> _users = [];

  @override
  void addUser(User user) {
    _users.add(user);
  }

  @override
  void sendMessage(String message, User sender) {
    // Пересылаем сообщение всем пользователям кроме отправителя
    for (final user in _users) {
      if (user != sender) {
        user.receiveMessage(message, sender.name);
      }
    }
  }
}

// Коллеги - компоненты, которые общаются через медиатор
abstract class User {
  final String name;
  final ChatMediator mediator;

  User(this.name, this.mediator);

  void send(String message) {
    print('$name отправляет: $message');
    mediator.sendMessage(message, this);
  }

  void receiveMessage(String message, String senderName) {
    print('$name получил сообщение от $senderName: $message');
  }
}

// Конкретные коллеги
class RegularUser extends User {
  RegularUser(String name, ChatMediator mediator) : super(name, mediator);
}

class AdminUser extends User {
  AdminUser(String name, ChatMediator mediator) : super(name, mediator);

  @override
  void send(String message) {
    print('Админ $name объявляет: $message');
    mediator.sendMessage('[ADMIN] $message', this);
  }
}

// Использование
void main() {
  final chatRoom = ChatRoom();

  final user1 = RegularUser('Alice', chatRoom);
  final user2 = RegularUser('Bob', chatRoom);
  final admin = AdminUser('Admin', chatRoom);

  chatRoom.addUser(user1);
  chatRoom.addUser(user2);
  chatRoom.addUser(admin);

  user1.send('Привет всем!');
  // Output:
  // Alice отправляет: Привет всем!
  // Bob получил сообщение от Alice: Привет всем!
  // Admin получил сообщение от Alice: Привет всем!

  admin.send('Система будет перезагружена');
  // Output:
  // Админ Admin объявляет: Система будет перезагружена
  // Alice получил сообщение от Admin: [ADMIN] Система будет перезагружена
  // Bob получил сообщение от Admin: [ADMIN] Система будет перезагружена
}

''',
  ),
];



// QA(q: '''''', a: r'''
// '''),