module Week1 where

import Prelude hiding (elem, take, length, drop)

test :: String 
test = "Hello World"

square :: Int -> Int -> Int
square x y = (x * x) + (y * y)


elem :: Eq a => a -> [a] -> Bool
elem x [] = False 
elem x (y:ys) = if x == y then True else elem x ys 

length :: [a] -> Int 
length [] = 0
length (x:xs) = 1 + length xs

drop :: Int -> [a] -> [a] 
drop 0 xs = 













