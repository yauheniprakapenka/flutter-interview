// ignore_for_file: unnecessary_raw_strings

import '../model/qa_model.dart';

const List<QA> flutterInterview = [
  QA(
    q: 'В чем отличие StatelessWidget и StatefulWidget?',
    a: '''
StatefulWidget может изменять себя изнутри через setState(), а StatelessWidget изменяется только когда родительский виджет передает ему новые параметры.
Когда использовать: если данные виджета не меняются после создания - используй StatelessWidget. Если нужно хранить и изменять данные - StatefulWidget.
'''
  ),
  QA(
    q: 'Что произойдёт, если вызвать setState() в методе build() у StatefulWidget?',
    a: 'Произойдёт бесконечный цикл перерисовок, так как setState() вызывает build(), а build() вызывает setState(). Это приведёт к StackOverflow или зависанию.',
  ),
  QA(
    q: 'Как обновляется InheritedWidget и кто инициирует rebuild зависимых виджетов?',
    a: '''
InheritedWidget - это специальный механизм для передачи данных вниз по дереву виджетов.

🎯 Как работает обновление:
InheritedWidget сам по себе НЕ инициирует rebuild. Он работает по принципу "push-down" - данные
передаются сверху вниз когда родительский виджет пересоздает InheritedWidget с новыми данными.

🎯 Процесс обновления:

1. Родительский виджет (обычно StatefulWidget) вызывает setState()
2. В методе build() создается новый экземпляр InheritedWidget с обновленными данными
3. Flutter сравнивает старый и новый InheritedWidget через метод updateShouldNotify()
4. Если updateShouldNotify() возвращает true - все зависимые виджеты помечаются для rebuild
5. Только те виджеты которые вызывали dependOnInheritedWidgetOfExactType() будут перестроены

class CounterData extends InheritedWidget {
  final int counter;

  const CounterData({
    required this.counter,
    required Widget child,
  }) : super(child: child);

  static CounterData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterData>();
  }

  @override
  bool updateShouldNotify(CounterData oldWidget) {
    return counter != oldWidget.counter; // rebuild только если изменился counter
  }
}

class CounterProvider extends StatefulWidget {
  final Widget child;

  const CounterProvider({required this.child});

  @override
  _CounterProviderState createState() => _CounterProviderState();
}

class _CounterProviderState extends State<CounterProvider> {
  int _counter = 0;

  void increment() {
    setState(() { // ВОТ ТУТ инициируется обновление
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterData( // Новый экземпляр с новыми данными
      counter: _counter,
      child: widget.child,
    );
  }
}
'''
  ),
  QA(
    q: 'Что произойдет, если передать в setState() пустую функцию: setState((){})?',
    a: 'Даже пустой setState((){}) приведёт к вызову build(). Это сигнал для Flutter, что нужно пересобрать виджет, даже если данные не изменились.',
  ),
  QA(
    q: 'Может ли StatelessWidget иметь поля, которые изменяются? Например, int counter?',
    a: r'''
StatelessWidget МОЖЕТ иметь изменяемые поля технически, но это антипаттерн. Все поля должны быть final.
Если нужно изменяемое состояние - используй StatefulWidget или state management решения (Provider, BLoC, Riverpod).
Виджет может быть пересоздан в любой момент (например, при hot reload или изменении размера экрана), и изменения в полях потеряются.

class BadStatelessWidget extends StatelessWidget {
  int counter = 0; // НЕ final!

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        counter++; // Изменяем поле
        print(counter); // Значение изменилось в памяти
      },
      child: Text('Counter: $counter'), // НО UI НЕ ОБНОВИТСЯ!
    );
  }
}
'''
  ),
  QA(
    q: 'Что произойдёт, если внутри initState() вызвать setState()?',
    a: '''
При вызове setState() внутри initState() произойдет исключение (exception)

  setState() called during build. This can happen when setState() is called from initState().

Почему это происходит:
initState() вызывается до первого build(), когда виджет еще не полностью инициализирован в дереве виджетов.
Flutter не готов обрабатывать запросы на перерисовку на этом этапе жизненного цикла.

Как правильно решить:

🎯 1. Убрать setState() из initState() - просто присваивай значения напрямую:

@override
void initState() {
  super.initState();
  _counter = 10; // Без setState()
}

🎯 2. Использовать WidgetsBinding.instance.addPostFrameCallback():

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      _counter = 10;
    });
  });
}

🎯 3. Перенести в didChangeDependencies() если нужен доступ к context:

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  setState(() {
    _counter = 10;
  });
}
'''
  ),
  QA(
    q: 'Почему нельзя вызывать async/await напрямую в initState()?',
    a: 'В initState() нельзя использовать async/await потому что initState() должен быть синхронным методом ',
  ),
  QA(
    q: 'Как определить, когда StatefulWidget перестаёт быть активным в дереве?',
    a: 'Через метод dispose(), который вызывается перед уничтожением State-объекта.',
  ),
  QA(
    q: 'Может ли один и тот же InheritedWidget быть доступен в нескольких точках дерева с разными значениями?',
    a: 'Да, если он обернут вокруг разных поддеревьев. Каждый экземпляр будет независим, и зависимости будут работать только в пределах своей ветки.',
  ),
  QA(
    q: 'Как работает const у StatelessWidget?',
    a: 'const-конструктор позволяет Flutter оптимизировать пересоздание, потому что объекты с одинаковыми параметрами не будут перестраиваться — они могут быть переиспользованы.',
  ),
  QA(
    q: 'Как виджет находит родителя нужного типа в дереве?',
    a: 'Через методы context.findAncestorWidgetOfExactType или context.dependOnInheritedWidgetOfExactType.',
  ),
  QA(
    q: 'Что такое RenderBox?',
    a: '''
RenderBox - это базовый класс в рендер-слое Flutter, который отвечает за отрисовку и компоновку (layout) двумерных прямоугольных объектов.

Когда ты создаешь виджеты, Flutter под капотом создает RenderBox объекты, которые выполняют фактическую отрисовку на экране.

Основные функции RenderBox:
1. Layout (компоновка) - вычисляет размеры и позиционирование
2. Paint (отрисовка) - рисует содержимое на Canvas
3. Hit Testing - определяет обработку касаний и кликов

Жизненный цикл RenderBox:
1. Получает constraints (ограничения) от родителя
2. Вычисляет свой размер в методе performLayout()
3. Рисует себя в методе paint()
4. Может обрабатывать события в hitTest()
'''
  ),
  QA(
    q: 'Почему нельзя использовать context после async-операций?',
    a: '''
Context становится небезопасным после async-операций, потому что виджет может быть удален из дерева виджетов пока выполняется асинхронная операция.

Проблема:
Context привязан к конкретному виджету в дереве. Если пользователь закрыл экран или виджет пересобрался,
а async-операция еще выполняется, то context становится недействительным.
'''
  ),
  QA(
    q: 'Какая разница между Widget, Element и RenderObject?',
    a: '''
🎯 Widget (Конфигурация)
- Immutable описание того, как должен выглядеть UI
- Легковесный объект, создается и уничтожается постоянно
- Содержит только конфигурацию и данные
- НЕ занимается рендерингом

🎯 Element (Жизненный цикл и состояние)
- Mutable объект, связывает Widget и RenderObject
- Живет дольше Widget'ов, переиспользуется между rebuild'ами
- Управляет жизненным циклом и состоянием
- Хранит ссылку на context
- Решает когда нужно пересоздать RenderObject

🎯 RenderObject (Рендеринг)
- Mutable объект, который реально рисует на экране
- Самый тяжелый для создания
- Выполняет layout, paint и hit-testing
- Содержит размеры, позицию, стили рендеринга

Как они взаимодействуют:

🎯 1. Widget создание:

// Каждый setState создает новый Widget
Container(color: Colors.red) // Новый объект Widget'а

🎯 2. Element сравнение:

// Element сравнивает старый и новый Widget
if (oldWidget.color != newWidget.color) {
  renderObject.color = newWidget.color; // Обновляем RenderObject
}

🎯 3. RenderObject обновление:

// RenderObject перерисовывается только при реальных изменениях
markNeedsPaint(); // Только если цвет изменился

Widget (создается при каждом rebuild)
    ↓
Element (переиспользуется, живет долго)
    ↓
RenderObject (переиспользуется, самый дорогой)
'''
  ),
  QA(
    q: 'Для чего нужен BuildContext?',
    a: '''
BuildContext - предоставляет доступ к информации о виджете и его месте в дереве виджетов.

Что такое BuildContext технически:
- Ссылка на Element в дереве элементов
- Каждый виджет получает свой уникальный context
- Позволяет виджету "знать" где он находится в иерархии

🎯 1. Доступ к данным из родительских виджетов

// Получение темы приложения
Theme.of(context).primaryColor
MediaQuery.of(context).size.width
Localizations.of(context).locale

// Внутри Flutter это работает так:
static ThemeData of(BuildContext context) {
  // Поиск вверх по дереву до ближайшего Theme виджета
  return context.dependOnInheritedWidgetOfExactType<_InheritedTheme>().theme;
}

🎯 2. Навигация

// Навигация между экранами
Navigator.of(context).push(MaterialPageRoute(...));
Navigator.of(context).pop();

// Показ диалогов
showDialog(context: context, builder: (context) => AlertDialog(...));

🎯 3. Показ SnackBar, BottomSheet и других overlay виджетов

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Hello'))
);

showModalBottomSheet(
  context: context,
  builder: (context) => BottomSheetContent()
);

🎯 4. Доступ к состоянию родительских виджетов

// Поиск ближайшего Scaffold
Scaffold.of(context).openDrawer();

// Поиск Form для валидации
Form.of(context)?.validate();

🎯 Как работает поиск "вверх по дереву":

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ⚠️ context ищет Theme начиная от этого виджета вверх
    return Container(
      color: Theme.of(context).primaryColor, // Найдет ближайший Theme
      child: Builder(
        builder: (innerContext) {
          // ⚠️ innerContext - это уже другой контекст!
          return Text('Hello');
        }
      )
    );
  }
}
''',
  ),
  QA(
    q: 'Что происходит, когда вызывается setState?',
    a: 'Вызывается build() на соответствующем StatefulElement, который сравнивает старый и новый Widget и обновляет поддерево.',
  ),
  QA(
    q: 'Как Flutter решает, пересоздавать ли RenderObject при обновлении виджета?',
    a: 'Flutter сравнивает runtimeType и ключи (keys); если они совпадают — переиспользуется старый RenderObject.',
  ),
  QA(
    q: 'Почему StatelessWidget всё ещё имеет метод build, если он "stateless"?',
    a: 'Потому что StatelessWidget может быть перестроен при изменении родительского виджета; build вызывается при каждом rebuild.',
  ),
  QA(
    q: 'Что произойдёт, если поменять ключи у элементов в списке?',
    a: 'Flutter уничтожит старые элементы и создаст новые, даже если виджеты выглядят одинаково — ключи нарушают identity.',
  ),
  QA(
    q: 'Чем отличается const Widget от обычного?',
    a: 'const Widget компилируется один раз и переиспользуется, не требует перестроения — оптимизирует производительность.',
  ),
  QA(
    q: 'Может ли один виджет иметь несколько элементов в дереве?',
    a: 'Да, если один и тот же виджет используется в нескольких местах, Flutter создаст отдельные элементы для каждого использования.',
  ),
  QA(
    q: 'Что делает метод createElement у StatelessWidget/StatefulWidget?',
    a: 'Создаёт соответствующий StatelessElement или StatefulElement, которые будут участвовать в дереве.',
  ),
  QA(
    tags: [Tag.flutter],
    q: 'В чем разница между ValueKey, ObjectKey и UniqueKey?',
    a: '''
🎯 1. ValueKey<T> - когда есть уникальное значение (id, email)

Сравнивает значение (==) и тип объекта.

Когда есть уникальное примитивное значение (или объект с корректным ==),
которое однозначно идентифицирует виджет.

ValueKey('user_123')
ValueKey(42)
ValueKey(User(id: 1)) // если User правильно переопределил == и hashCode

🎯 2. ObjectKey - для уникальных объектов

Сравнивает сам объект по ссылке (identical(a, b)), игнорируя ==.

Когда есть объект, который не переопределяет ==, или необходимо привязаться именно к экземпляру, а не к значению.

final user1 = User(name: "Alice");
final user2 = User(name: "Alice"); // другой экземпляр
ObjectKey(user1) != ObjectKey(user2) // даже если user1 == user2 по полям

🎯 3. UniqueKey - когда нет уникального значения (создается новый каждый раз)

Гарантированно уникален — создаётся новый ключ при каждом создании экземпляра.

final key1 = UniqueKey();
final key2 = UniqueKey();
print(key1 == key2); // false всегда

⚠️ Опасность: Использование UniqueKey в build() → новый ключ при каждом ререндере → Flutter думает,
что это новый виджет → State теряется → виджет пересоздаётся с нуля → плохо для производительности и состояния.

✅ Подходит для:
- редких случаев, когда нужно сбросить состояние виджета принудительно.
- тестов (чтобы гарантировать пересоздание виджета).

🎯 4. GlobalKey - когда нужен доступ к State или RenderObject

🎯 5. PageStorageKey - для сохранения позиции скролла
''',
  ),
  QA(
    q: 'Что произойдет, если не использовать Key при динамическом списке?',
    a: 'Flutter может перепутать виджеты, переиспользовать не те элементы и нарушить состояние — например, состояние TextField окажется у другого элемента.',
  ),
  QA(
    q: 'Как Key влияет на работу Element Tree?',
    a: 'Key влияет на то, как Flutter сопоставляет старые и новые элементы дерева при hot reload или при изменении стейта. Он определяет, следует ли сохранить существующий элемент или создать новый.',
  ),
  QA(
    q: 'Можно ли использовать один и тот же Key для нескольких виджетов?',
    a: 'Нет, Key должен быть уникальным в рамках одного родительского виджета. Повторяющиеся ключи приведут к ошибке при построении.',
  ),
  QA(
    q: 'Когда обязательно использовать Key?',
    a: '''
🎯 1. Списки с изменяемым порядком элементов

Без Key Flutter сопоставляет виджеты по позиции, что ломается при reorder:

// НЕПРАВИЛЬНО - без Key
List<Widget> items = list.map((item) =>
  ListTile(title: Text(item.name))
).toList();

// ПРАВИЛЬНО - с Key
List<Widget> items = list.map((item) =>
  ListTile(
    key: ValueKey(item.id), // Уникальный ключ
    title: Text(item.name)
  )
).toList();

🎯 2. StatefulWidget в списках

Состояние может "прилипнуть" к неправильному элементу:

// Счетчик без Key - состояние остается в той же позиции
class CounterWidget extends StatefulWidget {
  final String name;

  CounterWidget({required this.name, Key? key}) : super(key: key);
}

// При удалении первого элемента, состояние второго "перепрыгнет" на первое место
// Решение - использовать ValueKey(name) или UniqueKey()

🎯 3. Формы и текстовые поля

TextEditingController может потерять фокус или данные:

// В списке TextField'ов обязательно нужен Key
TextField(
  key: ValueKey('email_field'),
  controller: emailController,
)
'''
  ),
  QA(
    q: 'Что произойдет, если использовать UniqueKey в ListView.builder?',
    a: 'Каждый элемент будет иметь новый ключ при перестроении, что приведет к полной потере состояния и созданию новых элементов каждый раз. Это неправильное использование.',
  ),
  QA(
    q: 'Можно ли использовать const конструкцию с Key?',
    a: 'Да, например, const ValueKey("id"). Const позволяет использовать ключи в compile-time и избегать ненужных перестроений.',
  ),
  QA(
    q: 'Как ключи помогают в оптимизации ререндеринга UI?',
    a: 'Ключи позволяют Flutter точно понимать, какие элементы изменились, какие можно переиспользовать, и какие нужно пересоздать. Это минимизирует лишние rebuild и сохраняет состояние там, где это нужно.',
  ),
  QA(
    q: 'Можно ли сохранить BuildContext в переменной и использовать позже?',
    a: 'Нет. BuildContext может стать невалидным после перестроения. Лучше вызывать методы, использующие context, синхронно внутри build или методов жизненного цикла.',
  ),
  QA(
    q: 'Почему возникает ошибка "No Material widget found" при вызове Theme.of(context)?',
    a: 'Ошибка возникает, если в иерархии выше текущего context нет MaterialApp или Theme. Возможно, context был вызван слишком рано или вне нужной иерархии.',
  ),
  QA(
    q: 'Что делает метод `context.findAncestorWidgetOfExactType<T>()`?',
    a: 'Ищет первого родительского виджета указанного типа <T> выше по дереву. Это используется для доступа к окружению без state management.',
  ),
  QA(
    q: 'Можно ли вызвать Navigator.of(context) в initState?',
    a: 'Нет. Navigator.of(context) безопасно вызывать только после фазы build, например в addPostFrameCallback.',
  ),
  QA(
    q: 'Как получить размер виджета?',
    a: r'''
🎯 1. GlobalKey + RenderBox (самый популярный)

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: _key,
          width: 200,
          height: 100,
          color: Colors.blue,
        ),
        ElevatedButton(
          onPressed: _getSize,
          child: Text('Получить размер'),
        ),
      ],
    );
  }

  void _getSize() {
    final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    print('Ширина: ${size.width}, Высота: ${size.height}');
  }
}

🎯 2. LayoutBuilder (размер доступного пространства)

LayoutBuilder(
  builder: (context, constraints) {
    print('Доступная ширина: ${constraints.maxWidth}');
    print('Доступная высота: ${constraints.maxHeight}');

    return Container(
      width: constraints.maxWidth * 0.8,
      height: 100,
      color: Colors.red,
    );
  },
)

🎯 3. MediaQuery (размер экрана)

@override
Widget build(BuildContext context) {
  final Size screenSize = MediaQuery.of(context).size;

  return Container(
    width: screenSize.width * 0.5,
    height: screenSize.height * 0.3,
    child: Text('Половина ширины экрана'),
  );
}
'''
  ),
  QA(
    q: 'Что такое mounted в StatefulWidget?',
    a: '''
mounted - это булевое свойство State класса, которое показывает привязан ли виджет к дереву виджетов или нет.

🎯 Жизненный цикл mounted:

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    print(mounted); // true - виджет только что создан
  }

  @override
  void dispose() {
    print(mounted); // false - виджет уже отвязан
    super.dispose();
  }
}

🎯 Основное применение - защита от ошибок:

Проблема без проверки mounted:

void _loadData() async {
  final data = await api.getData(); // Долгая операция

  // ОПАСНО! Пользователь мог закрыть экран
  setState(() {
    _data = data; // Ошибка если виджет удален!
  });
}

Правильное использование:

void _loadData() async {
  final data = await api.getData();

  if (mounted) { // Проверяем что виджет еще живой
    setState(() {
      _data = data;
    });
  }
}

🎯 Типичные сценарии использования:

1. Async операции:

void _fetchUserData() async {
  try {
    final userData = await userService.getUser();

    if (mounted) {
      setState(() {
        _user = userData;
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
}

2. Таймеры и периодические операции:

Timer? _timer;

@override
void initState() {
  super.initState();
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    if (mounted) {
      setState(() {
        _counter++;
      });
    } else {
      timer.cancel(); // Останавливаем таймер
    }
  });
}

@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

3. Навигация после async операций:

void _saveAndNavigate() async {
  await saveData();

  if (mounted) {
    Navigator.of(context).pop();
  }
}
'''
  ),
  QA(
    q: 'Жизненный цикл StatefulWidget?',
    a: '''
                        ┌─────────────┐
                        │ constructor │
                        └─────────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   createState()     │
                    └─────────────────────┘


                    ┌─────────────────────┐
                    │    BuildContext     │
                    │      assigned       │
                    └─────────────────────┘
                               │ mounted = true
                               ▼
                    ┌─────────────────────┐
                    │     initState       │ widget properties
                    └─────────────────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │didChangeDependencies│
                    └─────────────────────┘
                               │
                               ▼
                         ┌──────────┐
                 ┌──────▶│dirty=true│◄───────┐
                 │       └──────────┘        │
                 │             │             │
                 │             ▼             │
         ┌───────────┐     ┌────────┐    ┌──────────┐
         │ didUpdate │     │ build  │    │ setState │
         │  Widget   │     └────────┘    └──────────┘
         └───────────┘         │             │
                ▲              ▼             │
                │        ┌───────────┐       │
                └────────│dirty=false│───────┘
                         └───────────┘
                               │
                               ▼
                       ┌─────────────────┐
                       │   deactivate    │
                       └─────────────────┘
                               │
                               ▼
                       ┌─────────────────┐
                       │    dispose      │
                       └─────────────────┘
                        mounted = false
''',
  ),
  QA(
    q: 'Чем отличаются методы initState() и didChangeDependencies()?',
    a: '''
- initState() вызывается один раз при создании State и не имеет доступа к InheritedWidget'ам через context.
- didChangeDependencies() вызывается после initState(). Если виджет связан с InheritedWidget, этот метод будет вызываться каждый раз, когда этот виджет будет перестраиваться.
''',
  ),
  QA(
    q: 'Когда стоит использовать addPostFrameCallback?',
    a: 'Когда нужно выполнить код после первого кадра (построения UI). Это полезно, чтобы, например, показать диалог после отображения экрана.',
  ),
  QA(
    q: 'Что делает метод dispose()? Когда его вызывать обязательно?',
    a: 'dispose() вызывается при удалении виджета из дерева. Его нужно переопределить, чтобы освободить ресурсы: контроллеры, таймеры, слушатели и т.п.',
  ),
  QA(
    q: 'Как сохранить состояние при переходе на другую вкладку или экран?',
    a: 'Можно использовать AutomaticKeepAliveClientMixin для табов или другие механизмы, как Provider, Riverpod, чтобы сохранить данные вне State.',
  ),
  QA(
    q: 'Что такое BLoC?',
    a: '''
BLoC (Business Logic Component) - это архитектурный паттерн для разделения бизнес-логики от UI.
Основан на Streams и использует реактивное программирование.

Основные принципы BLoC:

1. Вся бизнес-логика выносится в отдельные компоненты (BLoC)
2. UI только отправляет события и слушает состояния
3. Односторонний поток данных: Event → BLoC → State
4. BLoC ничего не знает об UI, полностью независим
'''
  ),
  QA(
    q: 'Как передать ошибку в состояние в Cubit?',
    a: r'''
class UserState {
  final User? user;
  final bool isLoading;
  final String? error;

  UserState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserState());

  Future<void> loadUser(int userId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await userRepository.getUser(userId);
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}

BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    }

    if (state.error != null) {
      return Column(
        children: [
          Text('Ошибка: ${state.error}'),
          ElevatedButton(
            onPressed: () => context.read<UserCubit>().loadUser(1),
            child: Text('Повторить'),
          ),
        ],
      );
    }

    if (state.user != null) {
      return Text('Привет, ${state.user!.name}');
    }

    return Text('Нажмите "Загрузить"');
  },
)
'''
  ),
  QA(
    q: 'Что произойдёт, если в Cubit вызвать emit дважды подряд с одинаковым состоянием?',
    a: 'Cubit не уведомит слушателей, если новое состояние эквивалентно предыдущему (через ==). Это помогает избежать лишних rebuild.',
  ),
  QA(
    q: 'Что такое HydratedBloc?',
    a: 'HydratedBloc — расширение BLoC, которое автоматически сохраняет и восстанавливает состояние BLoC между запусками приложения с помощью local storage.',
  ),
  QA(
    q: 'Как работает BlocProvider и зачем он нужен?',
    a: 'BlocProvider предоставляет экземпляр BLoC (или Cubit) для всего поддерева виджетов и управляет его жизненным циклом.',
  ),
  QA(
    q: 'Что такое MultiBlocProvider и зачем он используется?',
    a: 'MultiBlocProvider — это удобный способ зарегистрировать несколько BLoC/Cubit в одном месте, чтобы не вкладывать BlocProvider вручную.',
  ),
  QA(
    q: 'Чем BlocBuilder отличается от BlocListener?',
    a: '''
BlocBuilder — используется для перестроения UI на основе состояния.
BlocListener — для выполнения побочных эффектов (показ Snackbar, переходы и т.д.), он не перестраивает UI.
''',
  ),
  QA(
    q: 'Для чего нужны: context.read(), context.watch() и context.select()?',
    a: r'''
Эти методы используются для работы с Provider/BLoC и имеют разные принципы взаимодействия с состоянием:

🎯 context.read() -  Получает значение БЕЗ подписки на изменения

// Получаем BLoC для отправки события
void _increment() {
  context.read<CounterBloc>().add(CounterIncrement());
}

// Или получаем Provider для вызова метода
void _addItem() {
  context.read<CartProvider>().addItem(product);
}

🎯 context.watch() - Получает значение И подписывается на изменения

@override
Widget build(BuildContext context) {
  // Подписка на все изменения состояния
  final counterState = context.watch<CounterBloc>().state;

  if (counterState is CounterLoaded) {
    return Text('Count: ${counterState.count}');
  }
  return CircularProgressIndicator();
}

🎯 context.select() - Подписывается только на конкретную часть состояния

@override
Widget build(BuildContext context) {
  // Подписка только на count, игнорирует другие изменения
  final count = context.select<CounterBloc, int>(
    (bloc) => bloc.state is CounterLoaded
      ? (bloc.state as CounterLoaded).count
      : 0
  );
  return Text('Count: $count');
}
''',
  ),
  QA(
    q: 'Что такое WidgetsFlutterBinding.ensureInitialized()?',
    a: '''
Flutter framework должен быть полностью инициализирован перед тем как использовать его API.
По умолчанию инициализация происходит автоматически при вызове runApp(), но если нужно выполнить
какую-то работу ДО запуска приложения - нужно явно инициализировать binding.

КОГДА ИСПОЛЬЗОВАТЬ:

- Работа с SharedPreferences до runApp()
- Инициализация Firebase
- Настройка orientation или системных UI
- Работа с platform channels
- Инициализация dependency injection контейнеров
- Настройка crash analytics

ПРИМЕР ИСПОЛЬЗОВАНИЯ:
void main() async {
  // Обязательно вызываем перед любыми async операциями
  WidgetsFlutterBinding.ensureInitialized();

  // Теперь можем безопасно использовать Flutter API
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Инициализация SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Запуск приложения
  runApp(MyApp());
}
'''
  ),
  QA(
    q: 'Что такое `WidgetsBinding.instance.addPersistentFrameCallback()` и как он отличается от addPostFrameCallback()?',
    a: 'addPersistentFrameCallback вызывается на каждой перерисовке (кадр), в отличие от addPostFrameCallback, который вызывается один раз после текущего кадра. Используется для постоянного трекинга времени или состояния.',
  ),
  QA(
    q: 'Можно ли передавать context между изолятами (Isolate)? Почему?',
    a: 'Нет. BuildContext нельзя передавать между изолятами, потому что он привязан к текущему дереву виджетов и потоку UI. Изоляты изолированы и не имеют доступа к UI-ресурсам.',
  ),
  QA(
    q: 'Чем отличается const MainAxisAlignment.spaceAround от spaceBetween и spaceEvenly?',
    a: '''
- spaceBetween: без отступов по краям, только между элементами.
- spaceAround: отступы по краям вдвое меньше, чем между элементами.
- spaceEvenly: равномерные отступы между всеми элементами и краями.
''',
  ),
  QA(
    q: 'Когда Flutter вызывает build() повторно, если параметры виджета не изменились?',
    a: 'Flutter вызывает build() при любом вызове setState или notifyListeners, даже если параметры не изменились. Flutter не делает diff параметров, только проверяет необходимость rebuild.',
  ),
  QA(
    q: 'Что делает const factory конструктор во Flutter?',
    a: 'const factory позволяет возвращать кэшированные экземпляры классов, часто используется с singleton pattern. Он возвращает уже существующий объект, если такой есть.',
  ),
  QA(
    q: 'Почему MediaQuery.of(context).size может возвращать нулевые значения при старте?',
    a: 'Если вызвать MediaQuery.of(context) слишком рано (например, в initState), дерево ещё не построено, и значения могут быть недоступны. Нужно вызывать после первого кадра или в build().',
  ),
  QA(
    q: 'Можно ли использовать async/await внутри метода build()? Почему это плохо?',
    a: 'Нельзя. build() должен быть чистой и синхронной функцией. Асинхронность может нарушить логику построения UI и привести к багам или race conditions.',
  ),
  QA(
    q: 'Почему Flutter не использует нативные UI-компоненты платформы (например, UIButton в iOS)?',
    a: 'Flutter рендерит весь UI самостоятельно через движок Skia. Это даёт одинаковый внешний вид и поведение на всех платформах, но не использует нативные контролы напрямую.',
  ),
  QA(
    q: 'Как Flutter обеспечивает плавную анимацию при 60fps? Что будет, если работа build занимает больше 16мс?',
    a: 'Если build занимает больше 16мс, кадры будут пропущены (jank). Flutter рендерит UI в каждом кадре через pipeline (build → layout → paint → composite), и все стадии должны уложиться в 16мс.',
  ),
  QA(
    q: 'В чем разница между AndroidView и UiKitView?',
    a: '''
AndroidView и UiKitView - это виджеты для встраивания нативных view в Flutter приложение.

ОСНОВНАЯ РАЗНИЦА:

AndroidView:
- Только для Android платформы
- Встраивает нативные Android View (TextView, WebView, MapView и т.д.)
- Использует Android's SurfaceView или TextureView для рендеринга

UiKitView:
- Только для iOS платформы
- Встраивает нативные iOS UIView (UILabel, WKWebView, MKMapView и т.д.)
- Использует iOS UIView hierarchy
''',
  ),
  QA(
    q: 'Что такое Sliver виджеты?',
    a: 'Sliver — это виджеты, которые позволяют создавать scrollable-интерфейсы с высокой производительностью и гибкой кастомизацией. Они работают только внутри CustomScrollView и позволяют реализовывать lazy-loading, анимации и сложные поведения прокрутки.',
  ),
  QA(
    q: 'Какие есть Sliver виджеты?',
    a: 'Основные: SliverAppBar, SliverList, SliverGrid, SliverFixedExtentList, SliverToBoxAdapter, SliverFillRemaining, SliverPersistentHeader и SliverPadding.',
  ),
  QA(
    q: 'Чем отличается SliverList от ListView?',
    a: 'SliverList используется внутри CustomScrollView и предоставляет больше гибкости при кастомизации скроллинга. ListView — это обёртка, которая внутри себя использует SliverList, но с фиксированным поведением.',
  ),
  QA(
    q: 'Что делает SliverToBoxAdapter?',
    a: 'Он позволяет вставить обычный виджет (не sliver) внутрь CustomScrollView, оборачивая его в совместимый формат.',
  ),
  QA(
    q: 'Как можно реализовать collapsing header в Flutter?',
    a: 'С помощью SliverAppBar с параметром `pinned`, `floating`, `snap` и `expandedHeight`. Он позволяет заголовку сворачиваться при прокрутке.',
  ),
  QA(
    q: 'Можно ли использовать Column внутри CustomScrollView?',
    a: 'Напрямую — нет. Но можно использовать Column внутри SliverToBoxAdapter или преобразовать структуру в набор Sliver-виджетов.',
  ),
  QA(
    q: 'Что произойдёт, если в CustomScrollView указать обычный ListView?',
    a: 'Произойдёт ошибка: ListView конфликтует с scroll physics CustomScrollView. Вместо ListView нужно использовать SliverList.',
  ),
  QA(
    q: 'Как добиться lazy loading элементов в scrollable списке с использованием Slivers?',
    a: 'С помощью SliverChildBuilderDelegate в SliverList или SliverGrid. Это позволяет создавать элементы по мере необходимости.',
  ),
  QA(
    q: 'Для чего используется SliverPersistentHeader?',
    a: 'Позволяет создать заголовок, который остаётся на экране при прокрутке или изменяет своё поведение в зависимости от scroll offset.',
  ),
  QA(
    q: 'Какие параметры управления поведением прокрутки доступны в SliverAppBar?',
    a: 'Основные параметры: `pinned` (закреплён сверху), `floating` (появляется при обратной прокрутке), `snap` (автоматически появляется/исчезает при прокрутке), `expandedHeight` (высота раскрытого состояния).',
  ),
  QA(
    q: 'В чём разница между Implicit и Explicit анимациями?',
    a: '''
Implicit анимации (например, AnimatedContainer) управляются Flutter и не требуют AnimationController.
Explicit анимации (например, с использованием AnimatedBuilder и AnimationController) дают полный контроль над анимацией.
Implicit — проще, но менее гибко. Explicit — сложнее, но мощнее.
''',
  ),
  QA(
    q: 'Что делает класс AnimationController и как его правильно освободить?',
    a: '''
AnimationController управляет временем анимации: старт, стоп, повтор и т.д.
Его обязательно нужно вызывать dispose() при уничтожении State, иначе будет утечка памяти.
''',
  ),
  QA(
    q: 'Для чего используется Tween и чем отличается от Animation?',
    a: '''
Tween задаёт диапазон значений (от и до), а Animation — это абстракция над текущим значением.
AnimationController даёт значение от 0 до 1, а Tween трансформирует его, например, в от 100 до 500.
''',
  ),
  QA(
    q: 'Как работает AnimatedBuilder и зачем он нужен?',
    a: '''
AnimatedBuilder слушает Animation и перестраивает переданный builder.
Это экономит ресурсы: пересоздаётся только часть UI, а не весь виджет.
''',
  ),
  QA(
    q: 'Какие есть ImplicitlyAnimatedWidget?',
    a: '''
AnimatedContainer, AnimatedOpacity, AnimatedAlign, AnimatedPadding, AnimatedPositioned, AnimatedDefaultTextStyle.
''',
  ),
  QA(
    q: 'Что делает метод addStatusListener у Animation',
    a: '''
addStatusListener позволяет слушать изменения статуса анимации:
- dismissed (начало)
- forward (идёт вперёд)
- reverse (обратная анимация)
- completed (дошла до конца)
''',
  ),
  QA(
    q: 'Как работает Hero-анимация?',
    a: '''
Hero связывает два виджета с одинаковым тегом на разных маршрутах и анимирует переход между ними.
Ошибки:
- одинаковые теги на одном экране
- разные размеры или формы Hero-виджетов
- использование Hero в списках без уникальных тегов
''',
  ),
  QA(
    q: 'Можно ли использовать AnimatedContainer внутри StatelessWidget?',
    a: '''
Да, можно. Анимация будет работать, если AnimatedContainer получает новые параметры через обновление дерева.
Flutter сам сравнит старые и новые значения и запустит анимацию.
''',
  ),
  QA(
    q: 'Что такое RepaintBoundary?',
    a: '''
RepaintBoundary создает отдельный слой для рендеринга, изолируя перерисовку виджетов.

Когда что-то изменяется внутри RepaintBoundary, Flutter перерисовывает только этот слой, а не весь экран.
Это критично для производительности при анимациях или частых обновлениях UI.

RepaintBoundary(
  child: AnimatedContainer(
    // Анимация будет изолирована от остального UI
  ),
)
''',
  ),
  QA(
    q: 'В чем разница между hot reload и hot restart?',
    a: '''
🎯 Hot reload:
– Перезагружает только измененный код в работающем приложении.
– Сохраняет текущее состояние (например, заполненные поля, состояние BLoC или Provider, навигацию).
– Очень быстрый, используется для UI-правок и мелких изменений.
– Но! Если ты изменил глобальные переменные, логику initState или конструкторы — результат может быть некорректным, потому что эти вещи не пересоздаются.

🎯 Hot restart:
– Полностью пересоздает приложение, включая main().
– Сбрасывает состояние (все контроллеры, провайдеры, навигацию).
– Медленнее, чем hot reload, но гарантирует чистый старт с обновленным кодом.
– Используется, если изменения затронули глобальные вещи (например, зависимости, статические переменные, DI).
''',
  ),
  QA(
    q: 'Что такое RenderFlex overflow?',
    a: '''
RenderFlex overflow возникает, когда содержимое Row/Column не помещается в доступное пространство.

Способы исправления:

🎯 1. Обернуть виджеты в Flexible/Expanded

Row(
  children: [
    Expanded(child: Text('Long text...')),
    Icon(Icons.star),
  ],
)

🎯 2. Использовать Wrap вместо Row/Column

Wrap(
  children: [...],
)

🎯 3. SingleChildScrollView для прокрутки

SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [...]),
)
''',
  ),
  QA(
    q: 'Как работает LayoutBuilder и чем отличается от MediaQuery?',
    a: '''
- LayoutBuilder предоставляет constraints конкретного виджета в дереве
- MediaQuery дает размеры всего экрана/устройства

LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return DesktopLayout();
    }
    return MobileLayout();
  },
)

LayoutBuilder лучше подходит для responsive design, так как учитывает реальное доступное пространство виджета.
''',
  ),
  QA(
    q: 'Что такое Semantics?',
    a: '''
Semantics предоставляет информацию о виджетах для accessibility сервисов (screen readers, voice control).

Semantics(
  label: 'Увеличить счетчик',
  hint: 'Нажмите чтобы добавить единицу',
  child: FloatingActionButton(
    onPressed: _increment,
    child: Icon(Icons.add),
  ),
)
''',
  ),
  QA(
    q: 'Что произойдет, если вызвать Navigator.pop() на последнем маршруте?',
    a: '''
Flutter выбросит исключение или закроет приложение (на Android). Чтобы избежать этого, нужно проверять:

if (Navigator.canPop(context)) {
  Navigator.pop(context);
} else {
  // Альтернативное действие или SystemNavigator.pop()
}

Или использовать Navigator.maybePop(context) который безопасно обрабатывает эту ситуацию.
''',
  ),
  QA(
    q: 'Как Flutter определяет, нужно ли перестроить виджет?',
    a: '''
Flutter сравнивает новое дерево с предыдущим.
Если runtimeType и Key совпадают — элемент переиспользуется, вызывается didUpdateWidget.
Если отличаются — старый элемент уничтожается, создается новый.
Поэтому Key важны при списках и перестановке элементов.

Зачем нужны ключи?
– Чтобы управлять сохранением состояния при перестановке виджетов в списке.
– Например, в ListView при reorder без Key Flutter пересоздает элементы, а с правильными Key сохраняет их State (например, положение в TextField).

Алгоритм такой:
1. Flutter идет сверху вниз по дереву.
2. На каждой позиции проверяет:
– Совпадает ли runtimeType (тип класса виджета).
– Совпадает ли Key (ключ виджета).

Если runtimeType и Key совпадают → Flutter считает, что это "тот же самый" виджет, и обновляет его состояние, вызвав didUpdateWidget(). При этом сохраняется Element и (если есть) State.
Если не совпадают → Flutter удаляет старый элемент (dispose, unmount) и создает новый (initState, mount).
''',
  ),
  QA(444
    q: 'Что такое PlatformChannel и как организовать двустороннюю связь с нативным кодом?',
    a: r'''
PlatformChannel позволяет вызывать нативные методы Android/iOS из Flutter и наоборот.

Есть три типа каналов:

// MethodChannel - для вызова методов
static const platform = MethodChannel('samples.flutter.dev/battery');

Future<String> _getBatteryLevel() async {
  try {
    final int result = await platform.invokeMethod('getBatteryLevel');
    return 'Battery level: $result%';
  } catch (e) {
    return 'Failed to get battery level: ${e.message}';
  }
}

// EventChannel - для потока событий от нативной стороны
static const EventChannel _eventChannel = EventChannel('samples.flutter.dev/charging');

Stream<bool> get chargingStream => _eventChannel.receiveBroadcastStream().cast<bool>();

// BasicMessageChannel - для произвольных сообщений

''',
  ),

  QA(
    q: 'В чем разница между Positioned и Align внутри Stack?',
    a: '''

- Positioned использует абсолютные координаты относительно краев Stack
- Align использует относительное позиционирование (0.0 до 1.0) и Alignment

''',
  ),
  QA(
    q: ' Что такое Spacer и чем отличается от SizedBox?',
    a: '''
Spacer — это Expanded(child: SizedBox()), автоматически занимает доступное пространство в Flex виджетах // Expanded(flex: flex, child: const SizedBox.shrink());
SizedBox — фиксированный размер
''',
  ),

  QA(
    q: 'Как работает CustomPainter и что такое Canvas?',
    a: '''
CustomPainter позволяет рисовать кастомную графику используя Canvas API.

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Рисуем круг
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Использование
CustomPaint(
  painter: CirclePainter(),
  size: Size(200, 200),
)

''',
  ),
  QA(
    q: ' В чем разница между ListView.builder и ListView(children: [])?',
    a: r'''
ListView(children: []) создает все виджеты сразу в памяти - подходит для небольших списков

ListView.builder создает виджеты lazy (по требованию) - обязателен для больших списков

// Все элементы в памяти сразу - ПЛОХО для больших списков
ListView(
  children: List.generate(1000, (index) => ListTile(title: Text('$index'))),
)

// Lazy loading - ХОРОШО для больших списков
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(title: Text('$index')); // Создается только при отображении
  },
)
''',
  ),
  QA(
    q: 'Как работает FutureBuilder и какие состояния ConnectionState существуют?',
    a: r'''
FutureBuilder автоматически перестраивает UI в зависимости от состояния Future.

FutureBuilder<String>(
  future: fetchUserData(),
  builder: (context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('No connection');
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active: // Только для Stream
        return Text('Active...');
      case ConnectionState.done:
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Text('Data: ${snapshot.data}');
    }
  },
)
''',
  ),

  QA(
    q: 'Что такое Overlay и OverlayEntry? Как показать виджет поверх всего экрана?',
    a: '''
Overlay - это Stack, который находится над всем приложением. OverlayEntry - элемент этого стека.

void showCustomOverlay(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 100,
      left: 50,
      child: Material(
        color: Colors.blue.withOpacity(0.8),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Custom Overlay'),
              ElevatedButton(
                onPressed: () => overlayEntry.remove(), // Удаляем overlay
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
''',
  ),
  QA(
    q: ' В чем разница между PreferredSize и PreferredSizeWidget?',
    a: '''

PreferredSizeWidget - абстрактный класс с методом preferredSize
PreferredSize - обертка для обычных виджетов, чтобы они соответствовали PreferredSizeWidget

Используется в AppBar.bottom, TabBar и других местах, где нужно знать размер заранее.

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.blue,
      child: Center(child: Text('Custom AppBar')),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}

// Использование обычного виджета как PreferredSizeWidget
AppBar(
  title: Text('App'),
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(50),
    child: Container(
      height: 50,
      color: Colors.red,
      child: Center(child: Text('Bottom')),
    ),
  ),
)

''',
  ),
  QA(
    q: 'Что такое Focus и FocusNode во Flutter?',
    a: '''
Focus управляет фокусом ввода (клавиатура, навигация). FocusNode — объект, который хранит состояние фокуса.

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose(); // Обязательно освободить
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(focusNode: _focusNode),
        ElevatedButton(
          onPressed: () => _focusNode.requestFocus(), // Запросить фокус
          child: Text('Focus TextField'),
        ),
      ],
    );
  }
}
''',
  ),
  QA(
    q: 'В чем разница между MediaQuery.of(context) и MediaQuery.maybeOf(context)?',
    a: '''
MediaQuery.of(context) — выбрасывает исключение, если MediaQuery не найден

MediaQuery.maybeOf(context) — возвращает null, если MediaQuery не найден

// Выбросит исключение, если нет MediaQuery в дереве
final size = MediaQuery.of(context).size;

// Вернет null, если нет MediaQuery в дереве
final size = MediaQuery.maybeOf(context)?.size;

// Безопасное использование
final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 400;

''',
  ),

  QA(
    q: 'Что такое RenderObject и как он связан с виджетами?',
    a: '''
RenderObject — это низкоуровневый объект, который выполняет layout, painting и hit testing.
Каждый виджет через Element может создавать RenderObject.

Widget    → Element          → RenderObject
Container → ContainerElement → RenderContainer
Text      → TextElement      → RenderParagraph

RenderObject выполняет:

layout() — вычисляет размеры и положение
paint() — отрисовывает на Canvas
hitTest() — определяет касания

Не все виджеты создают RenderObject (StatelessWidget не создает), только RenderObjectWidget.
''',
  ),

  QA(
    q: 'В чем разница между MaterialApp и WidgetsApp?',
    a: '''
WidgetsApp — базовое приложение без Material Design
MaterialApp — extends WidgetsApp + Material Design компоненты

// Базовое приложение
WidgetsApp(
  color: Colors.blue,
  builder: (context, child) => Text('Basic App'),
)

// Material Design приложение
MaterialApp(
  theme: ThemeData.light(),
  home: Scaffold(
    appBar: AppBar(title: Text('Material App')),
  ),
)
''',
  ),

  QA(
    q: 'Что произойдет, если использовать StatefulWidget без переменных состояния?',
    a: '''
Ничего не произойдет, но это будет неэффективно. StatefulWidget создает State объект и занимает больше памяти, чем StatelessWidget.

// Неэффективно - нет состояния, но используется StatefulWidget
class EmptyStateful extends StatefulWidget {
  @override
  _EmptyStatefulState createState() => _EmptyStatefulState();
}

class _EmptyStatefulState extends State<EmptyStateful> {
  @override
  Widget build(BuildContext context) {
    return Text('Static text'); // Никаких переменных состояния
  }
}

// Лучше использовать StatelessWidget
class EmptyStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Static text');
  }
}
''',
  ),

  QA(
    q: 'В чем разница между SingleChildScrollView и ListView?',
    a: r'''
SingleChildScrollView — скроллит весь контент сразу (все в памяти)
ListView — использует viewport culling (создает элементы по мере прокрутки)

// Все виджеты создаются сразу - плохо для больших списков
SingleChildScrollView(
  child: Column(
    children: List.generate(1000, (i) => ListTile(title: Text('$i'))),
  ),
)

// Виджеты создаются лениво - хорошо для больших списков
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(title: Text('$index')),
)
''',
  ),
  QA(
    q: 'Что такое ChangeNotifier и для чего он используется во Flutter?',
    a: '''
ChangeNotifier — это класс, реализующий шаблон "наблюдатель" (Observer).

Когда данные внутри ChangeNotifier изменяются, он вызывает notifyListeners(),
и все виджеты, подписанные через Provider (или ChangeNotifierProvider), получают обновление.

Пример:
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
''',
  ),
  QA(
    q: 'Как использовать ChangeNotifier с Provider в виджете?',
    a: r'''
Для использования ChangeNotifier с Provider:
1. Оберни дерево в ChangeNotifierProvider.
2. Получай доступ через context.watch() или context.read().

Пример:
return ChangeNotifierProvider(
  create: (_) => Counter(),
  child: MyHomePage(),
);

// Внутри MyHomePage
final counter = context.watch<Counter>();
Text('Count: ${counter.count}')
''',
  ),
  QA(
    q: 'В чём разница между context.watch(), context.read() и context.select()?',
    a: '''
- watch<T>() — слушает и перестраивает при notifyListeners().
- read<T>() — получает данные один раз, не слушает изменения.
- select<T, R>() — слушает только выбранное поле, уменьшает rebuild'ы.

Пример:
final count = context.select<Counter, int>((c) => c.count);
''',
  ),
  QA(
    q: 'Можно ли вызывать notifyListeners() внутри build() метода?',
    a: '''
Нет. notifyListeners() в build() приведёт к бесконечному циклу перестроения.
notifyListeners() вызывается только при изменении данных (например, в методе increment()).
''',
  ),
  QA(
    q: 'Какие подводные камни при работе с ChangeNotifier?',
    a: '''
1. Забыть вызвать notifyListeners() — UI не обновится.
2. Слишком частые notifyListeners() — ухудшает производительность.
3. Обновление больших объектов — лучше использовать ValueNotifier или разделить ChangeNotifier.
4. Использование read() для данных, которые могут измениться — UI не обновится.

Лучше делить состояние на мелкие, независимые модели.
''',
  ),
  QA(
    q: 'Что такое  FlutterError.onError?',
    a: '''
FlutterError.onError — это глобальный обработчик ошибок, возникающих в Flutter-виджетах во время выполнения (в debug и release).

Работает только для ошибок из Flutter (не Dart Isolate).

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); // по умолчанию печатает в консоль
    // можно отправить в Sentry или другой сервис
    // sendToAnalytics(details);
  };

  runApp(MyApp());
}

🔹 Когда используется
- Логгирование ошибок
- Отправка ошибок в Crashlytics или Sentry
- Скрытие ошибок в релизе (не показывать красный экран)

''',
  ),
  QA(
    q: 'Объясните разницу между Cubit и Bloc?',
    a: '''

Cubit

Ключевые особенности:
- Методы напрямую изменяют состояние через emit()
- Нет событий (events) - только методы

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

Bloc

Ключевые особенности:
- Работает через события (events)
- Более декларативный подход
- Лучше для сложной бизнес-логики
- Возможность перехвата событий (onTransition, onEvent)

''',
  ),

  QA(
    q: 'Пример Cubit',
    a: r'''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class CounterState {
  final int count;
  final bool isLoading;

  CounterState({required this.count, this.isLoading = false});

  CounterState copyWith({int? count, bool? isLoading}) {
    return CounterState(count: count ?? this.count, isLoading: isLoading ?? this.isLoading);
  }
}

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(count: 0));

  void increment() {
    emit(state.copyWith(count: state.count + 1));
  }

  void decrement() {
    emit(state.copyWith(count: state.count - 1));
  }

  void setLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) {
          return CounterCubit();
        },
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterCubit = context.read<CounterCubit>();

    return Scaffold(
      body: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Column(
            children: [
              Text('${state.count}'),
              state.isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              counterCubit.setLoading(true);
              await Future.delayed(const Duration(seconds: 1));
              counterCubit.increment();
              counterCubit.setLoading(false);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(onPressed: counterCubit.decrement, child: const Icon(Icons.remove)),
        ],
      ),
    );
  }
}

''',
  ),
  QA(
    q: 'Расскажите про BlocListener, BlocBuilder и MultiBlocProvider',
    a: r'''

BlocBuilder:

Перестраивает UI в ответ на изменения состояния

BlocBuilder<CounterCubit, int>(
  builder: (context, state) {
    return Text('Count: $state');
  },
)

// С условием перестройки
BlocBuilder<UserCubit, UserState>(
  buildWhen: (previous, current) => previous.user != current.user,
  builder: (context, state) {
    return UserProfile(user: state.user);
  },
)

=====

BlocListener

Выполняет side effects (навигация, снэкбары, диалоги) без перестройки UI

BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    // Только side effects, НЕ перестраивает UI
    if (state is AuthError) {
      showErrorDialog(state.message);
    }
  },
  child: LoginForm(), // Статичный child
)


=====

BlocConsumer

BlocConsumer = BlocBuilder + BlocListener в одном виджете

BlocConsumer<AuthCubit, AuthState>(
  // Side effects (как BlocListener)
  listener: (context, state) {
    if (state is AuthError) {
      showErrorDialog(state.message);
    }
  },
  // Перестройка UI (как BlocBuilder)
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    if (state is AuthSuccess) return WelcomeScreen();
    return LoginForm();
  },
)

======

MultiBlocProvider

Когда несколько виджетов нужно обеспечить разными BLoC'ами

MultiBlocProvider(
  providers: [
    BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
    BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
    BlocProvider<CartCubit>(create: (context) => CartCubit()),
  ],
  child: MyApp(),
)

''',
  ),

  QA(
    q: 'Виджет const и без const',
    a: '''

Когда вы добавляете const перед созданием виджета, Flutter создает один экземпляр этого виджета на этапе компиляции. Этот экземпляр переиспользуется везде, где встречается одинаковый const виджет.

Если вы не добавляете const, Flutter создает новый экземпляр виджета каждый раз, когда он используется.
''',
  ),

  QA(tags: [Tag.flutter],
  q: 'Что такое WidgetTree?',
  a: '''
WidgetTree — это иммутабельное декларативное описание интерфейса.
WidgetTree — это чертёж интерфейса, который Flutter потом "оживляет" через ElementTree и RenderObjectTree.

- Каждый Widget описывает конфигурацию UI (например, "кнопка с текстом 'OK'").
- Дерево пересоздаётся на каждом build().
- В нём нет состояния и логики отрисовки — только структура и данные для UI.

Пример

Scaffold(
  appBar: AppBar(title: Text("Заголовок")),
  body: Center(child: Text("Hello")),
)

Даёт WidgetTree:

Scaffold
 ├── AppBar
 │     └── Text("Заголовок")
 └── Center
       └── Text("Hello")

'''
  ),

  QA(
    tags: [Tag.flutter],
    q: 'Что такое ElementTree?',
    a: '''

ElementTree — это дерево элементов, которое связывает WidgetTree (описание интерфейса) и RenderObjectTree (отрисовку).

ElementTree = долгоживущее связующее дерево, которое хранит состояние и оптимизирует обновления,
чтобы Flutter не пересоздавал всё при каждом build().

ElementTree — это "клей" между декларативным описанием UI (WidgetTree) и императивной отрисовкой (RenderObjectTree).
Именно он позволяет Flutter быть декларативным и производительным одновременно.

🔑 Главные моменты:
- Каждый Widget при вставке в дерево создаёт Element.
- Element — это mutable-объект, который:
  - хранит ссылку на Widget,
  - управляет его жизненным циклом,
  - хранит State (для StatefulWidget),
  - содержит ссылку на RenderObject (если он нужен).
- Не пересоздаётся при каждом build() — Flutter старается переиспользовать Element, если тип Widget совпадает.
- Именно ElementTree делает Flutter эффективным: сравнивает старое и новое дерево виджетов (widget diffing)
и решает, какие части реально нужно обновить.

Пример

Scaffold(
  body: Center(child: Text("Hello")),
)
- WidgetTree создаётся заново при каждом build().
- Для него формируется ElementTree:

ScaffoldElement
 └── CenterElement
       └── TextElement

- Если setState() меняет текст "Hello" → "Hi", то:
  - TextWidget пересоздаётся,
  - ElementTree видит, что тип (Text) совпадает → переиспользует старый TextElement,
  - обновляет внутри только RenderParagraph.


🔁 Жизненный цикл Element

Когда Flutter строит дерево:
1) Widget → Element: При первом build() или при вставке виджета в дерево, Flutter вызывает createElement() у Widget → создаётся соответствующий Element.

2) Element → RenderObject: Если Element реализует RenderObjectElement (например, LeafRenderObjectElement для Text), он создаёт или обновляет RenderObject.

3) При повторном build(): Flutter сравнивает новый Widget с предыдущим, используя canUpdate(oldWidget, newWidget).

static bool canUpdate(Widget oldWidget, Widget newWidget) {
  return oldWidget.runtimeType == newWidget.runtimeType
      && oldWidget.key == newWidget.key;
}

👉 Если true — Element переиспользуется.
👉 Если false — Element уничтожается и создаётся заново.

WidgetTree (временное)          ElementTree (долгоживущее)       RenderObjectTree
┌──────────────┐                ┌──────────────────┐             ┌──────────────────┐
│ Scaffold     │  createElement │ ScaffoldElement  │  instantiate│ RenderView       │
│   Center     │ ──────────────►│   CenterElement  │ ───────────►│   RenderBox      │
│     Text     │                │     TextElement  │             │     RenderParagraph │
└──────────────┘                └──────────────────┘             └──────────────────┘
      ↓ rebuild()                     ↓ reuse if canUpdate()           ↓ updateRenderObject()
┌──────────────┐                ┌──────────────────┐             ┌──────────────────┐
│ Scaffold     │                │ ScaffoldElement  │             │ RenderView       │
│   Center     │                │   CenterElement  │             │   RenderBox      │
│    Text("Hi")│                │     TextElement  │             │     RenderParagraph(text: "Hi") ← обновилось!
└──────────────┘                └──────────────────┘             └──────────────────┘
'''
  ),

  QA(
    tags: [Tag.flutter],
    q: 'Что такое RenderObjectTree?',
    a: '''
RenderObjectTree — это императивное дерево объектов, отвечающих за layout (расположение), paint (отрисовку)
и hit-testing (взаимодействие с касаниями) на экране.

Это низкоуровневый слой, который работает "под капотом" Flutter. Он не декларативный,
как WidgetTree — он императивный, мутируемый и оптимизированный для производительности.

🔗 Как связаны три дерева?

WidgetTree (декларативный, временный)
    ↓ createElement()
ElementTree (связующее звено, долгоживущее, хранит State)
    ↓ instantiate / updateRenderObject()
RenderObjectTree (императивный, отвечает за layout & paint)

Widget — это инструкция: «Я хочу текст по центру».
Element — это мост: «Окей, я помню, что ты хотел текст, и держу его состояние».
RenderObject — это исполнитель: «Я измеряю, где текст поместится, рисую его пиксели и проверяю, нажал ли пользователь именно на него».

🧱 Что такое RenderObject?

RenderObject — абстрактный класс, от которого наследуются все объекты, участвующие в:
- Layout — измерение и позиционирование (performLayout())
- Paint — рисование на экране (paint())
- Hit-testing — обработка касаний (hitTest())

Основные подклассы:

┌─────────────────┬─────────────────────────────────────────────┬──────────────────────────────────────┐
│     КЛАСС       │                НАЗНАЧЕНИЕ                   │         ПРИМЕР ИСПОЛЬЗОВАНИЯ         │
├─────────────────┼─────────────────────────────────────────────┼──────────────────────────────────────┤
│ RenderBox       │ Объект с фиксированными размерами           │ Container, Text, Image, SizedBox     │
│                 │ (box model)                                 │                                      │
├─────────────────┼─────────────────────────────────────────────┼──────────────────────────────────────┤
│ RenderSliver    │ Объекты для ленивой прокрутки (slivers)     │ SliverList, SliverGrid               │
├─────────────────┼─────────────────────────────────────────────┼──────────────────────────────────────┤
│ RenderParagraph │ Рендерит текст                              │ Text → RenderParagraph               │
├─────────────────┼─────────────────────────────────────────────┼──────────────────────────────────────┤
│ RenderFlex      │ Рендерит Row/Column                         │ Row → RenderFlex                     │
└─────────────────┴─────────────────────────────────────────────┴──────────────────────────────────────┘

🔄 Как создаётся RenderObjectTree?
- Widget создаёт Element → widget.createElement()
- Element создаёт или обновляет RenderObject → element.mount() → element.updateRenderObject()
- RenderObject встраивается в дерево → становится частью RenderObjectTree

Text("Hello")
  → TextElement
    → RenderParagraph(text: "Hello")
''',
  ),
  QA(
    q: 'Проблемы с Container + Decoration?',
    a: '''

1) Конфликт с color параметром:

// ОШИБКА - нельзя использовать одновременно
Container(
  color: Colors.blue,           // ❌
  decoration: BoxDecoration(    // ❌
    color: Colors.red,
  ),
)

2) Избыточное создание RenderBox:

 Container с условным decoration = нестабильная структура = потеря состояния дочерних виджетов.


// Плохо - создается дополнительный RenderDecoratedBox
Container(
  decoration: BoxDecoration(color: Colors.red),
  child: Text('Hello'),
)

// Лучше - прямое использование
DecoratedBox(
  decoration: BoxDecoration(color: Colors.red),
  child: Text('Hello'),

 // BAD: При изменении hasDecoration структура меняется
Widget build(BuildContext context) {
  return hasDecoration
    ? Container(
        decoration: BoxDecoration(color: Colors.red),
        child: ExpensiveWidget(), // ❌ Пересоздается!
      )
    : Container(
        child: ExpensiveWidget(), // ❌ Пересоздается!
      );
}
)

// GOOD: Структура не меняется
Widget build(BuildContext context) {
  return DecoratedBox(
    decoration: hasDecoration
      ? BoxDecoration(color: Colors.red)
      : BoxDecoration(), // Пустая, но структура та же
    child: ExpensiveWidget(), // ✅ Сохраняется состояние
  );
}

''',
  ),

  QA(
    q: 'Самые часто используемые InheritedWidget?',
    a: '''

1) MediaQuery:

final screenSize = MediaQuery.of(context).size;
final padding = MediaQuery.of(context).padding;
final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

2) Theme:

final theme = Theme.of(context);
final primaryColor = Theme.of(context).primaryColor;
final textTheme = Theme.of(context).textTheme;

3) Navigator:

Navigator.of(context).push(...);
Navigator.of(context).pop();

4) Scaffold:

Scaffold.of(context).openDrawer();
Scaffold.of(context).showSnackBar(snackBar);

5) Form:

Form.of(context).validate();
Form.of(context).save();

7) Localizations:

final locale = Localizations.of(context);
final isRTL = Directionality.of(context) == TextDirection.rtl;

10) Overlay:

Overlay.of(context).insert(overlayEntry);

''',
  ),
  QA(
    q: 'Какая используется алгоритмическая сложность в поиске MediaQuery вверху по дереву виджетов?',
    a: r'''

Поиск вверх по дереву виджетов для получения InheritedWidget (например, MediaQuery.of(context))
имеет алгоритмическую сложность O(n), где n — это количество уровней (глубина) от текущего виджета до искомого предка.

где n — это высота дерева виджетов от текущего виджета до ближайшего предка, содержащего MediaQuery.


// Представим дерево виджетов:
// MaterialApp
// └── Scaffold
//     └── AppBar
//     └── Container
//         └── Column
//             └── MyWidget ← Здесь вызываем MediaQuery.of(context)

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Поиск идет вверх по 4 уровням:
    // MyWidget → Column → Container → Scaffold → MaterialApp (где есть MediaQuery)
    final mediaQuery = MediaQuery.of(context); // O(4) = O(n)
    return Text('Ширина: ${mediaQuery.size.width}');
  }
}


''',
  ),

  QA(
    q: 'Как реализовать поиск по нажатию на кнопку?',
    a: '''

Debounce vs Restartable

Debounce - это пассивная задержка: ждем паузу в вводе
Restartable - это активная отмена: сразу реагируем, но отменяем предыдущее (bloc_concurrency: ^0.3.0 предоставляет набор трансформеров)


Когда что использовать:

Debounce ✅
-Когда нужна пауза в действиях пользователя
-Поиск: пользователь печатает → ждем 300-500ms паузы → отправляем запрос
-Экономит запросы к серверу

Restartable ✅
-Когда нужна мгновенная реакция на последнее событие
-Более отзывчивый UX
-Больше запросов, но актуальнее результаты


Реализация с debounce:
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(
      (event, emit) async {
        // Только когда пользователь сделал паузу
        final results = await searchRepository.search(event.query);
        emit(SearchSuccess(results));
      },
      // debounce 300ms
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }
}

Комбинирование подходов:
// Сначала debounce, потом restartable
transformer: restartable().combineWith(debounce(...))

''',
  ),
  QA(
    q: 'Какие есть трансформеры в bloc_concurrency?',
    a: '''

Sequential (последовательно) - порядок выполнения критичен, каждый новый запрос должен ждать предыдущий
Пример: банковские транзакции, очередь команд

Concurrent (параллельно) - Когда операции независимы и можно выполнять несколько одновременно
Пример: загрузка нескольких изображений, параллельная обработка данных

Droppable (игнорировать новые во время выполнения)

Restartable (перезапуск с последним событием)


''',
  ),

  QA(
    q: 'Как хранить секретные данные на мобильном устройстве локально в flutter?',
    a: '''

Хранение секретных данных в Flutter

1) Flutter Secure Storage (рекомендуется)
iOS: Keychain
Android: Keystore
Шифрование на уровне ОС
Сохранность при очистке кэша

Проблема: данные в Keychain сохраняются после удаления приложения. Это штатное поведение, а не баг.

Решение: ручная очистка
// При первом запуске после переустановки
if (isFirstLaunchAfterReinstall()) {
  secureStorage.deleteAll();
}

✅ Решение: сравнение между Secure Storage и Unprotected Storage
При удалении приложения:

SharedPreferences                   - стирается
Keychain / Keystore (SecureStorage) - остаётся

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkFirstRunAndClearSecureStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('is_first_run') ?? true;

  if (isFirstRun) {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
    await prefs.setBool('is_first_run', false);
  }
}

''',
  ),

  QA(
    q: '',
    a: r'''

Объекто-ориентированная модель. Работает с Dart объектами напрямую.


======

Основы
// Определение модели
@RealmModel()
class _User {
  @PrimaryKey()
  late String id;
  late String name;
  int? age;
  late List<_Task> tasks; // Связь один-ко-многим
}
// Генерация: flutter packages pub run build_runner build


======

Инициализация и конфигурация
final config = Configuration.local([User.schema, Task.schema]);
final realm = Realm(config);

// Миграции при изменении схемы
final config = Configuration.local(
  [User.schema],
  schemaVersion: 2,
  migrationCallback: (migration, oldSchemaVersion) {
    // Логика миграции
  }
);


======



CRUD операции


// Create
realm.write(() {
  realm.add(User('1', 'John', age: 30));
});

// Read
final users = realm.all<User>();
final john = realm.find<User>('1');
final adults = realm.all<User>().query('age >= 18');

// Update
realm.write(() {
  john?.age = 31;
});

// Delete
realm.write(() {
  realm.delete(john);
});


======


Запросы и фильтрация

// Query language (похож на SQL)
final results = realm.all<User>().query(
  'name CONTAINS[c] $0 AND age BETWEEN {18, 65}',
  ['john']
);

// Сортировка
final sorted = realm.all<User>().query('TRUEPREDICATE SORT(name ASC)');


=====

Реактивность (Stream API)

// Подписка на изменения
realm.all<User>().changes.listen((changes) {
  print('Inserted: ${changes.inserted}');
  print('Modified: ${changes.modified}');
  print('Deleted: ${changes.deleted}');
});


''',
  ),

  QA(
    q: 'Какие есть базы данных для локального хранилища?',
    a: r'''

1. SQLite (sqflite)
final db = await openDatabase('app.db', version: 1,
  onCreate: (db, version) => db.execute('CREATE TABLE...'));
await db.insert('users', user.toMap());
final users = await db.query('users', where: 'age > ?', whereArgs: [18]);
Плюсы: Стандарт, SQL, мало весит, надежность
Минусы: Boilerplate код, ручные миграции, нет реактивности


2. Drift
@DriftDatabase(tables: [Users, Tasks])
class AppDatabase extends _$AppDatabase {
  Stream<List<User>> watchActiveUsers() =>
    select(users).where((u) => u.isActive).watch();
}
Плюсы: Type-safe SQL, code generation, Stream API
Минусы: Сложная настройка, большой размер


3. Hive
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0) String name;
}

final box = await Hive.openBox<User>('users');
await box.add(User('John'));
final user = box.getAt(0);


4. Isar


''',
  ),

  QA(
    q: 'Что такое PrimaryKey в базе данных?',
    a: '''

Свойства PrimaryKey:
  Уникальность - нет дубликатов
  NOT NULL - обязательное значение
  Неизменяемость - нельзя обновлять
  Один на таблицу - только один PK
  @RealmModel()
    class _User {
    @PrimaryKey()
    late String id; // Уникальный идентификатор
  }


===

Foreign Key (Внешний ключ)

@RealmModel()
class _Order {
  @PrimaryKey()
  late String id;
  _User? customer; // FK на User
}

// sqflite - явное определение
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  FOREIGN KEY (customer_id) REFERENCES users(id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
);

Foreign Key - это "ссылка" из одной таблицы на запись в другой таблице.

Как работает CASCADE:
1. Удаляешь запись с Primary Key
2. БД автоматически находит все Foreign Key, которые на неё ссылаются
3. Удаляет все эти записи


''',
  ),

  QA(
    q: 'В чем разница Реляционная и НеРеляционная базы данных?',
    a: '''

Реляционная БД — данные хранятся в таблицах с чёткой структурой (строки/столбцы), связанных между собой (например, PostgreSQL, MySQL).

Нереляционная БД — данные хранятся гибко, без строгой таблицы: документы (MongoDB), ключ-значение (Redis), графы (Neo4j) и т.п.
Это значит, что данные не обязаны быть организованы в строки и столбцы как в Excel.

В нереляционных БД данные могут храниться в формате:

Документов (JSON-подобные структуры)
Ключ-значение (как словарь в Dart)
Графов (узлы и связи)
Колонок (отдельные колонки данных)
Нет строгой схемы — можно добавлять поля без изменения всей структуры.



''',
  ),

  QA(q: 'Что делает базу данной хорошей?', a: 'Наличие миграций'),
  QA(
    q: 'Как скачать большой файл например 1 гб с точки зрения системного дизайна',
    a: '''

Самое главное: качать chunk-ами

1) Потоковое скачивание (streaming)
Использую HttpClient (не http пакет) — он даёт доступ к байтовому потоку (Stream<List<int>>).

2) Позволяет не загружать всё в память, а писать напрямую в файл.

3) Поддержка прогресс бар
Общий размер доступен через response.contentLength.
Отслеживаю количество записанных байт, вычисляю %.
int total = response.contentLength;
int received = 0;

response.listen((chunk) {
  received += chunk.length;
  sink.add(chunk);
  onProgress(received / total); // emit в стейт
});

4) Поддержка прерывания скачивания
Если сервер поддерживает скачивание частями, то продолжу с того места, где оборвалось

5) Event Loop + Async I/O
Все Dart операции выполняются в одном isolate (одном потоке)
Сетевые операции делегируются операционной системе (ОС) через асинхронный I/O
Когда данные готовы, OS уведомляет event loop через механизмы типа epoll/kqueue/IOCP

''',
  ),

  QA(
    q: 'Почему в const конструкторе класса не может быть тела {} в dart?',
    a: '''

Объекты создаются во время компиляции, не должно быть runtime кода

class Point {
  final int x, y;

  // ✅ const конструктор без тела
  const Point(this.x, this.y);

  // ❌ Это невозможно
  // const Point(this.x, this.y) {
  //   какой-то код
  // }
}

''',
  ),
  QA(
    q: 'Что такое ValueListenableBuilder?',
    a: r'''

- ValueNotifier<T> — легковесная альтернатива setState для локального состояния.
- ValueListenableBuilder перерисовывает только ту часть дерева, что зависит от value.


class CounterPage extends StatelessWidget {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  void _increment() => _counter.value++;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, child) {
            return Text(
              'Count: $value',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}


Третий аргумент child в builder можно использовать для неизменяемых поддеревьев, чтобы избежать лишних rebuild'ов.

class CounterPage extends StatelessWidget {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  void _increment() => _counter.value++;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _counter,
        child: const Icon(Icons.star, size: 48, color: Colors.amber), // child передаётся в ValueListenableBuilder один раз и не перестраивается.
                                                                        // При каждом изменении value перестраивается только текст, а Icon остаётся прежним.
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child!, // неизменяемая часть
              Text(
                'Count: $value',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''',
  ),

  QA(
    q: 'Что такое RootRestorationScope?',
    a: r'''

RootRestorationScope - это виджет, который помогает приложению "запоминать" свое состояние и восстанавливать его после перезапуска или сворачивания.
Краткий чеклист концепции:

📱 Сохраняет состояние приложения
🔄 Восстанавливает данные после перезапуска
🎯 Работает на уровне всего приложения
🔑 Требует уникальный restorationId

🎯 Зачем нужен?
Представьте: пользователь увеличил счетчик до 15, свернул приложение, система закрыла его для экономии памяти. Без RootRestorationScope счетчик сбросится на 0. С ним - останется 15.

🔧 Как работает?
- RootRestorationScope оборачивает все приложение
- Виджеты с RestorationMixin регистрируют свои данные
- Flutter автоматически сохраняет и восстанавливает эти данные

📝 Ключевые моменты:
- restorationId должен быть уникальным
- Используйте RestorableInt, RestorableString и др. для данных
- Миксин RestorationMixin обязателен для виджетов
- Состояние сохраняется локально на устройстве


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RootRestorationScope(
      // Уникальный ID для восстановления состояния всего приложения
      restorationId: 'my_app',
      child: MaterialApp(
        title: 'Restoration Demo',
        // Включаем восстановление состояния навигации
        restorationScopeId: 'app',
        home: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> with RestorationMixin {
  // RestorableInt сохраняет значение счетчика
  final RestorableInt _counter = RestorableInt(0);
  final RestorableString _userName = RestorableString('Пользователь');

  @override
  String? get restorationId => 'counter_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Регистрируем переменные для восстановления
    registerForRestoration(_counter, 'counter_value');
    registerForRestoration(_userName, 'user_name');
  }

  void _incrementCounter() {
    setState(() {
      _counter.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Вы нажали кнопку столько раз:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '${_counter.value}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName.value = 'Активный пользователь';
                });
              },
              child: Text('Изменить имя'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Увеличить',
        child: Icon(Icons.add),
      ),
    );
  }
}
''',
  ),
  QA(
    q: 'Назначение GlobalKey',
    a: '''

GlobalKey - это уникальный идентификатор виджета во всем приложении, который позволяет получить доступ
к состоянию и контексту виджета из любого места в дереве виджетов.


Иерархия ключей в Flutter

// Базовый класс
abstract class Key {
  const Key(this.value);
  final String value;
}

// Локальные ключи (в пределах родительского виджета)
class ValueKey<T> extends LocalKey { ... }
class UniqueKey extends LocalKey { ... }
class ObjectKey extends LocalKey { ... }

// Глобальные ключи (уникальны во всем приложении)
class GlobalKey<T extends State<StatefulWidget>> extends Key { ... }
class LabeledGlobalKey<T extends State<StatefulWidget>> extends GlobalKey<T> { ... }


В чем разница между LocalKey и GlobalKey?
LocalKey
- уникален в пределах родителя, ValueKey('item1') может повторяться в разных родителях
- доступ к state нет
- сохранение state при перемещении нет

GlobalKey
- уникален во всем приложении, GlobalKey() должен быть единственным в приложении
- доступ к state есть
- сохранение state при перемещении есть


GlobalKey<T extends State<StatefulWidget>> — это уникальный идентификатор, который:
- Гарантирует уникальность в рамках всего дерева виджетов.
- Даёт доступ к:
    - State виджета
    - BuildContext виджета
    - Позиции и размеров (через RenderObject)
- Сохраняет состояние при перемещении виджета в дереве (в отличие от Key или ValueKey, которые только участвуют в сравнении).


Типичный use-case:
- Управление состоянием дочернего StatefulWidget извне (вызов метода State).
- Доступ к Form и FormState для валидации и сохранения.
- Измерение размеров или позиции через RenderBox.
- Скролл



Как работает под капотом
- Обычные ключи (ValueKey, ObjectKey) нужны для сравнения при Element diff’е.
- GlobalKey регистрируется в глобальном Map<GlobalKey, Element> внутри Flutter Engine.
- При перестроении дерева, если виджет с GlobalKey перемещён:
  - Flutter не пересоздаёт State.
  - Element просто реаттачится в новой позиции.
- Благодаря этому состояние виджета “мигрирует” вместе с ним.


Подводные камни
- Уникальность: Два одинаковых GlobalKey в дереве → Duplicate GlobalKey runtime exception.
- Перенос в другое дерево: GlobalKey может сохранить State даже при переносе между родителями, но если виджет временно удалён из дерева, State уничтожается.
- Память: Если GlobalKey удерживает ссылку на State, который больше не в дереве, это может задержать сборку мусора (memory leak при неправильной архитектуре).



Измерение размеров через GlobalKey

final key = GlobalKey();

Widget build(BuildContext context) {
  return Container(key: key, child: Text('Hello'));
}

void measure() {
  final box = key.currentContext!.findRenderObject() as RenderBox;
  final size = box.size;
  final position = box.localToGlobal(Offset.zero);
}


Производительность
- Каждый GlobalKey хранится в глобальной Map, что делает сравнение ключей медленнее, чем у LocalKey.
- При большом числе GlobalKey (> сотен) возможны проблемы с diff’ом.
- Не подходит для массового списка элементов (например, в ListView.builder)


Альтернативы GlobalKey
- Для управления состоянием: BLoC, Provider, Riverpod.
- Для измерений: LayoutBuilder, MeasureSize (Custom widget).
- Для навигации: GoRouter или Navigator с ключом navigatorKey в MaterialApp.




гарантированно выбросит Duplicate GlobalKey:
Ошибка возникает, если один и тот же объект GlobalKey (одна и та же ссылка в памяти) попадает в дерево более чем один раз.

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Duplicate GlobalKey Example')),
        body: Column(
          children: [
            Container(
              key: globalKey,
              height: 50,
              color: Colors.red,
            ),
            Container(
              key: globalKey, // ❌ один и тот же GlobalKey
              height: 50,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}


''',
  ),
  QA(
    q: 'Какие проблемы будут с аналитикой приложения (например, Firebase analytics) при обфускации кода?',
    a: r'''

Основные проблемы:

1. Обфускация имен событий и параметров

// ДО обфускации - читаемые события
FirebaseAnalytics.instance.logEvent(
  name: 'user_purchase',
  parameters: {
    'item_id': 'premium_subscription',
    'currency': 'USD',
    'value': 9.99,
  },
);

// ПОСЛЕ обфускации - нечитаемые имена
Событие может стать чем-то вроде 'a1b2c3'

2. Нарушение Crashlytics stack traces

// Stack traces становятся нечитаемыми
try {
  // некий код
} catch (e, stackTrace) {
  FirebaseCrashlytics.instance.recordError(e, stackTrace);
  // stackTrace будет содержать обфускированные имена классов и методов
}

Как избежать

1. Не обфусцировать имена событий и параметров
События и параметры лучше хранить в const или как enum, но с ручным указанием значения:

class AnalyticsEvent {
  static const String signUp = 'sign_up';
  static const String purchase = 'purchase';
}

2. Сохранить читаемые имена экранов
Авто-трекинг экранов в Firebase опирается на runtimeType виджета. При обфускации он станет a, b и т.п.
Решение: выключить setCurrentScreen авто-режим и задавать явно:

FirebaseAnalytics.instance.setCurrentScreen(
  screenName: 'ProfileScreen',
);


3. ProGuard/R8: keep правила

# Firebase Analytics
-keep class com.google.firebase.analytics.** { *; }
-keepclassmembers class * {
    @com.google.firebase.analytics.FirebaseAnalytics *;
}

# Оставить имена классов Activity/Fragment (для screen tracking)
-keep class * extends android.app.Activity
-keep class * extends androidx.fragment.app.Fragment


''',
  ),

  QA(
    q: 'Что такое обфускация кода?',
    a: r'''

Обфускация - это процесс преобразования исходного кода в функционально эквивалентный, но трудночитаемый и сложный для понимания код.
Цели обфускации:

🔐 Защита интеллектуальной собственности
🛡️ Усложнение reverse engineering
📱 Защита от декомпиляции приложения
🔍 Сокрытие бизнес-логики


Как работает обфускация:

ДО обфускации:

class ApiService {
  final String apiKey = "sk_live_abcd1234";
  final String baseUrl = "https://api.stripe.com";

  Future<void> makeRequest() async {
    print("Using API key: $apiKey");
    // HTTP запрос с реальным ключом
    final response = await http.get(
      Uri.parse('$baseUrl/charges'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );
  }
}

ПОСЛЕ обфускации:

class x9z8y7 {  // Имя класса обфускировано
  final String w6v5u4 = "sk_live_abcd1234";  // КЛЮЧ ОСТАЛСЯ!
  final String t3s2r1 = "https://api.stripe.com";  // URL ОСТАЛСЯ!

  Future<void> q0p9o8() async {  // Имя метода обфускировано
    print("Using API key: $w6v5u4");  // Вывод: "sk_live_abcd1234"
    final n7m6l5 = await k4j3i2.h1g0f9(
      e8d7c6.b5a4z3('$t3s2r1/charges'),  // Реальный URL!
      y2x1w0: {'Authorization': 'Bearer $w6v5u4'},  // Реальный ключ!
    );
  }
}

Обфускируется:

✅ Имя переменной: apiKey → d4e5f6
✅ Имя класса: UserRepository → a1b2c3
✅ Имя метода: fetchUserById → m3n4o5

НЕ обфускируется:

❌ Строковые литералы: "secret_api_key_12345"
❌ Числовые значения: 12345
❌ URL endpoints: "https://api.example.com"


Однако есть проблемы безопасности:

1. Можно извлечь строки из APK
strings app-release.apk | grep "sk_live" # Результат: sk_live_abcd1234

Решение

// ❌ ПЛОХО - ключ в коде
class ApiService {
  final String apiKey = "sk_live_abcd1234"; // Виден в APK!
}

// ✅ ХОРОШО - ключ из переменных окружения

flutter build apk \
  --obfuscate \
  --split-debug-info=./debug \
  --dart-define=API_KEY=sk_live_abcd1234

class ApiService {
  final String apiKey = const String.fromEnvironment(
    'API_KEY',
    defaultValue: 'dev_key'
  );
}
''',
  ),

  QA(
    q: 'Понимание концепции и назначения Slivers',
    a: r'''

Sliver (от англ. "тонкий кусочек") - это базовый строительный блок для создания прокручиваемого контента во Flutter.
Это низкоуровневые виджеты, которые работают непосредственно с viewport'ом и могут эффективно обрабатывать большие объемы данных.


// Обычный подход (неэффективный для больших списков)
Column(
  children: [
    AppBar(),
    Expanded(
      child: ListView(
        children: List.generate(1000, (index) => ListTile()),
      ),
    ),
  ],
)

// Sliver подход (эффективный)
CustomScrollView(
  slivers: [
    SliverAppBar(),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(),
        childCount: 1000,
      ),
    ),
  ],
)


Ключевые концепции

1. Viewport и Scroll Offset

- Viewport - видимая область экрана
- Scroll Offset - текущая позиция прокрутки
- Paint Extent - область, которую виджет занимает на экране


// Этот Sliver будет "понимать" границы viewport
SliverToBoxAdapter(
  child: Container(
    height: 200,
    color: Colors.blue,
    child: Center(
      child: Text('Viewport Height: ${MediaQuery.of(context).size.height}'),
    ),
  ),
),


2. Ленивое создание (Lazy Creation)

Slivers создают виджеты только когда они попадают в viewport:

SliverList(
  delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      print('Создан виджет с индексом: $index'); // Выполнится только для видимых элементов
      return ListTile(
        title: Text('Item $index'),
        subtitle: Text('Создан только когда стал видимым'),
      );
    },
    childCount: 10000, // Большое количество, но создаются только видимые
  ),
)


Основные преимущества Slivers

1. Производительность

// ❌ Плохо: создает все виджеты сразу
Column(
  children: List.generate(10000, (index) =>
    ExpensiveWidget(data: heavyData[index])
  ),
)

// ✅ Хорошо: создает только видимые виджеты
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) => ExpensiveWidget(data: heavyData[index]),
    childCount: 10000,
  ),
)

2. Единая координация прокрутки

CustomScrollView(
  slivers: [
    // Все эти элементы прокручиваются синхронно
    SliverAppBar(
      title: Text('Заголовок'),
      floating: true,
      snap: true,
    ),
    SliverToBoxAdapter(
      child: Container(
        height: 100,
        child: Text('Фиксированный контент'),
      ),
    ),
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildBuilderDelegate(
        (context, index) => GridItem(index),
        childCount: 20,
      ),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListItem(index),
        childCount: 100,
      ),
    ),
  ],
)


Когда использовать Slivers?


✅ Используйте Slivers когда:

Большие списки данных (>100 элементов)

// Для больших списков
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) => BigDataItem(bigDataList[index]),
    childCount: bigDataList.length, // Может быть очень большим
  ),
)


Кастомное поведение при прокрутке

// Для специального поведения AppBar
SliverAppBar(
  floating: true,    // Появляется при прокрутке вверх
  snap: true,        // Быстро разворачивается/сворачивается
  pinned: false,     // Не остается закрепленным
  expandedHeight: 200,
)

''',
  ),

  QA(
    q: 'Почему обычные виджеты нужно оборачивать в SliverToBoxAdapter?',
    a: r'''

📝 Краткий чеклист понимания
- Sliver — это “умный” список/скролл-элемент, который умеет лениво отрисовывать и адаптировать размер контента.
- Box widgets (Container, Column, Stack и т.д.) рисуются в фиксированной системе координат и не знают про scroll-логику.
- CustomScrollView требует только slivers, чтобы контролировать их лэйаут.
- SliverToBoxAdapter — адаптер, позволяющий вставить обычный box в sliver-поток.
- Разделение сделано ради производительности и гибкости — вместо универсального тяжёлого виджета используют два специализированных типа.


🔍 Почему разделили на Sliver и обычные виджеты
В Flutter система лэйаута делится на RenderBox и RenderSliver:
- RenderBox — классический “прямоугольный” элемент.
  Пример: Container, Row, Column. Они знают свой размер и просто отрисовываются.
- RenderSliver — элемент, который сам решает, какую часть контента отрисовывать, в зависимости от видимой области.
  Пример: SliverList, SliverAppBar.


Если бы всё было одним типом, то:
- Потеряли бы оптимизацию: обычный ListView с 10 000 элементами грузил бы все сразу.
- Сложнее управлять поведением при скролле: sticky headers, collapsing app bars, lazy loading.
- Рендер был бы тяжелее: пришлось бы добавлять сложную логику в каждый виджет.


📦 Почему нужен SliverToBoxAdapter
CustomScrollView принимает только slivers, потому что он полностью контролирует их размер и позицию в scroll-потоке.

Если ты вставишь туда обычный Container, он не знает, как себя вести в “sliver-контексте”.
SliverToBoxAdapter просто оборачивает его в RenderSliver, который говорит:

"У меня фиксированный размер, я веду себя как один элемент в потоке".


RenderBox и RenderSliver решают принципиально разные задачи, и отказаться от RenderBox
в пользу только RenderSliver означало бы сломать половину экосистемы Flutter — в том числе и там, где скролла вообще нет.


почему RenderBox всё ещё нужен
- Не всё в UI — это скролл. Кнопки, диалоги, формы, иконки — им не нужен sliver-режим.
- RenderBox проще и легче. Он не тратит ресурсы на расчёты видимой области, как sliver.
- Большая часть Flutter UI построена на Box-модели. Менять это — значит переписывать весь фреймворк.
- Sliver сложнее в разработке. Для каждого элементарного виджета пришлось бы писать отдельный RenderSliver.
- Разделение — это гибкость. Box для фиксированных областей, Sliver для скролла.


под “sliver-режимом” имеют в виду особый способ лэйаута и рендеринга, который применяется,
когда виджет находится внутри RenderViewport и реализован как RenderSliver, а не как обычный RenderBox.
"Sliver-режим" = когда виджет живёт в sliver-окружении и должен работать по правилам sliver-протокола.


ASCII схема: RenderBox vs RenderSliver
═══════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────┐
│                    RENDERBOX                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐  ◄── Фиксированные размеры             │
│  │   RenderBox     │      width × height                    │
│  │                 │                                        │
│  │  ┌───────────┐  │  ◄── Дочерние элементы                 │
│  │  │   Child   │  │      также RenderBox                   │
│  │  └───────────┘  │                                        │
│  │                 │                                        │
│  └─────────────────┘                                        │
│                                                             │
│  Constraints: BoxConstraints                                │
│  ┌─────────────────────────────────────┐                    │
│  │ minWidth, maxWidth                  │                    │
│  │ minHeight, maxHeight                │                    │
│  └─────────────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   RENDERSLIVER                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌═══════════════════════════════════════════════════════┐  │
│  ║                VIEWPORT                               ║  │
│  ║  ┌─────────────────┐ ◄── Видимая область              ║  │
│  ║  │   RenderSliver  │                                  ║  │
│  ║  │                 │     ┌──────────┐                 ║  │
│  ║  │  ┌───────────┐  │ ◄───┤ Geometry │                 ║  │
│  ║  │  │   Item    │  │     │ paintExtent                ║  │
│  ║  │  └───────────┘  │     │ layoutExtent               ║  │
│  ║  │                 │     │ scrollExtent               ║  │
│  ║  │  ┌───────────┐  │     └──────────┘                 ║  │
│  ║  │  │   Item    │  │                                  ║  │
│  ║  │  └───────────┘  │                                  ║  │
│  ║  └─────────────────┘                                  ║  │
│  ║                                                       ║  │
│  ║  ┌─────────────────┐ ◄── За пределами viewport        ║  │
│  ║  │   (не видим)    │     (не рендерится)              ║  │
│  ║  └─────────────────┘                                  ║  │
│  ╚═══════════════════════════════════════════════════════╝  │
│                                                             │
│  Constraints: SliverConstraints                             │
│  ┌─────────────────────────────────────┐                    │
│  │ axisDirection, growthDirection      │                    │
│  │ scrollOffset, remainingPaintExtent  │                    │
│  │ crossAxisExtent, userScrollDirection│                    │
│  └─────────────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────┘

КЛЮЧЕВЫЕ РАЗЛИЧИЯ:
═════════════════════

RenderBox                      │  RenderSliver
──────────────────────────────────────────────────────────────
✓ Фиксированный размер         │  ✓ Динамический размер
✓ 2D layout (width × height)   │  ✓ 1D layout (вдоль оси скролла)
✓ Все дети рендерятся          │  ✓ Ленивый рендеринг
✓ BoxConstraints               │  ✓ SliverConstraints
✓ Container, Row, Column       │  ✓ ListView, GridView, SliverList

ПОТОК ДАННЫХ:
═════════════

RenderBox:
Parent ──[BoxConstraints]──► Child ──[Size]──► Parent

RenderSliver:
Viewport ──[SliverConstraints]──► Sliver ──[SliverGeometry]──► Viewport

''',
  ),

  QA(
    q: 'Как добавить обработку клавиатуры на любых экрана?',
    a: '''

Ключевые принципы решения:

1) resizeToAvoidBottomInset: false — отключает автоматическое сжатие экрана
2) SingleChildScrollView на верхнем уровне — дает возможность скроллить весь контент
3) ConstrainedBox с minHeight — гарантирует, что контент занимает минимум полную высоту экрана
4) IntrinsicHeight — позволяет Expanded корректно работать внутри ScrollView
5) SizedBox(height: keyboardHeight) — создает дополнительное пространство для скролла за клавиатурой
6) ClampingScrollPhysics() — убирает bounce-эффект на iOS

Результат:
- Без клавиатуры — экран выглядит как обычно
- С клавиатурой — ничего не сдвигается, но можно проскроллить на высоту клавиатуры для доступа к скрытому контенту

Эта структура универсальна и работает на любых экранах с формами.


import 'package:flutter/material.dart';

class KeyboardDemoScreen extends StatefulWidget {
  @override
  State<KeyboardDemoScreen> createState() => _KeyboardDemoScreenState();
}

class _KeyboardDemoScreenState extends State<KeyboardDemoScreen> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false, // КЛЮЧЕВОЙ МОМЕНТ 1: отключаем автоматическое изменение размера
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Демо клавиатуры'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView( // КЛЮЧЕВОЙ МОМЕНТ 2: весь контент в SingleChildScrollView
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints( // КЛЮЧЕВОЙ МОМЕНТ 3: минимальная высота = полный экран
              minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        kToolbarHeight, // учитываем AppBar
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Заголовок экрана',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40),

                          Text('Поле 1:', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          TextField(
                            controller: _controller1,
                            decoration: InputDecoration(
                              hintText: 'Введите текст',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),

                          Text('Поле 2:', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          TextField(
                            controller: _controller2,
                            decoration: InputDecoration(
                              hintText: 'Еще одно поле',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),

                          Text('Поле 3 (внизу):', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          TextField(
                            controller: _controller3,
                            decoration: InputDecoration(
                              hintText: 'Это поле будет скрыто за клавиатурой',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: 40),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.orange[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Дополнительный контент\n(может быть скрыт за клавиатурой)',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Нижняя часть
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Кнопка нажата!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: Text('Главная кнопка'),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Это текст в нижней части экрана. При открытии клавиатуры можно проскроллить до него.',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),

                        // КЛЮЧЕВОЙ МОМЕНТ 4: пространство для скролла за клавиатурой
                        SizedBox(height: keyboardHeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: KeyboardDemoScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

''',
  ),

  QA(
    tags: [Tag.flutter],
    q: 'Для чего нужен clipBehavior: Clip.none в Stack виджете?',
    a: '''
clipBehavior: Clip.none в Stack решает проблему обрезки дочерних виджетов, которые выходят за границы Stack'а.

Как работает клиппинг по умолчанию

По умолчанию Stack использует clipBehavior: Clip.hardEdge, что означает:
- Все дочерние виджеты, выходящие за границы Stack'а, обрезаются
- Видимой остается только та часть виджета, которая находится внутри размеров Stack'а

// Stack размером 32x32
SizedBox(
  width: 32,
  height: 32,
  child: Stack(
    // clipBehavior: Clip.hardEdge (по умолчанию)
    children: [
      Center(child: Icon(Icons.notifications)), // 24x24, помещается
      Positioned(
        right: -8,  // выходит на 8px за правую границу Stack'а
        top: -8,    // выходит на 8px за верхнюю границу Stack'а
        child: Badge(), // этот виджет будет ОБРЕЗАН
      ),
    ],
  ),
)

В этом случае badge будет обрезан, потому что его часть находится в координатах -8, -8,
что выходит за границы Stack'а размером 32x32.

Решение с Clip.none

Stack(
  clipBehavior: Clip.none, // ✅ Отключаем обрезку
  children: [
    Center(child: Icon(Icons.notifications)),
    Positioned(
      right: -8,
      top: -8,
      child: Badge(), // теперь виджет НЕ обрезается
    ),
  ],
)

Варианты clipBehavior
- Clip.none — обрезка отключена, все видно
- Clip.hardEdge — резкая обрезка (по умолчанию)
- Clip.antiAlias — сглаженная обрезка
- Clip.antiAliasWithSaveLayer — сглаженная обрезка с дополнительной оптимизацией
''',
  ),

  QA(
    tags: [Tag.flutter],
    q: 'Архитектура Flutter (3 слоя)',
    a: '''
Framework (dart): Widgets, Rendering, Animation, Gestures
Engine (c/c++)  : Isolate, Platform channels, Dart VM
Embedder (platform specific): native plugins
''',
  ),

  QA(
    tags: [Tag.flutter, Tag.memory],
    q: 'Как работает однопоточный Dart и многопоточный (4 потока) Flutter?  ',
    a: '''
1. Dart – однопоточная модель (event loop)

- В Dart весь код приложения исполняется в одном Isolate.
- У каждого Isolate есть:
  - Свой heap (память)
  - Свой event loop (как в JS)

- Задачи делятся на:
  - Microtasks (очередь с высшим приоритетом — scheduleMicrotask)
  - Event tasks (обычные async-задания — Future, таймеры, IO)

- Event loop последовательно берет задачи из очередей и исполняет их.

- Никакого доступа к общей памяти между Isolate-ами нет, данные передаются через передачу сообщений

Плюс: Нет race condition и необходимости в синхронизации.
Минус: Тяжелые вычисления могут блокировать UI.

=====

Flutter – 4 потока под капотом

Flutter использует многопоточность движка (C++), но логика Dart-приложения по-прежнему сидит в одном Isolate:

- UI thread (главный Isolate Dart)
  - Запускает ваш Dart-код.
  - Формирует дерево виджетов и передает команды на отрисовку движку.

- Raster thread (отрисовка)
  - На основе команд из UI-thread отрисовывает кадры на GPU.
  - Полностью нативный (C++), без доступа к Dart heap.

- IO thread
  - Занимается чтением файлов, изображений, сетевыми запросами и прочим.
  - Разгружает UI-поток.

- Platform thread
  - Общается с платформой (Android/iOS), обрабатывает каналы (Platform Channels).

Важное: Эти потоки движка не делят кучу Dart. UI-поток (Isolate) передает только команды и данные через message passing в другие потоки.

===

Как это выглядит в реальности
- Ваш Dart-код всегда однопоточен.
- Но Flutter Engine (написан на C++) распараллеливает тяжелые задачи (рендеринг, IO, платформенные вызовы) на отдельные нативные потоки.
- Если нужно параллельное вычисление в Dart — создаешь новый Isolate, он тоже будет работать на отдельном системном потоке.

Подвох на собеседовании
Вопрос: "Почему я не могу просто запустить тяжелую функцию в отдельном потоке Dart?"
Ответ: В Dart нет потоков с общей памятью. Нужно создавать новый Isolate, потому что главный Isolate заблокирует event loop и UI перестанет обновляться.
''',
  ),
  QA(
    tags: [Tag.flutter],
    q: 'Почему пакет dart:mirrors не используется во Flutter?',
    a: '`dart:mirrors` не поддерживается во Flutter, потому что он требует рефлексии во время выполнения, что несовместимо с AOT-компиляцией и tree shaking, и сильно увеличивает размер сборки.',
  ),

  QA(
    tags: [Tag.flutter],
    q: 'Как Dart работает в Web-приложениях?',
    a: '''
Dart компилируется в JavaScript с помощью `dart compile js`. Можно использовать `dart:html`.
Flutter Web — это другой runtime (CanvasKit, DomCanvas).',

Ограничения Dart в Web-среде:

Отсутствие dart:io — недоступны файловые операции, сокеты, процессы. Вместо этого нужно использовать dart:html и Web APIs.
Ограничения dart:ffi — Foreign Function Interface не работает в браузере, нельзя вызывать нативные библиотеки C/C++.
Нет многопоточности с Isolates — dart:isolate ограничен в веб-среде, полноценные изоляты недоступны. Есть только Web Workers через dart:html.
Ограничения рефлексии — dart:mirrors не поддерживается в продакшене из-за tree-shaking. Это влияет на сериализацию/десериализацию и DI-контейнеры.
CORS и Same-Origin Policy — ограничения браузера на кросс-доменные запросы, которых нет в нативных приложениях. Влияет на HTTP-клиенты и WebSocket-соединения.''',
  ),
  QA(
    tags: [Tag.flutter],
    q: 'Как работает взаимодействие с платформой в Flutter (iOS/Android)?',
    a: r'''

Flutter взаимодействует с нативными платформами через Platform Channels — асинхронный механизм
обмена сообщениями между Dart и нативным кодом.

Архитектура Platform Channels

┌─────────────────┐    Message     ┌─────────────────┐
│   Flutter/Dart  │ ─────────────► │  Native Code    │
│                 │                │  (iOS/Android)  │
│   UI Layer      │ ◄───────────── │  Platform APIs  │
└─────────────────┘    Channel     └─────────────────┘

Типы каналов

1. MethodChannel (наиболее частый)

// Dart сторона
class BatteryService {
  static const MethodChannel _channel = MethodChannel('battery_level');

  static Future<int?> getBatteryLevel() async {
    try {
      final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
      return batteryLevel;
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
      return null;
    }
  }

  static Future<void> vibrate({int duration = 100}) async {
    await _channel.invokeMethod('vibrate', {'duration': duration});
  }
}

Android (Kotlin):

// MainActivity.kt
class MainActivity: FlutterActivity() {
    private val CHANNEL = "battery_level"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryLevel" -> {
                        val batteryLevel = getBatteryLevel()
                        if (batteryLevel != -1) {
                            result.success(batteryLevel)
                        } else {
                            result.error("UNAVAILABLE", "Battery level not available.", null)
                        }
                    }
                    "vibrate" -> {
                        val duration = call.argument<Int>("duration") ?: 100
                        vibrate(duration)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        return batteryLevel
    }

    private fun vibrate(duration: Int) {
        val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(duration.toLong(), VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            vibrator.vibrate(duration.toLong())
        }
    }
}


iOS (Swift):

// AppDelegate.swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "battery_level",
                                                 binaryMessenger: controller.binaryMessenger)

        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            switch call.method {
            case "getBatteryLevel":
                self?.receiveBatteryLevel(result: result)
            case "vibrate":
                let args = call.arguments as? [String: Any]
                let duration = args?["duration"] as? Int ?? 100
                self?.vibrate(duration: duration)
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",
                              message: "Battery level not available.",
                              details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }

    private func vibrate(duration: Int) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

''',
  ),
];
