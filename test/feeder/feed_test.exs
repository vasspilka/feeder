defmodule Feeder.FeedTest do
  use ExUnit.Case

  alias Feeder.Feed

  describe "get_feeds/2" do
    test "can create feeds from tweets and profiles" do
      tweets = [
        {"Vitalik",
         "Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."},
        {"Michael",
         "There are only two hard things in Computer Science: cache invalidation, naming things and off-by-1 errors."}
      ]

      profiles = [
        %Feeder.Profile{following: ["Vitalik"], user: "Michael"},
        %Feeder.Profile{following: [], user: "Vitalik"}
      ]

      assert Feed.get_feeds(tweets, profiles) == [
               {"Michael",
                [
                  {"Michael",
                   "There are only two hard things in Computer Science: cache invalidation, naming things and off-by-1 errors."},
                  {"Vitalik",
                   "Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."}
                ]},
               {"Vitalik",
                [
                  {"Vitalik",
                   "Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."}
                ]}
             ]
    end
  end

  describe "to_text/1" do
    test "can a single feed into a string" do
      assert Feed.to_text(
               {"Vitalik",
                [
                  {"Vitalik",
                   "Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."}
                ]}
             ) ==
               "Vitalik\n\t@Vitalik: Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."
    end

    test "can transform multyple feeds into a string" do
      feeds = [
        {"Michael",
         [
           {"Michael",
            "There are only two hard things in Computer Science: cache invalidation, naming things and off-by-1 errors."},
           {"Vitalik",
            "Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."}
         ]},
        {"Vitalik",
         [
           {"Vitalik",
            "Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."}
         ]}
      ]

      assert Feed.to_text(feeds) ==
               "Michael\n\t@Michael: There are only two hard things in Computer Science: cache invalidation, naming things and off-by-1 errors.\n\t@Vitalik: Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems.\n\nVitalik\n\t@Vitalik: Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."
    end
  end
end
