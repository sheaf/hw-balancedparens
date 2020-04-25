{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module HaskellWorks.Data.BalancedParens.Broadword.Word32Spec where

import HaskellWorks.Data.Bits.BitShow
import HaskellWorks.Hspec.Hedgehog
import Hedgehog
import Test.Hspec

import qualified HaskellWorks.Data.BalancedParens.Broadword.Word32     as BW32
import qualified HaskellWorks.Data.BalancedParens.Internal.Slow.Word32 as SW32
import qualified Hedgehog.Gen                                          as G
import qualified Hedgehog.Range                                        as R

{-# ANN module ("HLint: ignore Redundant do"        :: String) #-}
{-# ANN module ("HLint: ignore Reduce duplication"  :: String) #-}

spec :: Spec
spec = describe "HaskellWorks.Data.BalancedParens.Broadword.Word32Spec" $ do
  it "findUnmatchedCloseFar" $ requireTest $ do
    p <- forAll $ pure 0
    w <- forAll $ pure 0xe9f6e7ff
    annotateShow $ bitShow w
    BW32.findUnmatchedCloseFar p w === SW32.findUnmatchedCloseFar p w
  it "findUnmatchedCloseFar" $ require $ withTests 10000 $ property $ do
    p <- forAll $ G.word32 (R.linear 0 32)
    w <- forAll $ G.word32 R.constantBounded
    annotateShow $ bitShow w
    BW32.findUnmatchedCloseFar p w === SW32.findUnmatchedCloseFar p w
