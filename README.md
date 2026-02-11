# Loan Calculator

Пакет для расчета кредитных условий в мобильном приложении. Предоставляет
полнофункциональный калькулятор кредитов с возможностью расчета ежемесячного платежа, валидации
условий и интерактивного пользовательского интерфейса.

## Описание

Loan Calculator - это Flutter пакет, который включает в себя:

- **Интерактивный калькулятор кредитов** с возможностью ввода суммы кредита и срока
- **Расчет ежемесячного платежа** в реальном времени
- **Валидация кредитных условий** с проверкой лимитов и доходов
- **Слайдер для выбора срока кредита** с удобным интерфейсом
- **Поддержка различных валют** через интеграцию с ramework
- **Архитектура на основе BLoC** для управления состоянием
- **Локализация** для поддержки нескольких языков

## Возможности

### Основные функции

- ✅ Расчет ежемесячного платежа по кредиту
- ✅ Валидация минимальных и максимальных лимитов
- ✅ Проверка ежемесячного дохода заемщика
- ✅ Интерактивный выбор срока кредита (слайдер)
- ✅ Отображение общей суммы к выплате
- ✅ Обработка ошибок с возможностью повторной загрузки
- ✅ Shimmer эффекты для улучшения UX
- ✅ Поддержка документов и условий кредитования

### Архитектурные особенности

- **Clean Architecture** с разделением на data, domain и presentation слои
- **BLoC Pattern** для управления состоянием
- **Repository Pattern** для работы с данными
- **Dependency Injection** через framework
- **Freezed** для создания immutable классов
- **Reactive Programming** с использованием RxDart

## Структура проекта

```
lib/
├── src/
│   ├── data/
│   │   ├── data_source/          # Источники данных
│   │   └── repository/           # Репозитории
│   ├── domain/
│   │   ├── bloc/                 # BLoC логика
│   │   └── object/               # Доменные объекты
│   ├── localization/             # Локализация
│   └── ui/                       # UI компоненты
│       ├── loan_calculator_widget.dart
│       ├── monthly_income_widget.dart
│       └── months_slider.dart
└── oan_calculator.dart    # Основной экспорт
```

## Использование

### Базовое использование

```dart
import 'package:oan_calculator/loan_calculator.dart';

// Использование виджета калькулятора
class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoanCalculatorWidget(
        isReviewServer: false,
        onFailurePressed: () {
          // Обработка ошибок
        },
      ),
    );
  }
}
```

## Доменные объекты

### LoanCalculatorData

```dart
class LoanCalculatorData {
  final CurrencyAmount amount; // Сумма кредита
  final LoanDuration duration; // Срок кредита
  final String? productId; // ID продукта
  final String? applicationId; // ID заявки
  final CurrencyAmount? income; // Доход заемщика
}
```

### MonthlyPayment

```dart
class MonthlyPayment {
  final CurrencyAmount monthlyAmount; // Ежемесячный платеж
  final CurrencyAmount? totalAmount; // Общая сумма к выплате
}
```

### LoanCalculatorState

Основные поля состояния:

- `currentAmount` - текущая сумма кредита
- `currentDuration` - текущий срок кредита
- `monthlyAmount` - рассчитанный ежемесячный платеж
- `minLimit/maxLimit` - лимиты по сумме кредита
- `minIncome/maxIncome` - лимиты по доходу
- `isLoading` - состояние загрузки
- `canProceed` - возможность продолжить

## Локализация

Пакет поддерживает локализацию через `LoanCalculatorLocalizationContract`:

```dart
abstract class LoanCalculatorLocalizationContract {
  String loanAmount(BuildContext context);

  String monthlyPayment(BuildContext context);

  String proceed(BuildContext context);

  String month(BuildContext context, int month);
// ... другие методы локализации
}
```

## Зависимости

### Основные зависимости

- `flutter`: SDK Flutter
- `bloc`: ^9.0.0 - Управление состоянием
- `flutter_bloc`: ^9.1.0 - Flutter интеграция для BLoC
- `decimal`: ^3.2.1 - Точные вычисления с десятичными числами
- `freezed_annotation`: ^3.0.0 - Создание immutable классов
- `rxdart`: ^0.28.0 - Reactive programming
- `jiffy`: ^6.3.2 - Работа с датами

### Внутренние зависимости

- `framework` - Основной фреймворк
- `base` - Базовые компоненты
- `ui_kit` - UI компоненты
- `flutter_framework` - Flutter утилиты

## Требования к среде

- **Dart SDK**: 3.8.1
- **Flutter SDK**: 3.32.4
- **Минимальная версия Android**: API 21+
- **Минимальная версия iOS**: 12.0+

## Разработка

### Генерация кода

Для генерации Freezed классов:

```bash
flutter packages pub run build_runner build
```

### Структура файлов

- `*.build.dart` - файлы с Freezed классами
- `*.build.freezed.dart` - сгенерированные файлы (не редактировать)
- `contract.dart` - интерфейсы и контракты

### Линтинг

Проект использует `lintorium` для проверки качества кода:

```bash
flutter analyze
```

## Архитектура

### Слои архитектуры

1. **UI Layer** (`src/ui/`)
    - Виджеты и компоненты пользовательского интерфейса
    - Обработка пользовательского ввода
    - Отображение состояния

2. **Domain Layer** (`src/domain/`)
    - Бизнес-логика приложения
    - BLoC для управления состоянием
    - Доменные объекты

3. **Data Layer** (`src/data/`)
    - Репозитории для работы с данными
    - Источники данных (локальные и удаленные)
    - Контракты для внешних API

### Принципы

- **Single Responsibility** - каждый класс имеет одну ответственность
- **Dependency Inversion** - зависимости передаются через интерфейсы
- **Immutability** - использование неизменяемых объектов
- **Reactive Programming** - реактивное программирование через BLoC
