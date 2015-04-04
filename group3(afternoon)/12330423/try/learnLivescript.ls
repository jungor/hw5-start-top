a = [1 2 3 4]
b = [1 to 100]
c = <[1 2 3]>
y = {}
x = switch
  | otherwise             => \object
  | (typeof y) is \number => \number
  | (typeof y) is \string => \string
  | 'length' of y         => \array

console.log(x)
