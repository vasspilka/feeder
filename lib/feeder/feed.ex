defmodule Feeder.Feed do
  @moduledoc """
  This module is responsible for generating and parsing feeds.
  """

  @typedoc "Feed is a structure that contains all feed items of a user."
  @type t() :: {Feeder.username(), [Feeder.tweet()]}

  @doc "Given a list of tweets and profiles will return a list of feeds."
  @spec get_feeds([Feeder.tweet()], [Feeder.Profile.t()]) :: [Feeder.Feed.t()]
  def get_feeds(tweets, profiles) do
    indexed_followers =
      profiles
      |> Enum.reduce(%{}, fn profile, outer_index ->
        Enum.reduce(profile.following, outer_index, fn follwee, inner_index ->
          Map.update(inner_index, follwee, [profile.user], &[profile.user | &1])
        end)
      end)

    Enum.reduce(tweets, %{}, fn {user, tweet}, feeds ->
      followers = indexed_followers[user] || []

      Enum.reduce([user | followers], feeds, fn followee, inner_feed ->
        Map.update(inner_feed, followee, [{user, tweet}], &[{user, tweet} | &1])
      end)
    end)
    |> Enum.into([])
  end

  @doc "Transforms feeds into text."
  @spec to_text(t() | [t()]) :: binary()
  def to_text(feeds) do
    feeds
    |> List.wrap()
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(fn {user, tweets} ->
      tweets_txt =
        tweets
        |> Enum.map(fn {username, tweet} ->
          "\t" <> "@#{user}: " <> tweet
        end)
        |> Enum.join("\n")

      user <> "\n" <> tweets_txt
    end)
    |> Enum.join("\n\n")
  end
end
