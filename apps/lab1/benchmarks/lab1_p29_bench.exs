alias Lab1

Benchee.run(%{
  "Tail recursion" => fn -> Lab1.distinct_powers_tail_rec(100) end,
  "Recursion" => fn -> Lab1.distinct_powers_rec(100) end,
  "Modular" => fn -> Lab1.distinct_powers_modular(100) end,
  "Comprehension" => fn -> Lab1.distinct_powers_comprehension(100) end,
  "Stream" => fn -> Lab1.distinct_powers_stream(100) end,
  "Traditional" => fn -> Lab1.distinct_powers_traditional(100) end
}, time: 10, memory_time: 2)
