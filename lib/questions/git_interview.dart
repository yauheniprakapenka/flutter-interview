import '../model/qa_model.dart';

final gitInterview = [
  const QA(
    tags: [Tag.git],
    q: 'Что такое index?',
    a: 'Staging area (index) — промежуточная зона между рабочей директорией и коммитом.',
  ),

  const QA(
    tags: [Tag.git],
    q: ' Что такое Git Submodule?',
    a: '''
Git Submodule — это механизм для включения одного Git-репозитория в качестве поддиректории другого Git-репозитория,
при этом сохраняя их историю коммитов раздельной.

Практический пример для Flutter

Допустим, у вас есть общие UI-компоненты:

# В основном проекте добавляем shared UI как submodule
        git submodule add https://github.com/user/repo.git path/to/submodule
пример: git submodule add https://github.com/company/flutter-ui-kit.git packages/ui_kit

# Структура проекта:
your_flutter_app/
├── lib/
├── packages/
│   └── ui_kit/           # submodule
└── pubspec.yaml

В pubspec.yaml:

dependencies:
  ui_kit:
    path: packages/ui_kit


git submodule init
git submodule update
flutter pub get


Обновление submodule (когда нужно)

# Перейти в директорию submodule
cd packages/ui_kit

# Обновиться до нужного коммита
git checkout main
git pull origin main

# Вернуться в корень проекта
cd ../..

# Закоммитить новую ссылку на submodule
git add packages/ui_kit
git commit -m "Update ui_kit submodule to latest"

   ''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Что такое Git hooks?',
    a: '''
Git hooks — скрипты, которые автоматически выполняются при определенных Git событиях.

Расположение: .git/hooks/

Основные hooks:
• pre-commit: проверка кода перед коммитом (линтеры, тесты)
• pre-push: валидация перед push
• post-receive: деплой после получения изменений на сервере
• commit-msg: валидация формата сообщения коммита

Пример pre-commit:
#!/bin/sh
npm run lint
npm run test''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как разрешить rebase конфликт?',
    a: '''
Процесс:
1. Разрешить конфликты в файлах
2. git add <файл>
3. git rebase --continue
''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как клонировать удалённый репозиторий?',
    a: '''
git clone <url>

1. Скачивается полная история проекта (.git папка)
2. Создается рабочая директория с файлами последнего коммита
3. Настраивается remote origin на исходный репозиторий
4. Устанавливается HEAD на default ветку (обычно main/master)

  ''',
  ),
  const QA(tags: [Tag.git], q: 'Как добавить файл в staging area?', a: 'git add <file>'),
  const QA(tags: [Tag.git], q: 'Как добавить все изменения в staging area?', a: 'git add .'),
  const QA(tags: [Tag.git], q: 'Как создать коммит с сообщением?', a: 'git commit -m "message"'),
  const QA(
    tags: [Tag.git],
    q: 'Как показать различия между рабочей директорией и staging area?',
    a: 'git diff',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как показать различия между staging area и последним коммитом',
    a: 'git diff --staged',
  ),
  const QA(tags: [Tag.git], q: 'Как показать детали конкретного коммита?', a: 'git show <commit>'),
  const QA(
    tags: [Tag.git],
    q: 'Загрузить изменения с удалённого репозитория без слияния',
    a: '''
git fetch origin main // Загрузить конкретную ветку:

git fetch --all // Загрузить все ветки:''',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как отправить локальные коммиты в удалённый репозиторий?',
    a: '''

# Push в текущую ветку (если upstream настроен)
git push

# Push в конкретную ветку
git push origin main
git push origin feature/new-feature

# Push всех веток
git push --all origin

''',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как привязать локальную ветку к удалённой?',
    a: 'git branch --set-upstream-to=origin/feature/login',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как удалить удалённую ветку?',
    a: '''

git push origin --delete branch-name

git push origin --delete feature/user-authentication

Перед удалением убедитесь, что находитесь не на удаляемой ветке

''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как откатиться к предыдущему коммиту с сохранением изменений в рабочей директории?',
    a: 'git reset --mixed HEAD~1\n// Или просто: git reset HEAD~1',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Отменить коммит через новый коммит (безопасно)',
    a: 'git revert <commit>',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как изменить последний коммит?',
    a: '''
git commit --amend

С новым сообщением: git commit --amend -m "new message"
''',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Временно сохранить незакоммиченные изменения',
    a: 'git stash\n// С сообщением: git stash save "Описание изменений"',
  ),
  const QA(tags: [Tag.git], q: "Показать список stash'ей", a: 'git stash list'),
  const QA(
    tags: [Tag.git],
    q: 'Применить последний stash и удалить его из списка',
    a: 'git stash pop',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Удалить stash',
    a: '''

удалить конкретный stash:
git stash drop stash@{номер} // git stash drop stash@{1}

узнать номер stash:
git stash list
// stash@{0}: WIP on main: abc1234 Fix bug
// stash@{1}: WIP on feature: def5678 Add feature

удалить все stash:
git stash clear
''',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Применить конкретный коммит в текущую ветку',
    a: 'git cherry-pick <commit>',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Удалить неотслеживаемые файлы и папки',
    a: 'git clean -fd\n// Предварительный просмотр: git clean -n',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Создать аннотированный тег',
    a: 'git tag -a v1.0.0 -m "Release version 1.0.0"',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Отправить теги в удалённый репозиторий',
    a: 'git push origin --tags\n// Конкретный тег: git push origin v1.0.0',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Что такое HEAD?',
    a: 'Указатель на текущий коммит (обычно на последний коммит текущей ветки)',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Что такое origin?',
    a: 'Стандартное имя для удалённого репозитория по умолчанию',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Разница между рабочей директорией, staging area и HEAD',
    a: '''
Working Directory: файлы в файловой системе
Staging Area (Index): подготовленные к коммиту изменения
HEAD: последний коммит текущей ветки''',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Разница между merge и rebase',
    a: '''
merge: сохраняет историю ветвления, создаёт merge-коммит
rebase: перемещает коммиты, создаёт линейную историю
Используй merge для публичных веток, rebase для локальной работы''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как объединить несколько коммитов в один?',
    a: 'git rebase -i HEAD~N, затем изменить pick на squash для объединяемых коммитов',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как посмотреть, кто изменял строки в файле?',
    a: 'git blame <file>',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Объясните разницу между Git и GitHub',
    a: '''
Git — это система контроля версий, инструмент для отслеживания изменений в коде
GitHub — это облачный сервис для хостинга Git-репозиториев с дополнительными возможностями (Issues, Pull Requests, Actions)
Аналогично: GitLab, Bitbucket — тоже сервисы для Git''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Объясните жизненный цикл файла в Git',
    a: '''
Untracked → Staged → Committed → Modified
• Untracked: новый файл, Git о нем не знает
• Staged: файл добавлен через git add, готов к коммиту
• Committed: файл сохранен в истории Git
• Modified: файл изменен после последнего коммита''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как разрешить merge конфликт?',
    a: '''
1. Git помечает конфликтные файлы в статусе
2. Открыть файлы, найти маркеры конфликта:
   <<<<<<< HEAD
   код из текущей ветки
   =======
   код из мерджируемой ветки
   >>>>>>> feature-branch
3. Вручную выбрать нужный код, удалить маркеры
4. git add <файл>
5. git commit (создастся merge-коммит)''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Какие существуют типы git reset?',
    a: '''
git reset --soft HEAD~1:
• Откатывает коммит, но сохраняет изменения в staging
• Используется для переписывания последнего коммита

git reset --mixed HEAD~1 (по умолчанию):
• Откатывает коммит и staging, сохраняет рабочие файлы

git reset --hard HEAD~1:
• Полностью удаляет коммит и все изменения
• Опасно! Используется для полного отката''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Что такое git stash и когда его использовать?',
    a: '''
Stash временно сохраняет незакоммиченные изменения и очищает рабочую директорию.

Когда использовать:
• Нужно быстро переключиться на другую ветку
• Пришел критический багфикс, а текущая работа не готова
• Нужно сделать git pull, но есть локальные изменения

Команды:
• git stash push -m "описание"
• git stash pop (применить и удалить)
• git stash apply (применить, но оставить)''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Что такое git cherry-pick и зачем он нужен?',
    a: '''
Cherry-pick применяет конкретный коммит из одной ветки в другую.

Сценарии использования:
• Нужно перенести багфикс из feature в main до полного merge
• Случайно закоммитили в wrong ветку
• Нужен только один коммит из большой feature ветки

Пример:
git checkout main
git cherry-pick abc123  # применит коммит abc123 в main''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'В чем разница между git fetch и git pull?',
    a: '''
git fetch:
• Загружает изменения с remote, но НЕ применяет их
• Безопасно — не меняет локальные ветки
• Можно просмотреть изменения перед применением

git pull:
• git fetch + git merge origin/<branch>
• Автоматически сливает изменения в текущую ветку
• Быстро, но может создать неожиданные конфликты

Best practice: используй fetch для контроля, pull для routine обновлений''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Что делать, если случайно запушили секретные данные?',
    a: '''
Немедленные действия:
1. Сменить скомпрометированные секреты
2. Удалить из истории:
   git filter-branch --index-filter 'git rm --cached --ignore-unmatch secrets.txt'
   или git filter-repo --path secrets.txt --invert-paths
3. Force push: git push --force-with-lease
4. Уведомить команду о перезаписи истории

⚠️ Если репозиторий публичный — секреты считать скомпрометированными навсегда''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Опишите Git Flow',
    a: '''
Git Flow:
• main (или master) — Содержит production-ready код, Коммиты помечаются тегами с номерами версий
• develop — Ветка разработки, Все новые функции сливаются сюда
• feature/* — новые фичи, Создаются от: develop, Сливаются в: develop
• release/* — подготовка релизов
• hotfix/* — критические баги


# 1. Создаем release-ветку от develop
git checkout -b release/1.2.0 develop

# 2. Работаем над релизом (багфиксы, тестирование)
# ... изменения в release-ветке ...

# 3. Готовим релиз - сливаем в main
git checkout main
git merge --no-ff release/1.2.0

# 4. СТАВИМ ТЕГ НА main
git tag -a v1.2.0 -m "Release version 1.2.0"

# 5. Сливаем изменения обратно в develop
git checkout develop
git merge --no-ff release/1.2.0

# 6. Удаляем release-ветку
git branch -d release/1.2.0

# 7. Пушим тег и изменения
git push origin main develop --tags
''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Что такое Pull Request / Merge Request? Зачем они нужны?',
    a: '''
PR/MR — это предложение влить изменения из одной ветки в другую.

Преимущества:
• Code Review — проверка кода коллегами
• Обсуждение изменений
• Автоматическое тестирование (CI/CD)
• Документирование изменений
• Контроль качества перед попаданием в main

Процесс:
1. Создаешь feature ветку
2. Пушишь изменения
3. Открываешь PR
4. Code review + исправления
5. Merge после аппрува''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Какие если варинаты, если нужно изменить уже запушенный коммит?',
    a: '''
1. Amend последнего коммита + force push

# Изменить последний коммит
git commit --amend -m "Updated commit message"

# Отправить принудительно
git push --force-with-lease origin branch-name


2. Interactive rebase для истории коммитов

# Изменить последние N коммитов
git rebase -i HEAD~3

# В редакторе изменить 'pick' на:
# edit - остановиться для изменения коммита
# reword - изменить только сообщение
# squash - объединить с предыдущим коммитом


3. Revert (безопасный способ)

# Создать новый коммит, отменяющий изменения
git revert <commit-hash>
git push origin branch-name
''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Какие правила написания commit сообщений вы знаете?',
    a: '''

Примеры:
• feat(auth): add JWT token validation
• fix(api): handle null response in user service
• docs: update README with installation steps

Правила:
• Первая строка до 50 символов
• Тело коммита до 72 символов на строку
• Imperative mood: "add", не "added"
• Объяснять "что" и "зачем", не "как"''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Для чего нужен merge?',
    a: '''
используется для объединения одной ветки в другую:

git checkout main
git merge feature/login

Это означает: влить изменения из feature/login в main.
''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Что делает git pull?',
    a: '''
git pull — это сокращённая команда, которая сначала выполняет git fetch, затем git merge:

git pull = git fetch + git merge origin/<текущая-ветка>

git pull origin main

Скачает изменения с удалённого origin/main и объединит их с текущей локальной ветк

''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как создать новый локальный репозиторий?',
    a: 'git init <repository_name>',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как показать текущее состояние файлов: что изменено, что готово к коммиту?',
    a: 'git status',
  ),
  const QA(tags: [Tag.git], a: 'git add <file>', q: 'Как добавить файл в индекс?'),
  const QA(tags: [Tag.git], a: 'git add .', q: 'Как добавить все изменения в индекс?'),
  const QA(
    tags: [Tag.git],
    a: 'git commit -m "message"',
    q: 'Создать коммит с заданным сообщением',
  ),
  const QA(
    tags: [Tag.git],
    a: 'git diff',
    q: 'Показать различия между текущими изменениями и последним коммитом',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Показать историю коммитов',
    a: '''
git log

только 5 последних коммитов: git log -n 5

история по файлу: git log lib/models/user.dart
''',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Показать все удалённые репозитории, которые связаны с текущим локальным репозиторием',
    a: 'git remote -v\nв формате: origin  https://github.com/user/project.git',
  ),

  const QA(
    tags: [Tag.git],
    a: 'git pull origin <branch_name>',
    q: 'Загрузит и автоматически сливает изменения из удалённой ветки?',
  ),
  const QA(
    tags: [Tag.git],
    a: 'git push origin <branch_name>',
    q: 'Отправить локальные коммиты в удалённый репозиторий',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как показать список локальных веток или удаленных веток?',
    a: '''

# Локальные ветки
git branch

# Все ветки (локальные и удаленные)
git branch -a

''',
  ),
  const QA(tags: [Tag.git], a: 'git branch <name>', q: 'Создать новую локальную ветку'),
  const QA(
    tags: [Tag.git],
    a: 'git rebase <branch>',
    q: 'Перенести текущую ветку на другую, переписывая историю как будто разработка шла оттуда',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как удалить локальную ветку?',
    a: '''

Удалить локальную ветку (если вы с неё ушли):

git checkout main
git branch -d feature/login

Принудительное удаление (если есть несохраненные изменения):

git checkout main
git branch -D feature/login

Важные моменты:
- Нельзя удалить ветку, на которой вы сейчас находитесь
- Перед удалением переключитесь на другую ветку:

git checkout main
git branch -d название_ветки

Удаление нескольких веток:

# Удалить несколько веток одновременно
git branch -d feature-1 feature-2 bugfix-3

# Принудительно удалить несколько веток
git branch -D old-feature another-branch
''',
  ),

  const QA(
    tags: [Tag.git],
    a: '''
git restore lib/main.dart // начиная с Git 2.23, более предпочтительный способ:

или

git checkout -- lib/main.dart

''',
    q: 'Как отменить изменения в ФАЙЛЕ до последнего коммита',
  ),

  const QA(
    tags: [Tag.git],
    a: 'git stash apply',
    q: 'Применить изменения из stash, оставив в списке',
  ),
  const QA(
    tags: [Tag.git],
    a: 'git cherry-pick <commit>',
    q: 'Применить указанный коммит в текущую ветку',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Открыть интерактивный rebase для последних 3 коммитов',
    a: 'git rebase -i HEAD~3',
  ),

  const QA(tags: [Tag.git], a: 'git clean -fd', q: 'Удалить неотслеживаемые файлы и папки'),
  const QA(tags: [Tag.git], a: 'git tag', q: 'Показать список всех тегов'),
  const QA(
    tags: [Tag.git],
    a: 'git tag -a v1.0 -m "release"',
    q: 'Создать аннотированный тег с сообщением',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Откатить коммиты и staging, но оставляет рабочие файлы',
    a: 'git reset --mixed <commit>',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как убрать файл из индекса (staging area), отменить git add, но не удалять сам файл',
    a: 'git restore --staged lib/main.dart',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Как отменить коммит, но сохранить изменения в staging',
    a: 'git reset --soft HEAD~1',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Чем отличается reset от revert',
    a: 'reset переписывает историю, revert сохраняет историю и отменяет изменения через новый коммит',
  ),

  const QA(tags: [Tag.git], q: 'Что такое origin', a: 'Имя удалённого репозитория по умолчанию'),
  const QA(
    tags: [Tag.git],
    q: 'Что такое upstream',
    a: 'Удалённая ветка, к которой привязана текущая локальная ветка для push/pull',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как объ    tags: [Tag.git],единить несколько коммитов в один?',
    a: 'git rebase -i HEAD~N, где N - количество последних коммитов',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Что такое tag',
    a: 'это метка, которая указывает на конкретный коммит и, как правило, используется для обозначения релизов (например, v1.0.0, v2.1.3)',
  ),

  const QA(
    tags: [Tag.git],
    a: '''
git restore --staged <filename> или git restore --staged . //  в новых версиях Git:

git reset HEAD <filename> или git reset HEAD



''',
    q: 'Как убрать файлы из staging area?',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Разница reset и revert',
    a: '''
# git reset - изменяет историю
A -> B -> C -> D (HEAD)
git reset --hard B
A -> B (HEAD) # коммиты C,D удалены

# git revert - сохраняет историю
A -> B -> C -> D (HEAD)
git revert C
A -> B -> C -> D -> E (HEAD) # E отменяет изменения из C
''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как создать ветку и переключиться на нее',
    a: '''
git checkout -b <branch-name>

git checkout -b feature/my-awesome-feature

''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как создать новую фичу от ветки develop, внести изменения и подготовить Pull Request',
    a: '''
✅ 1. Переключиться на ветку develop и обновить её
git checkout develop
git pull origin develop // или git pull origin feature/login


✅ 2. Создать новую ветку для фичи
git checkout -b feature/my-awesome-feature

✅ 3. Сделать нужные изменения в коде

✅ 4. Проиндексировать файлы
git add .
(или конкретные файлы: git add lib/file.dart)

✅ 5. Сделать коммит
git commit -m "feat: add awesome feature"

✅ 6. Отправить фичу на сервер (origin)
git push -u origin feature/my-awesome-feature

✅ 7. Создать Pull Request (PR)
''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Как в git отменить коммит если он уже запушен?',
    a: '''
git revert <commit_hash>

или

git reset --hard HEAD~1
''',
  ),
  const QA(
    tags: [Tag.git],
    q: 'Первая отправка новой ветки:',
    a: '''

git push -u origin new-feature
''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Создать временную ветку',
    a: '''

git checkout -b temp-branch
git add .
git commit -m "Временные изменения"
git checkout main  # вернуться к основной ветке

''',
  ),

  const QA(
    tags: [Tag.git],
    q: 'Создать временный коммит',
    a: '''

git add .
git commit -m "Временный коммит"
# позже можно отменить через:
git reset HEAD~1

''',
  ),
];
