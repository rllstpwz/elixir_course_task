defmodule Location do

  alias Coordinate, as: Cord
  
  #forcing the user to not leave empty fields

  struct_keys = [:coordinates, :name, :type]
  @enforce_keys(struct_keys)
  defstruct [coordinates: nil, name: nil, type: nil]

  
  #guarded function for creating a new location
  
  def location_new(strct_pttrn = %Cord{lat: lat, lon: lon}, loc_name, type)
  when is_map(strct_pttrn)
  and is_number(lat)
  and is_number(lon)
  and is_bitstring(loc_name)
  and is_atom(type) do
    
    if Map.keys(strct_pttrn) == [] do
      {
        :error,
        IO.puts("Expected a structure of type %Coordinate{}. Got: ")
        <> IO.inspect(strct_pttrn)
        <> IO.puts(", map.")
      }
    end
    
    if type == :landmark ||
      type == :cafe ||
      type == :restaurant ||
      type == :shop do
      {
        :ok,
        %Location{coordinates: [lat, lon], name: loc_name, type: type}
      }
    else
      {
        :error,
        IO.puts("The location type must be either:
        ':landmark',
        ':cafe',
        ':restaurant' or
        ':shop'.")
      }
    end
  end

  #unguarded function for creating a new location
  #to catch bad data input

  def location_new(structure_data, name_data, type_data) do
    if is_map(structure_data) == true do
      if Map.keys(structure_data) == [] do
        IO.puts("Expected a structure of type %Coordinate{}. Got: ")
        <> IO.inspect(structure_data)
        <> IO.puts(",  map.")
      end
      
      if Map.keys(structure_data, :__struct__) != [] do
        IO.puts("Expected a structure of type %Coordinate{}. Got: ")
        <> IO.inspect(structure_data)
        <> IO.puts(" structure type")
      end
      
      
      if is_map(structure_data) == false do
        {
          :error,
          IO.puts("Bad argument data. Got: ")
          <> IO.inspect(structure_data)
          <> IO.puts(". Expected a structure of type %Coordinate{}.")
        }
      end
      
      if is_bitstring(name_data) == false do
        {
          :error,
          IO.puts("Bad argument data. Got: ")
          <> IO.inspect(name_data)
          <> IO.puts(". Expected a string.")
        }
      end
      
      if is_atom(type_data) == false do
        {
          :error,
          IO.puts("Bad argument data. Got: ")
          <> IO.inspect(structure_data)
          <> IO.puts(". Expected an atom.")
        }
      end
    end
  end


  #guarded function to calculate the distance
  #between two locations
  
  def location_distance(strct_x = %Location{coordinates: [lat_x, lon_x]},
         strct_y = %Location{coordinates: [lat_y, lon_y]})
  when is_map(strct_x)
  and is_map(strct_y) do
    
    if Map.keys(strct_x) == [] ||
      Map.keys(strct_y) == [] do
      
      IO.puts("Expected a structures of type %Location{}. Got: ")
      <> IO.inspect(strct_x, strct_y)
      <> IO.puts(", map(s).")
    else
      :math.sqrt(:math.pow((lon_x - lat_x), 2) + :math.pow((lon_y - lat_y), 2))
    end
  end
  
  #unguarded function to calculate the distance
  #between two locations; catching bad data input
  
  def location_distance(strct_x, strct_y) do
    if is_map(strct_x) == true do
      if Map.keys(strct_x) == [] do
        IO.puts("Expected a structure of type %Location{}. Got: ")
        <> IO.inspect(strct_x)
        <> IO.puts(", map.")
      end
      
      if Map.keys(strct_x, :__struct__) != [] do
        IO.puts("Expected a structure of type %Coordinate{}. Got: ")
        <> IO.inspect(strct_x)
        <> IO.puts(", structure type.")
      end
    end
    
    if is_map(strct_y) == true do
      if Map.keys(strct_y) == [] do
        IO.puts("Expected a structure of type %Location{}. Got: ")
        <> IO.inspect(strct_y)
        <> IO.puts(", map.")
      end
      
      if Map.keys(strct_y, :__struct__) != [] do
        IO.puts("Expected a structure of type %Location{}. Got: ")
        <> IO.inspect(strct_y)
        <> IO.puts(", structure type.")
      end
    end
  end
  
end
