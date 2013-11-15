%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(toppage_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
%	{ok, Req2} = cowboy_req:reply(200, [], <<"Hello world!">>, Req),
%         error_logger:info_msg("ok"),

    {Method, Req2} = cowboy_req:method(Req),
    HasBody = cowboy_req:has_body(Req2),
    {ok, Req3} = has_body(Method, HasBody, Req2),
    {ok, Req3, State}.

terminate(_Req, _State,_) ->
	ok.


has_body(<<"GET">>, false, Req) ->
    {Props, Req2} = cowboy_req:qs_vals(Req),
    error_logger:info_msg("prop: ~p",[Props]),
    App = proplists:get_value(<<"app">>, Props),
    User = proplists:get_value(<<"user_id">>, Props),
    Stream = proplists:get_value(<<"stream_id">>, Props),
    perform([App, User, Stream], Req2);
has_body(<<"GET">>, true, Req) -> cowboy_req:reply(400, [], <<"Bad request">>, Req);
has_body(_, _, Req) -> cowboy_req:reply(405, Req).

perform(Params, Req) ->
    case lists:all(fun valid/1, Params) of
        true ->
%            storage:update(key(Params)),
            error_logger:info_msg("ok"),
            cowboy_req:reply(200, [], <<"OK">>, Req);
        false ->
            cowboy_req:reply(400, [], <<"Bad request">>, Req)
    end.

valid(<<"">>)    -> false;
valid(undefined) -> false;
valid(_)         -> true.

key(Params) -> string:join(["heartbeat" | lists:map(fun binary_to_list/1, Params)], "_").
