defmodule FeederTest do
  use ExUnit.Case

  @sample_files [
    %Feeder.File{
      name: "user.txt",
      content: """
      Michael follows Vitalik, Kent
      Veronica follows Michael, Vitalik
      Kent follows Vitalik
      Vitalik follows Veronica
      """
    },
    %Feeder.File{
      name: "tweet.txt",
      content: """
      Vitalik> Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems.
      Michael> There are only two hard things in Computer Science: cache invalidation, naming things and off-by-1 errors.
      Kent> For it should never feel the high complexity of the future of preference
      Veronica> Worried about shifting your focus from now another sister will surely become to have bugs, only!
      Michael> If your linter tortures you, its complexity and we're building?
      """
    }
  ]

  describe "get_feeds_as_text/1" do
    test "giving no files will returns error" do
      assert Feeder.get_feeds_as_text([]) == {:error, :user_or_tweet_file_missing}
    end

    test "giving files with different names returns error" do
      assert Feeder.get_feeds_as_text([
               %Feeder.File{name: "other.txt", content: "some"},
               %Feeder.File{name: "some.txt", content: "other"}
             ]) == {:error, :user_or_tweet_file_missing}
    end

    test "giving files with incorrect expected context will return error tuple" do
      assert Feeder.get_feeds_as_text([
               %Feeder.File{name: "user.txt", content: "here is some none related text"},
               %Feeder.File{name: "tweet.txt", content: "likewise"}
             ]) == {:error, :invalid_files_provided}
    end

    test "giving valid file uploads will produce the correct output" do
      assert Feeder.get_feeds_as_text(@sample_files) ==
               "Kent\n\t@Kent: For it should never feel the high complexity of the future of preference\n\t@Vitalik: Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems.\n\nMichael\n\t@Michael: If your linter tortures you, its complexity and we're building?\n\t@Kent: For it should never feel the high complexity of the future of preference\n\t@Michael: There are only two hard things in Computer Science: cache invalidation, naming things and off-by-1 errors.\n\t@Vitalik: Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems.\n\nVeronica\n\t@Michael: If your linter tortures you, its complexity and we're building?\n\t@Veronica: Worried about shifting your focus from now another sister will surely become to have bugs, only!\n\t@Michael: There are only two hard things in Computer Science: cache invalidation, naming things and off-by-1 errors.\n\t@Vitalik: Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems.\n\nVitalik\n\t@Veronica: Worried about shifting your focus from now another sister will surely become to have bugs, only!\n\t@Vitalik: Things like tornado cash and uniswap, kyber and the like are successful in part because they are just tools that people can put into their existing workflows, and not ecosystems. We need more tools that are content with being tools and fewer attempts at ecosystems."
    end
  end
end
