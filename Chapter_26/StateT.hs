{-# LANGUAGE InstanceSigs #-}

import Control.Monad.Trans.Class
import Control.Monad.IO.Class

newtype StateT s m a = StateT { runStateT :: s -> m (a,s) }

instance (Functor m) => Functor (StateT s m) where
    fmap f (StateT smas) = StateT $ \s -> (fmap (\(a, _) -> (f a, s)) (smas s))

instance (Monad m) => Applicative (StateT s m) where
    pure :: a -> StateT s m a
    pure a = StateT $ \s -> return (a, s)
    (<*>) :: StateT s m (a -> b) -> StateT s m a -> StateT s m b
    (StateT smabs) <*> (StateT smas) =
        StateT $ \s -> do
            (ab, s') <- smabs s
            (a, s'') <- smas s'
            return (ab a, s'')

instance (Monad m) => Monad (StateT s m) where
    return = pure
    (>>=) :: StateT s m a -> (a -> StateT s m b) -> StateT s m b
    (StateT sma) >>= f = StateT $ \s -> do
        (a, s') <- sma s
        runStateT (f a) s'

instance MonadTrans (StateT s) where
    --lift :: Monad m => m a -> StateT m a
    lift ma = StateT $ \s -> (,) <$> ma <*> (pure s)

instance (MonadIO m) => MonadIO (StateT s m) where
    liftIO = lift . liftIO