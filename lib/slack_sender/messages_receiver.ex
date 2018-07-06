defmodule MessagesReceiver do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_messages_for(topics, identity) do
    Agent.get_and_update(__MODULE__, fn map ->
      {list_of_messages, updated_map} =
        topics |> Enum.map_reduce(map, fn topic, m ->
          {messages, topic_entries} = get_messages_and_remaining_entries m, topic, identity
          {messages, m |> Map.put(topic, topic_entries)}
        end)
      messages = list_of_messages |> List.flatten
      {messages, updated_map}
      # entriess = map[topic]
      # messages = entries |> Enum.map(fn {message, _} -> message end)
      # remaining_entries =
      #   entries |> Enum.map(fn {message, subscribers} ->
      #     subscribers = subscribers && subscribers |> MapSet.delete(identity)
      #     {message, subscribers}
      #   end)
      #   |> Enum.filter(fn {_, subscribers} -> subscribers && !(subscribers |> Enum.empty?) end)
      # {messages, map |> Map.put(topic, remaining_entries)}
    end)
  end

  def accept_message(%ReceiverMessage{payload: message, reply_to: receiver}) do
    Agent.update(__MODULE__, fn map ->
      subscribers = SubscriptionManager.get_subscribers receiver
      entry = {message, subscribers}
      map |> Map.update(receiver, [entry], &[entry|&1])
    end)
  end

  defp get_messages_and_remaining_entries(map, topic, identity) do
    IO.puts "Getting messages by #{topic} for #{identity}"
    entries = map[topic]
    messages = if entries, do: entries |> Enum.map(fn {message, _} -> message end), else: []
    remaining_entries =
      if entries do
        entries |> Enum.map(fn {message, subscribers} ->
          subscribers = subscribers && subscribers |> MapSet.delete(identity)
          IO.puts "Identity #{identity} has been removed."
          IO.puts "Remaining subscribers are: #{inspect subscribers}"
          {message, subscribers}
        end)
        |> Enum.filter(fn {_, subscribers} -> subscribers && (MapSet.size(subscribers) > 0) end)
      else
        []
      end
    {messages, remaining_entries}
  end
end
