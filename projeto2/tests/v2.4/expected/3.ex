int fun: somatorio (params: int p)
  int var: r = 1
  if: > p 1
  then:
    = r + soma[1 params] - p 1 p
  ret r
int fun: soma (params: int c)
  int var: r = 1
  if: > c 1
  then:
    = r + c somatorio[1 params] - c 1
  ret r
$ R: 10

