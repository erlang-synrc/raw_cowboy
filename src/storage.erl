-module(storage).
-behaviour(gen_server).
-export([start_link/0, stop/0, update/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop() -> gen_server:call(?MODULE, stop).

update(Key) -> gen_server:cast(?MODULE, {update, Key}).

init([]) ->
%    {ok, Redis} = eredis:start_link(),
    {ok, []}.

handle_call(stop, _From, State) -> {stop, normal, ok, State};
handle_call(_Request, _From, State) -> {reply, ignored_message, State}.

handle_cast({update, Key}, Redis) ->
    eredis:q(Redis, ["SET", Key, "1"]),
    %%io:format("Redis store: ~p~n", [eredis:q(Redis, ["GET", Key])]),
    {noreply, Redis};
handle_cast(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
