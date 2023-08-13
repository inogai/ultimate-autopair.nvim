return {
    simple={
        {'|','(','(|)'},
        {'(|)',')','()|'},
        {'|','"','"|"'},
        {'"|"','"','""|'},
        {'() |','(','() (|)'},
        {"'' |","'","'' '|'"},
        {'(|))','(','((|))'},
        {'"a|b"','"','"a"|"b"'},
        {'<!-|','-','<!--|-->',{ft='html'}},
        {'<!-|-->','-','<!--|-->',{ft='html'}},
        {'""|','"','"""|"""',{ft='python'}},
        {'|)',')',')|)'},
        {'(|))',')','()|)'},
        {'f|','(','foo(|)',{abbr={f='foo'}}},
    },
    SKIP_interactive={
        {'|','a(..','(((|)))',{interactive=true}},
        {'|','3a(','(((|)))',{interactive=true}},
        {'|foo','R(','()o',{interactive=true}},
        {'|','I="("\r','()',{interactive=true,c={extensions={cmdtype={skip={}}}}}},
        --TODO: test treesitter inside cmdline
        {'|','Iprint("hello world!")','print("hello world!")|',{interactive=true}},
        {'|','Iprint("hello world!','print("hello world!|")',{interactive=true}},
        {'|','Iprint "hello world!F ;s(','print(|"hello world!")',{interactive=true}},
        {'|','Ifo\ro [bar]\r"baz"\rggI(','(|)fo\no [bar]\n"baz"\n',{interactive=true,c={fastwarp={nocursormove=false}}}},
        {'|','Ifo\ro [bar]\r"baz"\rggI(','(|)fo\no [bar]\n"baz"\n',{interactive=true,c={fastwarp={nocursormove=true}}}},
        {'|','Ifoo [bar]"baz"ggI\'','\'|\'foo [bar]"baz"',{interactive=true,c={fastwarp={nocursormove=false}}}},
        {'|','I"("','"()"|',{interactive=true,c={extensions={fly={nofilter=true}},config_internal_pairs={{'"','"',fly=true}}}}},
        {'|','I{I(','(|{})',{interactive=true,c={config_internal_pairs={{'{','}',suround=true}}}}},
        {'|',"Iprint'hello world!)'I('","('')print'hello world!)'",{interactive=true}}
    },
    SKIP_newline={
        {'{|}','\r','{\n\t|\n}',{cindent=true}},
        {'{foo|}','\r','{foo\n\t|\n}',{cindent=true}},
        {'{|foo}','\r','{\n\t|foo\n}',{cindent=true}},
        {'local x=[[|]]','\r','local x=[[\n|\n]]',{ft='lua'}},
        {'"""|"""','\r','"""\n|\n"""',{ft='python'}},
        {'{|','\r','{\n\t|\n}',{cindent=true,c={cr={autoclose=true}}}},
        {'{[(|','\r','{[(\n|\n)]}',{c={cr={autoclose=true}}}},
        {'({|\n)','\r','({\n|\n}\n)',{c={cr={autoclose=true}}}},
        {'{foo|','\r','{foo\n\t|\n}',{cindent=true,c={cr={autoclose=true}}}},
        {'{|foo','\r','{\n\t|foo\n}',{cindent=true,c={cr={autoclose=true}}}},
        {'do|','\r','do\n\nend',{skip=true,ft='lua',c={cr={autoclose=true},{'do','end',imap=false}}}},
        {'{|}','\r','{\n|\n};',{skip=true,ft='c',c={autosemi={'c'}}}},
        {'{|','\r','{\n|\n};',{skip=true,ft='c',c={autosemi={'c'},autoclose=true}}},
        {'{|};','\r','{\n|\n};',{skip=true,ft='c',c={autosemi={'c'},autoclose=true}}},
        {'```|','\r','```\n|\n```'},
        {'f|','\r','foo\r|)',{abbr={f='foo'}}},
    },
    SKIP_backspace={
        {'[|]','','|'},
        {'"|"','','|'},
        {'""|','','|'},
        {'[]|','','|'},
        {'[[|]]','','[|]'},
        {'[[|]','','[|]'},
        {'[|foo]','','|foo'},
        {'[ ]|','','|',{skip=true}},
        {'[ |foo ]','','[foo]'},
        {'(|','H','|',{c={bs={map={'<bs>','H'}}}}},
        {'<!--|-->','','',{ft='html'}},
        {'<!---->|','','',{ft='html'}},
        {'<!--|-->','','<!-|-->'},
        {[["'"'|']],'',[["'"|]]},
        {'{\n|\n}','','{|}'},
        {'{\r\t|\r}','','{|}',{interactive=true}},
        {'{\r\t|\r}','','{|}',{c={bs={indent_ignore=true}}}},
        {'[ | ]','','[|]'},
        {'( |foo )','','(|foo)'},
        {'(  |foo  )','','( |foo )'},
        {'(  | )','','( | )'},
        {'(|foo)','','|foo)',{c={bs={overjumps=false}}}},
        {'( | )','','(| )',{c={bs={space=false}}}},
        {'"|foo"','','|foo',{c={config_internal_pairs={{'"','"',bs_overjumps=true}}}}},
        {'<>\n|\n<>','','<>|<>',{c={{'<>','<>',newline=true}}}},
        {'<< | >>','','<<|>>',{c={{'<<','>>',space=true}}}},
        {'<< |foo >>','','<<|foo>>',{c={{'<<','>>',space=true}}}},
        {'$ | $','','$|$',{c={{'$','$',space=true}}}},
        {'( |  )','','( | )',{c={bs={space='balance'}}}},
        {'(  |)','','(|)',{bs={space='balance'}}},
        {'( |foo  )','','( |foo )',{bs={space='balance'}}},
        {'f|','','',{abrv={f='foo'}}},
    },
    SKIP_fastwarp={
        {'{|}[]','','{|[]}'},
        {'{|}foo','','{|foo}'},
        {'{|}foo,','','{|foo},'},
        {'{foo|},bar','','{foo,bar}'},
        {'(|)"bar"','','(|"bar")'},
        {'{foo|},','','{foo,|}'},
        {'{foo|},(bar)','','{foo,|}(bar)'},
        {'{(|),}','','{(|,)}'},
        {'{(|,)}','','{(|,)}'},
        {'(|)\n','','(\n|)',{c={fastwarp={nocursormove=false}}}},
        {'(|),""','','(|,)""'},
        {'"|"[]','','"|[]"'},
        {'"|"foo','','"|foo"'},
        {'"|"foo,','','"|foo",'},
        {'"|foo",bar','','"|foo,bar"'},
        {'"foo|",bar','','"foo,bar|"'},
        {'"|" ""','','" |"""'},
        {'"foo|"','','"foo|"\n'},
        {'<<|>>foo','','<<|foo>>',{c={{'<<','>>',fastwarp=true}}}},
        {'<<|>>()','','<<|()>>',{c={{'<<','>>',fastwarp=true}}}},
        {'<<|>><<>>','','<<|<<>>>>',{c={{'<<','>>',fastwarp=true}}}},
        {'(<<|>>)','','(<<|>>)',{c={{'<<','>>',fastwarp=true}}}},
        {'<<|>>foo,,','','<<|foo>>,,',{c={{'<<','>>',fastwarp=true}}}},
        {'(|)<<>>','','(|<<>>)',{c={{'<<','>>'}}}},
        {'(|)a_e','','(|a_e)'},
        {'(|")")foo','','(|")"foo)',{c={fastwarp={filter_string=true}}}},
        {'(foo|)','','(|)foo'},
        {'(|foo)','','(|)foo'},
        {'(|)','','(|)'},
        {'(foo,bar|)','','(foo|),bar'},
        {'({bar}|)','','(|){bar}'},
        {'("bar"|)','','(|)"bar"'},
        {'(foo{bar}baz|)','','(foo{bar}|)baz'},
        {'(\n|)','','(|)\n'},
        {'(|"",)','','(|""),'},
        {'"foo|"','','"|"foo'},
        {'"|foo"','','"|"foo'},
        {'"|"','','"|"'},
        {'"foo,bar|"','','"foo|",bar'},
        {'<<foo|>>','','<<|>>foo',{c={{'<<','>>',fastwarp=true}}}},
        {'<<()|>>','','<<|>>()',{c={{'<<','>>',fastwarp=true}}}},
        {'<<|<<>>>>','','<<|>><<>>',{c={{'<<','>>',fastwarp=true}}}},
        {'(<<|>>)','','(<<|>>)',{c={{'<<','>>',fastwarp=true}}}},
        {'(|"")','','(|)""'},
        {'(|")")','','(|)")"',{c={fastwarp={filter_string=true}}}},
        {'(|)foo','e','(|foo)',{fastwarp={multi=true,{map='e'},{map='E',nocursormove=false}}}},
        {'(|)foo','E','(foo|)',{fastwarp={multi=true,{map='e'},{map='E',nocursormove=false}}}},
    },
    SKIP_space={
        {'[|]',' ','[ | ]'},
        {'[|foo]',' ','[ |foo ]'},
        {'[|foo ]',' ','[ |foo ]'},
        {'[ |foo]',' ','[  |foo  ]'},
        {'+ [|]',' ','+ [ |]',{ft='markdown'}},
        {'+ [ ](|)',' ','+ [ ]( | )',{ft='markdown'}},
        {'<<|>>',' ','<< | >>',{c={{'<<','>>',space=true}}}},
        {'<< | >>',' ','<<  |  >>',{c={{'<<','>>',space=true}}}},
        {'<<|foo>>',' ','<< |foo >>',{c={{'<<','>>',space=true}}}},
        {'<< |foo >>',' ','<<  |foo  >>',{c={{'<<','>>',space=true}}}},
        {'$|$',' ','$ | $',{c={{'$','$',space=true}}}},
        {'$|foo$',' ','$ foo $',{c={{'$','$',space=true}}}},
        {'|','I="( \r','( | )',{interactive=true}},
    },
    SKIP_space2={
        {'[ |]','afoo','[ foo| ]',{interactive=true,c={space2={enable=true}}}},
        {'[  |','afoo','[  foo|  ]',{interactive=true,c={space2={enable=true}}}},
        {'[ |oo]','f','[ f|oo ]',{interactive=true,c={space2={enable=true}}}},
        {'[ |oo ]','f','[ f|oo ]',{interactive=true,c={space2={enable=true}}}},
        {'[  |oo ]','f','[  f|oo  ]',{interactive=true,c={space2={enable=true}}}},
        {'$ |$','foo','$ foo| $',{interactive=true,c={{'$','$',space=true},space2={enable=true}}}},
        {'<< |>>','foo','<< foo| >>',{interactive=true,c={{'<<','>>',space=true},space2={enable=true}}}},
    },
    SKIP_close={
        {'(|','','(|)'},
        {'({|','','({|})'},
        {'({()|','','({()|})'},
        {'({|)','','({|})'},
        {'"|','','"|"'},
        {'("|','','("|")'},
        {'("|")','','("|")'},
        {'<!--|','','<!--|-->',{ft='html'}},
        {'<!--|-->','','<!--|-->',{ft='html'}},
        {'<!---->|','','<!---->|',{ft='html'}},
    },
    ext_suround={
        {'|"foo"','(','(|"foo")'},
        {'|""','(','(|"")'},
        {'"foo|""bar"','(','"foo(|)""bar"'},
        {'|??&&','(','(|??&&)',{c={{'??','&&',suround=true}}}},
        {'|"")','(','(|"")'},
        {'<|""','<','<<|"">>',{c={{'<<','>>',dosuround=true}}}},
        {'|""','<','<|""',{c={{'<<','>>',dosuround=true}}}},
        {'<|"">>','<','<<|"">>',{c={{'<<','>>',dosuround=true}}}},
    },
    ext_string={
        {'| ")"','(','(|) ")"'},
        {'"|")','(','"(|)")'},
        {[[|"'"]],"'",[['|'"'"]]},
        {[['""(|)']],')',[['""()|']]},
        {'("|")',')','(")|")'},
        {[[| '\')']],'(',[[(|) '\')']]},
        {'| [[)]]','(','(|) [[)]]',{ft='lua',ts=true}},
        {'|\n")"','(','(|)\n")"'},
        {'"|"\n)','(','"(|)"\n)'},
        {"'''|'","'","''''|",{ts=true,ft='lua'}},
        --{[["'"|"'"]],'"',[["'""|""'"]]}, --TODO: fix
        --{[['"' '"' |]],"'",[['"' '"' '|']]}, --TODO: fix
        --TODO: test multiline string (python)
    },
    ext_cmdtype={
        {'|','I="("\r','()',{interactive=true,c={extensions={cmdtype={skip={}}}}}},
        {'|','I="("\r','(',{interactive=true,c={extensions={cmdtype={skip={'='}}}}}},
        {'|','(','(|)',{incmd=':'}},
        {'|','(','(|',{incmd='/'}},
    },
    ext_alpha={
        {"don|t","'","don'|t"},
        {"'a|'","'","'a'|"},
        {"f|","'","f'|'",{ft='python'}},
        {"fr|","'","fr'|'",{ft='python'}},
        {"a' |","'","a' '|'",{c={extensions={alpha={filter=true}}}}},
        {'a" |','"','a" "|',{c={extensions={alpha={filter={'txt'}}}}}},
        {"a' |","'","a' '|'",{ft='txt',c={extensions={alpha={filter={'txt'}}}}}},
        {'|a','<','<|a',{c={{'<','>',alpha_after=true}}}},
        {'a|','<','a<|',{c={{'<','>',alpha=true}}}},
        {'a<|','<','a<<|',{c={{'<<','>>',alpha=true}}}},
        {'<|a','<','<<|a',{c={{'<<','>>',alpha_after=true}}}},
        {'b""|','"','b"""|"',{ft='python',c={config_internal_pairs={{'"""','"""',alpha=true}}}}},
    },
    ext_filetype={
        {'<!-|','-','<!--|'},
        {'""|','"','"""|"'},
        {'<!-|','-','<!--|-->',{ft='html'}},
        {'|','(','(|',{ft='TelescopePrompt'}},
    },
    ext_escape={
        {'\\|','(','\\(|'},
        {'\\\\|','(','\\\\(|)'},
        {[['\\|']],'"',[['\\"|"']]},
        {'|\\)','(','(|)\\)'},
        {'\\(|)',')','\\()|)'},
        {'\\<!-|','-','\\<!--|',{ft='html'}},
        {'<!--\\-->|-->','-','<!--\\-->-->|',{ft='html'}},
        {'\\|','(','\\(|\\)',{c={{'\\(','\\)'}}}},
        {'\\\\|','(','\\\\(|)',{c={{'\\(','\\)'}}}},
        {'\\(|\\)','\\','\\(\\)|',{c={{'\\(','\\)'}}}},
        {'\\(|)','','\\|)'},
    },
    ext_cond={
        {'|',"'","'|",{ft='fennel'}},
        {'"|"',"'",[["'|'"]],{ft='fennel'}},
        {'|','(','(|',{c={extensions={cond={cond=function () return false end}}}}},
        {'#|','(','#(|',{c={extensions={cond={cond=function (_,o) return o.line:sub(o.col-1,o.col-1)~='#' end}}}}},
        {'|#)','(','(|)#)',{c={extensions={cond={cond=function (_,o)
            return o.line:sub(o.col-1,o.col-1)~='#' end,filter=true}}}}},
        {'"|"','(','"(|"',{c={extensions={cond={cond=function(fns) return not fns.in_string() end}}}}},
    },
    ext_fly={
        {'[{( | )}]',']','[{(  )}]|'},
        {'("|")',')','("")|',{c={{'"','"',p=11,fly=true},extensions={fly={nofilter=true}}}}},
        {'"(|)"','"','"()"|',{c={{'"','"',p=11,fly=true},extensions={fly={nofilter=true}}}}},
        {[['"' "(|)"]],'"',[['"' "()"|]],{skip=true,c={{'"','"',p=11,fly=true}}}},
        {'({|})',')','({)|})',{interactive=true,c={extensions={fly={undomap='<C-u>'}}}}},
        {'|(  )',')','(  )|'},
        {'|(  )',')',')|(  )',{c={extensions={fly={only_jump_end_pair=true}}}}},
        {'<<(|)>>','>','<<()>>|',{c={{'<<','>>',fly=true}}}},
        {'(<<|>>)',')','(<<>>)|',{c={{'<<','>>',fly=true}}}},
    },
    SKIP_ext_tsnode={
        {'--|','(','--(|',{ft='lua',ts=true,{c={extensions={tsnode={p=50,outside={'comment'}}}}}}},
        {'|','(','(|)',{ft='lua',ts=true,{c={extensions={tsnode={p=50,outside={'comment'}}}}}}},
        {'--|','(','--(|)',{ft='lua',ts=true,{c={extensions={tsnode={p=50,inside={'comment'}}}}}}},
        {'|','(','(|',{ft='lua',ts=true,{c={extensions={tsnode={p=50,inside={'comment'}}}}}}},
    },
    SKIP_utf8={
        {"'á|'","'","'á'|"}, --simple
        {'(|)aøe','','(|aøe)'}, --rfaswarp
        {'(|aáa)','','|aøe'}, --backspace
        {'|"¿qué?"','(','(|"¿qué")'}, --ext.suround
        {"ä|","'","ä'|"}, --ext.alpha
        {'"ě""|"','','"ě"|'}, --backspace
        {"'ø',|","'","'ø','|'",{ft='lua',ts=true}}, --treesitter
    },
    SKIP_options={
        ---pair
        {'|','(',{c={map=false}}},
        {'|','(',{c={pair_map=false}}},
        {'|','I="("\r','(',{interactive=true,c={cmap=true}}},
        {'|','I="("\r','(',{interactive=true,c={pair_cmap=true}}},
        ---bs
        {'(|)','','|)',{c={bs={enable=false}}}},
        {'(|)','','|)',{c={bs={map=false}}}},
        {'(|)','a','|',{c={bs={map='a'}}}},
        {'(|)','b','|',{c={bs={map={'a','b'}}}}},
        {'|','I="("\r',')',{interactive=true,c={bs={cmap=false}}}},
        {'(|foo)','','foo)',{c={bs={overjumps=false}}}},
        {'( | )','','(| )',{c={bs={space=false}}}},
        ---cr
        {'(|)','\r','(\n|)',{c={cr={enable=false}}}},
        {'(|','\r','(\n|\n)',{c={cr={autoclose=true}}}},
        ---space
        {'(|)',' ','( |)',{c={space={enable=false}}}},
        {'(|)',' ','( |)',{c={space={map=false}}}},
        {'|','I="( \r','( )',{interactive=true,c={space={cmap=false}}}},
        {'+ [|]',' ','+ [ |]',{ft='lua',c={space={check_box_ft={'lua'}}}}},
        --TODO: write more tests
    },
    SKIP_filter={
        {'\\(|)','','\\|)'},
        {'\\(|','','\\(|'},
        {'\\(|)','\r','\\(\n|)'},
        {'{(|)\\}}','','{(|\\})}'},
        {'{(|\\{)}','','{(|)\\{}'},
        {'\\(|)',' ','\\( |)'},
        {'\\( |)','f','\\( f)',{interactive=true,c={space2={enable=true}}}},
        {'|"\\"','(','(|)"\\"'},
        {'("|")',')','(")|")',{c={{'"','"',fly=true,p=11},extensions={fly={nofilter=false}}}}},
    },
    multiline={
        {'|\n)','(','(|\n)'},
        {'(\n|)',')','(\n)|'},
        {'\n|)',')','\n)|)'},
        {'(|\n)','(','((|)\n)'},
        {'(\n|\n)','(','(\n(|)\n)'},
        {'()\n|)',')','()\n)|)'},
        {'(\n(|)',')','(\n()|)'},
        {'(|\n))','(','((|\n))'},
        {'"""\n|"""','"','"""\n"""|',{ft='python'}},
        {'"\n|"','"','"\n"|"'},
        {'|\n>','<','<|>\n>',{c={{'<','>',multiline=false}}}},
        {'<\n|>','>','<\n>|>',{c={{'<','>',multiline=false}}}},
        {'(|)\n',')','()|\n'},
        {'\n(|)\n',')','\n()|\n'},
        {'\n |\n()','(','\n (|)\n()'},
        {'\n "|"\n""','"','\n ""|\n""',{c={config_internal_pairs={{'"','"',multiline=true}}}}},
        {'(\n  (|)\n)','','(\n  |\n)'},
        {'\n"|"','"','\n""|'},
        {"\n'|'","'","\n''|",{ts=true,ft='lua'}},
        {'(\n\n|\n)','(','(\n\n(|)\n)'},
    },
    DEV_run_multiline={
        {'\n|','a','\na|'},
        {'\n|\n','','|\n'},
        {'foo\n|bar\n','','foo|bar\n'},
        {'\n|\n','','\n|'},
    },
}
