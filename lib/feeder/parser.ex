defmodule Feeder.Parser do
  @moduledoc """
  This module takes care of parsing our text input into
  our defined datastructures.
  """

  @doc """
  We expect the contents of user.txt files to be passed and
  that it will have the following form:

  user_a follows user_b, user_c\n
  user_b follows user_a\n

  where for each line the first username is the subject
  and the usernames after follows are the ones they are following.

  This function will parse the input into a list of profiles.
  """
  @spec parse_profiles(binary()) :: [Feeder.Profile.t()]
  def parse_profiles(text) do
    text
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
      [user, followers] = String.split(line, " follows ")

      %Feeder.Profile{
        user: user,
        following: String.split(followers, ", ")
      }
    end)
  end

  @doc """
  We expect the contents of tweet.txt files to be passed and
  that it will have the following form:

  user_a> Some tweet\n
  user_b> Another tweet\n
  user_b> Yet another tweet\n

  where for each line the part before '>' is the username
  and the rest until the end of the line is the tweet text.

  This function will parse the input into a list of tweets.
  """
  @spec parse_tweets(binary()) :: [Feeder.tweet()]
  def parse_tweets(text) do
    text
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
      # we match to raise error if format not correct
      [_, _] = tweet = String.split(line, "> ")

      List.to_tuple(tweet)
    end)
  end
end
