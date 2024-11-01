# Lab3

## Титульный лист

- Студент: `Соколов Анатолий Владимирович`
- Группа: `P3312`
- ИСУ: `368823`

---

## Требования к разработанному ПО

Программа представляет собой инструмент для интерполяции данных с следующими ключевыми требованиями:

1. **Алгоритмы интерполяции:**

   - Обязательная реализация линейной интерполяции
   - Дополнительная реализация интерполяции методом Лагранжа

2. **Конфигурация через командную строку:**

   - Выбор используемых алгоритмов
   - Настройка частоты дискретизации

   ```elixir
       8:21:apps/lab3/lib/lab3.ex
       {opts, _, _} =
       OptionParser.parse(args,
           switches: [
           algorithms: :string,
           frequency: :integer
           ],
           aliases: [
           a: :algorithms,
           f: :frequency
           ]
       )

       algorithms = parse_algorithms(opts[:algorithms] || "linear")
       frequency = opts[:frequency] || 1
   ```

3. **Формат данных:**

   - Входные данные в текстовом формате (CSV-подобный)
   - Поддержка различных разделителей (пробелы, табуляции, запятые, точки с запятой)

   ```elixir
   # 28:42:apps/lab3/lib/lab3/input_processor.ex
   defp parse_line(line) do
       # Теперь поддерживает запятые, точки с запятыми, табуляции и пробелы
       case String.trim(line) |> String.split(~r/[,\;\t\s]+/) do
       [x_str, y_str] ->
           with {x, ""} <- Float.parse(x_str),
               {y, ""} <- Float.parse(y_str) do
           {:ok, {x, y}}
           else
           _ -> {:error, "Invalid number format"}
           end

       _ ->
           {:error, "Invalid format"}
       end
   end
   ```

4. **Режим работы:**
   - Потоковая обработка данных
   - Асинхронная работа через процессы Elixir
   - Вывод результатов по мере поступления данных

## Ключевые элементы реализации

1. **Архитектура приложения:**

   - Модульная структура с разделением ответственности
   - Использование процессов для параллельной обработки
   - Асинхронное взаимодействие через сообщения

2. **Основные модули:**

   - `Lab3`: точка входа и управление конфигурацией
   - `InputProcessor`: обработка входных данных
   - `OutputProcessor`: форматирование и вывод результатов
   - `LinearInterpolation`: реализация линейной интерполяции
   - `LagrangeInterpolation`: реализация интерполяции методом Лагранжа

3. **Алгоритмы интерполяции:**
   - **Линейная интерполяция:**

```elixir
  # 35:44:apps/lab3/lib/lab3/algorithms/linear_interpolation.ex
  defp linear_interpolate({x1, y1}, {x2, y2}, freq) do
    step = 1.0 / freq
    xs = generate_steps(x1, x2, step)
    ys = Enum.map(xs, fn x -> y1 + (y2 - y1) / (x2 - x1) * (x - x1) end)

    %{
      xs: Enum.map(xs, &Float.round(&1, 2)),
      ys: Enum.map(ys, &Float.round(&1, 2))
    }
  end
```

- **Интерполяция Лагранжа:**

```elixir
  # 53:65:apps/lab3/lib/lab3/algorithms/lagrange_interpolation.ex
  defp lagrange(points, x) do
    Enum.reduce(points, 0.0, fn {x_i, y_i}, acc ->
      term =
        points
        |> Enum.filter(fn {x_j, _y_j} -> x_j != x_i end)
        |> Enum.reduce(1.0, fn {x_j, _y_j}, prod ->
          prod * ((x - x_j) / (x_i - x_j))
        end)
        |> Kernel.*(y_i)
    num_steps = trunc(Float.ceil(stop / step))
      acc + term
    end)
  end
```

## Примеры использования

1. **Запуск с линейной интерполяцией:**

   ```bash
   ./lab3 -a linear -f 1
   ```

2. **Запуск с обоими алгоритмами:**

   ```bash
   ./lab3 -a "linear,lagrange" -f 2
   ```

3. **Пример входных данных:**

   ```text
   0 0.00
   1.571 1
   3.142 0
   4.712 -1
   12.568 0
   ```

4. **Пример вывода:**

   ```text
   Линейная:
   0.00    1.00    2.00
   0.00    0.64    1.27

   Лагранж:
   0.00    1.00    2.00    3.00    4.00
   0.00    0.97    0.84    0.12    -0.67
   ```

## Тесты и метрики

### Тесты

Реализованы модульные тесты для проверки корректности работы алгоритмов интерполяции:

1. **Линейная интерполяция:**

   ```elixir
   # 4:28:apps/lab3/test/lab3_test.exs
   describe "LinearInterpolation" do
       test "interpolates two points correctly" do
       parent = self()
       pid = spawn(Lab3.Algorithms.LinearInterpolation, :start, [parent, 1])
       pid = spawn(Lab3.Algorithms.LinearInterpolation, :start, [parent, 1])
       send(pid, {:point, {+0.0, +0.00}})
       send(pid, {:point, {1.571, +1.0}})
       # Завершаем процесс
       send(pid, :eof)
       send(pid, :eof)
       assert_receive {:output, "Линейная", [+0.00, +1.00, +2.00], [+0.00, +0.64, +1.27]}, 1000
       end
       end
       test "interpolates non-integer steps correctly" do
       parent = self()
       pid = spawn(Lab3.Algorithms.LinearInterpolation, :start, [parent, 1])
       pid = spawn(Lab3.Algorithms.LinearInterpolation, :start, [parent, 1])
       send(pid, {:point, {1.0, 2.0}})
       send(pid, {:point, {3.0, 4.0}})
       # Завершаем процесс
       send(pid, :eof)
       send(pid, :eof)
       assert_receive {:output, "Линейная", [1.00, 2.00, 3.00], [2.00, 3.00, 4.00]}, 1000
       end
       end
   ```

2. **Интерполяция Лагранжа:**

   ```elixir
   # 30:61:apps/lab3/test/lab3_test.exs
   describe "LagrangeInterpolation" do
       test "interpolates three points correctly" do
       parent = self()
       pid = spawn(Lab3.Algorithms.LagrangeInterpolation, :start, [parent, 1])
       pid = spawn(Lab3.Algorithms.LagrangeInterpolation, :start, [parent, 1])
       send(pid, {:point, {+0.0, +0.00}})
       send(pid, {:point, {+1.0, +1.0}})
       send(pid, {:point, {+2.0, +0.0}})
       # Завершаем процесс
       send(pid, :eof)
       send(pid, :eof)
       assert_receive {:output, "Лагранж", [+0.00, +1.00, +2.00], [+0.00, +1.00, +0.00]}, 1000
       end
       end
       test "interpolates five points correctly" do
       parent = self()
       pid = spawn(Lab3.Algorithms.LagrangeInterpolation, :start, [parent, 1])
       pid = spawn(Lab3.Algorithms.LagrangeInterpolation, :start, [parent, 1])
       send(pid, {:point, {0.0, 0.00}})
       send(pid, {:point, {1.0, 1.00}})
       send(pid, {:point, {2.0, 0.00}})
       send(pid, {:point, {3.0, -1.00}})
       send(pid, {:point, {4.0, 0.00}})
       # Завершаем процесс
       send(pid, :eof)
       send(pid, :eof)
       expected_xs = [0.00, 1.00, 2.00, 3.00, 4.00]
       expected_ys = [0.00, 1.00, 0.00, -1.00, 0.00]
       expected_ys = [0.00, 1.00, 0.00, -1.00, 0.00]
       assert_receive {:output, "Лагранж", ^expected_xs, ^expected_ys}, 1000
       end
       end
   ```

### Отчет инструмента тестирования

Тесты проверяют:

- Корректность интерполяции для двух точек (линейная)
- Правильность работы с нецелыми шагами
- Точность интерполяции Лагранжа для 3 и 5 точек
- Обработку граничных случаев

### Метрики

1. **Производительность:**

   - Асинхронная обработка данных
   - Эффективное использование процессов Elixir
   - Минимальная задержка вывода результатов

2. **Надежность:**
   - Обработка ошибок ввода
   - Валидация входных данных
   - Корректное завершение процессов

## Выводы

1. **Достижения:**

   - Реализована потоковая обработка данных
   - Поддержка множественных алгоритмов интерполяции
   - Гибкая конфигурация через командную строку
   - Надежная обработка ошибок

2. **Технические решения:**

   - Использование процессов Elixir для параллельной обработки
   - Модульная архитектура для легкого расширения
   - Эффективная реализация алгоритмов интерполяции

3. **Возможности улучшения:**
   - Добавление новых алгоритмов интерполяции
   - Расширение опций конфигурации
   - Улучшение форматирования вывода
   - Добавление визуализации результатов
