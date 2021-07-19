defmodule Feeder.ParserTest do
  use ExUnit.Case

  describe "parse_profiles/1" do
    test "with correct format it will parse string into profiles" do
      txt = """
      user_a follows user_b, user_c\n
      user_b follows user_a\n
      """

      assert Feeder.Parser.parse_profiles(txt) == [
               %Feeder.Profile{following: ["user_b", "user_c"], user: "user_a"},
               %Feeder.Profile{following: ["user_a"], user: "user_b"}
             ]
    end

    test "with incorrect format it will raise error" do
      assert_raise MatchError, fn ->
        Feeder.Parser.parse_profiles("bad text\nwith new lines\n no follows in first lines")
      end
    end
  end

  describe "parse_tweets/1" do
    test "with correct format it will parse string into tweets" do
      txt = """
      user_a> Some tweet\n
      user_b> Another tweet\n
      user_b> Yet another tweet\n
      """

      assert Feeder.Parser.parse_tweets(txt) == [
               {"user_a", "Some tweet"},
               {"user_b", "Another tweet"},
               {"user_b", "Yet another tweet"}
             ]
    end

    test "with incorrect format it will raise error" do
      assert_raise MatchError, fn ->
        Feeder.Parser.parse_tweets("bad text\nwith new lines\n no > in first lines")
      end
    end
  end
end
