defmodule Mix.Tasks.ParseFiles do
  use Mix.Task

  @shortdoc "Displays tweet feed output to console."
  def run(args) do
    Enum.map(args, fn path ->
      %Feeder.File{
        path: path,
        name: Path.basename(path),
        content: File.read!(path)
      }
    end)
    |> Feeder.get_feeds_as_text()
    |> IO.puts()
  end
end
