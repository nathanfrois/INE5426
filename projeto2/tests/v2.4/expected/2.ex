int fun: fatorial (params: int p)
  int var: r = 1
  if: > p 1
  then:
    = r * p + fatorial[1 params] - p 1 0
  ret r
$ R: 5040
$ R: 720
$ R: 120

