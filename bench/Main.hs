{-# LANGUAGE OverloadedStrings #-}

module Main where

import Criterion.Main
import Data.Word
import HaskellWorks.Data.BalancedParens.FindClose
import HaskellWorks.Data.Bits.Broadword
import HaskellWorks.Data.Bits.FromBitTextByteString
import HaskellWorks.Data.Naive

import qualified Data.Vector.Storable                          as DVS
import qualified HaskellWorks.Data.BalancedParens.RangeMinMax  as RMM
import qualified HaskellWorks.Data.BalancedParens.RangeMinMax2 as RMM2

setupEnvVector :: Int -> IO (DVS.Vector Word64)
setupEnvVector n = return $ DVS.fromList (take n (cycle [maxBound, 0]))

setupEnvRmmVector :: Int -> IO (RMM.RangeMinMax (DVS.Vector Word64))
setupEnvRmmVector n = return $ RMM.mkRangeMinMax $ DVS.fromList (take n (cycle [maxBound, 0]))

setupEnvRmm2Vector :: Int -> IO (RMM2.RangeMinMax2 (DVS.Vector Word64))
setupEnvRmm2Vector n = return $ RMM2.mkRangeMinMax2 $ DVS.fromList (take n (cycle [maxBound, 0]))

setupEnvBP2 :: IO Word64
setupEnvBP2 = return $ DVS.head (fromBitTextByteString "10")

setupEnvBP4 :: IO Word64
setupEnvBP4 = return $ DVS.head (fromBitTextByteString "1100")

setupEnvBP8 :: IO Word64
setupEnvBP8 = return $ DVS.head (fromBitTextByteString "11101000")

setupEnvBP16 :: IO Word64
setupEnvBP16 = return $ DVS.head (fromBitTextByteString "11111000 11100000")

setupEnvBP32 :: IO Word64
setupEnvBP32 = return $ DVS.head (fromBitTextByteString "11111000 11101000 11101000 11100000")

setupEnvBP64 :: IO Word64
setupEnvBP64 = return $ DVS.head (fromBitTextByteString "11111000 11101000 11101000 11101000 11101000 11101000 11101000 11100000")

benchRankSelect :: [Benchmark]
benchRankSelect =
  [ env setupEnvBP2 $ \w -> bgroup "FindClose 2-bit"
    [ bench "Broadword"     (whnf (findClose (Broadword w)) 1)
    , bench "Naive"         (whnf (findClose (Naive     w)) 1)
    ]
  , env setupEnvBP4 $ \w -> bgroup "FindClose 4-bit"
    [ bench "Broadword"     (whnf (findClose (Broadword w)) 1)
    , bench "Naive"         (whnf (findClose (Naive     w)) 1)
    ]
  , env setupEnvBP8 $ \w -> bgroup "FindClose 8-bit"
    [ bench "Broadword"     (whnf (findClose (Broadword w)) 1)
    , bench "Naive"         (whnf (findClose (Naive     w)) 1)
    ]
  , env setupEnvBP16 $ \w -> bgroup "FindClose 16-bit"
    [ bench "Broadword"     (whnf (findClose (Broadword w)) 1)
    , bench "Naive"         (whnf (findClose (Naive     w)) 1)
    ]
  , env setupEnvBP32 $ \w -> bgroup "FindClose 32-bit"
    [ bench "Broadword"     (whnf (findClose (Broadword w)) 1)
    , bench "Naive"         (whnf (findClose (Naive     w)) 1)
    ]
  , env setupEnvBP64 $ \w -> bgroup "FindClose 64-bit"
    [ bench "Broadword"     (whnf (findClose (Broadword w)) 1)
    , bench "Naive"         (whnf (findClose (Naive     w)) 1)
    ]
  , env (setupEnvVector 1000000) $ \bv -> bgroup "Vanilla"
    [ bench "findClose"   (nf   (map (findClose bv)) [0, 1000..10000000])
    ]
  , env (setupEnvRmmVector 1000000) $ \bv -> bgroup "RangeMinMax"
    [ bench "findClose"   (nf   (map (findClose bv)) [0, 1000..10000000])
    ]
  , env (setupEnvRmm2Vector 1000000) $ \bv -> bgroup "RangeMinMax2"
    [ bench "findClose"   (nf   (map (findClose bv)) [0, 1000..10000000])
    ]
  ]

main :: IO ()
main = defaultMain benchRankSelect
