defmodule FeederWeb.PageLive do
  use FeederWeb, :live_view
  alias Feeder.FileUpload

  @impl true
  def render(assigns) do
    ~L"""
    <div class="mt-15">
      <h1 class="text-center text-xl">Please provide .txt files for user and tweet data.</h1>
      <h1 class="text-center text-xl">You can drop them down to the green area or choose them through the button.</h1>
      <h1 class="text-center text-xl">Only two files can be uploaded at a time.</h1>
    </div>

    <div class="mt-10">
      <form id="upload-csv-form" phx-submit="put-files" phx-change="file-update">
        <section class="h-48 bg-green-100 flex items-end  place-content-end"  phx-drop-target="<%= @uploads.txt.ref %>">
          <%= live_file_input @uploads.txt, class: "flex-grow self-start" %>
          <%= for entry <- @uploads.txt.entries do %>
            <article>
              <figure>
                <figcaption class="mr-2"><%= entry.client_name %></figcaption>
              </figure>

              <%# Phoenix.LiveView.Helpers.upload_errors/2 returns a list of error atoms %>
              <%= for err <- upload_errors(@uploads.txt, entry) do %>
                <p class="alert alert-danger"><%= inspect(err) %></p>
              <% end %>
            </article>
          <% end %>
          <button type="submit" class="bg-green-500 text-white px-12 py-4 rounded font-medium hover:bg-green-600 transition duration-200">Upload</button>
        </section>
      </form>
    </div>

    <div class="mt-10">
      <h1 class="text-center text-xl">Uploaded Files:</h1>
      <%= for file <- @file_uploads do %>
        <div class="mt-4">
          <div class="pre-wrap"><%= file.name %></div>
          <div class="pre-wrap mt-2"><%= file.content %></div>
        </div>
      <% end %>
    </div>

    <div class="mt-10">
      <h1 class="text-center text-xl">Output:</h1>
      <div class="mt-4">
        <div class="pre-wrap"><%= Feeder.get_feeds_as_text(@file_uploads) %></div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:file_uploads, [])

    {:ok, socket |> allow_upload(:txt, accept: ~w(.txt), max_entries: 2)}
  end

  @impl true
  def handle_event("put-files", _params, socket) do
    uploads =
      socket
      |> consume_uploaded_entries(:txt, fn %{path: path}, entry ->
        %FileUpload{
          path: path,
          name: entry.client_name,
          content: File.read!(path)
        }
      end)

    {:noreply, assign(socket, :file_uploads, uploads)}
  end

  def handle_event("file-update", _params, socket) do
    {:noreply, socket}
  end
end
