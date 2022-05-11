defmodule Pokedex.State do
  use Agent
  require Logger

  def start_link(_) do
    Agent.start_link(&get_initial_data/0, name: __MODULE__)
  end

  def state do
    Agent.get(__MODULE__, & &1)
  end

  defp get_initial_data() do
    Logger.info("Getting the api data")

    {:ok, response} =
      Mojito.post(
        "https://beta.pokeapi.co/graphql/v1beta",
        [{"content-type", "application/json"}, {"accept", "*/*"}],
        Jason.encode!(%{
          "query" =>
            "query MyQuery { pokemon_v2_pokemon { id height name weight pokemon_v2_pokemonabilities { pokemon_v2_ability { name } is_hidden } } }"
        })
      )

    data = Jason.decode!(response.body)
    Logger.info("Api data obtained")
    data["data"]["pokemon_v2_pokemon"]
  end
end
