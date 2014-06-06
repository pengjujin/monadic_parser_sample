{
{- The goal of this code is to be a compact example to show the way to do 
   the Haskell layout using alex+happy monadic parser.
   So, rules are far from enough to analize the language.
-}
module Main where
import Lexer
}

%name parser
%error { parseError }
%lexer { lexwrap } { Eof }
%monad { Alex }
%tokentype { Token }

%token
TOKEN   { Token $$ }
SP_TOK  { Token' $$ }
"{"     { OBrace $$ }
"}"     { CBrace $$ }
vobrace { VOBrace $$ }
vcbrace { VCBrace $$ }
"("     { OParen $$ }
")"     { CParen $$ }

%%
tokens:    token tokens_t       { $1 ++ $2 }
 |         {- empty -}          { [] }

tokens_t:  token tokens_t       { $1 ++ $2 }
 |         {- empty -}          { [] }

token:     TOKEN                { [$1] }
 |         "(" tokens ")"       { ("(",$1) : ($2 ++ [(")",$3)]) }
 |         SP_TOK llist         { $1 : $2 }


llist:     "{" tokens "}"               { [("{",$1)] ++ $2 ++ [("}",$3)] }
           {- shift/reduce conflict occurs with the following two rules.
              the parser will try to shift (try to accept longer rule) first. -}
 |         vobrace tokens vcbrace       { [("{",$1)] ++ $2 ++ [("}",$3)] }
 |         vobrace tokens               {% Alex (\s -> missing_vcbrace s $2 $1) }


{
missing_vcbrace s@AlexState{alex_ust=t@AlexUserState{indent_levels=lvs}} toks pos=
  case lvs of
    [] -> Left $ "fatal error: " ++ show toks
    _:lvs' -> Right (s{alex_ust=t{indent_levels=lvs'}}, [("{",pos)] ++ toks ++ [("}",pos)])
  
lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan >>=)

parseError :: Token -> Alex a
parseError t = alexError $ "parseError: " ++ show t

parse s = runAlex s parser

p' (Right []) = putStr "\n"
p' (Right ((x,_):xs)) = do
  if x == ";" || x == "{" then putStr "\n" else putStr " "
  putStr x
  p' $ Right xs
p' (Left s) = putStrLn s

main :: IO ()
main = getContents >>= p' . parse
}
