{
module Main where
import Lexer
}

%name parser
%error { parseError }
%lexer { lexwrap } { Eof }
%monad { Alex }
%tokentype { Token }

%token
TOKEN   { Token ($$, _) }
"{"     { OBrace _ }
"}"     { CBrace _ }
vobrace { VOBrace _}
vcbrace { VCBrace _}

%%
tokens:    token tokens_t       { $1 : $2 }
 |         {- empty -}          { [] }

tokens_t:  token tokens_t       { $1 : $2 }
 |         {- empty -}          { [] }

token:     TOKEN                { $1 }
 |         "{"                  { "{" }
 |         "}"                  { "}" }
 |         vobrace              { "{" }
 |         vcbrace              { "}" }

{
lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan >>=)

parseError :: Token -> Alex a
parseError t = alexError $ "parseError: " ++ show t

parse s = runAlex s parser

main :: IO ()
main = getContents >>= pp . parse 

pp (Right []) = putStr "\n"
pp (Right (x:xs)) = do
  if x == ";" || x == "{" || x == "}" then putStr "\n" else putStr " "
  putStr x
  pp $ Right xs
pp (Left s) = putStrLn s
}