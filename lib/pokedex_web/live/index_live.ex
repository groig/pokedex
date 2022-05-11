defmodule PokedexWeb.IndexLive do
  use PokedexWeb, :live_view
  alias Pokedex.FavoritePokemons
  @page_size 10

  @impl true
  def mount(_, _session, socket) do
    favorites = FavoritePokemons.list_favorite_pokemons()
    {favs, no_favs} = Pokedex.State.state() |> Enum.split_with(&(&1["id"] in favorites))
    pokemons = favs ++ no_favs

    page_num = 1
    total_pages = length(pokemons) / @page_size

    current_pokemons = get_current_page(pokemons, page_num)

    socket =
      socket
      |> assign(:pokemons, pokemons)
      |> assign(:current_pokemons, current_pokemons)
      |> assign(:favorites, favorites)
      |> assign(:show_details, false)
      |> assign(:selected_pokemon, nil)
      |> assign(:page_num, page_num)
      |> assign(:total_pages, total_pages)

    {:ok, socket}
  end

  @impl true
  def handle_event("next-page", _params, socket) do
    socket =
      if socket.assigns.page_num < socket.assigns.total_pages do
        page = socket.assigns.page_num + 1

        socket
        |> assign(
          :current_pokemons,
          get_current_page(socket.assigns.pokemons, page)
        )
        |> assign(:page_num, page)
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("prev-page", _params, socket) do
    socket =
      if socket.assigns.page_num > 1 do
        page = socket.assigns.page_num - 1

        socket
        |> assign(:current_pokemons, get_current_page(socket.assigns.pokemons, page))
        |> assign(:page_num, page)
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle-favorite", %{"pokemon" => pokemon_id} = _params, socket) do
    pokemon_id = String.to_integer(pokemon_id)

    favorites =
      if pokemon_id in socket.assigns.favorites do
        favorite_pokemon = FavoritePokemons.get_favorite_pokemon!(pokemon_id)
        FavoritePokemons.delete_favorite_pokemon(favorite_pokemon)
        Enum.filter(socket.assigns.favorites, &(&1 != pokemon_id))
      else
        FavoritePokemons.create_favorite_pokemon(%{pokemon_id: pokemon_id})
        [pokemon_id | socket.assigns.favorites]
      end

    {:noreply, assign(socket, :favorites, favorites)}
  end

  @impl true
  def handle_event("show-details", %{"index" => index} = _params, socket) do
    socket =
      socket
      |> assign(:show_details, true)
      |> assign(
        :selected_pokemon,
        Enum.at(socket.assigns.pokemons, String.to_integer(index), %{})
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("hide-details", _params, socket) do
    socket = socket |> assign(:show_details, false) |> assign(:selected_pokemon, nil)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-serif mb-3">Pokémons</h1>
    <span class="px-4 py-1 text-white bg-blue-400 rounded">Peso Promedio: <%= get_avg_weight(@current_pokemons) %></span>
    <span class="px-4 py-1 text-white bg-blue-400 rounded">Altura Promedio: <%= get_avg_height(@current_pokemons) %></span>
    <div class="flex flex-col mt-3">
      <table>
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-2 text-xs text-gray-500">
              Nombre
            </th>
            <th class="px-6 py-2 text-xs text-gray-500">
              Peso
            </th>
            <th class="px-6 py-2 text-xs text-gray-500">
              Altura
            </th>
            <th class="px-6 py-2 text-xs text-gray-500">
              Habilidades Activas
            </th>
            <th class="px-6 py-2 text-xs text-gray-500">
              Total de Habilidades
            </th>
            <th class="px-6 py-2 text-xs text-gray-500">
              Favorito
            </th>
            <th class="px-6 py-2 text-xs text-gray-500">
              Acciones
            </th>
          </tr>
        </thead>
        <tbody class="bg-white" id="pokemons-table">
          <%= for  {pokemon, index} <- Enum.with_index(@current_pokemons) do %>
            <tr class="whitespace-nowrap hover:bg-gray-100" id={"#{pokemon["id"]}"}>
              <td class="px-6 py-4 text-sm text-center text-gray-900">
                <%= pokemon["name"] %>
              </td>
              <td class="px-6 py-4 text-center">
                <div class="text-sm text-gray-900 text-center">
                  <%= pokemon["weight"] %>
                </div>
              </td>
              <td class="px-6 py-4 text-center">
                <div class="text-sm text-gray-500"><%= pokemon["height"] %></div>
              </td>
              <td class="px-6 py-4 text-sm text-center text-gray-500">
                <%= get_abilities(pokemon) %>
              </td>
              <td class="px-6 py-4 text-sm text-center text-gray-500">
                <%= length(pokemon["pokemon_v2_pokemonabilities"]) %>
              </td>
              <td class="px-6 py-4 flex justify-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-6 w-6 text-center cursor-pointer"
                  fill={if pokemon["id"] in @favorites, do: "yellow", else: "none"}
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="2"
                  phx-click="toggle-favorite"
                  phx-value-pokemon={pokemon["id"]}
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"
                  />
                </svg>
              </td>
              <td class="px-6 py-4 text-center">
                <button
                  class="px-4 py-1 text-sm text-white bg-blue-400 rounded"
                  phx-click="show-details"
                  phx-value-index={index}
                >
                  Ver
                </button>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    <div class="flex w-full justify-center mt-3">
    <%= if @page_num > 1 do %>
      <button class="px-4 py-1 text-sm text-white bg-blue-400 rounded mr-2" phx-click="prev-page">
        Página Anterior
      </button>
    <% end %>
    <%= if @page_num < @total_pages do %>
      <button class="px-4 py-1 text-sm text-white bg-blue-400 rounded" phx-click="next-page">
        Página Siguiente
      </button>
    <% end %>
    </div>

    <%= if @show_details do %>
      <div id="modal" class="fixed z-50 inset-0 bg-gray-900 bg-opacity-60 overflow-y-auto h-full w-full px-4">
        <div class="relative top-40 mx-auto shadow-lg rounded-md bg-white max-w-md">
          <!-- Modal header -->
          <div class="flex justify-between items-center text-3xl font-serif rounded-t-md px-4 py-2 border-b border-b-gray-200">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6 cursor-pointer"
              fill={if @selected_pokemon["id"] in @favorites, do: "yellow", else: "none"}
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
              phx-click="toggle-favorite"
              phx-value-pokemon={@selected_pokemon["id"]}
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"
              />
            </svg>
            <h3><%= @selected_pokemon["name"] %></h3>
            <button>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                stroke-width="2"
                phx-click="hide-details"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <!-- Modal body -->
          <div class="p-4">
            <dl>
              <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <img src={
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{@selected_pokemon["id"]}.png"
                } />
              </div>
              <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <dt class="text-sm font-medium text-gray-500">Peso</dt>
                <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2"><%= @selected_pokemon["weight"] %></dd>
              </div>
              <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <dt class="text-sm font-medium text-gray-500">Altura</dt>
                <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2"><%= @selected_pokemon["height"] %></dd>
              </div>
              <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <dt class="text-sm font-medium text-gray-500">Habilidades Activas</dt>
                <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                  <%= get_abilities(@selected_pokemon) %>
                </dd>
              </div>
              <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <dt class="text-sm font-medium text-gray-500">Total de Habilidades</dt>
                <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                  <%= length(@selected_pokemon["pokemon_v2_pokemonabilities"]) %>
                </dd>
              </div>
            </dl>
          </div>
          <!-- Modal footer -->
        </div>
      </div>
    <% end %>
    """
  end

  defp get_abilities(pokemon) do
    pokemon["pokemon_v2_pokemonabilities"]
    |> Enum.filter(&(not &1["is_hidden"]))
    |> Enum.map(& &1["pokemon_v2_ability"]["name"])
    |> Enum.join(", ")
  end

  defp get_avg_weight(pokemons) do
    Float.floor((pokemons |> Enum.map(& &1["weight"]) |> Enum.sum()) / length(pokemons), 2)
  end

  defp get_avg_height(pokemons) do
    Float.floor((pokemons |> Enum.map(& &1["height"]) |> Enum.sum()) / length(pokemons), 2)
  end

  def get_current_page(pokemons, page_num) do
    pokemons |> Enum.drop(@page_size * (page_num - 1)) |> Enum.take(@page_size)
  end
end
