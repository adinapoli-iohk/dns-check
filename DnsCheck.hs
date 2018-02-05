#!/usr/bin/env stack
-- stack --resolver lts-9.1 --no-system-ghc --install-ghc runghc --package shelly --package text
{-# LANGUAGE OverloadedStrings #-}

import Shelly
import Data.Maybe
import Data.Monoid
import System.Environment (getArgs)
import qualified Data.Text as T

type GitHash = T.Text

data DnsLibVersion = VR_3_0_1
                   | VR_git !GitHash

renderLibVersion :: DnsLibVersion -> T.Text
renderLibVersion VR_3_0_1 = "3.0.1"
renderLibVersion (VR_git hash) = hash

cardanoCurrentRevision :: GitHash
cardanoCurrentRevision = "b106470f0a93672af22cbc7ed6564b53c0f249ed"

main :: IO ()
main = do
  args <- getArgs
  shelly $ verbosely $ do
    case args of
      ["3.0.1"] -> dnsCheck VR_3_0_1
      _ -> dnsCheck (VR_git cardanoCurrentRevision)

isStackInstalled :: IO Bool
isStackInstalled = shelly $ silently $ errExit False $ do
  p <- fromMaybe mempty <$> which "stack"
  ec <- lastExitCode
  pure (ec == 0 && (not $ T.null (toTextIgnore p)))

dnsCheck :: DnsLibVersion -> Sh ()
dnsCheck vr = do
  let libVersion = renderLibVersion vr
  echo $ ">> Testing DNS lookups against dns library: " <> libVersion
  stackInstalled <- liftIO isStackInstalled
  -- Install stack if not there.
  unless stackInstalled $ escaping False $
    run_ "curl" ["-sSL", "https://get.haskellstack.org/", "|", "sh"]

  -- Fetch the right project, build it and run the check.
  chdir (fromText $ "dns-check-" <> libVersion) $ do
    run_ "stack" ["build"]
