defmodule Pokedex.Repo.Migrations.CreateFavoritePokemons do
  use Ecto.Migration

  def change do
    create table(:favorite_pokemons) do
      add :pokemon_id, :integer

      timestamps()
    end
    create unique_index(:favorite_pokemons, [:pokemon_id])
  end
end
