module TryExcept where

import Control.Exception

willIFail :: Integer -> IO (Either ArithException ())
willIFail denom = try $ print $ div 5 denom

willIFail' :: Integer -> IO ()
willIFail' denom = print (div 5 denom) `catch` handler
    where handler :: ArithException -> IO ()
          handler e = print e
