#!/usr/bin/env run-script
module Application.Script.Scrape where

import Application.Script.Prelude
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import GHC.Generics (Generic)
import Network.HTTP.Simple


data ArchiveItem = ArchiveItem
    {   identifier :: Text,
        date :: Maybe Text,
        collection :: Maybe Text,
        transferer :: Maybe Text,
        downloads :: Maybe Int, 
        source :: Maybe Text,
        avgRating :: Maybe Float,
        numReviews :: Maybe Int,
        lineage :: Maybe Text,
        coverage :: Maybe Text,
        venue :: Maybe Text
    }
    deriving (Show, Generic,  Eq)

instance FromJSON ArchiveItem where 
    parseJSON = withObject "ArchiveItem" $ \obj ->
        ArchiveItem
            <$> obj .: "identifier"
            <*> obj .:? "date"
            <*> obj .:? "collection"
            <*> obj .:? "transferer"
            <*> obj .:? "downloads"
            <*> obj .:? "source"
            <*> obj .:? "avg_rating"
            <*> obj .:? "num_reviews"
            <*> obj .:? "lineage"
            <*> obj .:? "coverage"
            <*> obj .:? "venue"

data ScrapeResponse = ScrapeResponse 
    {   scrapeItems :: [ArchiveItem],
        scrapeCursor :: Maybe Text
    }
    deriving (Generic)

instance FromJSON ScrapeResponse where 
    parseJSON = withObject "ScrapeResponse" $ \obj ->
        ScrapeResponse
            <$> obj .: "items"
            <*> obj .:? "cursor"

scrape :: Text -> IO [ArchiveItem]
scrape t = scrape' t Nothing

scrape' :: Text -> Maybe Text -> IO [ArchiveItem]
scrape' collection cursor =
  let baseUrl = "https://archive.org/services/search/v1/scrape?fields=avg_rating,venue,coverage,num_reviews,date,downloads,source,transferer,lineage,identifier&q=collection:" <> collection
      url = case cursor of
        Just c -> baseUrl <> "&cursor=" <> c
        Nothing -> baseUrl
   in do
        request <- parseRequest (cs url)
        putStrLn url
        response <- httpJSON request
        let ScrapeResponse {..} = getResponseBody response
        case scrapeCursor of
          Just cursor -> do
            rest <- scrape' collection (Just cursor)
            return $ scrapeItems ++ rest
          Nothing -> return scrapeItems

run :: Script
run = do
    scrape "etree"
    pure ()