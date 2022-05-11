defmodule Pokedex.FavoritePokemonsTest do
  use Pokedex.DataCase

  alias Pokedex.FavoritePokemons

  describe "favorite_pokemons" do
    alias Pokedex.FavoritePokemons.FavoritePokemon

    import Pokedex.FavoritePokemonsFixtures

    @invalid_attrs %{pokemon_id: nil}

    test "list_favorite_pokemons/0 returns all favorite_pokemons" do
      favorite_pokemon = favorite_pokemon_fixture()
      assert FavoritePokemons.list_favorite_pokemons() == [favorite_pokemon]
    end

    test "get_favorite_pokemon!/1 returns the favorite_pokemon with given id" do
      favorite_pokemon = favorite_pokemon_fixture()
      assert FavoritePokemons.get_favorite_pokemon!(favorite_pokemon.id) == favorite_pokemon
    end

    test "create_favorite_pokemon/1 with valid data creates a favorite_pokemon" do
      valid_attrs = %{pokemon_id: 42}

      assert {:ok, %FavoritePokemon{} = favorite_pokemon} =
               FavoritePokemons.create_favorite_pokemon(valid_attrs)

      assert favorite_pokemon.pokemon_id == 42
    end

    test "create_favorite_pokemon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               FavoritePokemons.create_favorite_pokemon(@invalid_attrs)
    end

    test "update_favorite_pokemon/2 with valid data updates the favorite_pokemon" do
      favorite_pokemon = favorite_pokemon_fixture()
      update_attrs = %{pokemon_id: 43}

      assert {:ok, %FavoritePokemon{} = favorite_pokemon} =
               FavoritePokemons.update_favorite_pokemon(favorite_pokemon, update_attrs)

      assert favorite_pokemon.pokemon_id == 43
    end

    test "update_favorite_pokemon/2 with invalid data returns error changeset" do
      favorite_pokemon = favorite_pokemon_fixture()

      assert {:error, %Ecto.Changeset{}} =
               FavoritePokemons.update_favorite_pokemon(favorite_pokemon, @invalid_attrs)

      assert favorite_pokemon == FavoritePokemons.get_favorite_pokemon!(favorite_pokemon.id)
    end

    test "delete_favorite_pokemon/1 deletes the favorite_pokemon" do
      favorite_pokemon = favorite_pokemon_fixture()

      assert {:ok, %FavoritePokemon{}} =
               FavoritePokemons.delete_favorite_pokemon(favorite_pokemon)

      assert_raise Ecto.NoResultsError, fn ->
        FavoritePokemons.get_favorite_pokemon!(favorite_pokemon.id)
      end
    end

    test "change_favorite_pokemon/1 returns a favorite_pokemon changeset" do
      favorite_pokemon = favorite_pokemon_fixture()
      assert %Ecto.Changeset{} = FavoritePokemons.change_favorite_pokemon(favorite_pokemon)
    end
  end
end
