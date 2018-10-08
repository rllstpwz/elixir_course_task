defmodule RoutesHolder do

   use GenServer

   alias __MODULE__

   def start_link(routes_l) do
     GenServer.start_link(__MODULE__, routes_l, name: __MODULE__)
   end

   def init(routes_l) do
     {:ok, routes_l}
   end

   def update_state(new_state) do
     GenServer.cast(__MODULE__, {:update, new_state})
   end

   def get_state() do
     GenServer.call(__MODULE__, {:status})
   end

   def handle_call({:status}, _from, state) do
     {:reply, state, state}
   end

   def handle_cast({:update, received_state}, state) do
     {:noreply, received_state}
   end

 end
