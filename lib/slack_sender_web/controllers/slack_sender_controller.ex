defmodule SlackSenderWeb.SlackSenderController do
  use SlackSenderWeb, :controller

  def send(conn, params) do
    message = params["message"]
    working_queue = Application.get_env(:rabbitmq_sender, :working_queue)
    IO.puts "Sending message [#{message}] to working queue [#{working_queue}]"
    RabbitMQSender |> RabbitMQSender.send_message(working_queue, message, true)
    IO.puts "Message [#{message}] has been sent to queue [#{working_queue}]"
    json conn, %{sent: true}
  end

  def receive(conn, params) do
    topics = params["topics"]
    identity = params["identity"]
    IO.puts "Topics: #{inspect topics}, identity: #{identity}"
    messages = MessagesReceiver.get_messages_for(topics, identity)
    json conn, %{messages: messages}
  end

  def register(conn, params) do
    identity = params["identity"]
    topics = params["topics"]
    topics |> Enum.each(fn topic -> topic |> SubscriptionManager.add_subscriber(identity) end)
    json conn, %{registered: identity}
  end
end
