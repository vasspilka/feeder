defmodule Feeder do
  @moduledoc """
  Feeder parses files that represent twitter follower and tweet data and creates a feed for
  each existing user.
  """
  use TypedStruct

  alias Feeder.{Feed, Parser, Profile}

  typedstruct module: File do
    field(:path, binary())
    field(:name, binary(), enforce: true)
    field(:content, binary(), enforce: true)
  end

  typedstruct module: Profile do
    field(:user, Feeder.username(), enforce: true)
    field(:following, [Feeder.username()], enforce: true)
  end

  @typedoc "Username is represented by binary string."
  @type username :: binary()

  @typedoc "Tweet is represented by a name, tweet text tuple."
  @type tweet() :: {username(), binary()}

  @spec get_feeds_as_text([Feeder.File.t()]) :: binary()
  @doc "Creates the text to display from file uploads."
  def get_feeds_as_text(files) do
    with %Feeder.File{content: user_txt} <-
           Enum.find(files, &String.starts_with?(&1.name, "user")),
         %Feeder.File{content: tweets_txt} <-
           Enum.find(files, &String.starts_with?(&1.name, "tweet")) do
      profiles = Parser.parse_profiles(user_txt)
      tweets = Parser.parse_tweets(tweets_txt)

      tweets
      |> Feeder.Feed.get_feeds(profiles)
      |> Feeder.Feed.to_text()
    end
  end
end
