defmodule Pokedex.FavoritePokemonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pokedex.FavoritePokemons` context.
  """

  @doc """
  Generate a favorite_pokemon.
  """
  def favorite_pokemon_fixture(attrs \\ %{}) do
    {:ok, favorite_pokemon} =
      attrs
      |> Enum.into(%{
        pokemon_id: 42
      })
      |> Pokedex.FavoritePokemons.create_favorite_pokemon()

    favorite_pokemon
  end
end
