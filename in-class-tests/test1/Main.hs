{- 
   CI505 Introduction to Functional Propgramming
   In-Class Test 1 
-}
module Main where

import Prelude hiding (takeWhile)
import Test.QuickCheck

{- 1. Complete the following function where takeWhile p xs returns
elements of xs as a list until it reaches an element of xs
for which p is false. For example, takeWhile (\x -> x < 3) [1, 2, 3, 4]
returns [1, 2]. -}

takeWhile :: (a -> Bool) -> [a] -> [a] 
takeWhile p [] = []
takeWhile p (x:xs) = if p x then x : takeWhile p xs else []

{- 2. Find the penultimate (second to last) element in list l. Behaviour is 
  undefined if the list has fewer than 2 elements. -}

penultimate :: [a] -> a
penultimate l = last $ init l

{- 3. Find the element at index k in list l. For example, findK 2 [0,0,1,0,0,0]
returns 1. -}

findK :: Int -> [a] -> a
findK k l = if k == 0 then head l else findK (k-1) $ tail l

{- 4. Determine if a list, l, is a palindrome. -}

palindrome :: Eq a => [a] -> Bool
palindrome l = l == (reverse l)

{- 5. Duplicate the elements in list xs. For example duplicate [1,2,3] should
  give the list [1,1,2,2,3,3]. Hint: The concat [l] function flattens a list
  of lists into a single list. For example: concat [[1,2,3],[3,4,5]] returns
  [1,2,3,3,4,5]. -}

duplicate :: [a] -> [a]
duplicate l = concatMap (\x -> x:x:[]) l

{- 6. Split a list, l, at element k into a tuple containing the first part of
  l up to and including k, followed by the part of l which comes after
  k. For example splitAtIndex 3 [1,1,1,2,2,2] returns
  ([1,1,1,2],[2,2]). -}

splitAtIndex :: Int -> [a] -> ([a], [a])
splitAtIndex k l = (take (k+1) l, drop (k+1) l)

{- 7. Drop the element at index k in list l. For example dropK 3 [1, 2, 3, 4, 5]
    returns [1, 2, 3, 5]. -}

dropK :: Int -> [a] -> [a]
dropK _ []     = []
dropK 0 (x:xs) = xs
dropK k (x:xs) = x : dropK (k-1) xs

{- 8. Extract elements between ith and kth element in list l,  including i but not k. 
   For example, slice 3 6 [0,0,0,1,2,3,0,0,0]  returns [1,2,3]. -}

slice :: Int -> Int -> [a] -> [a]
slice i k []     = []
slice i k (x:xs) = if i > 0 then slice (i-1) (k-1) xs
                   else if k < 1 then []
                        else x : slice i (k-1) xs

{- 9. Insert element x in list l at index k. For example,
insertElem 2 5 [0,0,0,0,0,0] returns [0,0,0,0,0,2,0]. If index k
 does not exist in l, insert x at the tail of l. -}

insertElem :: a -> Int -> [a] -> [a]
insertElem x k [] = [x]
insertElem x k l  = if k == 0 then x:l 
                    else (head l) : (insertElem x (k-1) (tail l))

{- 10. Rotate list l n places left, where n is less than the length of the list. 
   For example, rotate 2 [1,2,3,4,5] gives [3,4,5,1,2]. -}

rotate :: Int -> [a] -> [a]
rotate n l = xs ++ ys where (ys, xs) = splitAt n l

{- TESTS

Run these from the interpreter by invoking quickCheck, e.g.
> quickCheck prop_myTakeWhile
 Or run them all by compiling and executing the module, e.g.
> ghc --make -o ass1a Main.hs
> ./ass1a

-}

prop_myTakeWhile xs = not (null xs) ==> (<3) (head xs) ==> 
                      length xs >= length (myTakeWhile (<3) xs)
                          where types = xs::[Int]
prop_myTakeWhileNot xs = not (null xs) ==> not ((<3) (head xs)) ==> 
                         null (myTakeWhile (<3) xs)
                             where types = xs::[Int]

prop_penultimate :: [Int] -> Property
prop_penultimate xs = length xs > 1 ==> penultimate xs `elem` xs

prop_penultimate2 :: [Int] -> Property
prop_penultimate2 xs = length xs > 1 ==> penultimate xs == xs !! ((length xs)-2)

prop_findK :: Int -> [Int] -> Property
prop_findK k xs = k >= 0 && k < length xs ==> 
                  (findK k xs) `elem` xs

prop_isPalindrome :: [Char] -> Bool
prop_isPalindrome xs = and [isPalindrome [1]
                           , isPalindrome [123454321] ]

prop_duplicate :: [Int] -> Bool
prop_duplicate xs = length (duplicate xs) == (length xs) * 2

prop_splitAtIndex :: Int -> [Int] -> Property
prop_splitAtIndex k xs = k >= 0 ==> ys ++ zs == xs
    where (ys, zs) = splitAtIndex k xs

prop_splitAtIndex2 :: Int -> [Int] -> Property
prop_splitAtIndex2 k xs = k >= 0 && k < length xs ==> length ys == k+1
    where (ys, _) = splitAtIndex k xs

prop_splitAtIndex3 :: Int -> [Int] -> Bool
prop_splitAtIndex3 k xs = length ys + length zs == length xs
    where (ys, zs) = splitAtIndex k xs

prop_dropK :: [Int] -> Property
prop_dropK xs = not (null xs) ==> dropK 0 xs == tail xs

prop_dropK2 :: Int -> [Int] -> Property
prop_dropK2 k xs = not (null xs) && k > 0 && k < length xs ==>
  length (dropK k xs) == (length xs) -1

prop_slice :: Int -> Int -> [Int] -> Property
prop_slice i k l = i >= 0 && k >= 0 && i < k ==>
                   slice i k l == take (k-i) (drop i l)

prop_insertElem :: Int -> Int -> [Int] -> Bool
prop_insertElem x i xs = length (insertElem x i xs) == length xs + 1

prop_insertElem2 x i xs = x `elem` (insertElem x i xs) 
prop_insertElem3 x i xs = i >= 0 && i < length xs ==> (insertElem x i xs)!!i' == x
    where i' = if i == 0 then i else i-1

prop_rotate :: Int -> [Int] -> Bool
prop_rotate i xs = (rotate 0 xs) == xs

prop_rotate2 :: Int -> [Int] -> Bool
prop_rotate2 i xs = rotate (length xs) xs == xs

main = do quickCheck prop_myTakeWhile
          quickCheck prop_myTakeWhileNot
          quickCheck prop_penultimate
          quickCheck prop_penultimate2
          quickCheck prop_findK
          quickCheck prop_isPalindrome
          quickCheck prop_duplicate
          quickCheck prop_splitAtIndex
          quickCheck prop_splitAtIndex2
          quickCheck prop_splitAtIndex3
          quickCheck prop_dropK
          quickCheck prop_dropK2
          quickCheck prop_slice
          quickCheck prop_insertElem
          quickCheck prop_rotate
          quickCheck prop_rotate2
