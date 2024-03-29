class Bifunctor p where
    {-# MINIMAL bimap | first, second #-}

    bimap :: (a -> b) -> (c -> d) -> p a c -> p b d
    bimap f g = first f . second g

    first :: (a -> b) -> p a c -> p b c
    first f = bimap f id

    second :: (b -> c) -> p a b -> p a c
    second f = bimap id f

data Deux a b = Deux a b

instance Bifunctor Deux where
    bimap f g (Deux x y) = Deux (f x) (g y)

data Const a b = Const a

instance Bifunctor Const where
    bimap f _ (Const x) = Const (f x)

data Drei a b c = Drei a b c

instance Bifunctor (Drei a) where
    bimap f g (Drei w x y) = Drei w (f x) (g y)

data SuperDrei a b c = SuperDrei a b

instance Bifunctor (SuperDrei a) where
    bimap f _ (SuperDrei w x) = SuperDrei w (f x)

data SemiDrei a b c = SemiDrei a

instance Bifunctor (SemiDrei a) where
    bimap _ _ (SemiDrei w) = SemiDrei w

data Quadriceps a b c d = Quadzzz a b c d

instance Bifunctor (Quadriceps a b) where
    bimap f g (Quadzzz v w x y) = Quadzzz v w (f x) (g y)

data Either' a b = Left' a | Right' b

instance Bifunctor Either' where
    bimap f _ (Left' x) = Left' (f x)
    bimap _ g (Right' y) = Right' (g y)