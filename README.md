# template_flutter

A Flutter project.

## Utils commands:

- flutter pub get
- flutter run / build (--release) (-d Device Name)
- flutter clean
- flutter pub cache repair

## Tests:

- flutter test
    - `-r expanded`
- flutter test --plain-name "Test description use case"

## Generate .g files

- flutter pub run build_runner build --delete-conflicting-outputs

### Generate HTML Coverage Report

- flutter test --coverage
- lcov --remove coverage/lcov.info 'lib/repository/contract/*' 'lib/resource/*' -o coverage/new_lcov.info
- genhtml coverage/new_lcov.info -o coverage/html
    - On macOS: `brew install lcov`
- Look report on: `coverage/html/index.html`
