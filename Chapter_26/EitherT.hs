{-# LANGUAGE InstanceSigs #-}

import Control.Monad.Trans.Class
import Control.Monad.IO.Class
import Control.Monad (liftM)

newtype EitherT e m a = EitherT { runEitherT :: m (Either e a) }

instance Functor m => Functor (EitherT e m) where
    fmap f (EitherT ma) = EitherT $ (fmap . fmap) f ma

instance Applicative m => Applicative (EitherT e m) where
    pure x = EitherT $ (pure (pure x))
    (EitherT mab) <*> (EitherT ma) = EitherT $ (<*>) <$> mab <*> ma

instance Monad m => Monad (EitherT e m) where
    return = pure
    (>>=) :: EitherT e m a -> (a -> EitherT e m b) -> EitherT e m b
    (EitherT ma) >>= f =
        EitherT $ do
            v <- ma
            case v of
                Left x -> return (Left x)
                Right x -> runEitherT (f x)

swapEither :: Either e a -> Either a e
swapEither (Left x) = Right x
swapEither (Right x) = Left x

swapEitherT :: (Functor m) => EitherT e m a -> EitherT a m e
swapEitherT (EitherT ma) = EitherT $ fmap swapEither ma

eitherT :: Monad m => (a -> m c) -> (b -> m c) -> EitherT a m b -> m c
eitherT famc fbmc (EitherT mab) = do
    v <- mab
    case v of
        Left x -> famc x
        Right x -> fbmc x

instance MonadTrans (EitherT e) where
    lift = EitherT . (liftM Right)

instance (MonadIO m) => MonadIO (EitherT e m) where
    liftIO = lift . liftIO