int var: i, j = 0
for: = i 0, < i 10, = i + i 1
do:
  = j + j i
$ R: j = 55
bool var: a, b
= a true
= b ! a
int var: c = 0
do:
  = c + c 1
  if: > c 10
  then:
    = a false
while: | a b
$ R: c = 11
int var: p = 100
while: & > p 0 < p 100000
do:
  = p - p 1
$ R: p = 0

