defmodule Pokedex.FavoritePokemons do
  @moduledoc """
  The FavoritePokemons context.
  """

  import Ecto.Query, warn: false
  alias Pokedex.Repo

  alias Pokedex.FavoritePokemons.FavoritePokemon

  @doc """
  Returns the list of favorite_pokemons.

  ## Examples

      iex> list_favorite_pokemons()
      [%FavoritePokemon{}, ...]

  """
  def list_favorite_pokemons do
    Pokedex.Repo.all(from p in Pokedex.FavoritePokemons.FavoritePokemon, select: p.pokemon_id)
  end

  @doc """
  Gets a single favorite_pokemon.

  Raises `Ecto.NoResultsError` if the Favorite pokemon does not exist.

  ## Examples

      iex> get_favorite_pokemon!(123)
      %FavoritePokemon{}

      iex> get_favorite_pokemon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_favorite_pokemon!(id), do: Repo.one(from p in FavoritePokemon, where: p.pokemon_id == ^id)

  @doc """
  Creates a favorite_pokemon.

  ## Examples

      iex> create_favorite_pokemon(%{field: value})
      {:ok, %FavoritePokemon{}}

      iex> create_favorite_pokemon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favorite_pokemon(attrs \\ %{}) do
    %FavoritePokemon{}
    |> FavoritePokemon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a favorite_pokemon.

  ## Examples

      iex> update_favorite_pokemon(favorite_pokemon, %{field: new_value})
      {:ok, %FavoritePokemon{}}

      iex> update_favorite_pokemon(favorite_pokemon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_favorite_pokemon(%FavoritePokemon{} = favorite_pokemon, attrs) do
    favorite_pokemon
    |> FavoritePokemon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a favorite_pokemon.

  ## Examples

      iex> delete_favorite_pokemon(favorite_pokemon)
      {:ok, %FavoritePokemon{}}

      iex> delete_favorite_pokemon(favorite_pokemon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite_pokemon(%FavoritePokemon{} = favorite_pokemon) do
    Repo.delete(favorite_pokemon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favorite_pokemon changes.

  ## Examples

      iex> change_favorite_pokemon(favorite_pokemon)
      %Ecto.Changeset{data: %FavoritePokemon{}}

  """
  def change_favorite_pokemon(%FavoritePokemon{} = favorite_pokemon, attrs \\ %{}) do
    FavoritePokemon.changeset(favorite_pokemon, attrs)
  end
end
