defmodule Pokedex.FavoritePokemons.FavoritePokemon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorite_pokemons" do
    field :pokemon_id, :integer

    timestamps()
  end

  @doc false
  def changeset(favorite_pokemon, attrs) do
    favorite_pokemon
    |> cast(attrs, [:pokemon_id])
    |> validate_required([:pokemon_id])
  end
end
