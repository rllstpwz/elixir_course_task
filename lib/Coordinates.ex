 defmodule Coordinate do

   #Force the keys to be inserted.

   struct_keys = [:lat, :lon]
   @enforce_keys(struct_keys)
   defstruct [lat: nil , lon: nil]

 end
