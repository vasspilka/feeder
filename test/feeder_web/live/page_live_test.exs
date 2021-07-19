defmodule FeederWeb.PageLiveTest do
  use FeederWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")
    assert render(page_live) =~ "Please provide .txt files for user and tweet data."
  end
end
