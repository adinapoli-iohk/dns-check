#!/usr/bin/env stack
-- stack --resolver lts-9.1 --no-system-ghc --install-ghc runghc --package shelly --package text
{-# LANGUAGE OverloadedStrings #-}

import Shelly
import System.Environment (getArgs)
import qualified Data.Text as T

type GitHash = T.Text

data DnsLibVersion = VR_3_0_1
                   | VR_git !GitHash

cardanoCurrentRevision :: GitHash
cardanoCurrentRevision = "b106470f0a93672af22cbc7ed6564b53c0f249ed"

main :: IO ()
main = do
  args <- getArgs
  shelly $ silently $ do
    case args of
      ["3.0.1"] -> dnsCheck VR_3_0_1
      _ -> dnsCheck (VR_git cardanoCurrentRevision)


dnsCheck :: DnsLibVersion -> Sh ()
dnsCheck _ = echo "Hello World!"
