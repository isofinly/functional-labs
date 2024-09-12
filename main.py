def fib(N):
    i, j = 0, 1
    while j < N:
        yield(j)
        i, j = j, i+j

print(sum(i for i in fib(4e6) if i%2==0))
