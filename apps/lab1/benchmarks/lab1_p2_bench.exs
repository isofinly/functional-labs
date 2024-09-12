alias Lab1

Benchee.run(%{
  "Tail recursion" => fn -> Lab1.sum_even_fibs_tail_rec() end,
  "Recursion" => fn -> Lab1.sum_even_fibs_rec() end,
  "Modular" => fn -> Lab1.sum_even_fibs_modular() end,
  "Map" => fn -> Lab1.sum_even_fibs_map_generation() end,
  "Comprehension" => fn -> Lab1.sum_even_fibs_comprehension() end,
  "Stream" => fn -> Lab1.sum_even_fibs_stream() end,
  "Traditional" => fn -> Lab1.sum_even_fibs_traditional() end
}, time: 10, memory_time: 2)
