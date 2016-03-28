defmodule WebsocketHandler do
  @behaviour :cowboy_websocket_handler


  # We are using the websocket handler.  See the documentation here:
  #     http://ninenines.eu/docs/en/cowboy/HEAD/manual/websocket_handler/
  #
  # All cowboy HTTP handlers require an init() function, identifies which
  # type of handler this is and returns an initial state (if the handler
  # maintains state).  In a websocket handler, you return a 
  # 3-tuple with :upgrade as shown below.  This is essentially following
  # the specification of websocket, in which a plain HTTP request is made
  # first, which requests an upgrade to the websocket protocol.
  def init({tcp, http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  # This is the first required callback that's specific to websocket
  # handlers.  Here I'm returning :ok, and no state since we don't 
  # plan to track ant state.
  #
  # Useful to know: a new process will be spawned for each connection
  # to the websocket.
  def websocket_init(_TransportName, req, _opts) do
    #IO.puts "init.  Starting timer. PID is #{inspect(self())}"

    # Here I'm starting a standard erlang timer that will send
    # an empty message [] to this process in one second. If your handler
    # can handle more that one kind of message that wouldn't be empty.
    #:erlang.start_timer(1000, self(), [])
    {:ok, req, :undefined_state }
  end

  # Required callback.  Put any essential clean-up here.
  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  # websocket_handle deals with messages coming in over the websocket.
  # it should return a 4-tuple starting with either :ok (to do nothing)
  # or :reply (to send a message back).  
  def websocket_handle({:text, content}, req, state) do
    {:reply, {:text, content}, req, state}
  end
  def websocket_handle({:binary, content}, req, state) do
    {:reply, {:binary, content}, req, state}
  end
  
  # Fallback clause for websocket_handle.  If the previous one does not match
  # this one just returns :ok without taking any action.  A proper app should
  # probably intelligently handle unexpected messages.
  def websocket_handle(_data, req, state) do    
    {:ok, req, state}
  end

  # fallback message handler 
  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end
end

