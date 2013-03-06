-module(test3).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").
-export([start/0]).

get_random_string(Length, AllowedChars) ->
    MapFun = fun(_) ->
        lists:nth(random:uniform(length(AllowedChars)), AllowedChars)
    end,
    lists:map(MapFun, lists:seq(1, Length)).

get_random_string_test() ->
    random:seed(),
    TestString = ?debugVal(get_random_string(4, "1234")),
    ?assert(length(TestString) =:= 4),
    ?assertEqual(TestString, "2343").

create_table(AllowedChars, NrCols, NrRows) ->
    HeaderNames = lists:seq(65, 65 + NrCols - 1),
    RowNames = lists:seq(0, NrRows - 1),
    Rows = lists:map(fun(_) ->
        get_random_string(NrCols, AllowedChars)
    end, RowNames),
    {HeaderNames, RowNames, Rows}.

render_table_text({HeaderNames, RowNames, Rows}) ->
    render_line_text({header, HeaderNames})
    , lists:map(
        fun({RowNr, Row}) -> render_line_text({row, RowNr, Row}) end
        , lists:zip(RowNames, Rows)
    )
    .

render_line_text(What) ->
    case What of
        {header, Header} ->
            Separator = lists:map(fun(_) -> "-" end, Header),
            io:format("  ~s  \n- ~s -\n", [Header, Separator]);
        {row, Nr, L} ->                 io:format("~B ~s ~B\n", [Nr, L, Nr]);
        newline ->                      io:format("\n")
    end.

render_table_markdown({HeaderNames, RowNames, Rows}) ->
    render_line_markdown({header, HeaderNames})
    , lists:map(
        fun({RowNr, Row}) -> render_line_markdown({row, RowNr, Row}) end
        , lists:zip(RowNames, Rows)
    )
    , render_line_markdown(newline)
    , render_line_markdown({header, HeaderNames})
    .

render_line_markdown(What) ->
    case What of
        {header, HeaderNames} ->
            HeaderNames2 = "." ++ HeaderNames ++ ".",
            Separator = lists:map(fun(_) -> "---" end, HeaderNames2),
            HeaderLine = lists:map(fun(Head) -> [" ", Head, " "] end, HeaderNames2),
            io:format("~s\n~s\n", [string:join(HeaderLine, " "), string:join(Separator, " ")]);
        newline -> io:format("\n");
        {row, Nr, Row} ->
            Row2 = lists:append([[Nr + 48], Row, [Nr + 48]]),
            io:format("~s\n", [
                string:join(lists:map(fun(Cell) -> [" ", Cell, " "] end, Row2), " ")
            ])
    end.

render_table(Table, Style) ->
    case Style of
        text -> render_table_text(Table);
        markdown -> render_table_markdown(Table)
    end.

start() ->
    AllowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_+-/!$%=#<>",
    NrCols = 10,
    NrRows = 10,

    %random:seed(now()),
    random:seed(),

    Table = create_table(AllowedChars, NrCols, NrRows),
    render_table(Table, text),
    render_table(Table, markdown).


