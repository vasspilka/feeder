defmodule FeederWeb.PageLive do
  use FeederWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
