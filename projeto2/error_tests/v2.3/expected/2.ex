int array: a (size: 5)
int var: i = 0
for: = i 0, < i 10, = i + i 1
do:
  switch: i
case: & & true true false
then:
  = [null] a i i
case: ! false
then:
  = [null] a i i
case: 3.3
then:
  = [null] a i i
case: ! true
then:
  = [null] a i i
default: 
then:
  if: < i 5
  then:
    = [index] a i * i 10
  end switch 
$ R: a(0) = 0
$ R: a(1) = 10
$ R: a(2) = 20
$ R: a(3) = 30
$ R: a(4) = 40

