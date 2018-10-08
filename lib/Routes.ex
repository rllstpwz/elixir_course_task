defmodule Routes do
  
  use GenServer
  
  alias __MODULE__
  alias RoutesHolder
  alias Location, as: Loc
  alias Route, as: Rt
  
  
  #initializing part
  
  def start_link(routes_l), do: GenServer.start_link(__MODULE__, RoutesHolder.get_state(), name: __MODULE__)
  
  def init(routes_l), do: {:ok, routes_l} 
   
  #private funcs

  defp add_new(%Rt{locations: locations_l, name: route_name}, routes_l) do
    [%Rt{locations: locations_l, name: route_name} | routes_l]
  end
  
  defp destroy([], loc_name, deleted) do
    case deleted do
      0 -> IO.puts("There were not routes containing the location #{loc_name}")
      x when x > 0 -> IO.puts("Routes containing the location #{loc_name} were
      successfully deleted from the routes list.")
      any -> {:error, IO.inspect(any)}
    end
  end

  defp destroy(routes_l = [h = %Rt{locations: %Loc{name: loc_name}, name: route_name} | t], loc_name, deleted) do
    if loc_name == route_name do
      List.delete(routes_l, h)
    else
      destroy(t, loc_name, deleted+1)
    end
  end

  defp best_route(routes_l,
        %Loc{coordinates: _, name:  loc_name_x, type: _},
        %Loc{coordinates: _, name: loc_name_y, type: _}) do
    
    Enum.map(routes_l, fn {route_x = %Rt{locations: %Loc{coordinates: _, name: name_x, type: _}}} ->
      if name_x == loc_name_x &&
        name_x == loc_name_y do
        {:ok, route_x}
      else
        {:error, :no_matching_route_found}
      end
    end)
  end

  defp print_nl(routes_l) do
    Enum.each(routes_l, fn each -> IO.puts(each) end)
  end
  
  #callbacks

  def add(%Rt{locations: locations_l, name: route_name}) do
    GenServer.call(__MODULE__, {:add, %Rt{locations: locations_l, name: route_name}})
  end
  
  def destroyed(%Rt{locations: %Loc{coordinates: _, name: loc_name, type: _}, name: _}) do
    GenServer.call(__MODULE__, {:destroyed, loc_name})
  end

  def best(%Rt{locations: %Loc{coordinates: _, name: loc_name_x, type: _}, name: _},
        %Rt{locations: %Loc{coordinates: _, name: loc_name_y, type: _}, name: _}) do
    GenServer.call(__MODULE__, {:best, {loc_name_x, loc_name_y}})
  end

  def print_all() do
    GenServer.call(__MODULE__, {:status})
  end

  
  #server part

  #add
  def handle_call({:add, route}, _from, routes_l) do
    new_state = add_new(route, routes_l)
    RoutesHolder.update_state(new_state)
    {:reply, new_state, new_state}
  end

  #destroyed
  def handle_call({:destroyed, loc_name}, _from, routes_l) do
    new_state = destroy(routes_l, loc_name, 0)
    {:reply, routes_l, new_state}
  end

  #best
  def handle_call({:best, {loc_name_x, loc_name_y}}, _from, routes_l) do
    {
      :reply,
      best_route(routes_l, loc_name_x, loc_name_y),
      routes_l
    }
  end
  
  #print
  def handle_call({:status}, _from, routes_l) do
    {:reply, print_nl(routes_l), routes_l}
  end
  
end
