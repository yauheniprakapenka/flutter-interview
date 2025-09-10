// ignore_for_file: prefer_const_constructors

import '../model/qa_model.dart';

List<QA> complex = [
  QA(
    tags: [Tag.complexity],
    q: 'Если сложить O(1) и O(n), то какая сложность получится?',
    a: '''

O(1) + O(n) = O(n)

ПОЧЕМУ:
─────────────────────────────────────────────────
В Big O нотации доминирует старший член.

O(1) = константное время (не зависит от n)
O(n) = линейное время (пропорционально n)

ПРИМЕР:
─────────────────────────────────────────────────
void example(List<int> list) {
  print('Hello');        // O(1)
  for (int item in list) { // O(n)
    print(item);
  }
}

МАТЕМАТИЧЕСКИ:
─────────────────────────────────────────────────
O(1) + O(n) = O(max(1, n)) = O(n)

ДРУГИЕ ПРИМЕРЫ:
─────────────────────────────────────────────────
O(1) + O(1) = O(1)
O(n) + O(n) = O(2n) = O(n)
O(n) + O(n²) = O(n²)
O(log n) + O(n) = O(n)
O(n) + O(m) = O(n + m)

ПРАВИЛО: При сложении Big O берется максимальный член.

''',
  ),
  const QA(
    tags: [Tag.complexity],
    q: '''Что такое O(1) константная?''',
    a: '''
Когда операция выполняется за фиксированное время, независимо от размера данных.

// Доступ к элементу списка по индексу
final list = [1, 2, 3, 4, 5];
final item = list[2]; // Всегда O(1) по индексу

// Доступ к значению в Map
final map = {'key': 'value'};
final value = map['key']; // Всегда O(1) по ключу
''',
  ),

  QA(
    tags: [Tag.complexity],
    q: 'Почему O(2n) = O(n)?',
    a: r'''

ПРИМЕР: O(n) + O(n) = O(n)

void processList(List<int> numbers) {
  // Первый проход: найти сумму - O(n)
  int sum = 0;
  for (int number in numbers) {
    sum += number;
  }

  // Второй проход: найти максимум - O(n)
  int max = numbers[0];
  for (int number in numbers) {
    if (number > max) {
      max = number;
    }
  }

  print('Sum: $sum, Max: $max');
}

АНАЛИЗ:
─────────────────────────────────────────────────
Первый цикл:  O(n)
Второй цикл: O(n)
Итого:       O(n) + O(n) = O(2n) = O(n)

ПОЧЕМУ O(2n) = O(n):
─────────────────────────────────────────────────
В Big O нотации константные множители игнорируются:

O(2n) = O(n) потому что 2 = константа

ДРУГОЙ ПРИМЕР:
─────────────────────────────────────────────────
void twoPasses(List<String> words) {
  // O(n) - преобразовать в верхний регистр
  List<String> upper = [];
  for (String word in words) {
    upper.add(word.toUpperCase());
  }

  // O(n) - посчитать длины
  List<int> lengths = [];
  for (String word in upper) {
    lengths.add(word.length);
  }

  // Итого: O(n) + O(n) = O(n)
}

КЛЮЧЕВОЙ МОМЕНТ:
Два последовательных прохода по данным = линейная сложность,
не квадратичная, потому что каждый проход независим.
''',
  ),

  const QA(
    tags: [Tag.complexity],
    q: '''Что такое O(log n) - Логарифмическая?''',
    a: '''

Когда данные упорядочены и можно делить пополам (бинарный поиск).

// Бинарный поиск в отсортированном списке
int binarySearch(List<int> sortedList, int target) {
  int left = 0;
  int right = sortedList.length - 1;

  while (left <= right) {
    int mid = (left + right) ~/ 2;
    if (sortedList[mid] == target) return mid;
    if (sortedList[mid] < target) left = mid + 1;
    else right = mid - 1;
  }
  return -1; // O(log n)
}

''',
  ),
  const QA(
    tags: [Tag.complexity],
    q: 'Что такое O(n) - Линейная сложность?',
    a: r'''

Когда нужно проверить каждый элемент.

// Поиск элемента в неотсортированном списке
bool contains(List<int> list, int target) {
  for (int item in list) {  // O(n)
    if (item == target) return true;
  }
  return false;
}

// Flutter: обход всех дочерних виджетов
final children = List.generate(100, (index) => Text('Item $index'));
// Рендеринг каждого виджета - O(n)

''',
  ),

  const QA(
    tags: [Tag.complexity],
    q: 'Что такое O(n²) - Квадратичная сложность?',
    a: '''

Когда для каждого элемента нужно проверить все остальные элементы.

// Поиск дубликатов "в лоб"
List<int> findDuplicates(List<int> list) {
  final duplicates = <int>[];
  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {  // O(n²)
      if (list[i] == list[j] && !duplicates.contains(list[i])) {
        duplicates.add(list[i]);
      }
    }
  }
  return duplicates;
}

''',
  ),
];
