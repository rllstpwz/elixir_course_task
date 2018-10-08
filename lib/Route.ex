defmodule Route do

  alias Location, as: Loc
  
  import Kernel
  
  #forcing user to leave no empty fields
  
  struct_keys = [:locations, :name]
  @enforce_keys(struct_keys)
  defstruct [locations: nil, name: nil]
  

  #recursive function to calculate the length of a route
  #by summing each two neighbour items from the locations list
  
  defp route_length(_, [], result, route_name) do
    {:ok, route_name, result}
  end

  defp route_length(%Loc{coordinates: [lat_x, lon_x]},
        [h = %Loc{coordinates: [lat_y, lon_y]} | t],
        result,
        route_name) do
    
    sum_between_two = :math.sqrt(:math.pow((lon_x - lat_x), 2) + :math.pow((lon_y - lat_y), 2))
    sum = result + sum_between_two
    route_length(h, t, sum, route_name)
  end
  
  def route_length(%Route{locations: loc_list = [h | t],
                          name: route_name}) do
    if Kernel.length(loc_list) == 0 do
      IO.puts("Your locations list is empty! Please try again
      after adding information about locations!")
    end
    if Kernel.length(loc_list) == 1 do
      IO.puts("Your locations list contains only one destination
      and therefore there is no distance to calculate!
      Please try adding more locations to your list!")
    end
    
    route_length(h, t, 0, route_name)
  end
  
  
  
  #guarded function which returns the best from two routes
  #only if their starting and finishing locations match
  
  def best(route_x = %Route{locations: loc_list_x, name: route_name_x},
        route_y = %Route{locations: loc_list_y, name: route_name_y})
  when is_map(route_x)
  and is_map(route_y)
  and is_list(loc_list_x)
  and is_list(loc_list_y)
  and is_bitstring(route_name_x)
  and is_bitstring(route_name_y) do

    if Map.keys(route_x) == [] do
      {
        :error,
        IO.puts("Expected %Route{} type of structure. Got: ")
        <> IO.inspect(route_x)
        <> IO.puts(" map.")
       }
    end

    if Map.keys(route_y) == [] do
      {
        :error,
        IO.puts("Expected %Route{} type of structure. Got: ")
        <> IO.inspect(route_y)
        <> IO.puts(" map.")
      }
    end

    if Kernel.length(loc_list_x) == 0 ||
      Kernel.length(loc_list_y) == 0 do
      IO.puts("Your locations lists are empty! Please try again
      after adding a number of locations!")
    end

    if List.first(loc_list_x) == List.first(loc_list_y) do
      if List.last(loc_list_x) == List.last(loc_list_y) do
        if Kernel.length(loc_list_x) < length(loc_list_y) do
          {:ok, %Route{locations: loc_list_x, name: route_name_x}}
        else
          {:ok, %Route{locations: loc_list_y, name: route_name_y}}
        end
      else
        {:error, IO.puts("Not matching.")}
      end
    else
      {:error, IO.puts("Not matching.")}
    end
  end
  
  #unguarded function to find best route,
  #to catch bad data inputs

  def best(route_x, route_y) do
    if Map.keys(route_x) == [] do
      {
        :error,
        IO.puts("Expected %Route{} type of structure. Got: ")
        <> IO.inspect(route_x)
        <> IO.puts(" map.")
      }
    end
    
    if Map.keys(route_x, :__struct__) != [] do
      IO.puts("Expected a structure of type %Route{}. Got: ")
      <> IO.inspect(route_x)
      <> IO.puts(", structure type.")
    end
    
    if Map.keys(route_y) == [] do
      {
        :error,
        IO.puts("Expected %Route{} type of structure. Got: ")
        <> IO.inspect(route_y)
        <> IO.puts(" map.")
      }
    end
    
    if Map.keys(route_y, :__struct__) != [] do
      IO.puts("Expected a structure of type %Route{}. Got: ")
      <> IO.inspect(route_y)
      <> IO.puts(", structure type. ")
    end
  end
  
  #recursive function to print each location
  #with a symbol between each one
  
  defp print(_, [], route_name, _, final_string) do
    %{"Route:" =>  route_name, "Locations:" => final_string}
  end
  
  defp print(%Loc{coordinates: _,
                  name: loc_name,
                  type: _},
        [h | t],
        route_name,
        symbol,
        memory_string) do
    
    particle =
    if t == [] do
      loc_name
    else
      loc_name <> symbol
    end
    
    string_concat = particle <> " " <> memory_string
    print(h, t, route_name, symbol, string_concat)
  end
  
  def print(route = %Route{locations: locations_list = [h | t], name: route_name}) do
    if length(locations_list) == 0 do
      {
        :eror,
        IO.puts("Please fill your locations list to print a route!")
      }
    end
    
    if route == %Route{locations: locations_list, name: route_name} do
      print(h, t, route_name, " ->", "")
    else
      {
        :error, IO.puts("Expected a %Route structure. Got: ")
        <> IO.inspect(route)
      }
    end
  end
  
end
