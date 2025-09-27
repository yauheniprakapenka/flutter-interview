// ignore_for_file: unnecessary_string_escapes, unnecessary_raw_strings

import '../model/qa_model.dart';

const List<QA> dartInterviewQuestions = [
  QA(
    tags: [Tag.dart],
    q: 'В чём разница между final и const?',
    a: '''
🎯 final создает переменную, которая может быть инициализирована только один раз, но значение определяется во время runtime.

final String userName = getUserName(); // Значение определится при выполнении
final DateTime now = DateTime.now();   // Каждый раз разное значение
final List<int> numbers = [1, 2, 3];   // Список можно изменять

🎯 const создает константу, значение которой должно быть известно на этапе compile-time и никогда не изменится.

const String appName = 'MyApp';
const int maxUsers = 100;
const Duration timeout = Duration(seconds: 30);

💾 Оптимизация памяти:

final list1 = [1, 2, 3];        // Новый объект
final list2 = [1, 2, 3];        // Еще один новый объект
print(identical(list1, list2)); // false


const list1 = [1, 2, 3];  // Единственный объект
const list2 = [1, 2, 3];  // Ссылка на тот же объект
print(identical(list1, list2)); // true - экономия памяти!
  ''',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: 'Что такое Future и async/await?',
    a: '''
Future представляет значение, которое будет получено в будущем (например, результат асинхронной операции).
Ключевые слова async и await упрощают работу с Future: async обозначает функцию, возвращающую Future,
а await "приостанавливает" выполнение до получения результата.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое extension?',
    a: '''
механизм добавления новой функциональности к существующим типам без их модификации.

extension ExtensionName on TargetType {
  // методы, геттеры, сеттеры, операторы
}

extension StringX on String {
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работает оператор ?? и ??=',
    a: '''
??  возвращает правый операнд, если левый равен null. Например: a ?? b.
??= присваивает значение переменной только если она равна null, иначе оставляет существующее значение
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как обрабатываются ошибки в Dart?',
    a: 'Dart использует конструкцию try-catch-finally для обработки исключений. Также можно перехватывать определённые типы исключений и выбрасывать свои с помощью `throw`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Чем отличается var, dynamic и Object?',
    a: '''
var     → тип определяется компилятором один раз и становится фиксированным, дальше изменить его нельзя. Ошибки будут на этапе compile-time.
dynamic → переменная может хранить значения любых типов в любой момент, проверки типов откладываются на runtime. Ошибки ловятся только в runtime.


🎯 var - Автоматический вывод типа. Безопасность типов.

Когда вы пишете var x = 42, Dart анализирует значение и автоматически определяет тип переменной на этапе compile-time.
var x = 42;   // x теперь имеет тип int НАВСЕГДА
x = 'hello';  // ❌ ОШИБКА! Нельзя присвоить String в int
x = 3.14;     // ❌ ОШИБКА! Нельзя присвоить double в int
x = 100;      // ✅ ОК, это тоже int


🎯 dynamic - Отключение системы типов. Потеря безопасности.

dynamic говорит Dart: "Не проверяй типы, я сам знаю что делаю". Тип может меняться в любой момент.
dynamic y = 42;        // Сейчас int
print(y.runtimeType);  // int

y = 'hello';           // Теперь String
print(y.runtimeType);  // String

y = [1, 2, 3];         // Теперь List<int>
print(y.runtimeType);  // List<int>

y = true;              // Теперь bool
print(y.runtimeType);  // bool

dynamic - Отсутствие проверок во время компиляции:

dynamic obj = 'hello';
// Компилятор НЕ проверяет эти вызовы:
obj.someMethod();      // Компилируется, но упадет в runtime
obj.nonExistentField;  // Компилируется, но упадет в runtime
int result = obj + 10; // Компилируется, но упадет в runtime


🎯 Object - это базовый класс для всех non-nullable типов.

// Object - явное указание "любой non-null тип"
Object obj1 = 42; // int
Object obj2 = 'hello'; // String
Object obj3 = [1, 2, 3]; // List<int>

Object obj4 = null;      // ❌ ОШИБКА! Object не может быть null

Безопасность типов сохраняется
obj1.someMethod();       // ❌ ОШИБКА на этапе компиляции
obj1 + 10;               // ❌ ОШИБКА на этапе компиляции

Но можно безопасно кастовать с проверкой
if (obj1 is int) { // без проверки ошибка The operator '+' isn't defined for the type 'Object'.
  print(obj1 + 10); // ✅ ОК, тип проверен
}


// Object? может содержать null
Object? nullableObj = null;  // ✅ ОК
nullableObj = 42;           // ✅ ОК
nullableObj = 'hello';      // ✅ ОК

// Требует null-проверки
if (nullableObj != null) {
  print(nullableObj.toString()); // Безопасный доступ
}


⚖️ Рекомендации по выбору
Используйте в порядке приоритета:

- var - когда тип очевиден из контекста
- Конкретный тип (int, String) - когда тип известен
- Object/Object? - для полиморфизма с безопасностью
- dynamic - только в крайних случаях (FFI, JSON, JS interop)

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое late?',
    a: 'Модификатор `late` используется для отложенной инициализации переменных. Это особенно полезно, если значение переменной не может быть определено сразу, но точно будет задано до использования.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие есть способы итерации по коллекциям?',
    a: '''
🎯 1. for - когда нужен индекс

for (var i = 0; i < list.length; i++) {
  print(list[i]);
}

🎯 2. for-in - когда нужен только элемент

for (final value in list) {
  print(value);
}

🎯 3. forEach - Метод коллекции, принимает callback. Менее удобен для break/continue.

list.forEach((value) => print(value));

🎯 4. Итерация через Iterable API - Использование методов как .map, .where, .fold, .reduce для функционального обхода.

list.map((e) => e * 2).forEach(print);

🎯 5. while / do-while
Гибко, но чаще избыточно для простых коллекций.

var i = 0;
while (i < list.length) {
  print(list[i++]);
}

🎯 6. iterator вручную
Прямой доступ к Iterator для тонкого контроля.

final it = list.iterator;
while (it.moveNext()) {
  print(it.current);
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое const конструктор?',
    a: '''
const конструкторы позволяют создавать compile-time константные объекты, которые повторно используются.
Const-конструкторы позволяют Dart переиспользовать один и тот же экземпляр объекта при одинаковых параметрах, что снижает расход памяти.''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'В чём разница между static и instance переменными и методами?',
    a: '`static` переменные и методы принадлежат самому классу и доступны без создания экземпляра. Instance-переменные принадлежат конкретному объекту.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли переопределять операторы?',
    a: '''
Да, в Dart можно переопределять операторы. Используется ключевое слово operator.

Переопределяемые операторы:
+ - * / ~/ % << >> & | ^ < > <= >= == [] []= unary- unary~

class Vector2D {
  final double x, y;

  const Vector2D(this.x, this.y);

  // Арифметические операторы
  Vector2D operator +(Vector2D other) => Vector2D(x + other.x, y + other.y);
  Vector2D operator -(Vector2D other) => Vector2D(x - other.x, y - other.y);
  Vector2D operator *(double scalar) => Vector2D(x * scalar, y * scalar);
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое tear-off в Dart?',
    a: '''
Tear-off — это ссылка на метод или функцию без вызова.

// Обычный вызов метода
print('Hello'); // вызов

// Tear-off - ссылка на метод
var printFunction = print; // tear-off

printFunction('Hello'); // теперь можно вызвать
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как создать неизменяемый (immutable) объект в Dart?',
    a: 'Создать immutable-объект можно с помощью `final` полей и `const` конструктора.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое typedef?',
    a: '''
`typedef` используется для создания псевдонима типа функции. Это упрощает чтение кода.
Пример: `typedef IntCallback = void Function(int value);`.


typedef MyString = String;
MyString name = 'Hello';
MyString и String для Dart одно и то же. Компилятор не будет их различать.
Такой алиас имеет смысл только для читаемости (например, когда String в коде обозначает конкретную семантику: typedef UserId = String

🎯 Полезно при длинных generic-типах.

typedef IntMap = Map<String, int>;
IntMap scores = {'Alice': 10, 'Bob': 20};

🎯 Создает псевдонимы (aliases) существующих типов.

typedef ValueChanged<T> = void Function(T value);
typedef VoidCallback = void Function();

typedef IntList = List<int>;
typedef StringCallback = void Function(String);

void main() {
  List<int> list1 = [1, 2, 3];
  IntList list2 = [1, 2, 3];

  // Это один и тот же тип!
  print(list1.runtimeType == list2.runtimeType); // true

  // Можно присваивать друг другу без каста
  list1 = list2;
  list2 = list1;
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Как работает оператор `as` и чем отличается от `is`?',
    a: '`is` проверяет тип во время выполнения: `obj is String`. `as` выполняет приведение типа и выбрасывает исключение при ошибке: `obj as String`.',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое enum и можно ли добавлять к ним методы?',
    a: r'''
это тип, представляющий ограниченный набор именованных констант.

С Dart 2.17 появились улучшенные перечисления (enhanced enums), позволяющие:
- Добавлять поля (включая конструкторы, геттеры, сеттеры)
- Определять методы
- Иметь собственные значения (например, int, String)

enum Status {
  pending('В ожидании'),
  inProgress('В процессе'),
  done('Готово');

  final String label;
  const Status(this.label);

  bool get isFinal => this == Status.done;

  void log() => print('Текущий статус: $label');
}

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работает factory конструктор?',
    a: r'''
Factory-конструктор предоставляет полный контроль над процессом создания объекта и может:

- Возвращать существующий объект
- Выполнять логику перед созданием
- Возвращать подклассы или разные реализации


Может возвращать подклассы

abstract class Animal {
  void speak();

  factory Animal(String type) {
    switch (type) {
      case 'dog':
        return Dog();
      case 'cat':
        return Cat();
      default:
        throw ArgumentError('Unknown animal type: $type');
    }
  }
}

// Подклассы
class Dog implements Animal {
  @override
  void speak() => print("Woof!");
}

class Cat implements Animal {
  @override
  void speak() => print("Meow!");
}

void main() {
  Animal a1 = Animal('dog'); // Фактически вернется Dog
  Animal a2 = Animal('cat'); // Фактически вернется Cat

  a1.speak(); // Woof!
  a2.speak(); // Meow!
}


в factory конструкторе можно выполнять любую логику — это обычный метод, который просто должен вернуть экземпляр класса.

class User {
  final String name;
  final String email;
  final bool isValid;

  User(this.name, this.email, this.isValid);

  factory User(String name, String email) {
    // Валидация
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }

    return User(name, email, true);
  }
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли наследовать от нескольких классов в Dart?',
    a: 'Нет, Dart поддерживает только одиночное наследование. Для повторного использования кода следует использовать mixin.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как сравниваются объекты?',
    a: '''
1. По ссылке (identical)

final a = [1, 2, 3];
final b = [1, 2, 3];
final c = a;

print(identical(a, b)); // false - разные объекты
print(identical(a, c)); // true - та же ссылка
print(a == b);          // false - по умолчанию сравнение по ссылке



2. Переопределение == и hashCode

class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;        // 1 identical
    if (other is! Person) return false;             // 2 type
    return name == other.name && age == other.age;  // 3 fields
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode; // hashcode fields
}

После переопределения == и hashCode:

final p1 = Person('John', 25);
final p2 = Person('John', 25);
print(p1 == p2); // true

Без переопределения == и hashCode будет false


Правило: Всегда переопределяй hashCode при переопределении ==, иначе объекты не будут корректно работать в Set, Map и других коллекциях.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие есть способы создания неизменяемых коллекций?',
    a: '''
🎯 1. Использовать `const` для литералов: `const list = [1, 2]`.

🎯 2. Использовать Unmodifiable классы из `package:collection`, например `UnmodifiableListView`.

🎯 3. С Dart 2.17+: `List.unmodifiable()`
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работают getter и setter?',
    a: r'''
Getter и setter — это специальные методы для контролируемого доступа к свойствам класса.

Getter/setter обеспечивают инкапсуляцию и контроль доступа, оставаясь синтаксически простыми как обычные свойства.

class User {
  String _name; // Приватное поле

  User(this._name);

  String get name => _name; // Getter - получение значения

  set name(String value) { // Setter - установка значения
    if (value.isEmpty) throw ArgumentError('Name cannot be empty');
    _name = value;
  }
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие есть аннотации?',
    a: '''

В языке Dart аннотации (или метаданные) — это специальные маркеры, которые предоставляют дополнительную информацию компилятору,
инструментам разработки (IDE), а также другим разработчикам. Они не влияют на выполнение кода, но могут использоваться для генерации кода,
анализа, документирования и других целей.

🔧 Встроенные аннотации Dart

🎯 1. @override - Указывает, что метод, геттер или сеттер переопределяет суперкласс.

class Parent {
  void doSomething() {}
}

class Child extends Parent {
  @override
  void doSomething() {
    // переопределение
  }
}

🎯 2. @deprecated - предупреждают разработчиков об использовании устаревшего кода.

@deprecated
void oldMethod() {}

🎯 3. @protected - должен использоваться только внутри самого класса или его подклассов
Требует импорта: package:meta/meta.dart

class Vehicle {
  @protected
  void startEngine() {
    print('Engine started');
  }
}

class Car extends Vehicle {
  void drive() {
    startEngine(); // ✅ Правильно: использование protected метода в подклассе
  }
}

void main() {
  var car = Car();
  car.drive(); // Это нормально - вызов через публичный метод подкласса
}

🎯 4. @visibleForTesting - Помечает член класса как видимый только для тестирования.


🧩 Другие полезные аннотации из package:meta

dev_dependencies:
  meta: 1.11.0


🎯 @mustCallSuper - Требует, чтобы подкласс вызывал super.method() при переопределении метода.

abstract class StatefulWidget {
  @mustCallSuper
  void dispose() {}

  void build();
}

class MyWidget extends StatefulWidget {
  @override
  void dispose() {
    super.dispose(); // ✅ Правильно: вызываем super.dispose() в конце
  }

  @override
  void build() {
    print('MyWidget: building UI');
  }
}

🎯 @immutable - Анализатор будет предупреждать, если в классе есть изменяемые поля.

🎯 @sealed - Запрещает реализацию или наследование класса вне библиотеки, где он определён.

Используйте нативные sealed классы если:
- Вы используете Dart 3.0+
- Нужна гарантия полноты при pattern matching

Используйте @sealed аннотацию если:
- Вы используете Dart < 3.0
- Нужно просто документировать ограничения
- Хочется предупреждений, а не ошибок компиляции

🎯 @experimental - Предупреждает пользователей, что API может измениться.

🎯 @internal - Указывает, что предназначен только для внутреннего использования в пакете.

🎯 @pragma('vm:entry-point') - Назначение: Указывает, что функция или класс является точкой входа (например, для Flutter или AOT компиляции).

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое рефлексия (reflection)?',
    a: '''
Рефлексия позволяет исследовать структуру объектов во время выполнения с помощью dart:mirrors`.

Flutter её избегает, потому что `dart:mirrors` не поддерживается в tree-shaking и увеличивает размер приложения.

Рефлексия позволяет анализировать и изменять код во время выполнения — работать с классами, методами и свойствами динамически.
Когда используется рефлексия, компилятор не может статически определить, какой код действительно нужен, поэтому оставляет всё.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое tree-shaking и почему не работает с рефлексией?',
    a: '''
Tree-shaking — это процесс удаления неиспользуемого кода при компиляции для уменьшения размера финальной сборки.

class MathUtils {
  static int add(int a, int b) => a + b;
  static int multiply(int a, int b) => a * b;
  static int divide(int a, int b) => a ~/ b;  // Не используется
  static int subtract(int a, int b) => a - b; // Не используется
}

void main() {
  print(MathUtils.add(2, 3));
  print(MathUtils.multiply(4, 5));
  // divide и subtract не используются
}

После tree-shaking в финальной сборке останутся только add и multiply.



🎯 Platform-specific код:

if (Platform.isIOS) {
  // Android-код будет полностью удален в iOS-сборке
  return CupertinoButton(...);
} else {
  // iOS-код будет удален в Android-сборке
  return ElevatedButton(...);
}

Flutter автоматически выполняет tree-shaking в release-сборках, значительно уменьшая размер APK/IPA.

🎯 Tree-shaking НЕ работает с Рефлексией (dart:mirrors)

import 'dart:mirrors';

class UserService {
  void createUser() => print('Creating user');
  void deleteUser() => print('Deleting user');
  void updateUser() => print('Updating user');
}

void main() {
  final service = UserService();

  // Статически видно только это
  service.createUser();

  // Но через рефлексию можем вызвать что угодно
  final mirror = reflect(service);
  final methodName = getMethodFromConfig(); // Из конфига, API, etc
  mirror.invoke(Symbol(methodName), []);
}

String getMethodFromConfig() {
  // Может вернуть 'deleteUser', 'updateUser' или любой другой метод
  return 'deleteUser';
}

Проблема: Tree-shaker видит, что явно вызывается только createUser(), но из-за рефлексии не может гарантировать, что deleteUser() и updateUser() не понадобятся в рантайме.
Результат: Все методы остаются в финальной сборке.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие существуют способы объединения двух списков?',
    a: '''
🎯 использовать оператор spread (`...`): `[...list1, ...list2]`

🎯 метод `addAll()`

🎯 `List.from(list1)..addAll(list2)`. Для защиты от null — `...?list2`.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает метод `map()` у коллекций?',
    a: 'Метод `map()` преобразует каждый элемент коллекции в новый элемент и возвращает Iterable. Пример: `[1,2,3].map((e) => e * 2)` вернёт `(2,4,6)`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как безопасно работать с nullable-переменными?',
    a: 'Использовать null-aware операторы: `??`, `??=`, `?.`, `!...`, а также `required`, `late`, `assert()` и проверки на null вручную. Важно проектировать API так, чтобы null был осмыслен.',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: 'Как в Dart реализовать обработку таймаута при выполнении Future?',
    a: r'''
В Dart обработка таймаута при выполнении Future реализуется с помощью метода .timeout(Duration).

Он позволяет задать максимальное время ожидания выполнения Future.
Если Future не завершится за указанный период, будет выброшено исключение TimeoutException, либо можно вернуть значение-заглушку.

try {
  await longOperation().timeout(Duration(seconds: 2));
} on TimeoutException catch (e) {
  print('Таймаут: $e');
}

Таймаут отменяет выполнение Future?
- Нет. Он не отменяет выполнение Future, а просто игнорирует результат
''',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Можно ли задать таймаут для stream?',
    a: r'''
Да, можно

final stream = Stream<int>.periodic(Duration(seconds: 2), (x) => x);

stream
    .timeout(
      Duration(seconds: 1),
      onTimeout: (sink) => sink.addError('Timeout!'),
    )
    .listen(
      (event) => print('Received: $event'),
      onError: (e) => print('Error: $e'),
    );
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Чем отличаются Set, List и Map?',
    a: '`List` — упорядоченная коллекция с доступом по индексу. `Set` — неупорядоченное множество уникальных значений. `Map` — ассоциативный массив (ключ-значение).',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работает оператор `!` (null assertion)?',
    a: 'Оператор `!` говорит компилятору, что переменная точно не равна null. Если она всё же null — будет выброшано `NullThrownError` во время выполнения.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как повысить читаемость и поддерживаемость кода на Dart?',
    a: 'Придерживаться style guide (dart.dev/guides/language/effective-dart), использовать meaningful names, избегать дублирования, декомпозировать методы, использовать const и final, писать unit-тесты.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое Iterable и чем отличается от List?',
    a: '`Iterable` — это абстракция, представляющая последовательность элементов, по которым можно итерироваться. `List` — конкретная реализация Iterable с доступом по индексу.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как в Dart пишутся unit-тесты?',
    a: '''
dev_dependencies:
  test: 1.24.0

🎯 Основные функции
test() — определяет один тест.
group() — группирует тесты.
setUp() — выполняется перед каждым тестом.
expect() — проверяет, что значение соответствует ожиданию (например, equals(5)).

void main() {
  group('Calculator', () {
    late Calculator calculator;

    setUp(() {
      calculator = Calculator();
    });

    test('add returns correct result', () {
      expect(calculator.add(2, 3), equals(5));
    });

    test('subtract returns correct result', () {
      expect(calculator.subtract(5, 3), equals(2));
    });
  });
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое `assert()` и когда его использовать?',
    a: '`assert()` используется во время разработки для проверки условий. Если условие ложно — выбрасывается исключение. В релизной сборке `assert()` не выполняется.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какой инструмент в Dart используется для анализа кода?',
    a: 'Dart Analyzer (`dart analyze`) проверяет стиль, ошибки, предупреждения и потенциальные проблемы в коде. Поддерживает кастомные правила через `analysis_options.yaml`.',
  ),
  QA(
    tags: [Tag.dart, Tag.memory],
    q: 'Как избежать утечек памяти?',
    a: 'Вручную отписываться (`cancel()`), использовать `dispose()` и `finalize()` в соответствующих местах.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие инструменты предоставляет DevTools для анализа производительности?',
    a: 'Flutter DevTools включает: Inspector (древо виджетов), Performance (timeline), Memory, CPU Profiler, Network и Logging. Используется для анализа фризов, ликов, rebuild-ов.',
  ),
  QA(
    tags: [Tag.dart, Tag.oop],
    q: 'Можно ли создать конструктор в абстрактном классе?',
    a: r'''
Да, в Dart можно создавать конструкторы в абстрактных классах.
Это часто используется для инициализации общих полей или реализации общей логики в иерархии классов.

abstract class Animal {
  final String name;
  final int age;

  Animal(this.name, this.age); // Конструктор в абстрактном классе

  void makeSound(); // Абстрактный метод

  void introduce() { // Обычный метод
    print('Привет, меня зовут $name, мне $age лет');
  }
}

class Dog extends Animal {
  Dog(String name, int age) : super(name, age);

  @override
  void makeSound() {
    print('Гав-гав!');
  }
}

🎯 Особенности
- Абстрактный класс не может быть инстанцирован напрямую
- Конструктор вызывается через super() в подклассах
- Можно создавать паттерн фабричный метод

abstract class Shape {
  factory Shape(String type, double size) {
    if (type == 'circle') {
      return Circle(size);
    } else if (type == 'square') {
      return Square(size);
    }
    throw ArgumentError('Неизвестный тип фигуры: $type');
  }
}

class Circle implements Shape { }
class Square implements Shape { }

''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Как создать абстрактные переменные и методы в абстрактном классе?',
    a: '''
Абстрактные переменные реализуются через абстрактные геттеры/сеттеры
Все абстрактные члены обязательно должны быть переопределены в наследниках
Абстрактные методы объявляются без тела

abstract class Vehicle {
  String get brand;              // Абстрактный геттер

  set speed(double value);       // Абстрактный сеттер

  void startEngine();            // Абстрактный метод
}

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое `covariant`?',
    a: r'''
covariant - это модификатор, позволяющий переопределить тип параметра метода в подклассе
инвариантны - по умолчанию параметры в переопределениях

class Animal {}
class Dog extends Animal {}

class Base {
  void feed(Animal animal) {}
}

class Sub extends Base {
  @override
  void feed(Dog dog) {} // ❌ Ошибка без covariant!
}

✅ Решение: covariant

class Sub extends Base {
  @override
  void feed(covariant Dog dog) {
    print('Feeding dog: $dog');
  }
}

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работать с файлами в чистом Dart (без Flutter)?',
    a: r'''

🎯 readAsString() - Асинхронный метод
- Возвращает Future<String>
- Не блокирует основной поток
- Выполняется в фоне
- Используется с await или .then()
- Подходит для больших файлов

    final file = File('data.txt');
    final contents = await file.readAsString(); // Асинхронно


🎯 readAsStringSync() - Синхронный метод
- Блокирует основной поток до завершения операции
- Выполняется сразу и синхронно
- Подходит для маленьких файлов

    final file = File('data.txt');
    final contents = file.readAsStringSync(); // Синхронно


file.writeAsStringSync('Привет, мир!');
await file.writeAsString('Привет, мир!');


final file = File('data.txt');
if (await file.exists()) {
  print('Файл существует');
}


final file = File('image.jpg');
final bytes = await file.readAsBytes();


final dir = Directory('new_folder');
await dir.create();

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как сериализовать/десериализовать объекты в JSON?',
    a: 'С помощью `dart:convert`: `jsonEncode()` и `jsonDecode()`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли переопределить оператор `==` без переопределения `hashCode`?',
    a: 'Можно, но не нужно. Это нарушает контракт `Object`, что приводит к некорректной работе в `Set`, `Map` и других хэш-структурах.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какая разница между throw и rethrow?',
    a: r'''
throw
- Создает новый exception в стек-трейсе
- Теряет оригинальную информацию о месте возникновения ошибки
- Если нужно обернуть существующее с дополнительным контекстом.

rethrow
- Сохраняет оригинальный стек-трейс
- Можно использовать только внутри catch блока
- Если нужно пропустить дальше

// ❌ Плохо - теряем оригинальный стек-трейс
void badExample() {
  try {
    riskyOperation();
  } catch (e) {
    logger.error('Operation failed: $e');
    throw e; // Новый стек-трейс начинается здесь
  }
}

// ✅ Хорошо - сохраняем оригинальный стек-трейс
void goodExample() {
  try {
    riskyOperation();
  } catch (e) {
    logger.error('Operation failed: $e');
    rethrow; // Сохраняет место исходной ошибки
  }
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'В чём разница между `const []` и `List.empty(growable: false)`?',
    a: '`const []` создаёт compile-time константный список. `List.empty(growable: false)` — тоже неизменяемый, но создаётся во время runtime и не является const.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли создать enum с параметрами в Dart?',
    a: r'''
Да, в Dart 2.17+ можно создавать enum с параметрами, методами и геттерами.

1. Enum с конструктором и полями

enum Status {
  pending('В ожидании', Colors.orange),
  approved('Одобрено', Colors.green),
  rejected('Отклонено', Colors.red),
  cancelled('Отменено', Colors.grey);

  const Status(this.title, this.color);

  final String title;
  final Color color;
}

// Использование
final status = Status.approved;
print(status.title); // "Одобрено"
print(status.color); // Colors.green

2. Enum с методами

enum HttpMethod {
  get('GET', false),
  post('POST', true),
  put('PUT', true),
  delete('DELETE', false);

  const HttpMethod(this.name, this.hasBody);

  final String name;
  final bool hasBody;

  bool get isIdempotent => this == HttpMethod.get || this == HttpMethod.put;

  String buildRequest(String url, [Map<String, dynamic>? body]) {
    if (hasBody && body != null) {
      return '$name $url\nBody: ${jsonEncode(body)}';
    }
    return '$name $url';
  }
}

// Использование
final method = HttpMethod.post;
print(method.isIdempotent); // false
print(method.buildRequest('/api/users', {'name': 'John'}));

3. Enum с фабричными конструкторами

enum Environment {
  development._('dev', 'http://localhost:3000', true),
  staging._('stage', 'https://staging.app.com', true),
  production._('prod', 'https://app.com', false);

  const Environment._(this.shortName, this.baseUrl, this.debugMode);

  final String shortName;
  final String baseUrl;
  final bool debugMode;

  factory Environment.fromString(String value) {
    return Environment.values.firstWhere(
      (env) => env.shortName == value,
      orElse: () => Environment.development,
    );
  }

  String get apiUrl => '$baseUrl/api';
}

// Использование
final env = Environment.fromString('prod');
print(env.apiUrl); // "https://app.com/api"
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что произойдёт, если вы забудете закрыть ReceivePort, но убьёте Isolate?',
    a: 'Изолят завершит работу, но ReceivePort, оставаясь открытым в родителе, будет продолжать удерживать ссылку в event loop и не даст освободить связанные ресурсы — это приведёт к утечке памяти.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как избежать утечки памяти?',
    a: '''
_controller.dispose();
_subscription?.cancel();
_timer?.cancel();

void _cleanupIsolate() {
  _receivePort?.close();
  _sendPort = null;
  _isolate?.kill();
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое `dart:ffi`?',
    a: '`dart:ffi` позволяет вызывать C-функции и работать с нативной памятью из Dart-кода. Используется для низкоуровневых интеграций, например, с платформенными библиотеками.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает `build_runner` и как его использовать?',
    a: '`build_runner` управляет генерацией кода (например, для `json_serializable`, `freezed`). Запуск: `dart run build_runner build` или `watch` для слежения за изменениями.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли использовать разные версии одной зависимости в проекте?',
    a: '''
Нет, напрямую нельзя. В Flutter/Dart проекте может быть только одна версия каждой зависимости.

Почему так:

- Dart использует flat dependency resolution
- Pub solver выбирает единственную версию, совместимую со всеми constraints
- Конфликты версий приводят к ошибкам сборки

Что делать при конфликтах:

1) Dependency overrides (временное решение):
- dependency_overrides:
    package_name: 2.0.0

2) Обновить constraints всех зависимостей до совместимых версий
3) Форк проблемной зависимости и обновить её
4) Ждать обновления от мейнтейнеров
        ''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие бывают типы тестов?',
    a: '1) Unit-тесты — изолированная логика (быстро). 2) Widget-тесты — UI без устройства. 3) Integration-тесты — сквозные, с устройством/эмулятором',
  ),
  QA(
    tags: [Tag.flutter],
    q: 'Что такое golden tests в Flutter?',
    a: 'Это скриншотные тесты, которые сравнивают рендер UI с эталонным изображением. Используются для проверки визуальной регрессии.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как измерить производительность кода в Dart?',
    a: r'''

📌 Основные свойства Stopwatch:

В Dart для измерения производительности кода используют класс Stopwatch.
Он позволяет точно измерить время выполнения блока кода.

void main() {
  final stopwatch = Stopwatch()..start();

  // Код, производительность которого измеряем
  doSomethingHeavy();

  stopwatch.stop();
  print('Время выполнения: ${stopwatch.elapsedMilliseconds} мс');
}

void doSomethingHeavy() {
  for (var i = 0; i < 1000000; i++) {
    final _ = i * i;
  }
}

🧪 Продвинутый подход:

Для бенчмарков можно использовать сторонние пакеты, например:
benchmark_harness

Пример:
import 'package:benchmark_harness/benchmark_harness.dart';

class MyBenchmark extends BenchmarkBase {
  MyBenchmark() : super("MyBenchmark");

  @override
  void run() {
    // Код, который измеряется
    for (var i = 0; i < 100000; i++) {
      final _ = i * i;
    }
  }
}

void main() {
  MyBenchmark().report();
}

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как создать и использовать кастомную аннотацию в Dart?',
    a: '''
В Dart можно создавать кастомные аннотации для метаданных, хотя их возможности ограничены по сравнению с другими языками.

class Deprecated {
  final String reason;
  const Deprecated([this.reason = 'Use alternative']);
}

class JsonIgnore {
  const JsonIgnore();
}

// Использование
class User {
  final String name;

  User(this.name);

  @Deprecated('Use fullName instead')
  String get displayName => name;

  @JsonIgnore()
  String? password;
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое JS interop в Dart?',
    a: 'С помощью `package:js` можно вызывать JS-код и экспортировать Dart-функции. Используются аннотации `@JS()`, `@anonymous` и связываются с JS API.',
  ),

  QA(
    q: 'Что такое runZoned и runZonedGuarded?',
    a: r'''

📌 runZoned - Устаревший. Создает зону (изолированную область выполнения) с возможностью перехвата синхронных ошибок и управления контекстом.

Асинхронные ошибки не перехватывает

import 'dart:async';

void main() {
  runZoned(() {
    // Код в зоне
    print('В зоне');
    throw Exception('Синхронная ошибка');
  }, onError: (error, stack) {
    // Перехват синхронных ошибок
    print('Ошибка: $error');
  });

  print('Продолжение выполнения');
}


📌 runZonedGuarded - Рекомендуемый - перехватывает и синхронные, и асинхронные ошибки.

void main() {
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    // Глобальный обработчик ошибок
    print('Global error: $error');
    // Отправка в систему логирования
    // Crashlytics, Sentry и т.д.
  });
}


runZonedGuarded полностью совместим с async/await и перехватывает все асинхронные ошибки.

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDependencies();
    runApp(const MyApp());
  }, (error, stackTrace) {
    // Глобальный обработчик всех ошибок приложения
    logError(error, stackTrace);
    // Отправка в Crashlytics, Sentry и т.д.
  });
}

Future<void> initializeDependencies() async {
  // Асинхронная инициализация
  await SharedPreferences.getInstance();
  await Firebase.initializeApp();
}



runZonedGuarded не перехватывает ошибки в изолятах, потому что:

- Изоляты - это отдельные потоки выполнения
- Зоны работают только в рамках одного изолята
- Каждый изолят имеет собственное пространство памяти и выполнения


void main() {
  runZonedGuarded(() async {
    print('Основной изолят');

    // Создание нового изолята
    await Isolate.spawn(backgroundTask, 'data');

  }, (error, stack) {
    // Перехватывает ошибки только в основном изолятe
    print('Ошибка в основном изолятe: $error');
  });
}

// Функция для выполнения в отдельном изолятe
void backgroundTask(String data) {
  // Эта ошибка НЕ будет перехвачена runZonedGuarded из main()
  throw Exception('Ошибка в изолятe');
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Как обрабатывать ошибки в изолятах?',
    a: r'''
void main() {
  runZonedGuarded(() async {
    final receivePort = ReceivePort();

    final isolate = await Isolate.spawn(
      backgroundTask,
      receivePort.sendPort
    );

    receivePort.listen((message) {
      if (message is SendError) {
        print('Ошибка из изолята: ${message.error}');
      }
    });

  }, (error, stack) {
    print('Ошибка в основном изолятe: $error');
  });
}

class SendError {
  final Object error;
  final StackTrace stackTrace;
  SendError(this.error, this.stackTrace);
}

void backgroundTask(SendPort sendPort) {
  try {
    // Работа в изолятe
    throw Exception('Ошибка в фоновом изолятe');
  } catch (error, stack) {
    // Отправляем ошибку в основной изолят
    sendPort.send(SendError(error, stack));
  }
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое FlutterError.onError?',
    a: r'''
📌 это глобальный обработчик ошибок Flutter, который перехватывает исключения, возникающие во фреймворке Flutter.

void main() {
  // Настройка обработчика ошибок Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    // Логирование ошибки
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');

    // Отправка в сервис аналитики (например, Firebase Crashlytics)
    FirebaseCrashlytics.instance.recordFlutterError(details);

    // В debug режиме также показываем стандартный экран
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  runApp(MyApp());
}

📌 Создание кастомного экрана ошибки

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorWidget({required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Что-то пошло не так'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Произошла ошибка в приложении',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            if (kDebugMode) // Показываем детали только в debug режиме
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  errorDetails.exception.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  FlutterError.onError = (details) {
    _handleError(details.exception, details.stack);

    // Замена стандартного красного экрана на кастомный
    FlutterError.presentError(details);
  };

  // Кастомный виджет для ошибок
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorDetails: details);
  };

  runApp(MyApp());
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Разница между FlutterError.onError и runZonedGuarded',
    a: r'''

Решают разные задачи.

FlutterError.onError → только ошибки Flutter фреймворка
runZonedGuarded      → все неперехваченные исключения Dart

📌 void main() {
  // НЕПОЛНАЯ защита - только Flutter ошибки
  FlutterError.onError = (details) {
    print('Flutter Error: ${details.exception}');
  };

  runApp(MyApp());
}

📌void main() {
  // НЕПОЛНАЯ защита - не ловит Flutter фреймворк ошибки
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    print('Zone Error: $error');
  });
}

📌 Правильный подход

void main() {
  runZonedGuarded(() {
    // Перенаправляем Flutter ошибки в runZonedGuarded
    FlutterError.onError = (details) {
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.current
      );
    };

    runApp(const MyApp());
  }, (error, stackTrace) {
    // Единая точка обработки ВСЕХ ошибок
    print('Единый обработчик: $error');

    // Отправка в Crashlytics, Sentry и т.д.
    reportError(error, stackTrace);
  });
}
''',
  ),

  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Изоляты общаются копированием или ссылками?',
    a: '''
Изоляты общаются КОПИРОВАНИЕМ, не ссылками! Это фундаментальный принцип безопасности и изоляции в Dart.

Концептуальные принципы изолятов:

📌 Копирование значений:
Простые типы (int, String, bool) копируются полностью
Списки и Map копируются как новые объекты

📌 Нет общей памяти:
// Нельзя передать ссылку на объект напрямую
// sendPort.send(sharedObjectReference); // Ошибка!

📌 Нужно сериализовать данные для передачи
sendPort.send({'data': [1, 2, 3], 'type': 'array'});
''',
  ),

  QA(
    tags: [Tag.dart, Tag.isolate, Tag.memory],
    q: 'Что такое TransferableTypedData?',
    a: r'''
TransferableTypedData — это обёртка для эффективной передачи больших массивов данных между изолятами без копирования в памяти.

Концептуальные аспекты:
- Zero-copy передача — данные не копируются, а передаются по ссылке
- Работа с изолятами — основное предназначение для многопоточности
- Владение данными — после передачи оригинальные данные становятся недоступны
- Производительность — критично для больших объемов данных
- Ограничения использования — только типизированные массивы

// TransferableTypedData - это обёртка для TypedData
abstract final class TransferableTypedData {
  // Создание из списка типизированных массивов
  external factory TransferableTypedData.fromList(List<TypedData> list);

  // Материализация данных в новом изоляте
  List<ByteBuffer> materialize();
}

🎯 Что происходит на уровне памяти:

ДО передачи:
┌─────────────────┐
│   ОЗУ           │
├─────────────────┤
│  [1,2,3,...]    │ ← Оригинальные данные (адрес: 0x123456)
│  ↑              │
│ originalData    │
└─────────────────┘

ПОСЛЕ обычной передачи:
┌─────────────────┐
│   ОЗУ           │
├─────────────────┤
│  [1,2,3,...]    │ ← Оригинальные данные (адрес: 0x123456)
│  ↑              │
│ originalData    │
├─────────────────┤
│  [1,2,3,...]    │ ← КОПИЯ данных (адрес: 0x789012)
│                 │   ← Эта копия передается в изолят
└─────────────────┘

ИТОГО: Использовано 2 МБ памяти вместо 1 МБ!

🎯 Если нужно избежать копирования и передать данные «по ссылке» (zero-copy), то надо использовать TransferableTypedData:

// ✅ ZERO-COPY передача
final ttd = TransferableTypedData.fromList([originalData]);
sendPort.send([ttd, answerPort.sendPort]);

1️⃣ В момент sendPort.send(...)
- Dart не копирует байты из originalData.
- Вместо этого он «отцепляет» внутренний буфер Uint8List от main изолята.
- Этот буфер теперь недоступен в main — любая попытка обратиться к originalData вызовет StateError («buffer detached»).
- Владение памятью переходит изоляту-получателю.

2️⃣ В изоляте-получателе

final ttd = message[0] as TransferableTypedData;
final data = ttd.materialize().asUint8List();

ttd.materialize() возвращает ByteBuffer из переданного объекта.
.asUint8List() даёт обычный Uint8List поверх этого же буфера (без копирования).
Теперь этот изолят — единственный владелец этого блока памяти и может читать/писать в него напрямую.


🎯 materialize() в TransferableTypedData — это метод, который «разворачивает» (материализует)
переданные данные обратно в реальный доступный блок памяти, чтобы работать с ним как с обычным ByteBuffer/Uint8List.

Когда создаем TransferableTypedData и передаем его через изолят:
1) В исходном изоляте данные отцепляются от своего исходного буфера и становятся недоступны (владение памятью переходит).
2) В получающем изоляте получаем «запакованный» объект TransferableTypedData, который ещё нельзя напрямую использовать.
3) Вызов .materialize() отдаёт тебе уже готовый ByteBuffer, который и есть та же самая память, но теперь доступная в этом изоляте.

''',
  ),

  QA(
    tags: [Tag.dart, Tag.memory, Tag.isolate],
    q: 'Что такое Указатель в памяти?',
    a: '''
Указатель — это переменная, которая хранит адрес в памяти, где находятся какие-то данные.

// Представим память как массив ячеек:
Память:
┌───────┬───────┬───────┬───────┬───────┐
│ 0x1000│ 0x1001│ 0x1002│ 0x1003│ 0x1004│ ← Адреса
├───────┼───────┼───────┼───────┼───────┤
│   1   │   2   │   3   │   4   │   5   │ ← Значения
└───────┴───────┴───────┴───────┴───────┘

// Указатель:
int* pointer = 0x1000;  // Указывает на первую ячейку

// Доступ к данным через указатель:
print(*pointer);     // Выводит: 1
print(*(pointer+1)); // Выводит: 2 (следующий элемент)

 В контексте Dart и изолятов:

🎯 Обычная передача (Uint8List)

Main Isolate:   pointer1 → [данные по адресу 0x1000]
Worker Isolate: pointer2 → [КОПИЯ данных по адресу 0x2000]

- pointer1 остаётся указывать на свой буфер в памяти main изолята (0x1000).
- pointer2 создаётся в heap воркера и указывает на новый буфер (0x2000), в который Dart побайтно скопировал данные.

Эти буферы живут в разных кучах (heap) — у каждого изолята свой GC и память.

Изменения через pointer2 не влияют на данные, на которые указывает pointer1, и наоборот.

🎯 Zero-copy через TransferableTypedData

ДО передачи:
Main Isolate:   pointer1 → [данные по адресу 0x1000]

ПОСЛЕ передачи:
Main Isolate:   pointer1 → ❌ (инвалидирован)
Worker Isolate: pointer2 → [данные по адресу 0x1000]

- TransferableTypedData — это передача владения буфером.
- При отправке Dart не копирует байты, а отдаёт сам блок памяти воркеру.
- pointer1 в main изоляте становится инвалидированным — Dart запрещает доступ к буферу, чтобы два изолята не трогали одну память одновременно (безопасность, изоляция GC).
- pointer2 в воркере теперь указывает на тот же самый адрес в памяти (0x1000) и получает эксклюзивное право на работу с этим буфером.

Изоляты принципиально не разделяют память, чтобы избежать гонок данных и проблем с синхронизацией.
TransferableTypedData — исключение, но оно не делает shared-memory, а именно передаёт владение (move semantics).
''',
  ),

  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Что такое isolates и как они взаимодействуют между собой?',
    a: 'Isolates — это отдельные потоки с собственной памятью. Они общаются друг с другом через обмен сообщениями (SendPort/ReceivePort), что исключает состояние гонок.',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: 'В чём особенность оператора `await` в цикле?',
    a: '''
Использование `await` внутри цикла последовательно ожидает завершения каждого Future, что может замедлить выполнение.
Чтобы выполнять задачи параллельно, лучше собрать все Future в список и использовать await Future.wait().
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое рекурсия и есть ли ограничения по глубине?',
    a: '''
Рекурсия — вызов функции самой себя. Ограничения зависят от размера стека — слишком глубокая рекурсия приведёт к StackOverflowError.

/// Рекурсивное вычисление факториала
int factorial(int n) {
  // Базовый случай: факториал 0 и 1 равен 1
  if (n <= 1) {
    return 1;
  }
  // Рекурсивный случай: n! = n * (n-1)!
  return n * factorial(n - 1);
}

void main() {
  print(factorial(5)); // Вывод: 120
  print(factorial(0)); // Вывод: 1
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое shadowing переменных в Dart и как его избежать?',
    a: 'Shadowing — когда локальная переменная или параметр имеет то же имя, что и внешняя переменная, что может приводить к ошибкам. Избегают переименованием переменных или уменьшением области видимости.',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое cascade notation (каскадный оператор)?',
    a: '''
Cascade notation (..) позволяет выполнять последовательность операций над одним объектом без необходимости повторно ссылаться на него.

// Обычный подход
var list = <int>[];
list.add(1);
list.add(2);
list.add(3);

// cascade notation
var list = <int>[]
  ..add(1)
  ..add(2)
  ..add(3);
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое `await for` и где он применяется?',
    a: r'''
`await for` используется для асинхронной итерации по Stream, позволяя обрабатывать события по мере их поступления.

Stream<int> counterStream() async* {
  for (int i = 0; i < 3; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  await for (final value in counterStream()) {
    print('Получено: $value');
  }
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работает оператор `is!` в Dart?',
    a: 'Оператор `is!` проверяет, что объект не является заданным типом. Например, `if (obj is! String)` означает "если obj не строка".',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие ограничения у const переменных и конструкторов?',
    a: '''
Класс с const конструктором может иметь только final поля.

class A {
  final int x;
  const A(this.x); // ок
}

const factory возможен, но возвращаемый объект должен быть const.


Компилируемое значение:
const переменная должна быть инициализирована значением, известным во время компиляции.
const a = 5; // ок
const b = DateTime.now(); // ошибка
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое ключевое слово this?',
    a: '''
Это ссылка на текущий экземпляр класса.

🎯 1. Разрешение конфликта имен
class User {
  String name;

  User(String name) {
    this.name = name; // this обязательно для различения параметра и поля
  }
}

🎯 2. Явное обращение к свойствам класса

class Widget {
  String title = 'Default';

  void updateTitle(String newTitle) {
    this.title = newTitle; // this опционально, но улучшает читаемость
  }

  void printInfo() {
    print(this.title); // то же, что print(title)
  }
}

this нельзя использовать в статических методах
В большинстве случаев this опускается для краткости
Обязательно только при конфликте имен или явной передаче экземпляра
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое `deferred` загрузка?',
    a: '''
deferred используется для отложенной (ленивой) загрузки библиотек.

Это значит, что библиотека не подгружается при старте программы, а только в тот момент, когда она реально понадобится.

import 'heavy_library.dart' deferred as heavy;

Future<void> main() async {
  print("Программа стартовала");
  // Код из heavy_library пока не загружен
  await heavy.loadLibrary(); // <- Загрузка библиотеки
  print(heavy.heavyFunction()); // теперь можно вызывать
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое `call` метод?',
    a: 'Метод `call` позволяет экземплярам классов вести себя как функции, позволяя вызывать объект как `instance()`.',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Что такое Stream?',
    a: 'Stream — это асинхронная последовательность событий (данных), которую можно слушать и обрабатывать по мере поступления.',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Когда использовать single-subscription Stream?',
    a: 'Когда поток должен иметь одного слушателя, например, для обработки результатов операций или передачи данных одному потребителю.',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Когда использовать broadcast Stream?',
    a: 'Если нужно несколько слушателей для одного потока.',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Как подписаться на Stream?',
    a: 'С помощью метода `listen()`, который принимает callback для обработки событий, ошибок и завершения.',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Как отменить подписку на Stream?',
    a: 'Вызвать `cancel()` у объекта `StreamSubscription`, возвращаемого `listen()`.',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Что такое StreamController?',
    a: '''
StreamController позволяет создавать и управлять Stream вручную, добавлять события и ошибки.

class UserRepository {
  final _controller = StreamController<List<User>>.broadcast();

  Stream<List<User>> get usersStream => _controller.stream;

  void updateUsers(List<User> users) {
    _controller.add(List.unmodifiable(users));
  }

  void dispose() {
    _controller.close();
  }
}
''',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Что делают методы `where()` и `take()` у Stream?',
    a: '`where()` фильтрует события по условию, `take()` берёт только указанное число событий из начала потока.',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Как объединить несколько Stream в один?',
    a: '''
import 'package:rxdart/rxdart.dart';

final stream1 = Stream.value(1);
final stream2 = Stream.value(2);

MergeStream([stream1, stream2]).listen(print); // 1, 2
''',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Как обработать ошибки в Stream?',
    a: r'''
🎯 1. Обработка через listen

myStream.listen(
  (data) {
    print('Получены данные: $data');
  },
  onError: (error, stackTrace) {
    print('Ошибка: $error');
  },
  onDone: () {
    print('Стрим завершён');
  },
  cancelOnError: true, // необязательно: автоматически завершает подписку при ошибке
);

🎯 2. Обработка через handleError

myStream
  .handleError((error) {
    print('Ошибка внутри handleError: $error');
  })
  .listen((data) {
    print('Данные: $data');
  });

Отличие: handleError может фильтровать, какие ошибки ловить.

myStream.handleError(
  (error) => print('Ловим только FormatException: $error'),
  test: (e) => e is FormatException,
).listen((data) => print('Данные: $data'));

🎯 3. Обработка в async* генераторах

Stream<int> numbers() async* {
  try {
    for (int i = 0; i < 5; i++) {
      if (i == 3) throw Exception("Ошибка на $i");
      yield i;
    }
  } catch (e, st) {
    print("Поймали ошибку: $e");
    rethrow; // или можно не выбрасывать дальше
  }
}

🎯 4. В StreamBuilder

StreamBuilder<int>(
  stream: myStream,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Ошибка: ${snapshot.error}');
    }
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    return Text('Данные: ${snapshot.data}');
  },
);

''',
  ),
  QA(
    tags: [Tag.dart, Tag.stream],
    q: 'Что такое `async*` и `yield` в контексте Stream?',
    a: '`async*` используется для создания асинхронных генераторов Stream, а `yield` — для добавления событий в поток.',
  ),
  QA(
    q: 'Как превратить Stream в Future?',
    a: 'Использовать методы `first`, `last`, `single` или `toList()` для получения результата из Stream как Future.',
  ),
  QA(
    q: 'Какие есть способы создания Stream?',
    a: '''
🎯 1. Async generator
Stream<int> asyncGenerator() async* {
  yield 1;
  yield 2;
}

🎯 2. StreamController
final controller = StreamController<String>();
controller.add('data');
Stream<String> stream = controller.stream;

🎯 3. Stream.fromIterable
Stream<String> fromList = Stream.fromIterable(['a', 'b', 'c']);

🎯 4. Stream.periodic
Stream<int> periodic = Stream.periodic(
  Duration(seconds: 1),
  (count) => count,
);

🎯 5. Stream.fromFuture
Stream<String> fromFuture = Stream.fromFuture(fetchData());
''',
  ),
  QA(
    q: 'Что такое broadcast Stream и как его создавать?',
    a: r'''
Позволяет иметь множество слушателей.

🎯 Из обычного Stream:
final streamController = StreamController<int>();
final broadcastStream = streamController.stream.asBroadcastStream();

🎯 Сразу как Broadcast Stream:
final broadcastController = StreamController<int>.broadcast();

- Каждый подписчик получает одно и то же событие, если он подписан до или во время его эмиссии.
- Подписчики не получают прошлых событий.
- Если один из подписчиков отменяется (unsubscribe), остальные продолжают получать данные.

final controller = StreamController<String>.broadcast();

controller.stream.listen((data) => print('Listener A: $data'));
controller.stream.listen((data) => print('Listener B: $data'));

controller.add('Hello');
// Выведет:
// Listener A: Hello
// Listener B: Hello
''',
  ),
  QA(
    q: 'Что такое StreamTransformer?',
    a: '''
Иногда стандартных операторов потоков (map, where, take и т.п.) недостаточно.
StreamTransformer даёт возможность создать свой кастомный оператор для стримов.

Допустим, есть поток чисел, и хотим умножать их на 10:

import 'dart:async';

final multiplyByTen = StreamTransformer<int, int>.fromHandlers(
  handleData: (value, sink) {
    sink.add(value * 10);
  },
);

void main() {
  final stream = Stream.fromIterable([1, 2, 3, 4]);

  stream
      .transform(multiplyByTen)
      .listen((data) => print(data)); // 10, 20, 30, 40
}

Здесь:
- StreamTransformer<int, int> означает: входной тип int, выходной тип тоже int.
- handleData получает элемент value и sink, через который мы добавляем новые данные.
- Можно фильтровать, модифицировать или даже игнорировать входные значения.
''',
  ),
  QA(
    q: 'Что такое Future?',
    a: 'Future представляет собой объект, который будет содержать результат асинхронной операции в будущем либо ошибку.',
  ),
  QA(
    q: 'Чем Future отличается от Stream?',
    a: 'Future возвращает единственное асинхронное значение, Stream — последовательность значений во времени.',
  ),
  QA(
    q: 'Как создать Future?',
    a: 'Можно использовать конструктор `Future(() => value)`, фабричный метод `Future.value()`, или async-функции, которые автоматически возвращают Future.',
  ),
  QA(
    q: 'Как обработать результат Future?',
    a: 'С помощью `then()` для успешного результата, `catchError()` — для ошибок, и `whenComplete()` — для кода, который выполняется в любом случае.',
  ),
  QA(
    q: 'Что такое цепочки Future?',
    a: 'Цепочки Future — последовательный вызов `then()`, где результат одного Future передается следующему, позволяя организовать последовательный асинхронный код.',
  ),
  QA(
    q: 'Что происходит, если не обработать ошибку в Future?',
    a: 'Необработанная ошибка приводит к необработанному исключению (unhandled exception), что может вызвать сбой приложения или вывод предупреждения.',
  ),
  QA(
    q: 'Как отменить выполнение Future?',
    a: 'Стандартный Future нельзя отменить напрямую. Для отмены используют дополнительные механизмы — например, Stream с поддержкой отмены или собственные контроллеры.',
  ),
  QA(
    q: 'Что делает метод `Future.wait()`?',
    a: 'Ожидает завершения нескольких Future одновременно и возвращает Future с результатами всех, или ошибку при любом сбое.',
  ),
  QA(
    q: 'Как использовать `Future.delayed()`?',
    a: 'Создает Future, который завершится через заданный промежуток времени, часто используется для имитации задержек или таймаутов.',
  ),
  QA(
    q: 'В чём разница между `then()` и `await`?',
    a: '`then()` — метод Future для обработки результата через callback, `await` — синтаксический сахар, делающий асинхронный код похожим на синхронный.',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: 'Что такое eagerError в Future.wait([], eagerError: true) ?',
    a: '''
Если eagerError = false (по умолчанию):
Future.wait ждёт завершения всех futures. Даже если одна из них упала с ошибкой, другие будут выполняться до конца.
Итоговый Future завершится с ошибкой (первой попавшейся), но только после того, как все остальные завершатся.

Если eagerError = true:
Future.wait завершится сразу, как только хоть один Future упадёт с ошибкой.
Остальные могут продолжать выполняться «в фоне», но результат wait уже будет завершён с ошибкой.
''',
  ),
  QA(
    q: 'Как обрабатывать несколько Future с разным временем выполнения?',
    a: 'Используют `Future.wait()`, `Future.any()`, `Future.wait([...], eagerError: true)`, или комбинируют с async/await и обработкой исключений.',
  ),
  QA(
    q: 'Что такое `Future.sync()`?',
    a: r'''
Метод для создания Future, который выполняется синхронно или асинхронен, но возвращает Future для совместимости.

Future.sync выполняется СИНХРОННО, не попадая ни в какую очередь

  // Future.sync - выполняется НЕМЕДЛЕННО
  Future.sync(() {
    print('2: Future.sync выполнен');
    return 'sync result';
  }).then((value) {
    print('3: Future.sync.then - попадает в MICROTASK QUEUE');
  });

- Когда нужно гарантированно вернуть Future, но функция может вернуть как T, так и Future<T>;

Future<void> main() async {
  print('Start');

  final future = Future.sync(() {
    print('Inside sync');
    return 'result';
  });

  future.then((value) => print('Value: $value'));

  print('End');
}

Start
Inside sync
End
Value: result
''',
  ),
  QA(
    q: 'Можно ли вернуть Future из синхронной функции?',
    a: 'Нет, функция должна быть помечена как `async` или явно возвращать Future, иначе вернется обычное значение.',
  ),

  QA(
    q: 'Что такое `FutureOr`?',
    a: '`FutureOr<T>` — тип, который может быть либо `T`, либо `Future<T>`. Используется для написания функций, которые могут возвращать сразу значение или Future.',
  ),
  QA(
    q: 'Как ловить исключения в async-функциях?',
    a: '''
Через блоки `try-catch` вокруг `await` или обработчики `catchError()` у Future.

Необработанные ошибки Future становятся необработанными исключениями (unhandled exceptions), что может привести к завершению программы или предупреждениям во время выполнения.''',
  ),
  QA(
    q: 'Какие очереди существуют в Dart event loop?',
    a: '''
🎯 Event loop работает по принципу:
1. Проверяет очередь микрозадач (microtask queue) — выполняет все микрозадачи
2. Проверяет очередь событий (event queue) — выполняет одну задачу из очереди событий
3. Повторяет цикл до тех пор, пока обе очереди не станут пустыми

🎯 Две очереди задач:

1. Microtask Queue (очередь микрозадач)
- Имеет высший приоритет
- Содержит задачи от scheduleMicrotask() и завершенные Future
- Выполняется полностью перед проверкой event queue

2. Event Queue (очередь событий)
- Содержит I/O события, таймеры, пользовательские события
- Выполняется по одной задаче за итерацию
''',
  ),
  QA(
    q: 'Как работает Future в контексте event loop?',
    a: 'Future помещает свои callback’и в очередь микротасков, которые выполняются после завершения текущего синхронного кода.',
  ),
  QA(
    q: 'Что произойдёт, если микротаски добавляются рекурсивно?',
    a: 'Микротаски выполняются до тех пор, пока очередь не опустеет. Рекурсивное добавление может заблокировать event loop, не давая обрабатываться событиям.',
  ),
  QA(
    q: 'Какова последовательность выполнения кода с async/await и event loop?',
    a: 'Сначала выполняется весь синхронный код, затем микротаски (callback-и Future), потом события (например, таймеры).',
  ),
  QA(
    q: 'В какую очередь попадает Timer?',
    a: 'Timer — событие, которое попадает в очередь событий (event queue) и выполняется после микротасков.',
  ),
  QA(
    q: 'Как можно заставить event loop выполнить код позже, чем microtask?',
    a: '''
- использовать Future без Future.microtask()
- Код из обычной Future, Timer, и т.п. попадает в event queue и выполняется позже, после всех microtask'ов.

Future(() {
  // Этот код выполнится позже, чем любой microtask
});

Timer.run(() {
  // Также выполнится в следующем event loop
});

void main() {
  print('1. sync start');
  Timer.run(() => print('2. event loop Timer.run'));
  Future(() => print('3. event loop Future()'));
  Future.delayed(Duration.zero, () => print('4. event loop delayed'));
  scheduleMicrotask(() => print('5. microtask via scheduleMicrotask'));
  Future.microtask(() => print('6. microtask via Future.microtask'));
  print('7. sync end');
}

1. sync start
7. sync end
5. microtask via scheduleMicrotask
6. microtask via Future.microtask
2. event loop Timer.run
3. event loop Future()
4. event loop delayed
''',
  ),
  QA(
    q: 'Какие задачи лучше помещать в микротаски, а какие в события?',
    a: '''
Правило: Если операция влияет на текущий фрейм — микротаска. Если может подождать — событие.

🎯 Микротаски (microtasks):

- Операции, которые должны выполниться до следующего фрейма
- Future.then(), async/await completions
- Schedulers.instance.addPostFrameCallback() callbacks
- Критичные по времени операции, которые блокируют отрисовку

// Плохо - блокирует UI
Future.microtask(() {
  // Тяжелые вычисления
  heavyComputation();
});

// Хорошо - для легких операций после build
Future.microtask(() {
  // Обновление состояния после build
  controller.updateAfterBuild();
});

🎯 События (events/timers):

- Операции, которые могут подождать следующий event loop
- Timer callbacks, Stream events
- I/O операции, HTTP запросы
- Тяжелые вычисления, которые можно отложить
''',
  ),
  QA(
    q: 'Как event loop влияет на производительность UI в Flutter?',
    a: 'Event loop управляет обработкой событий UI и асинхронных задач. Блокировка микротасков или долгие операции могут вызвать подвисание интерфейса.',
  ),
  QA(
    q: 'Как отменить задачу, поставленную в микротаск?',
    a: '''
В Dart нет прямого способа отменить уже поставленную микрозадачу.

Альтернатива через Future с возможностью отмены

import 'dart:async';

class CancelToken {
  bool _cancelled = false;
  bool get cancelled => _cancelled;

  void cancel() => _cancelled = true;
}

Future<void> cancellableTask(CancelToken token, void Function() callback) {
  final completer = Completer<void>();

  scheduleMicrotask(() {
    if (token.cancelled) {
      completer.complete();
      return;
    }
    callback();
    completer.complete();
  });

  return completer.future;
}

void main() async {
  final token = CancelToken();

  cancellableTask(token, () => print('Задача выполнена'));
  token.cancel(); // Отменяем

  await Future.delayed(Duration(milliseconds: 1));
  print('Программа завершена');
}
''',
  ),
  QA(
    q: 'Что такое "run-to-completion" модель в Dart event loop?',
    a: 'Каждая задача (микротаск или событие) выполняется полностью до завершения, без прерывания, что предотвращает состояние гонок.',
  ),
  QA(
    q: 'Какая разница между `Future.microtask()` и `scheduleMicrotask()`?',
    a: r'''
Future.microtask() и scheduleMicrotask() — запускают код в микрозадаче, но есть отличие.

✅ 1. scheduleMicrotask()
— напрямую ставит задачу в очередь микрозадач
- Не возвращает Future, без await
- Обработка ошибок:	Только через Zone

void main() {
  scheduleMicrotask(() => print('microtask'));
  print('main');
}
📌 Вывод:
main
microtask

✅ 2. Future.microtask()
— тоже микрозадача, но возвращает Future
- Обработка ошибок: Через .catchError() или try

void main() {
  Future.microtask(() => print('microtask'));
  print('main');
}
📌 Вывод — тот же:
main
microtask
Future.microtask() возвращает объект Future — его можно await, then, и обрабатывать ошибки через .catchError.

import 'dart:async';

void main() {
  runZonedGuarded(
    () {
      scheduleMicrotask(() {
        throw Exception('Ошибка в микрозадаче');
      });
    },
    (error, stack) {
      print('Перехвачена ошибка: $error');
    },
  );
}


''',
  ),
  QA(
    q: 'В чём разница между параллелизмом и конкурентностью?',
    a: '''
Конкуренция — управление несколькими задачами на одном ядре
Параллелизм — выполнение нескольких задач одновременно на разных ядрах CPU
''',
  ),
  QA(
    q: 'Почему Dart не использует потоки (threads) с общей памятью?',
    a: 'Чтобы избежать сложных ошибок, связанных с состоянием гонок и синхронизацией, Dart использует изолированные Isolates с копированием сообщений.',
  ),
  QA(
    q: 'Как в Dart реализуется concurrency?',
    a: '''
Через асинхронное программирование с Future, async/await и event loop, где задачи выполняются по очереди на одном ядре.

Ключевые моменты:
Main isolate — для UI и легких операций
Для Flutter-приложений обычно достаточно async/await + compute() для редких heavy operations.
''',
  ),
  QA(
    q: 'Можно ли в Dart выполнять одновременно несколько Future параллельно?',
    a: r'''

Future выполняются в рамках одного event loop, то есть конкурентно, но не параллельно

В Dart есть несколько способов выполнения Future параллельно.
Важно понимать, что это конкурентное выполнение в рамках одного изолята, а НЕ истинный параллелизм.

Future.wait() - самый популярный способ

Future<void> parallelExecution() async {
  // Запускаем все Future одновременно
  final futures = [
    fetchUserData(),      // 2 сек
    fetchWeatherData(),   // 1 сек
    fetchNewsData(),      // 3 сек
  ];

  try {
    // Ждем завершения всех Future (время выполнения ≈ 3 сек, не 6!)
    final results = await Future.wait(futures);

    final userData = results[0];
    final weatherData = results[1];
    final newsData = results[2];

    print('Все данные получены!');
  } catch (e) {
    print('Ошибка в одном из Future: $e');
  }
}

// Симуляция асинхронных операций
Future<String> fetchUserData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'User data';
}

Future<String> fetchWeatherData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Weather data';
}

Future<String> fetchNewsData() async {
  await Future.delayed(Duration(seconds: 3));
  return 'News data';
}
''',
  ),
  QA(
    q: 'Можно ли внутри изолята выполнить Future?',
    a: r'''
Да, можно.

📌 Пример 1: Базовое использование

void main() async {
  final ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(isolateFunction, receivePort.sendPort);
  final result = await receivePort.first;
  print(result); // "Данные из изолята получены!"
  receivePort.close();
}

// Функция, которая будет выполняться в изоляте
Future<void> isolateFunction(SendPort sendPort) async {
  // Future работает внутри изолята
  final result = await Future.delayed(
    Duration(seconds: 2),
    () => 'Данные из изолята получены!',
  );

  // Отправляем результат обратно
  sendPort.send(result);
}


📌 Пример 2: Тяжелые вычисления с HTTP запросом

// Функция изолята с HTTP запросом
void heavyWorkIsolate(List<dynamic> args) async {
  SendPort sendPort = args[0];
  String url = args[1];

  try {
    // Future для HTTP запроса внутри изолята
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final data = await response.transform(utf8.decoder).join();

    // Обработка данных (тяжелая работа)
    await Future.delayed(Duration(seconds: 1)); // Симуляция обработки

    sendPort.send({'success': true, 'data': data.length});
    client.close();
  } catch (e) {
    sendPort.send({'success': false, 'error': e.toString()});
  }
}

// Использование
void main() async {
  final receivePort = ReceivePort();

  // Запускаем изолят с параметрами
  await Isolate.spawn(
    heavyWorkIsolate,
    [receivePort.sendPort, 'https://jsonplaceholder.typicode.com/posts']
  );

  final result = await receivePort.first;
  print('Результат: $result');

  receivePort.close();
}

''',
  ),
  QA(
    q: 'Что такое "shared nothing" модель в контексте Isolates?',
    a: 'Каждый Isolate имеет свою память и не делит состояние с другими Isolate, что упрощает параллелизм без гонок.',
  ),
  QA(
    q: 'Чем отличаются синхронные генераторы (Iterable) от асинхронных (Stream)?',
    a: 'Синхронные генераторы возвращают Iterable и используют `sync*` и `yield`. Асинхронные — возвращают Stream, используют `async*` и `yield` для создания асинхронных последовательностей.',
  ),
  QA(
    q: 'В чем преимущество использования генераторов перед созданием коллекций сразу?',
    a: 'Генераторы позволяют лениво создавать данные по запросу, экономя память и повышая производительность при работе с большими или бесконечными последовательностями.',
  ),
  QA(
    q: 'Как объявить синхронный генератор?',
    a: 'Использовать ключевое слово `sync*` в функции, которая возвращает Iterable, и оператор `yield` для выдачи значений.',
  ),
  QA(
    q: 'Как объявить асинхронный генератор?',
    a: '''
В Dart асинхронный генератор объявляется с помощью:

- async* вместо async
- yield вместо return
- возвращаемый тип — Stream<T>

Stream<int> countTo(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
''',
  ),
  QA(
    q: 'Может ли генератор содержать `await`?',
    a: 'Только асинхронный генератор (`async*`) может содержать `await` для ожидания асинхронных операций перед выдачей значения.',
  ),
  QA(
    q: 'Как обработать ошибки в асинхронных генераторах?',
    a: 'Через `try-catch` внутри функции с `async*`, или используя методы обработки ошибок у Stream при подписке.',
  ),
  QA(
    q: 'Можно ли прервать выполнение генератора досрочно?',
    a: '''
📌 1. Синхронный генератор (sync*)

Iterable<int> numbers() sync* {
  for (var i = 0; i < 5; i++) {
    yield i;
  }
}

Прерывается просто — остановить итерацию:

for (var n in numbers()) {
  if (n == 2) break; // досрочно прерываем
}

Когда вызывается break, генератор больше не вызывается и его состояние теряется.

📌 2. Асинхронный генератор (async*)
Stream<int> numbers() async* {
  for (var i = 0; i < 5; i++) {
    yield i;
    await Future.delayed(Duration(milliseconds: 100));
  }
}

Прерывание происходит через отписку от Stream:

final sub = numbers().listen((value) {
  print(value);
  if (value == 2) {
    sub.cancel(); // отписка прерывает генератор
  }
});

Когда cancel() вызывается, генератор завершает выполнение (вызовется finally если он есть).

📌 3. Прерывание изнутри генератора

Ты можешь завершить генератор досрочно с помощью return:

Iterable<int> short() sync* {
  yield 1;
  yield 2;
  return; // досрочное завершение
  yield 3; // уже не выполнится
}

Аналогично для async*:

Stream<int> shortAsync() async* {
  yield 1;
  return; // прерываем
}

Вывод
- Синхронный: break/return или просто перестать итерировать.
- Асинхронный: StreamSubscription.cancel() или return внутри генератора.
''',
  ),
  QA(
    q: 'Какие преимущества дает использование flavors?',
    a: 'Упрощают управление средами, позволяют использовать разные API-ключи, настройки, иконки, обеспечивают параллельную работу с разными версиями.',
  ),
  QA(
    q: 'Как управлять разными конфигурациями API URL для разных flavors?',
    a: r'''
📌 1. Dart-define

Запуск
flutter run --dart-define=FLAVOR=dev  --dart-define=API_URL=https://api.dev.example.com
flutter run --dart-define=FLAVOR=prod --dart-define=API_URL=https://api.prod.example.com

Код

String.fromEnvironment('API_URL');

📌 2. Enum-based конфигурация

enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static const Environment _current = Environment.values.byName(
    String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev'),
  );

  static Environment get current => _current;

  static String get apiUrl {
    switch (_current) {
      case Environment.dev:
        return 'https://api.dev.example.com';
      case Environment.staging:
        return 'https://api.staging.example.com';
      case Environment.prod:
        return 'https://api.example.com';
    }
  }

📌 3. JSON-файлы конфигурации

assets/config/dev.json:
{
  "apiUrl": "https://api.dev.example.com",
  "timeout": 30000,
  "enableLogging": true
}

class ConfigLoader {
  static late Map<String, dynamic> _config;

  static Future<void> load() async {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final configString = await rootBundle.loadString('assets/config/$flavor.json');
    _config = json.decode(configString);
  }

  static String get apiUrl => _config['apiUrl'];
  static int get timeout => _config['timeout'];
  static bool get enableLogging => _config['enableLogging'];
}

📌 4. dotenv

dependencies:
  flutter_dotenv: 5.1.0

flutter:
  assets:
    - .env.dev
    - .env.test
    - .env.prod

.env.dev:
API_URL=https://api.dev.example.com
API_KEY=dev_key_123
TIMEOUT=30000
ENABLE_LOGGING=true

.env.prod:
API_URL=https://api.example.com
API_KEY=prod_key_456
TIMEOUT=10000
ENABLE_LOGGING=false

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> load({String flavor = 'dev'}) async {
    await dotenv.load(fileName: '.env.$flavor');
  }

  static String get apiUrl => dotenv.env['API_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static int get timeout => int.parse(dotenv.env['TIMEOUT'] ?? '30000');
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING'] == 'true';
}
''',
  ),
  QA(
    q: 'Как интегрировать flavors с Firebase в Flutter?',
    a: 'Создают отдельные проекты Firebase для каждого flavor, используют соответствующие google-services.json и GoogleService-Info.plist, подключая их в build.',
  ),
  QA(
    q: 'Можно ли переключать flavor динамически во время работы приложения?',
    a: 'Нет, flavor задаётся при сборке. Для динамического переключения используют другие механизмы, например, remote config.',
  ),
  QA(
    q: 'Как хранить секреты (API ключи) для разных flavors безопасно?',
    a: 'Используют файлы, не коммитящиеся в репозиторий (например, .env), или хранят секреты в защищённых сервисах, загружая их динамически.',
  ),
  QA(
    q: 'Как организовать структуру проекта для поддержки нескольких flavors?',
    a: 'Отделять конфигурационные файлы, использовать отдельные entry points (main_*.dart), и выделять flavor-специфичный код в отдельные папки.',
  ),
  QA(
    q: 'Что такое JIT-компиляция в Dart?',
    a: 'JIT ()Just-In-Time) — компиляция кода во время выполнения (runtime), что позволяет быстро запускать код и динамически изменять его.',
  ),
  QA(
    q: 'Что такое AOT-компиляция в Dart?',
    a: 'AOT (Ahead-of-Time) — предварительная компиляция кода в машинный код до запуска, что улучшает производительность и уменьшает время старта приложения.',
  ),
  QA(
    q: 'Какие преимущества у JIT-компиляции?',
    a: 'Быстрая разработка с hot reload, возможность динамических изменений кода и отладки.',
  ),
  QA(
    q: 'Какие преимущества у AOT-компиляции?',
    a: 'Более высокая производительность, меньший размер приложения и быстрое время запуска.',
  ),
  QA(
    q: 'Когда Dart использует JIT, а когда AOT?',
    a: 'JIT применяется в режиме разработки (debug) для быстрого цикла разработки, AOT — для сборок релиза (release).',
  ),
  QA(
    q: 'Как JIT влияет на hot reload в Flutter?',
    a: 'JIT позволяет выполнять hot reload — мгновенное обновление кода без перезапуска приложения.',
  ),
  QA(
    q: 'Можно ли использовать hot reload с AOT-компиляцией?',
    a: 'Нет, hot reload работает только с JIT, потому что AOT-компиляция фиксирует код заранее.',
  ),
  QA(
    q: 'Какие есть недостатки JIT-компиляции в продакшене?',
    a: 'Замедленное время запуска и пониженная производительность из-за компиляции на лету.',
  ),
  QA(
    q: 'Как в Flutter происходит переход с JIT на AOT при сборке?',
    a: 'При сборке release-флага Flutter запускает AOT-компиляцию, которая преобразует Dart-код в машинный код для целевой платформы.',
  ),
  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Что произойдёт, если попытаться передать не сериализуемый объект в другой Isolate?',
    a: '''
При передаче не сериализуемого объекта в другой Isolate будет ошибка ArgumentError с сообщением о том,
что объект не может быть сериализован.

Что можно передавать между Isolates:
- Примитивы (int, double, String, bool)
- Collections (List, Map, Set) с сериализуемым содержимым
- Объекты, реализующие правильную сериализацию
- SendPort для двусторонней коммуникации
''',
  ),
  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Можно ли использовать переменные из родительского Isolate в новом Isolate?',
    a: 'Нет. Isolate не разделяют память, все переменные и объекты копируются (если возможно), а не передаются по ссылке.',
  ),
  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Как завершить работу Isolate и освободить ресурсы?',
    a: 'Вызов Isolate.kill() завершает работу изолята. Также желательно закрывать ReceivePort через .close(), чтобы избежать утечек.',
  ),
  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Можно ли изоляту вернуть результат обратно?',
    a: '''
Да, изолят может вернуть результат обратно через message passing с использованием SendPort и ReceivePort.

1. Через compute() (самый простой)

// Автоматически возвращает результат
Future<int> calculateSquare(int number) async {
  return await compute(_squareFunction, number);
}

int _squareFunction(int n) {
  return n * n;
}

// Использование
final result = await calculateSquare(5); // 25


2. Ручная связь через SendPort/ReceivePort

Future<String> processInIsolate(String data) async {
  final receivePort = ReceivePort();

  // Создаем изолят и передаем SendPort
  await Isolate.spawn(_isolateFunction, {
    'data': data,
    'sendPort': receivePort.sendPort,
  });

  // Ждем результат
  final result = await receivePort.first;
  receivePort.close();

  return result;
}

void _isolateFunction(Map<String, dynamic> params) {
  final data = params['data'] as String;
  final sendPort = params['sendPort'] as SendPort;

  // Обрабатываем данные
  final result = data.toUpperCase();

  // Отправляем результат обратно
  sendPort.send(result);
}
''',
  ),
  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Что такое Isolate.current?',
    a: r'''
Isolate.current — это статическое свойство, которое возвращает ссылку на текущий изолят (Isolate), в котором выполняется код.

void main() {
  print('Main isolate: ${Isolate.current.debugName}');
}
''',
  ),
  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'Какие есть альтернативы Isolate, если не нужно задействовать многопоточность?',
    a: 'Если многопоточность не требуется, можно использовать асинхронные функции (Future, async/await), микротаски и event loop Dart-а, что гораздо дешевле по ресурсам.',
  ),
  QA(
    tags: [Tag.dart, Tag.isolate],
    q: 'В чём разница между compute() и Isolate.spawn() ?',
    a: r'''
📌 compute() — обёртка вокруг Isolate.spawn() с ограничениями: можно передать только один аргумент и нельзя управлять жизненным циклом.
compute() выполняет тяжелые вычисления в отдельном Isolate, чтобы не блокировать UI Thread.
Удобно для простых задач.

int heavyTask(int n) {
  int sum = 0;
  for (int i = 0; i < n; i++) {
    sum += i * i;
  }
  return sum;
}

void main() async {
  int result = await compute(heavyTask, 1000000);
  print('Результат: $result');
}

📌 Для продвинутых сценариев лучше использовать Isolate.spawn().
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое mixin?',
    a: r'''
Mixin — это способ повторного использования кода в нескольких классах без наследования.
С помощью `with` можно подключить функциональность из mixin к классу.
Mixin не может иметь конструкторов, поэтому нельзя определить `const`, `factory` или `named constructor` в mixin-

Определение и синтаксис

mixin Logger {
  void log(String message) {
    print('[${DateTime.now()}] $message');
  }
}

class ApiService with Logger {
  void fetchData() {
    log('Fetching data from API'); // Использует метод из mixin
  }
}

📌 1. Множественное наследование поведения

mixin Flyable {
  void fly() => print('Flying');
}

mixin Swimmable {
  void swim() => print('Swimming');
}

class Duck extends Animal with Flyable, Swimmable {
  // Duck получает методы fly() и swim()
}

📌 2. Ограничения через on

mixin DatabaseMixin on Repository {
  void logQuery(String query) {
    print('Executing: $query');
  }
}

abstract class Repository {
  void save();
}

// Можно применить только к наследникам Repository
class UserRepository extends Repository with DatabaseMixin {
  @override
  void save() {
    logQuery('INSERT INTO users...');
  }
}

📌 3. Абстрактные методы в mixin

mixin Validatable {
  bool validate(); // Абстрактный метод

  void saveIfValid() {
    if (validate()) {
      print('Saving...');
    }
  }
}

class User with Validatable {
  @override
  bool validate() => name.isNotEmpty;

  String name = '';
}

📌 Порядок линеаризации

mixin A {
  void method() => print('A');
}

mixin B {
  void method() => print('B');
}

mixin C {
  void method() => print('C');
}

class MyClass with A, B, C {
  // method() вызовет 'C' (последний в цепочке)
}

📌 Когда использовать mixin:
- Нужно добавить функциональность к нескольким несвязанным классам
- Функциональность не является основной характеристикой класса

📌 Mixin vs наследование:
Наследование: "является" (is-a)
Mixin: "может делать" (can-do)

📌 Mixin vs композиция:
Mixin встраивается в класс
Композиция содержит объект как поле
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Extension и Mixin — в чём разница?',
    a: 'Extension не может иметь состояние, а mixin — может. Extension не участвует в иерархии типов.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли реализовать несколько интерфейсов в одном классе?',
    a: 'Можно реализовать сколько угодно интерфейсов через implements, но Dart не поддерживает множественное наследование (extends — только один класс).',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое build_runner и как он работает?',
    a: '`build_runner` — это инструмент, который запускает генераторы кода. Он отслеживает изменения в файлах и вызывает генераторы (`Builder`), которые создают Dart-код на основе аннотаций или шаблонов.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает пакет json_serializable и зачем он нужен?',
    a: '`json_serializable` автоматически генерирует код для сериализации/десериализации объектов в JSON. Он использует аннотации и code generation, избавляя от ручного написания `toJson`/`fromJson`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какая аннотация указывает, что класс должен участвовать в json_serializable?',
    a: "`@JsonSerializable()` используется для генерации сериализации. Также нужно подключить part-файл и использовать директиву `part 'model.g.dart'`.",
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли использовать code generation для внедрения зависимостей?',
    a: 'Да. DI-фреймворки вроде `injectable` и `get_it` могут использовать `build_runner` и аннотации для автоматической генерации кода внедрения зависимостей.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'В чём разница между final и const?',
    a: '`final` означает, что значение переменной нельзя изменить после инициализации (runtime). `const` означает, что значение должно быть известно во время compile-time. `const` — compile-time, `final` — run-time.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что произойдёт, если обратиться к late-переменной до её инициализации?',
    a: 'Если это `late` без `final`, произойдёт runtime error `LateInitializationError`. Если переменная была инициализирована — всё работает корректно.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли комбинировать late с final?',
    a: '`late final` означает, что переменная может быть инициализирована один раз, но позже — не в момент объявления. Это ленивое final-поле.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое Static?',
    a: '''
static — это модификатор, который делает переменную или метод принадлежащими классу, а не экземпляру этого класса.
Доступ без создания объекта: ClassName.member.

static const - компилируется в константу
static final - инициализируется однократно в runtime
static late final - отложенная инициализация с проверкой
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Может ли static-переменная быть const или final?',
    a: 'Да. Например: `static const String version = "1.0";`. Также допустим `static final`, если значение инициализируется во время выполнения.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли использовать late с static?',
    a: 'Да. Например: `static late final MyService service;` — это позволяет отложить инициализацию общей переменной до момента её первого использования.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие преимущества const конструктора?',
    a: '''
1) Экономия памяти - одинаковые объекты используют одну и ту же память
2) Производительность - объекты создаются во время компиляции
3) Безопасность - неизменяемые объекты потокобезопасны
4) Кэширование - одинаковые константы не создаются повторно

Используй const конструкторы для классов, которые представляют неизменяемые данные и могут быть созданы на этапе компиляции.

Класс должен содержать только final поля:

class Person {
  final String name;
  final int age;
  const Person(this.name, this.age);
}

void main() {
  const person1 = Person('Alice', 25);
  const person2 = Person('Alice', 25);

  // person1 и person2 - это один и тот же объект в памяти!
  print(person1 == person2); // true
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что произойдёт, если попытаться изменить поле final после его инициализации?',
    a: 'Компилятор выдаст ошибку: `final` нельзя переназначать после инициализации',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Какие виды параметров функций поддерживает Dart?',
    a: r'''
📌 1. Позиционные обязательные параметры

void greet(String name, int age) {
  print('Hello $name, you are $age years old');
}

// Вызов
greet('Alice', 25);

📌 2. Позиционные необязательные параметры
Оборачиваются в квадратные скобки []:

void greet(String name, [String? surname, int? age]) {
  print('Hello $name');
  if (surname != null) print('Surname: $surname');
  if (age != null) print('Age: $age');
}

// Вызовы
greet('Alice');              // Hello Alice
greet('Alice', 'Smith');     // Hello Alice, Surname: Smith
greet('Alice', 'Smith', 25); // Hello Alice, Surname: Smith, Age: 25

📌 3. Параметры по умолчанию

Для необязательных параметров:

void greet(String name, {String greeting = 'Hello', int times = 1}) {
  for (int i = 0; i < times; i++) {
    print('$greeting, $name!');
  }
}

// Вызовы
greet('Alice');                    // Hello, Alice!
greet('Alice', greeting: 'Hi');   // Hi, Alice!
greet('Alice', times: 3);         // Hello, Alice! (3 раза)

Для позиционных необязательных:

void calculate(int a, [int b = 0, int c = 1]) {
  print(a + b + c);
}

📌 4. Обязательные именованные параметры

Используется ключевое слово required:

class User {
  final String name;
  final int age;
  final String email; // необязательный

  User(this.name, {required this.age, this.email = ''});
}

// Вызов
User('Alice', age: 25);
User('Bob', age: 30, email: 'bob@example.com');

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли использовать default значения для опциональных параметров?',
    a: 'Да. Для опциональных позиционных и именованных параметров можно задавать значения по умолчанию. Если параметр не передан — используется default.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какой синтаксис у функции с опциональными позиционными параметрами?',
    a: 'Опциональные позиционные параметры указываются в квадратных скобках: `void f(int a, [int? b]) {}`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли комбинировать обязательные и опциональные параметры в одной функции?',
    a: 'Да. Сначала идут обязательные позиционные параметры, затем — опциональные позиционные или именованные.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли задать несколько ограничений на generic-параметр в Dart?',
    a: '''
Dart поддерживает только одно прямое ограничение extends, но множественные ограничения можно реализовать
через промежуточные интерфейсы.

abstract class ComparableAndIterable<T> implements Comparable<T>, Iterable<T> {}

class MyClass<T extends ComparableAndIterable<T>> {
  // T должен реализовывать и Comparable, и Iterable
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли указать default значение для generic-параметра?',
    a: '''
Нет, в Dart нельзя указать значение по умолчанию для generic-параметра (типа).

// ❌ НЕ РАБОТАЕТ
class Box<T = String> {  // Ошибка: Default values for type parameters are not supported.
  T value;
  Box(this.value);
}

✅ Можно использовать статический фабричный метод

class Box<T> {
  final T value;

  Box(this.value);

  // Статический метод с типом по умолчанию
  static Box<String> create(String value) => Box<String>(value);
}

// Использование:
void main() {
  var box1 = Box<int>(100);
  var box2 = Box.create("default string"); // тип String "по умолчанию"
}

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'В чём разница между <T extends Object> и <T> ?',
    a: '`T extends Object` исключает null-значения (если null safety включена). Просто `T` — может быть `T?`. Это влияет на типовую строгость и защиту от null.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое callable класс?',
    a: '''
Класс, у которого определён метод call(...).

Такой метод можно вызывать так, будто экземпляр класса — это функция:

class Adder {
  final int addValue;
  const Adder(this.addValue);

  int call(int x) => x + addValue;
}

void main() {
  final addFive = Adder(5);
  print(addFive(10)); // 15 — вызвали как функцию
}

call — обычный метод, можно перегружать с разными сигнатурами.
Работает с любыми модификаторами (async, async*, sync*).
Метод `call()` может иметь любые параметры и возвращать любое значение, как обычная функция.

Callable class позволяет передавать объект как функцию.

Dart не поддерживает перегрузку методов. Допустим только один метод `call`,

Dart позволяет передавать объект с методом `call` как функцию, если сигнатура совпадает.
Например, `void doStuff(Function(String) action)` примет и `MyCallableClass().call`.

Если сигнатура `call()` совпадает с typedef, объект можно использовать там, где ожидается typedef-функция.
''',
  ),
  QA(
    q: 'Как отличить вызов конструктора от вызова метода call() у экземпляра?',
    a: '''
Вызов `MyClass()` — это создание экземпляра
      `MyClass()()` — это сначала создание, а потом вызов метода `call()`. Скобки после скобок — не ошибка, а синтаксис.

class A {
  void call() {}
}

class B { }

A()(); // OK
B()(); // ошибка

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое замыкание?',
    a: '''
это функция, которая запоминает переменные из внешней области видимости, даже когда эта область уже недоступна.

Особенности:
- Захват переменных: замыкание сохраняет ссылку на переменную, а не копию значения (кроме примитивов при присваивании)
- Живое состояние: изменения переменных внутри замыкания отражаются на внешней области
- Утечки памяти: при неправильном использовании могут удерживать ссылки на объекты дольше, чем нужно

Function makeAdder(int x) {
  return (int y) => x + y; // замыкание: захватывает x
}

void main() {
  final add5 = makeAdder(5);
  print(add5(3)); // 8
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Для чего нужен List.filled ?',
    a: '''
Если передавался объект (не примитив), то все элементы указывают на одну и ту же ссылку. Изменение одного элемента — меняет все. Это частый источник багов.

// Все элементы ссылаются на один и тот же объект, то изменяя один, меняются все.
final list1 = List.filled(3, []);
list1[0].add(1);
print(list1); // [[1], [1], [1]] - все списки изменились!

Также

void main() {
  final list1 = List.filled(3, Person('Tom'));
  list1[0].name = 'Jeryy';
  print(list1); // [Jeryy, Jeryy, Jeryy] - все списки изменились!
}

class Person {
  String name;

  Person(this.name);

  String toString() => name;
}

создаётся один объект Person('Tom'), и ссылка на него кладётся во все 3 ячейки списка.
Поэтому когда ты меняешь list1[0].name, меняется и list1[1].name, и list1[2].name.

Чтобы создать разные объекты, нужно вместо List.filled использовать List.generate.


🔑 Разница:
List.filled(3, Person('Tom')) → три ссылки на один и тот же объект.
List.generate(3, (_) => Person('Tom')) → три отдельных объекта, пусть даже с одинаковым содержимым.



// С примитивами безопасно:
  final list1 = List.filled(3, 0);
  list1[0] = 5;
  print(list1); // [5, 0, 0]
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Для чего нужен List.generate?',
    a: '''
Создает список, вызывая функцию-генератор для каждого индекса.

// Каждый элемент создается отдельно
final list1 = List.generate(3, (_) => []);
list1[0].add(1);
print(list1); // [[1], [], []] - только первый список изменился

// Может использовать индекс для генерации значений
final squares = List.generate(5, (index) => index * index);
print(squares); // [0, 1, 4, 9, 16]
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работает spread-оператор (...) и null-aware spread (...?) в List?',
    a: 'Spread-оператор распаковывает элементы другого списка внутрь текущего. Null-aware (`...?`) нужен, чтобы не выбрасывать ошибку, если список равен null.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает метод List.unmodifiable()? В чём отличие от const List?',
    a: '`List.unmodifiable()` создаёт список, который нельзя изменить во время runtime, но он может быть создан из переменных. `const []` — полностью константный на этапе compile.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как удалить все элементы, удовлетворяющие условию, из списка?',
    a: '''

1. removeWhere() - мутирует исходный список

final numbers = [1, 2, 3, 4, 5, 6];
numbers.removeWhere((n) => n % 2 == 0); // удалить четные
print(numbers); // [1, 3, 5]

2. where() + toList() - создает новый список

final numbers = [1, 2, 3, 4, 5, 6];
final oddNumbers = numbers.where((n) => n % 2 != 0).toList(); // оставить нечетные
print(oddNumbers); // [1, 3, 5]

3. retainWhere() - оставить элементы по условию

  final numbers = [1, 2, 3, 4, 5, 6];
  numbers.retainWhere((n) => n > 4);
  print(numbers); // [5, 6]

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как создать новый список, не изменяя исходный?',
    a: '''

1. List.from() (универсальный)

final original = [1, 2, 3];
final copy = List.from(original);

2. Spread operator ... (современный подход)

final original = [1, 2, 3];
final copy = [...original];

// С дополнительными элементами
final extended = [...original, 4, 5];
final combined = [...list1, ...list2];


''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Чем отличается List.from(other) от List.of(other)?',
    a: '''

List.from(other)
- Не делает проверку на соответствие типа элементов T при создании. Может упасть в рантайме только при попытке доступа/модификации.
  final a = List.from(<num>[1, 2]);
  final b = List<int>.from(<num>[1, 2.5]); // ОК на этапе создания, но даст ошибку при обращении к 2.5
                                              Unhandled exception: type 'double' is not a subtype of type 'int'

List.of(other)
- Делает runtime проверку, что каждый элемент other совместим с типом T, и выбросит CastError сразу при создании списка.
  final b = List<int>.of(<num>[1, 2.5]); // CastError сразу
                                            The argument type 'List<num>' can't be assigned to the parameter type 'Iterable<int>'. The argument type 'List<num>' can't be assigned to the parameter type 'Iterable<int>'.

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает метод List.setAll() и чем он отличается от addAll()?',
    a: '''

setAll заменяет существующие элементы на месте.
List.setAll(index, iterable) — заменяет уже существующие элементы списка начиная с позиции index элементами из iterable. Длина списка не меняется, и ты обязан иметь достаточное количество элементов после index, иначе будет RangeError.
final list = [1, 2, 3, 4];
list.setAll(1, [7, 8]); // [1, 7, 8, 4]


addAll расширяет список.
addAll(iterable) — добавляет элементы в конец списка, увеличивая его длину. Проверка на вместимость есть только для GrowableList (обычный List), но не для фиксированной длины.
final list2 = [1, 2];
list2.addAll([3, 4]);   // [1, 2, 3, 4]
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли изменить размер списка, созданного через List.filled(..., ..., growable: false)?',
    a: 'Нет. Только списки с `growable: true` поддерживают добавление/удаление элементов. Иначе будет выброшено `UnsupportedError` при попытке изменить размер.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как создать список, содержащий только непустые строки из другого списка?',
    a: 'С помощью фильтрации: `list.where((e) => e.isNotEmpty).toList();`. Это избавляет от пустых строк и возвращает новый список.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое Map?',
    a: 'Map — это коллекция пар ключ-значение. Пример: `final map = {"name": "Alice", "age": 30};`. Также можно создать через конструкторы: `Map()` или `Map.from({...})`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие типы можно использовать как ключи в Map?',
    a: 'Любые объекты, реализующие корректно `==` и `hashCode`. Обычно это `String`, `int`, `enum`, но можно и классы с переопределённым `==` и `hashCode`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'В чём разница между Map.of(), Map.from() и Map.unmodifiable()?',
    a: '''
📌 Map.from(other)
- Создаёт новый изменяемый Map<K, V> и копирует все пары ключ–значение из other.
- Типы ключей и значений при этом не проверяются (cast делается лениво при доступе).
- Можно модифицировать результат.

📌 Map.of(other)
- То же, что Map.from, но проверяет совместимость типов ключей и значений с указанными generic-параметрами
сразу при создании. Если хотя бы один элемент не подходит — выбросит CastError на месте.

📌 Map.unmodifiable(other)
- Создаёт неизменяемую карту (read-only view). Любая попытка изменить её (add, remove, присвоить значение) выбросит UnsupportedError. Типы ключей/значений также проверяются при создании.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как безопасно получить значение из Map, если ключ может отсутствовать?',
    a: 'Через оператор []: final String name = map["name"] ?? "default"`',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как удалить ключ из Map?',
    a: 'С помощью `map.remove("key")`. Также можно использовать removeWhere((k, v) => условие) для удаления по условию.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как итерироваться по Map?',
    a: r'Через `map.forEach((key, value) => ...)`, или через `map.entries.forEach(...)`. Пример: `for (var e in map.entries) { print("${e.key}: ${e.value}"); }`.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как фильтровать Map?',
    a: '''
final original = {'a': 1, 'b': 2, 'c': 3, 'd': 4};

📌 1. Map.fromEntries() + where() (рекомендуется)

// По значению
final filtered = Map.fromEntries(
  original.entries.where((entry) => entry.value > 2)
);
// Result: {'c': 3, 'd': 4}

// По ключу
final filtered = Map.fromEntries(
  original.entries.where((entry) => entry.key != 'b')
);
// Result: {'a': 1, 'c': 3, 'd': 4}

// По условию ключ + значение
final filtered = Map.fromEntries(
  original.entries.where((entry) => entry.key == 'a' || entry.value > 3)
);
// Result: {'a': 1, 'd': 4}

📌 2. removeWhere() (изменяет исходную Map)

final map = {'a': 1, 'b': 2, 'c': 3};
map.removeWhere((key, value) => value <= 2);
// Result: {'c': 3}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое MapEntry?',
    a: '''
MapEntry — это класс, представляющий пару ключ-значение в Map, контейнер для связки ключ-значение.

class MapEntry<K, V> {
  final K key;
  final V value;
  const MapEntry(this.key, this.value);
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли использовать spread-оператор с Map?',
    a: 'Да. Пример: `final newMap = {...map1, ...map2}`. Значения из второго перезапишут значения из первого при совпадении ключей.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как отсортировать Map по ключам или значениям?',
    a: '''
В Dart Map неупорядоченный (если это HashMap), поэтому сортировку делают через преобразование
в список пар MapEntry и создание нового LinkedHashMap (он сохраняет порядок).

📌 Сортировка по ключам:

  final Map<String, int> map = {'b': 2, 'a': 3, 'c': 1};
  final LinkedHashMap<String, int> sortedByKey = LinkedHashMap.fromEntries(
    map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
  print(sortedByKey); // {a: 3, b: 2, c: 1}

📌 Сортировка по значениям:

  final Map<String, int> map = {'b': 2, 'a': 3, 'c': 1};
  final LinkedHashMap<String, int> sortedByValue = LinkedHashMap.fromEntries(
    map.entries.toList()..sort((a, b) => a.value.compareTo(b.value)),
  );
  print(sortedByValue); // {c: 1, b: 2, a: 3}
''',
  ),
  QA(
    q: 'Что такое Set?',
    a: '''
Set — это коллекция уникальных элементов без определенного порядка (в отличие от List).

Основные характеристики:
- Каждый элемент уникален (дубликаты автоматически удаляются)
- Неупорядоченная коллекция (в отличие от List)
- Быстрый поиск: O(1) для contains/remove/add

📌 Литерал
final set1 = {1, 2, 3, 2}; // {1, 2, 3} - дубликаты удаляются

📌 Конструктор
final set2 = Set<int>();
set2.add(1);
set2.add(2);
set2.add(1); // не добавится

📌 Iterable
final List<int> list = [1, 2, 3, 2, 1];

final Set<int> set3 = Set.from(list); // {1, 2, 3}
final Set<int> set4 = Set.of(list);   // {1, 2, 3}

Основные операции:

final numbers = {1, 2, 3, 4, 5};

📌 Добавление/удаление
numbers.add(6);        // добавить элемент
numbers.remove(3);     // удалить элемент
numbers.contains(4);   // проверить наличие

📌 Размер
print(numbers.length); // количество элементов

📌 Итерация
for (final item in numbers) {
  print(item);
}

Математические операции:

final setA = {1, 2, 3, 4};
final setB = {3, 4, 5, 6};

📌 Объединение
final union = setA.union(setB); // {1, 2, 3, 4, 5, 6}

📌 Пересечение
final intersection = setA.intersection(setB); // {3, 4}

📌 Разность
final difference = setA.difference(setB); // {1, 2}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает метод lookup() у Set?',
    a: '''
Метод lookup() у Set находит и возвращает элемент, если он существует в множестве, или возвращает null, если элемент не найден.

Отличие от contains():
  - contains() возвращает bool (true/false)
  - lookup() возвращает сам элемент или null

// Когда нужно получить оригинальный элемент
final users = {'John', 'JANE', 'Bob'};
final user = users.lookup('john'.toUpperCase()); // null
final correctUser = users.lookup('JANE');        // 'JANE'

// С кастомными объектами и оператором ==
class Person {
  final String name;
  Person(this.name);

  @override
  bool operator ==(Object other) => other is Person && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

final people = {Person('John'), Person('Jane')};
final foundPerson = people.lookup(Person('John')); // Person('John')
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое sealed class?',
    a: '''
закрытый для внешнего наследования тип, который можно наследовать только в том же файле, где он объявлен.

sealed class Animal {}

class Dog extends Animal {}
class Cat extends Animal {}

Все классы, расширяющие Animal, должны находиться в том же файле.

Подходит для switch-case

String sound(Animal a) {
  return switch (a) {
    Dog() => 'woof',
    Cat() => 'meow',
    // 🔥 ошибка компиляции, если забыл случай!
  };
}

sealed — это модификатор ограничения иерархии, а не поведения.
Он может быть abstract, иметь factory, const, static методы и поля.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'В чём отличие sealed class от abstract class?',
    a: 'abstract class может наследоваться откуда угодно, а sealed — только внутри той же библиотеки. Sealed запрещает создание экземпляра. Может быть использована для исчерпывающих проверок.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли создать экземпляр sealed класса напрямую?',
    a: 'Нет. sealed класс не может быть инстанцирован напрямую — он должен иметь подклассы, которые реализуют или расширяют его.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Чем sealed class отличается от enum в Dart?',
    a: 'Enum — это набор фиксированных значений (одиночные инстансы), тогда как sealed class — это ограниченная иерархия классов, которые могут иметь состояние и логику. Enums — это значения, sealed — типы.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли sealed class использовать с pattern matching?',
    a: 'Да, sealed классы сочетаются с pattern matching, так как позволяют компилятору проверять все возможные случаи.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли реализовать sealed class в другой библиотеке?',
    a: 'Нет. Подклассы sealed класса должны быть объявлены в той же библиотеке. Это ключевое отличие от обычного abstract класса или интерфейса.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что произойдёт, если sealed класс имеет подкласс в другой библиотеке?',
    a: 'Будет ошибка компиляции. Dart строго запрещает наследование sealed класса вне его библиотеки.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли комбинировать sealed class с mixin или implements?',
    a: 'Да, можно. Подклассы sealed класса могут использовать mixin и реализовывать интерфейсы, если это не нарушает ограничения наследования.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как sealed class используется при построении архитектур (например, bloc или pattern matching в UI)?',
    a: 'Sealed классы подходят для описания состояний и событий: компилятор гарантирует, что все случаи рассмотрены. Это снижает риск пропущенных веток в обработке.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Чем отличается BehaviorSubject от StreamController?',
    a: '''
BehaviorSubject — это специальный тип StreamController из пакета rxdart, который хранит
последнее переданное значение и отдает его новому подписчику сразу при подписке.

StreamController такого не делает.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что произойдёт, если подписаться на BehaviorSubject до отправки первого значения?',
    a: 'Если значение ещё не отправлялось, то подписчик не получит ничего до первого события. Если уже было значение — он получит его сразу.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как получить последнее значение из BehaviorSubject?',
    a: '''
С помощью свойства .value. Оно синхронно возвращает последнее переданное значение.

final subject = BehaviorSubject<int>();
subject.add(10);
final lastValue = subject.value; // 10
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как завершить BehaviorSubject и освободить ресурсы?',
    a: 'Нужно вызвать метод .close(). Это завершит поток и освободит ресурсы. Важно для предотвращения утечек памяти.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Можно ли использовать BehaviorSubject в качестве state-holder в BLoC?',
    a: 'Да, это популярный подход. BehaviorSubject хранит последнее состояние, которое можно синхронно получить и слушать, что удобно для реактивного UI и обработки событий.',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Чем отличаются Queue и List?',
    a: '''
Queue оптимизирована для операций добавления и удаления с начала и конца (O(1)), в то время как List имеет O(n) при удалении из начала.
Queue лучше использовать, когда важна производительность при частом добавлении/удалении элементов с обоих концов (например, FIFO/LIFO логика).
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что произойдёт при сдвиге числа 3 на 2 бита влево? (3 << 2)',
    a: '''
3 = 0b0011
Сдвиг влево на 2 бита: 0b1100 = 12
Ответ: 12
''',
  ),
  QA(
    q: 'Какое минимальное действие с числом позволяет его умножить на 2^n?',
    a: '''
  print(2 << 1); // 4
  print(2 << 2); // 8
  print(2 << 3); // 16
  print(2 << 4); // 32
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как с помощью побитовой операции AND (&) проверить, является ли число чётным?',
    a: '''
Число 1 в двоичной системе: ...00000001 (только младший бит установлен)

Примеры:

// Четные числа (младший бит = 0):
4 & 1:  100 & 001 = 000 → 0
6 & 1:  110 & 001 = 000 → 0
8 & 1: 1000 & 001 = 000 → 0

// Нечетные числа (младший бит = 1):
3 & 1:  011 & 001 = 001 → 1
5 & 1:  101 & 001 = 001 → 1
7 & 1:  111 & 001 = 001 → 1

Почему это работает
В двоичной системе:

Четные числа всегда заканчиваются на 0
Нечетные числа всегда заканчиваются на 1

Побитовое AND с 1 "выделяет" только младший бит, обнуляя все остальные.

bool isEven(int x) => (x & 1) == 0;
bool isOdd(int x) => (x & 1) == 1;

// Быстрее чем:
bool isEven(int x) => x % 2 == 0;  // модуло медленнее

Преимущество: побитовые операции работают быстрее арифметических на уровне процессора.
''',
  ),
  QA(
    q: 'Что вернёт выражение: (-1 >> 1) в Dart?',
    a: '''
В Dart оператор >> сохраняет знак (арифметический сдвиг).
-1 = 0xFFFFFFFF
-1 >> 1 = -1
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Разница между class и mixin',
    a: '''

| Особенность                        | `class`                                  | `mixin`                                   |
| ---------------------------------- | ---------------------------------------- | ----------------------------------------- |
| 🔹 Наследование                    | Может наследовать и быть унаследован     | Не может наследовать (только `Object`)    |
| 🔸 Использование                   | Через `extends` и `implements`           | Через `with`                              |
| 🔄 Множественное использование     | Нет                                      | Да (`with A, B`)                          |
| 🧱 Конструкторы                    | Есть, можно переопределять               | ❌ Нет конструкторов                      |
| 🔐 Состояние (поля)                | Может содержать и хранить                | Может содержать, но нет `super()`         |
| 🎯 Типизация                       | Можно создавать экземпляры               | Нельзя создать экземпляр `mixin` напрямую |
| 🧩 Использование в архитектуре     | Базовые типы, модели, UI-компоненты      | Поведение: логгеры, кеш, утилиты          |
| 📦 Пример использования            | `class MyButton extends StatelessWidget` | `mixin Logger { void log() {} }`          |

''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Разница между reduce и fold в массиве?',
    a: '''
reduce
- Стартовое значение: первый элемент коллекции
- Тип результата: тот же, что у элементов коллекции
- Требования: коллекция НЕ должна быть пустой

final numbers = [1, 2, 3, 4];
final sum = numbers.reduce((a, b) => a + b); // 10
// Тип: int (как у элементов)

// ОШИБКА на пустой коллекции:
final empty = <int>[];
// empty.reduce((a, b) => a + b); // StateError!


fold
- Стартовое значение: задаешь сам
- Тип результата: любой (может отличаться от типа элементов)
- Требования: работает с пустыми коллекциями

final numbers = [1, 2, 3, 4];
final sum = numbers.fold<int>(0, (acc, item) => acc + item); // 10

// Разные типы:
final strings = ['a', 'b', 'c'];
final length = strings.fold<int>(0, (acc, str) => acc + str.length); // 3

// Безопасно с пустой коллекцией:
final empty = <int>[];
final result = empty.fold<int>(0, (acc, item) => acc + item); // 0
''',
  ),
  QA(
    tags: [Tag.dart],
    q: '''
Что выведет этот код:

  final List<int> numbers = [1, 2, 3, 4, 5];

  print(numbers.any((element) => element > 3));
  print(numbers.any((element) => element > 6));
''',
    a: '''
Хотя бы один элемент в массиве удовлетворяет условию

  print(numbers.any((element) => element > 3)); // true
  print(numbers.any((element) => element > 6)); // false
  ''',
  ),
  QA(
    tags: [Tag.dart],
    q: '''
Что выведет?

  final List<int> numbers = [1, 2, 3, 4, 5];
  print(numbers.asMap());
''',
    a: '// {0: 1, 1: 2, 2: 3, 3: 4, 4: 5}',
  ),
  QA(
    tags: [Tag.dart],
    q: '''
Что делает single в массиве?

  final List<int> numbers = [1, 2, 3, 4, 5];
  print(numbers.single); // 1

  ''',
    a: '''
Если в массиве ОДИН элемент, то он возвращается, иначе будет ошибка.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает reversed в массиве?',
    a: '''
  final List<int> numbers = [1, 2, 3, 4, 5];
  print(numbers.reversed); // [5, 4, 3, 2, 1]''',
  ),
  QA(
    tags: [Tag.dart],
    q: '''
Что делает every?

  final List<int> numbers = [1, 2, 3, 4, 5];
  print(numbers.every((key) => key > 3)); какой результат?
''',
    a: '''

  final List<int> numbers = [1, 2, 3, 4, 5];
  print(numbers.every((key) => key > 3)); // false
  print(numbers.every((key) => key > 0)); // true

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает expand в массиве?',
    a: '''

// Разворачивание списков
final lists = [[1, 2], [3, 4], [5]];
final flattened = lists.expand((list) => list).toList();
print(flattened); // [1, 2, 3, 4, 5]

// Дублирование элементов
final numbers = [1, 2, 3];
final doubled = numbers.expand((n) => [n, n]).toList();
print(doubled); // [1, 1, 2, 2, 3, 3]

// Генерация последовательностей
final words = ['hello', 'world'];
final chars = words.expand((word) => word.split('')).toList();
print(chars); // [h, e, l, l, o, w, o, r, l, d]

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает filled и filledRange',
    a: '''
  final words = List.filled(5, 'old');
  print(words); // [old, old, old, old, old]


  words.fillRange(1, 3, 'new');
  print(words); // [old, new, new, old, old]
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'ЧТо делает followedBy?',
    a: '''

объединяет текущую коллекцию с другой коллекцией

final a = [1, 2];
final b = [3, 4];
final c = [5, 6];
final result = a.followedBy(b).followedBy(c);
print(result.toList()); // [1, 2, 3, 4, 5, 6]

''',
  ),

  QA(
    tags: [Tag.dart],
    q: '''
Добавьте рефлекцию в следующий код

import 'dart:mirrors';

void main() {
  print(basicOp('+', 2, 4)); // 6
  print(basicOp('-', 2, 4)); // -2
}

int basicOp(String operator, int value1, int value2) {
  ...
}

''',
    a: '''
int basicOp(String operator, int value1, int value2) {
  return reflect(value1).invoke(Symbol(operator), [value2]).reflectee.toInt();
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: '''
Что выведет консоль

  1) print([] == []);

  2) print(const [] == const []);

  3)
  final list1 = [];
  final list2 = [];
  print(const DeepCollectionEquality().equals(list1, list2));

''',
    a: '''
  print([] == []); // false
  В Dart [] == [] возвращает false, потому что сравниваются ссылки на разные объекты в памяти, а не содержимое списков.


  print(const [] == const []); // true
  так как константы интернируются)


import 'package:collection/collection.dart';
void main() {
  final list1 = [];
  final list2 = [];
  print(const DeepCollectionEquality().equals(list1, list2)); // true
}

''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Что такое Record и чем они отличаются от классов?',
    a: '''
Record — структурный тип данных.

Основные отличия:

- Immutable by default — все поля final
- Структурная типизация — тип определяется структурой, не именем
- Компактный синтаксис — (String, int) вместо создания класса
- Автоматическое равенство == и hashCode генерируются автоматически
- Деструктуризация — var (name, age) = person;

// Record
(String, int) person = ('Alice', 25);

// Эквивалентный класс
class Person {
  final String name;
  final int age;
  const Person(this.name, this.age);

  // + equals, hashCode, toString
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Как работает деструктуризация Recors и паттерн-матчинг?',
    a: r'''

(String, int, bool) data = ('Alice', 25, true);

// Деструктуризация
var (name, age, isActive) = data;

// Паттерн-матчинг в switch
switch (data) {
  case (String name, int age, true) when age >= 18:
    print('$name совершеннолетний и активен');
  case (_, int age, false) when age < 18:
    print('Несовершеннолетний и неактивен');
  case (name, age, _):
    print('$name, $age лет');
}

// В функциях
String formatPerson((String, int) person) {
  var (name, age) = person;
  return '$name: $age';
}

''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'В чем разница между позиционными и именованными полями Record?',
    a: r'''

// Позиционные поля (доступ по $1, $2, ...)
(String, int) positional = ('Alice', 25);
print(positional.$1); // Alice
print(positional.$2); // 25

// Именованные поля
({String name, int age}) named = (name: 'Alice', age: 25);
print(named.name); // Alice
print(named.age); // 25

// Смешанные
(String, {int age, bool active}) mixed = ('Alice', age: 25, active: true);
print(mixed.$1); // Alice (позиционное)
print(mixed.age); // 25 (именованное)

// Типы несовместимы
(String, int) != ({String name, int age}) // Разные типы!

''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Как Records ведут себя при сравнении и в качестве ключей Map?',
    a: '''

// Структурное равенство
var person1 = ('Alice', 25);
var person2 = ('Alice', 25);
var person3 = ('Bob', 25);

print(person1 == person2); // true (одинаковая структура и значения)
print(person1 == person3); // false

// Как ключи Ma
Map<(String, int), String> roles = {
  ('Alice', 25): 'Developer',
  ('Bob', 30): 'Designer',
};

print(roles[('Alice', 25)]); // Developer

// hashCode одинаковый для равных records
print(person1.hashCode == person2.hashCode); // true

// Можно использовать в Set
Set<(String, int)> people = {('Alice', 25), ('Alice', 25)};
print(people.length); // 1 (дубликаты удалены)

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Когда использовать Record вместо классов или других структур данных?',
    a: '''

Используй Records когда:
- Нужна простая группировка данных без поведения
- Временные структуры (возврат из функций, локальные переменные)
- Ключи для Map/Set из нескольких значений
- Деструктуризация важнее инкапсуляции

// ✅ Хорошо для Records
(double lat, double lng) getCoordinates() => (55.7558, 37.6176);
Map<(String, int), User> userCache = {};

// ❌ Плохо для Records - лучше класс
class User {
  final String name;
  final List<String> permissions;

  bool hasPermission(String perm) => permissions.contains(perm);
  void addPermission(String perm) { /* logic */ }
}

''',
  ),

  QA(
    tags: [Tag.dart],
    q: r'''
Что выведет следующий код?

void main() {
  A()().then((result) {
    _someGetter1;
    print({result.$1.first, result.$2});
  });

  _someGetter2;
}

class A {
  A() {
    print('init');
  }

  Future<(List, bool)> call() async{
    final list1 = <Object>[const {} == const {}];
    final list2 = list1..add(123);
    list1.removeLast();
    return Future.value((list2, [] == []));
  }
}

get _someGetter1 => () => print('a');

get _someGetter2 => (() => print(2))();

''',
    a: '''

Output:

init
2
{true, false}

===

_someGetter1 не сработал, потому что он возвращает функцию, но не вызывает её.

get _someGetter1 => () => print('a');  // Возвращает Function
get _someGetter2 => (() => print(2))(); // Возвращает результат вызова Function


Разбор:
- _someGetter1 возвращает Function, которая при обращении к геттеру создается, но не выполняется
- _someGetter2 использует IIFE (Immediately Invoked Function Expression) — функция создается и сразу вызывается через ()()

''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Для чего нужен compareTo ?',
    a: r'''
Используется для сортировки.

По убыванию:

final a = [1, 7, 3, 5];
a.sort((a, b) => b.compareTo(a)); // [7, 5, 3, 1]

По возрастанию:

final a = [1, 7, 3, 5];
a.sort((a, b) => a.compareTo(b));
print(a); //[1, 3, 5, 7]
''',
  ),

  QA(
    tags: [Tag.isolate, Tag.dart],
    q: 'Простой пример изолята',
    a: r'''

import 'dart:isolate';

void main() async {
 // Создаем ReceivePort для получения сообщений от изолята
 final receivePort = ReceivePort();

 // Создаем изолят и передаем SendPort
 final isolate = await Isolate.spawn(
   isolateFunction,
   receivePort.sendPort,
 );

 // Слушаем сообщения от изолята
 receivePort.listen((message) {
   print('Главный изолят получил: $message');

   // Закрываем изолят после получения результата
   isolate.kill();
   receivePort.close();
 });

 print('Главный изолят: изолят запущен');
}

// Функция, которая будет выполняться в новом изоляте
// Имитируем тяжелую работу
void isolateFunction(SendPort sendPort) {
 print('Дочерний изолят: начал работу');
 int result = 0;
 for (int i = 0; i < 100000000; i++) {
   result += i;
 }

 // Отправляем результат обратно в главный изолят
 sendPort.send('Результат вычисления: $result');

 print('Дочерний изолят: работа завершена');
}
''',
  ),

  QA(
    tags: [Tag.dart, Tag.memory],
    q: 'Как работает сборщик мусора в Dart?',
    a: '''

Сборщик мусора (Garbage Collector, GC) в Dart работает по следующим принципам:

Существуют два вида поколений:

🎯 Young space (пространство молодых объектов)

1) Очищается часто и быстро
2) Объекты живут там недолго
3) Временная зона для новых объектов

- Создаются внутри метода
- Используются короткое время
- Нет долгоживущих ссылок
void processUserData(User user) {
  // Эти объекты попадают в Young space:

  // Локальные переменные
  final currentTime = DateTime.now();   // временное значение

  // Временные вычисления
  final formattedName = user.name.toUpperCase(); // промежуточный результат

  // Анонимные коллекции
  final tempData = [user.id, user.email]; // временный список
}

🎯 Old space (пространство старых объектов)

1) Объекты, которые нужны долго (например, на всё время работы приложения).
2) Перемещение из Young space: Если объект "пережил" несколько сборок мусора, он перемещается в Old space.
Это синглтоны, Глобальные сервисы (например, базы данных, API-клиенты).


🎯 Цикл сборки (GC cycle) — это процесс, который выполняет сборщик мусора (Garbage Collector, GC)
для освобождения памяти, занятой объектами, которые больше не используются в программе.

Если на объект нет ссылки, то этот объект считается мусором.
Цикл сборки работает автоматически, и разработчик не управляет им напрямую.

🎯 Если два объекта ссылаются друг на друга, но больше никто на них не ссылается,
сборщик мусора (Garbage Collector, GC) в Dart всё равно сможет их удалить.

class Node {
  Node? next;
}

void main() {
  var a = Node();
  var b = Node();

  a.next = b; // a ссылается на b
  b.next = a; // b ссылается на a

  // Теперь a и b ссылаются друг на друга
} // После выхода из метода, a и b становятся недостижимыми

🎯 Утечка памяти возникает из-за того, что объекты остаются доступными, даже если они больше не нужны.

1) Статические поля живут всё время работы приложения.
class AppState {
  static final List<User> users = [];
}

2) Отмена подписок. Если подписываетесь на события, но не отписываетесь, ссылки на подписчиков остаются в памяти.

3) AnimationController и другие контроллеры без dispose:
class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose(); // Обязательно!
    super.dispose();
  }
}

5) Timer и периодические задачи:
Timer.periodic(Duration(seconds: 1), (timer) {
  // timer.cancel() не вызван
});
''',
  ),
  QA(
    tags: [Tag.dart, Tag.memory],
    q: 'Почему добавление в массив большого количества элементов неэффективно, если длина массива известна?',
    a: '''
🎯 Почему это плохо:

1) Частые перераспределения памяти:
- В Dart (и многих других языках) массивы имеют фиксированный размер в памяти.
- Когда добавляются элементы в массив (например, через add), и он превышает текущую вместимость, создается новый массив большего размера, и все элементы копируются в него.
- Это вызывает дополнительные накладные расходы на выделение памяти и копирование данных.

2) Неэффективное использование памяти:
- Если массив часто расширяется, Dart может выделить больше памяти, чем нужно (например, увеличить размер в 1.5–2 раза), чтобы избежать частых перераспределений.
- Это приводит к временному перерасходу памяти.

3) Непредсказуемость производительности:
- Операции добавления могут казаться быстрыми, но внезапное перераспределение памяти может вызвать заметные задержки.


🎯 Как лучше сделать:
- сразу выделить массив нужного размера

void main() {
  final length = 1000; // Заранее известная длина
  final List<int> data = List.filled(length, 0); // Создаем массив с фиксированным размером

  for (int i = 0; i < length; i++) {
    data[i] = i * 2; // Заполняем массив данными
  }

  print(data);
}
''',
  ),
  QA(
    tags: [Tag.dart, Tag.memory],
    q: 'Как работает Map?',
    a: '''
в Dart реализация Map по умолчанию (Map<K, V>) основана на хэш-таблице.

Все операции с Map выполняются за O(1), но может ухудшиться до O(n) из-за коализий.

🎯 Поиск использует хеш-функцию для быстрого нахождения значения по ключу.

Пример
1) У нас есть {'Apple': 4}. Мы хотим добавить эту пару в Map.
2) Ключ 'Apple' хешируется: Хеш-функция вычисляет число для ключа 'Apple'. Например, для упрощения пусть хеш равен 7.
3) Находим индекс 7 в таблице.
4) Добавляем пару {'Apple': 4} в bucket с индексом 7.

Индекс | bucket
0      | null
1      | null
2      | null
3      | null
4      | null
5      | null
6      | null
7      | {'Apple': 4}
8      | null
9      | null

🎯 Коллизия возникает, когда два разных значения ключа получили один и тот же хэш.

Пусть у нас есть {'Apple': 4} и {'Carrot': 2}, где хеш для 'Apple' и 'Carrot' одинаковы.

В Dart коллизии разрешаются с помощью списков внутри bucket.

Индекс | bucket
6      | null
7      | [{'Apple': 4}, {'Carrot': 2}]
8      | null

При поиске ключа 'Apple' или 'Carrot' мы находим индекс 7 в хеш-таблице.
- Затем проходим по всем элементам массива, чтобы найти нужный ключ.
- Это занимает время, пропорциональное количеству элементов в бакете O(n).
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как работает Set?',
    a: '''
У Set в Dart под капотом используется та же идея, что и у Map, только без значений (то есть фактически это Map<K, Null>).

Как работает Set
1) Когда вставляешь элемент в Set, у него вычисляется hashCode.
2) По hashCode выбирается корзина (bucket).
3) В этой корзине Set сравнивает элементы через ==.
4) Если равный элемент уже есть → новый не добавляется.
5) Если равного нет → элемент добавляется.
''',
  ),
  QA(
    tags: [Tag.dart, Tag.complexity],
    q: 'Что такое SplayTreeMap?',
    a: r'''
SplayTreeMap полезен там, где важен порядок ключей, "обойти по возрастанию/убыванию".

🔎 Отличия от HashMap и LinkedHashMap

HashMap / LinkedHashMap:
- Используют hashCode для быстрого доступа.
- Средняя сложность — O(1) на вставку/поиск/удаление. В худшем случае O(n).
- Но ключи не упорядочены (в LinkedHashMap только сохраняется порядок вставки).

SplayTreeMap:
- Не использует hashCode, а работает через сравнение ключей.
- Держит ключи всегда в отсортированном порядке.
- Сложность операций — O(log n) амортизированно.
- Подходит, если нужно часто итерироваться в отсортированном виде или искать ближайшие ключи (firstKey, lastKey, диапазоны).

void main() {
  final map = SplayTreeMap<int, String>();

  map[3] = 'c';
  map[1] = 'a';
  map[2] = 'b';
  map[5] = 'e';
  map[4] = 'd';

  print(map.keys); // (1, 2, 3, 4, 5) — всегда в отсортированном порядке

  print(map[3]); // доступ к "3"
  print(map[1]); // доступ к "1"

  // Итерируемся — тоже в отсортированном порядке
  for (var entry in map.entries) {
    print('${entry.key} -> ${entry.value}');
  }
}


🎯 SplayTreeMap - это самобалансирующееся бинарное дерево поиска с "всплытием".

Простыми словами:
- Ключи всегда отсортированы
- При любом обращении к элементу, он "всплывает" в корень
- Часто используемые элементы становятся быстрее доступны

Причина "всплытия":
- Амортизированная сложность O(log n)
- Локальность доступа - часто запрашиваемые данные ближе к корню


Операции:
┌─────────────┬─────────────┐
│  Операция   │ Сложность   │
├─────────────┼─────────────┤
│ Доступ      │ O(log n)*   │
│ Вставка     │ O(log n)*   │
│ Удаление    │ O(log n)*   │
│ Минимум     │ O(log n)    │
│ Максимум    │ O(log n)    │
└─────────────┴─────────────┘
*амортизированная

Преимущества:
✓ Автоматическая оптимизация под паттерны доступа
✓ Гарантированное свойство сортировки
✓ Простая реализация по сравнению с другими самобалансирующимися деревьями

Недостатки:
✗ В худшем случае отдельные операции могут быть O(n)
✗ Дополнительные накладные расходы на перестроение дерева


🎯 Отсортированность в SplayTreeMap достигается за счёт свойства Бинарного Дерева Поиска (BST):

СВОЙСТВО BST:
Для каждого узла:
- Все ключи в левом поддереве < ключ текущего узла
- Все ключи в правом поддереве > ключ текущего узла

ПРИМЕР:
Вставка элементов в порядке: 4, 2, 6, 1, 3, 5, 7

Шаг 1: Вставляем 4 (корень)
       4

Шаг 2: Вставляем 2 (2 < 4 → лево)
       4
      /
     2

Шаг 3: Вставляем 6 (6 > 4 → право)
       4
      / \
     2   6

Шаг 4: Вставляем 1 (1 < 4 → лево, 1 < 2 → лево)
       4
      / \
     2   6
    /
   1

Шаг 5: Вставляем 3 (3 < 4 → лево, 3 > 2 → право)
       4
      / \
     2   6
    / \
   1   3

ИНВАРИАНТ:
При обходе дерева в порядке Лево-Корень-Право (in-order traversal)
всегда получаем отсортированную последовательность:
1 → 2 → 3 → 4 → 5 → 6 → 7

SPLAY-ОПЕРАЦИИ:
При доступе к любому элементу дерево перестраивается,
но свойство BST сохраняется:

До доступа к "2":    После splay(2):
       4                 2
      / \               / \
     2   6             1   4
    / \                   / \
   1   3                 3   6
                            / \
                           5   7
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Разница между % и ~/ ',
    a: '''
🎯 % - Оператор остатка от деления (modulo)

print(10 % 3);  // 1 (10 = 3*3 + 1)
print(7 % 2);   // 1 (7  = 2*3 + 1)
print(8 % 4);   // 0 (8  = 4*2 + 0)

// С отрицательными числами
print(-10 % 3); // 2 (не -1!)

Евклидово деление гарантирует, что остаток всегда неотрицательный.

-10 ÷ 3 = -3.33...

Для евклидова деления:
-10 = 3 × (-4) + 2
     ↓     ↓    ↓
   делимое делитель остаток

Где: -4 это floor(-10/3)
Остаток = 2 (всегда ≥ 0)

🎯 ~/ - Оператор целочисленного деления

print(10 ~/ 3);  // 3 (10 ÷ 3 = 3.33... → 3)
print(7 ~/ 2);   // 3 (7 ÷ 2  = 3.5 → 3)
print(8 ~/ 4);   // 2 (8 ÷ 4  = 2)

// С отрицательными числами
print(-10 ~/ 3); // -3

''',
  ),
  QA(
    tags: [Tag.isolate, Tag.dart],
    q: 'Какие есть способы создания изолятов?',
    a: '''
🎯 1) compute() - Flutter only, старый подход

Для Flutter: compute() → Isolate.run() (миграция)

// Простые вычисления в Flutter-приложениях
final result = await compute(heavyFunction, data);

Используй когда:
- Работаешь во Flutter (не в pure Dart)
- Нужно выполнить одну задачу и получить результат
- Требуется простота и минимум кода

🎯 2) Isolate.run() - современный подход

// Современный способ для разовых задач
final result = await Isolate.run(() => heavyComputation(params));

Async/await - поддерживается внутри изолята
Автоматическое управление - создание и уничтожение изолята происходит автоматически
Простой API - без ReceivePort/SendPort
Обработка ошибок - через стандартные try/catch с Future

Isolate.run() появился в Dart 2.19 и является рекомендуемым способом для простых случаев.
Для более сложных сценариев с двусторонней коммуникацией используй Isolate.spawn() с ReceivePort/SendPort.

Используй когда:
- Нужен современный, чистый API
- Разовая задача без сложной коммуникации
- Хочешь передать несколько параметров через замыкание
- Работаешь в pure Dart проекте

🎯 3) Isolate.spawn() - Maximum control

// Долгоживущий изолят с двусторонней связью
final receivePort = ReceivePort();
await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);

Используй когда:

Нужна двусторонняя коммуникация
- Изолят должен жить долго
- Требуется полный контроль над жизненным циклом
- Работаешь с потоками данных
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое null safety?',
    a: '''
В старых версиях Dart (до Dart 2.12, до введения null safety) Null относился к Object:

Object
  ├── Null (null относился сюда)
  ├── num
  │   ├── int
  │   └── double
  ├── String
  ├── bool
  ├── List
  ├── Map
  └── ...

// Dart < 2.12
print(null is Object);        // true
print(null is Null);          // true
print(null.runtimeType);      // Null

Object obj = null;            // Компилировалось без ошибок
List<int> list = null;        // Допустимо
int x = null;                 // Допустимо для всех типов

🎯 После введения null safety (Dart 2.12+):

Object?
  ├── Object (не включает null)
  │   ├── String
  │   ├── int
  │   └── ...
  |
  └── Null (null)

или

//  Корневая иерархия типов:
//
//         Object?
//        /       \
//   Object        Null
//      |           |
//   [все типы]    null
//      |
//  String, int...

Теперь null существует отдельно и только Object? может содержать null.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает allMatches для String?',
    a: '''
Ищет все непересекающиеся вхождения заданного шаблона (строки или RegExp) в другой строке и возвращает Iterable<Match>.

Пример

  String a = 'xooo';
  print('x'.allMatches(a).length); // 1
  print('o'.allMatches(a).length); // 3

Под капотом 'x'.allMatches(...) — это короткая форма для: RegExp('x').allMatches(a)
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое `Completer`?',
    a: '''
Completer - это инструмент для создания контролируемых Future
Future - представляет результат асинхронной операции
Ручное управление состоянием Future (успех/ошибка)

🎯 Инициализация
final Completer<T> completer = Completer<T>();
- Создает "контроллер" для Future типа T

🎯 Получение Future
final Future<T> future = completer.future;
- Возвращает Future, связанный с Completer

🎯 Проверка состояния
bool completer.isCompleted
- Показывает, завершен ли уже Future
- true - завершен (успешно или с ошибкой)
- false - все еще ожидает завершения

🎯 Успешное завершение
completer.complete(value);
- Завершает Future успешно с результатом value
- После этого все .then() и await получат этот результат

🎯 Завершение с ошибкой
dartcompleter.completeError(error);
- Завершает Future с ошибкой
- Ошибка попадет в .catchError() или try-catch при await

🎯 Симуляция загрузки данных с сервера
Future<String> loadDataFromServer() {
  final Completer<String> completer = Completer<String>();

  // Имитация асинхронной операции
  Timer(Duration(seconds: 2), () {
    if (Random().nextBool()) {
      // Успешная загрузка
      completer.complete("Данные загружены!");
    } else {
      // Ошибка загрузки
      completer.completeError("Ошибка сети");
    }
  });

  return completer.future;
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое join?',
    a: '''
Метод для объединения элементов коллекции в строку

🎯 Строки
final List<String> names = ['Alice', 'Bob', 'Charlie'];
final String result = names.join(', '); // "Alice, Bob, Charlie"

🎯 Числа (автоматически преобразуются в строки)
final List<int> numbers = [1, 2, 3, 4];
final String numbersString = numbers.join('-'); // "1-2-3-4"

🎯 С пустым разделителем
final List<String> chars = ['H', 'e', 'l', 'l', 'o'];
final String word = chars.join(''); // "Hello"
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какой формулой вывести сумму чисел от 1 до n?',
    a: '''
🎯 Наивный подход - O(n)

int sumOfNaive(int n) {
  int sum = 0;
  for (int i = 1; i <= n; i++) {
    sum += i;
  }
  return sum;
}

🎯 Математическая формула - O(1)

int sumOf(int n) {
  return (n + 1) ~/ 2 * n;
}

Преимущества O(1): Не зависит от размера входных данных

Сложение: n + 1 → 1 операция
Целочисленное деление: ~/ 2 → 1 операция
Умножение: * n → 1 операция

Итого: 3 элементарные операции вне зависимости от размера входных данных.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что такое clamp?',
    a: '''
используется для ограничения значения в заданных границах.
Он доступен у числовых типов (int, double, num) и работает так:

num clamp(num lowerLimit, num upperLimit)
- lowerLimit — нижняя граница
- upperLimit — верхняя граница

void main() {
  var value1 = 5;
  print(value1.clamp(0, 10)); // 5 (в пределах)

  var value2 = -3;
  print(value2.clamp(0, 10)); // 0 (меньше минимума)

  var value3 = 15;
  print(value3.clamp(0, 10)); // 10 (больше максимума)
}

📌 Для чего это удобно
- Ограничить позицию объекта (например, при анимации в Flutter)
- Контролировать ввод пользователя (например, минимальный и максимальный возраст)
- Безопасно работать с диапазонами (например, при расчёте процентов или прогресса)

💡 Замечание:
clamp() не изменяет исходное число, а возвращает новое значение
''',
  ),
  QA(
    tags: [Tag.dart, Tag.complexity],
    q: 'Что такое StringBuffer?',
    a: r'''
1️⃣ Строки в Dart неизменяемые

В Dart (как и в Java, C#, Python) строка — immutable.
Когда пишем:

var s = 'a';
s += 'b';

происходит не изменение, а:
- Создаётся новый объект строки длиной len(s) + len('b')
- Копируется содержимое старой строки s
- Копируется содержимое 'b'
- Старый объект остаётся висеть до сборки мусора

В цикле это особенно болезненно:

var s = '';
for (var i = 0; i < 1_000_000; i++) {
  s += i.toString();
}

Каждая итерация создаёт новую строку и копирует всё накопленное содержимое заново — получаем O(n²) по времени и памяти.

2️⃣ StringBuffer использует внутренний изменяемый буфер

Вместо того чтобы пересоздавать строку каждый раз:
- Он хранит данные в списке (List<Object>) или массиве байтов внутри (в реализации Dart это List<dynamic>).
- Каждый вызов write() просто добавляет ссылку на объект в этот список.
- Когда ты вызываешь toString(), все куски один раз конкатенируются в итоговую строку.

Выглядит примерно так (упрощённо):
class StringBuffer {
  final List<Object?> _chunks = [];

  void write(Object? obj) {
    _chunks.add(obj.toString());
  }

  String toString() {
    // join копирует всё в один новый StringBuilder на уровне движка
    return _chunks.join();
  }
}

Таким образом:
Добавление — O(1) амортизированно
Формирование итоговой строки — O(n) только один раз в конце

🎯 Замер скорости

void performanceComparison() {
  final Stopwatch stopwatch = Stopwatch();
  const int iterations = 10000;

  // ❌ Неэффективный способ - создание новых строк
  stopwatch.start();
  String inefficient = '';
  for (int i = 0; i < iterations; i++) {
    inefficient += 'segment $i '; // Каждый раз новый String объект
  }
  stopwatch.stop();
  print('String concatenation: ${stopwatch.elapsedMilliseconds}ms');


  stopwatch.reset();


  // ✅ Эффективный способ - StringBuffer
  stopwatch.start();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < iterations; i++) {
    buffer.write('segment $i '); // Добавление в буфер
  }
  final String efficient = buffer.toString(); // Одна операция объединения
  stopwatch.stop();
  print('StringBuffer: ${stopwatch.elapsedMilliseconds}ms');
}

void main () {
  performanceComparison();

  // String concatenation: 35ms
  // StringBuffer: 2ms
}


ВРЕМЕННАЯ СЛОЖНОСТЬ СТРОКОВЫХ ОПЕРАЦИЙ В DART:

STRING CONCATENATION (сложение строк):
─────────────────────────────────────────────────
Оператор +:  O(n) для каждой операции
Причина: строки неизменяемы, создается новая строка

ПРИМЕР:
String result = '';
for (int i = 0; i < n; i++) {
  result += 'a';  // O(1) + O(2) + O(3) + ... + O(n) = O(n²)
}

Сложность n последовательных конкатенаций: O(n²)

STRINGBUFFER:
─────────────────────────────────────────────────
append (write):     O(1) амортизированно
toString():         O(n) где n - общая длина

ПРИМЕР:
StringBuffer buffer = StringBuffer();
for (int i = 0; i < n; i++) {
  buffer.write('a');  // O(1) каждая, всего O(n)
}
String result = buffer.toString();  // O(n)

Сложность n добавлений + toString(): O(n)

СРАВНЕНИЕ ПРОИЗВОДИТЕЛЬНОСТИ:
─────────────────────────────────────────────────
┌─────────────────┬─────────────┬─────────────┐
│ Операция        │ String      │ StringBuffer│
├─────────────────┼─────────────┼─────────────┤
│ 1 конкатенация  │ O(n)        │ O(1)        │
│ n конкатенаций  │ O(n²)       │ O(n)        │
│ toString()      │ O(1)        │ O(n)        │
└─────────────────┴─────────────┴─────────────┘

РЕКОМЕНДАЦИИ:
─────────────────────────────────────────────────
✓ Используй StringBuffer для множественных конкатенаций
✓ Для 2-3 строк оператор + приемлем
✓ Для форматирования строк используй interpolation: '${a}${b}'

''',
  ),
  QA(
    tags: [Tag.dart, Tag.complexity],
    q: 'Как работает sort в dart?',
    a: r'''
Алгоритм использует Dual-Pivot Quicksort — улучшенную версию быстрой сортировки с двумя опорными элементами.

if (массив <= 32_элементов) {
  используем_insertion sort(); // Простая и быстрая для малого объема
} else {
  используем_dualPivotQuicksort();   // Быстрая для больших массивов
}

https://github.com/dart-lang/sdk/blob/main/sdk/lib/internal/sort.dart#L61


Сортировка вставками (insertion sort) - это простой алгоритм сортировки, который строит отсортированный массив
по одному элементу за раз. Он работает, беря каждый элемент из входной последовательности и вставляя его
в отсортированную часть массива в правильную позицию.

Пример пошагово

[5, 3, 8, 4, 2]
[3, 5, 8, 4, 2]
[3, 4, 8, 5, 2]
[2, 3, 4, 8, 5]
[2, 3, 4, 5, 8]

🎯 Dual-Pivot Quicksort

Представь, что нужно рассортировать людей по росту:
- В обычном quicksort ты ставишь одного человека как эталон и говоришь: "Все, кто ниже — налево, кто выше — направо".
- В dual-pivot у тебя два эталона (низкий и высокий), и люди сразу делятся на три группы: низкие, средние и высокие. Это быстрее, чем делать два прохода.

1️⃣ Обычный Quicksort
Обычный алгоритм Quicksort выбирает одну опорную точку (pivot) и делит массив на две части:
- элементы меньше pivot
- элементы больше pivot
- Потом рекурсивно сортирует эти две части.


2️⃣ Dual-Pivot Quicksort (двойной pivot)
Вместо одного опорного элемента берутся два pivots (например, первый и последний элемент).
Тогда массив делится сразу на три части:
- Все элементы меньше первого pivot1
- Все элементы между pivot1 и pivot2
- Все элементы больше второго pivot2
- Дальше каждая часть сортируется рекурсивно тем же методом.

Массив:
[9, 2, 7, 4, 6, 8, 1]

Выбираем два pivot: 2 и 8.
Разбиваем на три группы:
  < 2: [1]
  2..8: [7, 4, 6]
  > 8: [9]
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как получить код символа? Например, для буквы z?',
    a: r'''
🎯 Для одного символа (String длиной 1)
int code1 = 'z'.codeUnitAt(0); // 122
int code2 = 'Z'.codeUnitAt(0); // 90

🎯 Альтернативно
int code3 = 'z'.codeUnits.first; // 122
int code4 = 'Z'.codeUnits.first; // 90

🎯 Обратно - из кода в символ
String z = String.fromCharCode(122); // 'z'
String Z = String.fromCharCode(90);  // 'Z'

void main() {
  print('z: ${'z'.codeUnitAt(0)}');     // z: 122
  print('Z: ${'Z'.codeUnitAt(0)}');     // Z: 90

  // Диапазон a-z: 97-122
  // Диапазон A-Z: 65-90

  for (int i = 97; i <= 122; i++) {
    print('${String.fromCharCode(i)} = $i');
  }
}

for (int i = 97; i <= 122; i++) {
  print('${String.fromCharCode(i)} = $i');
}

// вывод: 97...122
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Для чего нужны функции min и max?',
    a: r'''
🎯 Назначение:
min(a, b) - возвращает меньшее значение
max(a, b) - возвращает большее значение

int smaller = min(5, 10);     // 5
int bigger = max(5, 10);      // 10
double minDouble = min(3.14, 2.71); // 2.71

🎯 Адаптивная ширина виджета
Widget adaptiveContainer(double screenWidth) {
  return Container(
    width: min(screenWidth * 0.8, 400), // Максимум 400px или 80% экрана
    height: max(200, screenWidth * 0.3), // Минимум 200px
  );
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие бывают конструкторы класса?',
    a: r'''
🎯 1. Обычный (Default) конструктор

class User {
  String name;
  int age;

  User(this.name, this.age); // Основной конструктор
}

🎯 2. Именованные конструкторы

class User {
  String name;
  int age;

  User(this.name, this.age);

  User.guest() : name = 'Guest', age = 0; // пример 1

  User.fromJson(Map<String, dynamic> json) // пример 2
      : name = json['name'],
        age = json['age'];

  User.child(String name) : this(name, 0); // пример 3
}

🎯 3. Factory конструкторы

class User {
  String name;
  int age;

  User(this.name, this.age);

  factory User(String name, int age) {
    if (age < 0) throw ArgumentError('Invalid age');
    return User._(name, age);
  }

  factory User.admin() => AdminUser._('Admin', 30);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['age']);
  }
}

🎯 4. Const конструкторы

class Point {
  final double x, y;

  // Const конструктор - создает compile-time константы
  const Point(this.x, this.y);

  const Point.origin() : x = 0, y = 0;
}

// Одинаковые const объекты - идентичны
const p1 = Point(1, 2);
const p2 = Point(1, 2);
print(identical(p1, p2)); // true

Ключевые различия:

- Обычный/Именованный - всегда новый объект
- Factory - полный контроль, может вернуть что угодно
- Const - compile-time константы, одинаковые объекты идентичны

🎯 5. Приватный конструктор

class StubRestaurantsDatabase {
  // Приватный конструктор для предотвращения создания экземпляров
  StubRestaurantsDatabase._();
''',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: '''
В каком порядке выполнится код?

void main() {
  print('1. Sync code');
  scheduleMicrotask(() => print('2. scheduleMicrotask'));
  Future.microtask(() => print('3. Future.microtask'));
  Future.sync(() => print('4. Future.sync - выполнится синхронно!'));
  Future.value(42).then((value) => print('5. Future.value.then'));
  Future(() => 'completed').then((_) => print('6. Future().then'));
  Future(() => print('7. Future()'));
  Future.delayed(Duration.zero, () => print('8. Future.delayed(zero)'));
  Future.delayed(Duration(milliseconds: 1), () => print('9. Future.delayed(1ms)'));
  Timer.run(() => print('10. Timer.run'));
  Timer(Duration.zero, () => print('11. Timer(zero)'));
  Timer(Duration(milliseconds: 1), () => print('12. Timer(1ms)'));
  Stream.fromIterable([1]).listen((_) => print('13. Stream event'));
  print('16. More sync code');
}
  ''',
    a: '''
// Синхронный код выполняется сразу:
1.  print(Sync code)
4.  Future.sync(() => print()) - выполнится синхронно!
16. print(More sync code)

// Затем MICROTASK QUEUE: (высокий приоритет)
2.  scheduleMicrotask
3.  Future.microtask
5.  Future.value.then
13. Stream event
6.  Future().then

// Затем EVENT QUEUE: (низкий приоритет)
7.  Future()
8.  Future.delayed(zero) // даже 0
10. Timer.run
11. Timer(zero)
9.  Future.delayed(1ms)
12. Timer(1ms)
''',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: '''
В каком порядке выполнится код?

class AsyncPerson {
  AsyncPerson() {
    print('1. Constructor start');
    Future(() => print('2. From constructor Future'));
    scheduleMicrotask(() => print('3. From constructor Microtask'));
    print('4. Constructor end');
  }
}

void main() {
  print('5. Before');
  final person = AsyncPerson();
  print('6. After');
  Future(() => print('7. Main Future'));
}
  ''',
    a: '''
// Синхронный код выполняется сразу:
print('5. Before');
print('1. Constructor start');
print('4. Constructor end');
print('6. After');

// Затем MICROTASK QUEUE:
scheduleMicrotask(() => print('3. From constructor Microtask');

// Затем EVENT QUEUE:
Future(() => print('2. From constructor Future'));
Future(() => print('7. Main Future'));
''',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: '''
В каком порядке выполнится код?

void main() {
  print('A');
  Future(() => print('B'));
  scheduleMicrotask(() => print('C'));
  Future.delayed(Duration.zero, () => print('D'));
  print('E');
}
''',
    a: '''
// Синхронный код выполняется сразу
print('A');
print('E');

// Затем MICROTASK QUEUE
scheduleMicrotask(() => print('C'));

// Затем EVENT QUEUE
Future(() => print('B'));
Future.delayed(Duration.zero, () => print('D'));
''',
  ),
  QA(
    tags: [Tag.dart],
    q: r'Как в строке найти количество определенного символа, например, @, через RegExp?',
    a: '''
🎯 Количество всех символов
String text = "Hello @ world @ test @";
int count = RegExp(r'@').allMatches(text).length;
print(count); // Выведет: 3

🎯 Наличие
String text = "Hello D world @ test";
bool hasDog = RegExp(r'D').hasMatch(text);
print(hasDog); // Выведет: true
''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Чем отличается i++ от ++i ?',
    a: '''
🎯 i++ (постфиксный инкремент):
- Возвращает текущее значение i, затем увеличивает на 1
- Сначала возврат, потом инкремент

🎯 ++i (префиксный инкремент):
- Увеличивает i на 1, затем возвращает новое значение
- Сначала инкремент, потом возврат

Пример:

int a = 5;
int b = 5;

int x = a++; // x = 5
             // a = 6

int y = ++b; // y = 6
             // b = 6

В циклах разницы нет:

// Эквивалентны
for (int i = 0; i < 10; i++) { }
for (int i = 0; i < 10; ++i) { }
''',
  ),
  QA(
    tags: [Tag.dart, Tag.future],
    q: 'Таблица Event Loop - Очереди выполнения',
    a: '''
Порядок выполнения
- Синхронный код (main thread) - выполняется сразу
- Microtask Queue - выполняется после синхронного кода, имеет приоритет
- Event Queue - выполняется после опустошения microtask queue

┌─────────────────────────────────────────────────────────────────┐
│                         СИНХРОННЫЙ КОД                          │
│                    (выполняется немедленно)                     │
├─────────────────────────────────────────────────────────────────┤
│ ✓ print('1. Sync code')                                         │
│ ✓ Future.sync(() => print('4. Future.sync'))                    │
│ ✓ print('16. More sync code')                                   │
│ ✓ var result = someFunction()                                   │
│ ✓ if/for/while циклы                                            │
│ ✓ Создание объектов: var obj = MyClass()                        │
│ ✓ Синхронные методы: list.add(), map.putIfAbsent()              │
│ ✓ setState(() {}) - сам вызов синхронный                        │
│ ✓ throw Exception() - синхронный                                │
│ ✓ try/catch блоки                                               │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        MICROTASK QUEUE                          │
│                  (высокий приоритет, FIFO)                      │
├─────────────────────────────────────────────────────────────────┤
│ ◦ scheduleMicrotask(() => print('2. scheduleMicrotask'))        │
│ ◦ Future.microtask(() => print('3. Future.microtask'))          │
│ ◦ Future.value(42).then((value) => print('5. then'))            │
│ ◦ Future.error('error').catchError((e) => print(e))             │
│ ◦ Completer().future.then(...)                                  │
│ ◦ Stream.fromIterable([1]).listen(...) - сам listener           │
│ ◦ StreamController.add() - уведомления listeners                │
│ ◦ async/await - продолжение после await                         │
│ ◦ Zone.current.scheduleMicrotask(...)                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         EVENT QUEUE                             │
│                    (обычный приоритет, FIFO)                    │
├─────────────────────────────────────────────────────────────────┤
│ ○ Future(() => print('7. Future()'))                            │
│ ○ Future(() => 'completed').then((_) => print('6. then'))       │
│ ○ Future.delayed(Duration.zero, () => print('8. delayed'))      │
│ ○ Future.delayed(Duration(milliseconds: 1), () => print('9'))   │
│ ○ Timer.run(() => print('10. Timer.run'))                       │
│ ○ Timer(Duration.zero, () => print('11. Timer zero'))           │
│ ○ Timer(Duration(milliseconds: 1), () => print('12. Timer'))    │
│ ○ Timer.periodic(Duration(seconds: 1), ...)                     │
│ ○ HttpClient.get().then(...) - HTTP ответы                      │
│ ○ File.readAsString().then(...) - I/O операции                  │
│ ○ Socket события                                                │
│ ○ Process.run().then(...) - запуск процессов                    │
│ ○ Directory.list().listen(...) - файловая система               │
│ ○ Isolate.spawn().then(...) - создание изолятов                 │
│ ○ Platform канальные события                                    │
│ ○ UI события (жесты, нажатия) - в Flutter                       │
│ ○ AnimationController.forward().then(...)                       │
│ ○ Future(() => heavyComputation()) - тяжелые вычисления         │
└─────────────────────────────────────────────────────────────────┘

''',
  ),

  QA(
    tags: [Tag.dart],
    q: 'Как быстро удвоить integer?',
    a: '''
void main() {
  print(2 << 0); // 2  (2 * 1)
  print(2 << 1); // 4  (2 * 2)
  print(2 << 2); // 8  (2 * 2 * 2)
  print(2 << 3); // 16 (2 * 2 * 2 * 2)

  print(3 << 1); // 6  (3 * 2)
  print(3 << 2); // 12 (3 * 2 * 2)
  print(3 << 3); // 24 (3 * 2 * 2 * 2)
}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: '''
Как исправить ошибку?
A value of type 'Iterable<int>' can't be assigned to a variable of type List
''',
    a: '''
Эта ошибка возникает потому, что Iterable<int> и List<int> — это разные типы, хотя List и реализует Iterable.

Необходимо явное преобразование с помощью toList()

// Неправильно
List<int> numbers = [1, 2, 3].where((n) => n > 1); // Ошибка

// Правильно
List<int> numbers = [1, 2, 3].where((n) => n > 1).toList();
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Как приводить типы элементов в коллекции?',
    a: '''
🎯 1. cast<T>()

List<dynamic> source = [1, 'hello', 3, null];
List<int> result = source.where((e) => e is int).cast<int>().toList(); [1, 3]

Use 'whereType' to select elements of a given type.

🎯 2. whereType<T>() - Безопасная фильтрация

List<dynamic> source = [1, 'hello', 3, null];
List<int> result = source.whereType<int>().toList(); // [1, 3]
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Какие способы есть для обновления значения в Map?',
    a: r'''
Map<String, int> result = {'a': 1};

🎯 Вариант 1: Прямое обращение с проверкой на null
result['a'] = (result['a'] ?? 0) + 1; // {a: 2}

🎯 Вариант 2: Использование update (более идиоматично)
result.update('a', (value) => value + 1, ifAbsent: () => 1); // {a: 3}

🎯 Вариант 3: Если уверен, что ключ существует
result['a'] = result['a']! + 1; // {a: 4}
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Что делает Оператор XOR (^) — "исключающее ИЛИ"',
    a: '''

Используется для:
- инверсия битов
- вычисление контрольных сумм
- генерация хэш

🎯 Как с помощью XOR обменять значения двух переменных без использования третьей?

void swap(a, b) {
  a = a ^ b;
  b = a ^ b; // теперь b = (a ^ b) ^ b = a
  a = a ^ b; // теперь a = (a ^ b) ^ a = b
}

🎯 Чему равно выражение: 5 ^ 3?

  5 = 0b0101
  3 = 0b0011
XOR = 0b0110 = 6
Ответ: 6

🎯 Какой результат даст выражение: true ^ true?

true ^ true   = false  // одинаковые → false
false ^ false = false  // одинаковые → false
true ^ false  = true   // разные → true
false ^ true  = true   // разные → true

🎯 Какой результат даст выражение: 12 ^ 12?

Любое число XOR само с собой даёт 0.
Ответ: 0

🎯 Как с помощью XOR обменять значения двух переменных без использования третьей?

void swap(a, b) {
  a = a ^ b;
  b = a ^ b; // теперь b = (a ^ b) ^ b = a
  a = a ^ b; // теперь a = (a ^ b) ^ a = b
}
''',
  ),

  QA(
    tags: [Tag.dart],
    q: '''
Разница между:

const String envFile = String.fromEnvironment('ENV_FILE');
final String envFile = String.fromEnvironment('ENV_FILE');

''',
    a: '''
// ✅ Правильно - будет получено значение при компиляции
const String envFile = String.fromEnvironment('ENV_FILE', defaultValue: '.env');

// ❌ Неправильно - не будет получено значение при компиляции
final String envFile = String.fromEnvironment('ENV_FILE', defaultValue: '.env');


для --dart-define всегда используй const, так как это compile-time константы.
''',
  ),
  QA(
    tags: [Tag.dart],
    q: '''
Как найти количество определенных слов в строке?

Например, есть final text = "Я люблю кошек и собак";

Нужно найти количество совпадений слов "кошек" и "собак"

Ответ: 2
''',
    a: '''
  final RegExp regexp = RegExp(r'кошек|собак', caseSensitive: false);
  return regexp.allMatches("Я люблю кошек и собак").length;
''',
  ),
  QA(
    tags: [Tag.dart],
    q: 'Для чего нужен padLeft и padRight?',
    a: r'''
padLeft и padRight используются для дополнения строк до нужной длины:

===

String number = '42';
String paddedLeft = number.padLeft(5, '0');   // '00042'
String paddedRight = number.padRight(5, '0'); // '42000'

String text = 'Hi';
String centered = text.padLeft(4, ' ').padRight(6, ' '); // '  Hi  '

====

String formatTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  final second = time.second.toString().padLeft(2, '0');
  return '$hour:$minute:$second'; // 09:05:03 вместо 9:5:3
}
''',
  ),

  QA(
    q: 'Что такое сериализуемый объект?',
    a: '''
Сериализуемый объект — это объект, который можно преобразовать в формат для хранения
или передачи (сериализация) и затем восстановить обратно (десериализация).

class User {
  final String name;
  final int age;
  final String email;

  User({required this.name, required this.age, required this.email});

  // Сериализация в Map
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'email': email,
  };

  // Десериализация из Map
  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    age: json['age'],
    email: json['email'],
  );
}

// Использование
final user = User(name: 'John', age: 30, email: 'john@example.com');
final json = user.toJson(); // Map<String, dynamic>
final jsonString = jsonEncode(json); // JSON строка
final restoredUser = User.fromJson(jsonDecode(jsonString));
''',
  ),
];
