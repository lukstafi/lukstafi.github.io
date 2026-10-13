{-# LANGUAGE GADTs, DataKinds, KindSignatures, TypeFamilies #-}
module GadtExamples where

data Nat = Z | S Nat

data Vec (n :: Nat) a where
  VNil  :: Vec 'Z a
  VCons :: a -> Vec n a -> Vec ('S n) a

headVec :: Vec ('S n) a -> a
headVec (VCons x _) = x


data SNat (n :: Nat) where
  SZ :: SNat 'Z
  SS :: SNat n -> SNat ('S n)

replicateVec :: SNat n -> a -> Vec n a
replicateVec SZ     _ = VNil
replicateVec (SS n) x = VCons x (replicateVec n x)

data SomeVec a where
  SomeVec :: SNat n -> Vec n a -> SomeVec a


type family Add (n :: Nat) (m :: Nat) :: Nat where
  Add 'Z     m = m
  Add ('S n) m = 'S (Add n m)

append :: Vec n a -> Vec m a -> Vec (Add n m) a
append VNil ys = ys
append (VCons x xs) ys = VCons x (append xs ys)
