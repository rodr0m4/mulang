module GobstonesSpec (spec) where

import	Test.Hspec
import	Language.Mulang
import	Language.Mulang.Parsers.Gobstones

spec :: Spec
spec = do

describe "translateProgramGobstonesToMulangExpression" $ do
    it "translate simple program Gobstones" $ do
      --  code = "program{}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": null,\"from\": 0}]"

      gobstonesAst `shouldBe` EntryPoint MuNull

    it "translate null program Gobstones" $ do
      --  code = "null"
      let gobstonesAst =  gbs "null"

      gobstonesAst `shouldBe` MuNull

    it "translate simple procedure Call" $ do
      --  code = "program{F()}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\": \"ProcedureCall\",\"from\": 14,\"to\": 18,\"arity\": \"routine\",\"name\": \"F\",\"parameters\": []}],\"from\": 0}]"
      									
      gobstonesAst `shouldBe` EntryPoint (Application (Variable "F") [])
    
    it "translate simple procedure declaration " $ do
      --  code = "procedure F(){}"
      let gobstonesAst =  gbs  "[{\"alias\": \"procedureDeclaration\",\"body\": null,\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"F\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"F\",\"parameters\": []}]"

      gobstonesAst `shouldBe` ProcedureDeclaration "F" [Equation [] (UnguardedBody MuNull)]

    it "translate simple procedure declaration with a param" $ do
      --  code = "program{F()} procedure F(parameter){}"
      let gobstonesAstWithAparam =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\": \"ProcedureCall\",\"from\": 14,\"to\": 18,\"arity\": \"routine\",\"name\": \"F\",\"parameters\": []}],\"from\": 0},{\"alias\": \"procedureDeclaration\",\"body\": null,\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"F\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"F\",\"parameters\":[{\"from\": 32,\"row\": 4,\"to\": 41,\"value\" : \"parameter\",\"arity\" : \"name\", \"reserved\": false,\"led\": null,\"std\": null,\"lbp\": 0}] }]"

      gobstonesAstWithAparam `shouldBe` Sequence [EntryPoint (Application (Variable "F") []),ProcedureDeclaration "F" [Equation [VariablePattern "parameter"] (UnguardedBody MuNull)]]
    
    it "translate simple procedure Application " $ do
      --  code = "program{F()} procedure F(){}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\": \"ProcedureCall\",\"from\": 14,\"to\": 18,\"arity\": \"routine\",\"name\": \"F\",\"parameters\": []}],\"from\": 0},{\"alias\": \"procedureDeclaration\",\"body\": null,\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"F\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"F\",\"parameters\": []}]"

      gobstonesAst `shouldBe` Sequence [EntryPoint (Application (Variable "F") []),ProcedureDeclaration "F" [Equation [] (UnguardedBody MuNull)]]

    it "translate simple procedure Application " $ do
      --  code = "program{Poner(Verde)}"
      let gobstonesAstWithPoner =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"PutStone\" , \"parameters\" : [{\"value\" : 3, \"arity\" : \"literal\" , \"reserved\" : true}] }],\"from\": 0}]"

      gobstonesAstWithPoner `shouldBe` EntryPoint (Application (Variable "Poner") [MuSymbol "Verde"])
      
    it "translate simple procedure Application " $ do
      --  code = "program{Sacar(Verde)}"
      let gobstonesAstWithSacar =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"RemoveStone\" , \"parameters\" : [{\"value\" : 3, \"arity\" : \"literal\" , \"reserved\" : true}] }],\"from\": 0}]"
      
      gobstonesAstWithSacar `shouldBe` EntryPoint (Application (Variable "Sacar") [MuSymbol "Verde"])

    it "translate simple procedure Application " $ do
      --  code = "program{Mover(Este)}"
      let gobstonesAstWithMover =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"MoveClaw\" , \"parameters\" : [{\"value\" : [1,0], \"arity\" : \"literal\" , \"reserved\" : true}] }],\"from\": 0}]"

      gobstonesAstWithMover `shouldBe` EntryPoint (Application (Variable "Mover") [MuSymbol "Este"])

    it "translate simple function declaration" $ do
      --  code = "function f(){return (2)}"
      let gobstonesAst =  gbs "[{\"alias\": \"functionDeclaration\",\"body\": [],\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"f\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"f\",\"parameters\": [],\"return\" : {\"from\" : 21, \"row\" : 1,\"to\" : 22, \"value\" : 2, \"arity\" : \"literal\"}}]"

      gobstonesAst `shouldBe` FunctionDeclaration "f" [Equation [] (UnguardedBody (Return (MuNumber 2.0)))]

    it "translate simple function declaration" $ do
      --  code = "function f(parameter){return (2)}"
      let gobstonesAstWithAparam =  gbs "[{\"alias\": \"functionDeclaration\",\"body\": [],\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"f\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"f\",\"parameters\": [{\"from\": 32,\"row\": 4,\"to\": 41,\"value\" : \"parameter\",\"arity\" : \"name\", \"reserved\": false,\"led\": null,\"std\": null,\"lbp\": 0}],\"return\" : {\"from\" : 21, \"row\" : 1,\"to\" : 22, \"value\" : 2, \"arity\" : \"literal\"}}]"

      gobstonesAstWithAparam `shouldBe` FunctionDeclaration "f" [Equation [VariablePattern "parameter"] (UnguardedBody (Return (MuNumber 2.0)))]
  
    it "translate simple variable assignment" $ do
      --  code = "program{x:= 1}"
      let gobstonesAstNumber =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : 1, \"arity\" : \"literal\"}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"

      gobstonesAstNumber `shouldBe` EntryPoint (VariableDeclaration "x" (MuNumber 1.0))

    it "translate simple variable assignment" $ do
      --  code = "program{x:= Verde}"
      let gobstonesAstColour = gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : 3, \"arity\" : \"literal\", \"reserved\" : true}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"

      gobstonesAstColour `shouldBe` EntryPoint (VariableDeclaration "x" (MuSymbol "Verde"))

    it "translate simple variable assignment" $ do
      --  code = "program{x:= True}"
      let gobstonesAstBool = gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : true, \"arity\" : \"literal\", \"reserved\" : true}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"

      gobstonesAstBool `shouldBe` EntryPoint (VariableDeclaration "x" (MuBool True))

    it "translate simple variable assignment" $ do
      --  code = "program{x:= Este}"
      let gobstonesAstDirection = gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : [1,0], \"arity\" : \"literal\", \"reserved\" : true}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"

      gobstonesAstDirection `shouldBe` EntryPoint (VariableDeclaration "x" (MuSymbol "Este"))

    it "translate simple variable assignment" $ do
      --  code = "program{x:= y}"
      let gobstonesAstVariable = gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : \"y\" , \"arity\" : \"literal\", \"reserved\" : true}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"

      gobstonesAstVariable `shouldBe` EntryPoint (VariableDeclaration "x" (Variable "y"))

    it "translate simple variable assignment" $ do
      --  code = "program{x:= f(2)}"
      let gobstonesAstFunctionCall = gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"alias\" : \"functionCall\" , \"name\" : \"f\" , \"parameters\" : [{\"value\" : 2, \"arity\" : \"literal\"}]}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"      

      gobstonesAstFunctionCall `shouldBe` EntryPoint (VariableDeclaration "x" (Application (Variable "f") [MuNumber 2.0]))

    it "translate simple variable assignment" $ do
      --  code = "program{x:= z && y}"
      let gobstonesAstSimpleExpression = gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : \"&&\" , \"arity\" : \"binary\",\"left\" : {\"value\" : \"z\" , \"arity\" : \"name\"} , \"right\" : {\"value\" : \"y\" , \"arity\" : \"name\"}}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"

      gobstonesAstSimpleExpression `shouldBe` EntryPoint (VariableDeclaration "x" (Application (Variable "&&") [Variable "z",Variable "y"]))

    it "translate simple variable assignment" $ do
      --  code = "program{x := True == 2 && x != t}"
      let gobstonesAstComposeExpression = gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : \"&&\" , \"arity\" : \"binary\",\"left\" : {\"value\" : \"==\" , \"arity\" : \"binary\", \"left\" : {\"value\" : true , \"arity\" : \"literal\" , \"reserved\" : true } , \"right\" : {\"value\" : 2 , \"arity\" : \"literal\"} } , \"right\" : {\"value\" : \"!=\" , \"arity\" : \"binary\" , \"left\" : {\"value\" : \"x\" , \"arity\" : \"name\"},\"right\" : {\"value\" : \"t\" , \"arity\" : \"name\"} }}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }],\"from\": 0}]"

      gobstonesAstComposeExpression `shouldBe`  EntryPoint (VariableDeclaration "x" (Application (Variable "&&") [Application Equal [MuBool True,MuNumber 2.0],Application NotEqual [Variable "x",Variable "t"]]))

    it "translate simple procedure declaration and application  with a parameter" $ do
      --  code = "program{F(2)} procedure F(parameter){}"
      let gobstonesAstNumber =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\": \"ProcedureCall\",\"from\": 14,\"to\": 18,\"arity\": \"routine\",\"name\": \"F\",\"parameters\": [{\"from\" : 15, \"row\" : 1, \"to\" : 16, \"value\" : 2, \"arity\" : \"literal\" }]}],\"from\": 0},{\"alias\": \"procedureDeclaration\",\"body\": null,\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"F\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"F\",\"parameters\":[{\"from\": 32,\"row\": 4,\"to\": 41,\"value\" : \"parameter\",\"arity\" : \"name\", \"reserved\": false,\"led\": null,\"std\": null,\"lbp\": 0}] }]"
      
      gobstonesAstNumber `shouldBe` Sequence [EntryPoint (Application (Variable "F") [MuNumber 2.0]),ProcedureDeclaration "F" [Equation [VariablePattern "parameter"] (UnguardedBody MuNull)]]

    it "translate simple procedure declaration and application  with a parameter" $ do
      --  code = "program{F(Negro)} procedure F(parameter){}"
      let gobstonesAstColour =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\": \"ProcedureCall\",\"from\": 14,\"to\": 18,\"arity\": \"routine\",\"name\": \"F\",\"parameters\": [{\"from\" : 15, \"row\" : 1, \"to\" : 16, \"value\" : 2,\"reserved\" : true , \"arity\" : \"literal\" }]}],\"from\": 0},{\"alias\": \"procedureDeclaration\",\"body\": null,\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"F\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"F\",\"parameters\":[{\"from\": 32,\"row\": 4,\"to\": 41,\"value\" : \"parameter\",\"arity\" : \"name\", \"reserved\": false,\"led\": null,\"std\": null,\"lbp\": 0}] }]"

      gobstonesAstColour `shouldBe` Sequence [EntryPoint (Application (Variable "F") [MuSymbol "Negro"]),ProcedureDeclaration "F" [Equation [VariablePattern "parameter"] (UnguardedBody MuNull)]]

    it "translate simple procedure declaration and application  with a parameter" $ do
      --  code = "program{F(True)} procedure F(parameter){}"
      let gobstonesAstBool =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\": \"ProcedureCall\",\"from\": 14,\"to\": 18,\"arity\": \"routine\",\"name\": \"F\",\"parameters\": [{\"from\" : 15, \"row\" : 1, \"to\" : 16, \"value\" : true,\"reserved\" : true , \"arity\" : \"literal\" }]}],\"from\": 0},{\"alias\": \"procedureDeclaration\",\"body\": null,\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"F\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"F\",\"parameters\":[{\"from\": 32,\"row\": 4,\"to\": 41,\"value\" : \"parameter\",\"arity\" : \"name\", \"reserved\": false,\"led\": null,\"std\": null,\"lbp\": 0}] }]"
      
      gobstonesAstBool `shouldBe` Sequence [EntryPoint (Application (Variable "F") [MuBool True]),ProcedureDeclaration "F" [Equation [VariablePattern "parameter"] (UnguardedBody MuNull)]]

    it "translate simple procedure declaration and application  with a parameter" $ do
      --  code = "program{F(Este)} procedure F(parameter){}"
      let gobstonesAstDirection =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\": \"ProcedureCall\",\"from\": 14,\"to\": 18,\"arity\": \"routine\",\"name\": \"F\",\"parameters\": [{\"from\" : 15, \"row\" : 1, \"to\" : 16, \"value\" : [1,0],\"reserved\" : true , \"arity\" : \"literal\" }]}],\"from\": 0},{\"alias\": \"procedureDeclaration\",\"body\": null,\"from\": 1,\"row\": 1,\"to\": 12,\"value\": \"F\",\"arity\": \"routine\",\"reserved\": false,\"led\": null,\"lbp\": 0,\"name\": \"F\",\"parameters\":[{\"from\": 32,\"row\": 4,\"to\": 41,\"value\" : \"parameter\",\"arity\" : \"name\", \"reserved\": false,\"led\": null,\"std\": null,\"lbp\": 0}] }]"

      gobstonesAstDirection `shouldBe` Sequence [EntryPoint (Application (Variable "F") [MuSymbol "Este"]),ProcedureDeclaration "F" [Equation [VariablePattern "parameter"] (UnguardedBody MuNull)]]
 	
    it "translate conditional declaration" $ do
      --  code = "program{If(True){}}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"conditional\", \"condition\" : {\"value\" : true, \"arity\" : \"literal\" , \"reserved\" : true}, \"left\" : null, \"right\" : null}],\"from\": 0}]"

      gobstonesAst `shouldBe` EntryPoint (If (MuBool True) MuNull MuNull)

    it "translate conditional declaration" $ do
      --  code = "program{If(True){x := 1}}"
      let gobstonesAstIfWithBody =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"conditional\", \"condition\" : {\"value\" : true, \"arity\" : \"literal\" , \"reserved\" : true}, \"left\" : [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : 1, \"arity\" : \"literal\"}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }], \"right\" : null}],\"from\": 0}]"

      gobstonesAstIfWithBody `shouldBe` EntryPoint (If (MuBool True) (VariableDeclaration "x" (MuNumber 1.0)) MuNull)

    it "translate while declaration" $ do
      --  code = "program{While(True){}}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"while\", \"expression\" : {\"value\" : true, \"arity\" : \"literal\" , \"reserved\" : true}, \"body\" : null}],\"from\": 0}]"

      gobstonesAst `shouldBe` EntryPoint (While (MuBool True) MuNull)

    it "translate while declaration" $ do
      --  code = "program{While(True){x := 1}}"
      let gobstonesAstWhileWithBody =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"while\", \"expression\" : {\"value\" : true, \"arity\" : \"literal\" , \"reserved\" : true}, \"body\" : [{\"alias\" : \":=\",\"arity\" : \"binary\", \"variable\" : {\"from\" : 13, \"row\" : 1,\"to\" : 14, \"value\" : \"x\", \"arity\" : \"name\"}, \"expression\" : {\"from\" : 18, \"row\" : 1,\"to\" : 19, \"value\" : 1, \"arity\" : \"literal\"}, \"assignment\" : true, \"from\" : 13,\"to\" : 20 }]}],\"from\": 0}]"

      gobstonesAstWhileWithBody `shouldBe` EntryPoint (While (MuBool True) (VariableDeclaration "x" (MuNumber 1.0)))

    it "translate switch declaration" $ do
      --  code = "program{Switch(2) to {2 -> {x := 2}}}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"switch\",\"value\" : {\"value\" : 2 , \"arity\" : \"literal\"} ,\"cases\" : [{\"case\" : {\"value\" : 2 , \"arity\" : \"literal\"} , \"body\" : [{\"alias\" : \":=\" , \"arity\" : \"binary\" , \"variable\" : {\"value\" : \"x\" , \"arity\" : \"name\"}, \"expression\" :{\"value\" : 2, \"arity\" : \"literal\"} }] }]}],\"from\": 0}]"

      gobstonesAst `shouldBe`  EntryPoint (Switch (MuNumber 2.0) [(MuNumber 2.0,VariableDeclaration "x" (MuNumber 2.0))])

    it "translate repeat declaration" $ do
      --  code = "program{Repeat(2){x := 2}}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": [{\"alias\" : \"repeat\",\"expression\" : {\"value\" : 2,\"arity\" : \"literal\"}, \"body\" : [{ \"alias\" : \":=\",\"arity\" : \"binary\",\"variable\" : {\"value\" : \"x\", \"arity\" : \"name\"},\"expression\" : {\"value\" : 2 ,\"arity\" : \"literal\" } }] }],\"from\": 0}]"

      gobstonesAst `shouldBe`  EntryPoint (Repeat (MuNumber 2.0) (VariableDeclaration "x" (MuNumber 2.0)))

    it "translate a complete program" $ do
      -- code = "program{F(Verde) G(2,3) X(Este) y := f(False) } procedure F(x){ Poner(x) Poner(x) Poner(x) Sacar(x) } procedure G(n1,n2){ x := n1 z := n2 while(True){ x := n1} switch(dir) to { Sur -> {Poner(Verde)} Este -> {Poner(Verde)} Oeste -> {Poner(Verde)} Norte -> {Poner(Verde)}}} procedure X(dir){ Mover(dir) } function f(bool){ g := 2 if(False) resultado := True else { resultado := resultado} return (resultado)}"
      let gobstonesAst =  gbs "[{\"alias\": \"program\",\"body\": [{\"arity\" : \"routine\", \"alias\" : \"ProcedureCall\" , \"name\" : \"F\" , \"parameters\" : [{\"value\" :3,\"arity\" : \"literal\" , \"reserved\" : true}]},{\"arity\" : \"routine\", \"alias\" : \"ProcedureCall\" , \"name\" : \"G\" , \"parameters\" : [{\"value\" :2,\"arity\" : \"literal\" , \"reserved\" : true}, {\"value\" :3,\"arity\" : \"literal\" , \"reserved\" : true}]},{\"arity\" : \"routine\", \"alias\" : \"ProcedureCall\" , \"name\" : \"X\" , \"parameters\" : [{\"value\" : [1,0],\"arity\" : \"literal\" , \"reserved\" : true}]},{\"alias\" : \":=\", \"arity\" : \"binary\" ,\"variable\" : {\"value\" : \"y\" , \"arity\" : \"name\"},\"expression\" : {\"alias\" : \"functionCall\" , \"name\" : \"f\" , \"parameters\" : [{\"value\" : false, \"arity\" : \"literal\" , \"reserved\" : true}] } }],\"from\": 0},{\"value\" : \"F\" , \"arity\" : \"routine\" , \"reserved\" : false , \"led\" : null, \"lbp\" : 0 , \"name\" : \"F\" , \"alias\" : \"procedureDeclaration\" , \"parameters\" : [{\"value\" : \"x\" , \"arity\" : \"name\"}] ,\"body\" : [{\"alias\" : \"PutStone\" , \"parameters\" : [{\"value\" : \"x\" ,\"arity\" : \"name\"}]},{\"alias\" : \"RemoveStone\" , \"parameters\" : [{\"value\" : \"x\" ,\"arity\" : \"name\"}]} ] },{\"value\" : \"G\" , \"arity\" : \"routine\" , \"reserved\" : false , \"led\" : null, \"lbp\" : 0 , \"name\" : \"G\" , \"alias\" : \"procedureDeclaration\" , \"parameters\" : [{\"value\" : \"n1\" , \"arity\" : \"name\"},{\"value\" : \"n2\" , \"arity\" : \"name\"}] , \"body\" : [{\"alias\" : \":=\" , \"arity\" : \"binary\" , \"variable\" :{\"value\" : \"x\" , \"arity\" : \"name\"}, \"expression\" : {\"value\" : \"n1\" , \"arity\" : \"name\"}},{\"alias\" : \":=\" , \"arity\" : \"binary\" , \"variable\" :{\"value\" : \"z\" , \"arity\" : \"name\"}, \"expression\" : {\"value\" : \"n2\" , \"arity\" : \"name\"}},{\"alias\" : \"while\" , \"expression\" :{\"value\" : true, \"arity\" : \"literal\" , \"reserved\" : true},\"body\" : [{\"alias\" : \":=\" , \"arity\" : \"binary\" , \"variable\" :{\"value\" : \"x\" , \"arity\" : \"name\"}, \"expression\" : {\"value\" : \"n1\" , \"arity\" : \"name\"}}]}, {\"alias\" : \"switch\" , \"value\" : {\"value\" : \"dir\" , \"arity\" : \"name\"} , \"cases\" :[{\"case\": {\"value\" : [0,-1], \"arity\" : \"literal\" , \"reserved\" : true},\"body\" :[{\"alias\" : \"PutStone\" , \"parameters\" : [{\"value\" : 3 , \"arity\" : \"literal\"}] }] },{\"case\": {\"value\" : [1,0], \"arity\" : \"literal\" , \"reserved\" : true},\"body\" :[{\"alias\" : \"PutStone\" , \"parameters\" : [{\"value\" : 3 , \"arity\" : \"literal\"}] }] },{\"case\": {\"value\" : [-1,0], \"arity\" : \"literal\" , \"reserved\" : true},\"body\" :[{\"alias\" : \"PutStone\" , \"parameters\" : [{\"value\" : 3 , \"arity\" : \"literal\"}] }] },{\"case\": {\"value\" : [0,1], \"arity\" : \"literal\" , \"reserved\" : true},\"body\" :[{\"alias\" : \"PutStone\" , \"parameters\" : [{\"value\" : 3 , \"arity\" : \"literal\"}] }] } ] } ] },{\"value\" : \"X\" , \"arity\" : \"routine\" , \"reserved\" : false , \"led\" : null, \"lbp\" : 0 , \"name\" : \"X\" , \"alias\" : \"procedureDeclaration\" , \"parameters\" : [{\"value\": \"dir\", \"arity\" : \"name\"}] ,\"body\" :[{\"alias\" : \"MoveClaw\", \"parameters\" : [{\"value\": \"dir\" , \"arity\" : \"name\"}]} ] },{\"value\" : \"f\" , \"arity\" : \"routine\" , \"reserved\" : false , \"led\" : null, \"lbp\" : 0 , \"name\" : \"f\" , \"alias\" : \"functionDeclaration\" , \"parameters\" : [{\"value\" : \"bool\" , \"arity\" : \"name\"}] , \"body\" : [{\"alias\" : \":=\" , \"arity\" : \"binary\" , \"variable\" :{\"value\" : \"g\" ,\"arity\" : \"name\" } ,\"expression\" :{\"value\" : 2 , \"arity\" : \"literal\"} } , {\"alias\" : \"conditional\", \"condition\" :{\"value\" : false, \"arity\" : \"literal\"},\"left\" : [{\"alias\" : \":=\" , \"arity\" : \"binary\" ,\"variable\" :{\"value\" : \"resultado\" ,\"arity\" : \"name\" }, \"expression\": {\"value\" : true , \"arity\" : \"literal\"} }], \"right\" : [{\"alias\" : \":=\" , \"arity\" : \"binary\" ,\"variable\" :{\"value\" : \"resultado\" ,\"arity\" : \"name\" }, \"expression\": {\"value\" : \"resultado\" , \"arity\" : \"name\"} }] } ] , \"return\" : {\"value\" : \"resultado\" , \"arity\" : \"name\"}}]"
      
      gobstonesAst `shouldBe`  Sequence [EntryPoint (Sequence [Application (Variable "F") [MuSymbol "Verde"],Application (Variable "G") [MuSymbol "Negro",MuSymbol "Verde"],Application (Variable "X") [MuSymbol "Este"],VariableAssignment "y" (Application (Variable "f") [MuBool False])]),ProcedureDeclaration "F" [Equation [VariablePattern "x"] (UnguardedBody (Sequence [Application (Variable "Poner") [Variable "x"],Application (Variable "Sacar") [Variable "x"]]))],ProcedureDeclaration "G" [Equation [VariablePattern "n1",VariablePattern "n2"] (UnguardedBody (Sequence [VariableAssignment "x" (Variable "n1"),VariableAssignment "z" (Variable "n2"),While (MuBool True) (VariableDeclaration "x" (Variable "n1")),Switch (Variable "dir") [(MuSymbol "Sur",Application (Variable "Poner") [MuNumber 3.0]),(MuSymbol "Este",Application (Variable "Poner") [MuNumber 3.0]),(MuSymbol "Oeste",Application (Variable "Poner") [MuNumber 3.0]),(MuSymbol "Norte",Application (Variable "Poner") [MuNumber 3.0])]]))],ProcedureDeclaration "X" [Equation [VariablePattern "dir"] (UnguardedBody (Application (Variable "Mover") [Variable "dir"]))],FunctionDeclaration "f" [Equation [VariablePattern "bool"] (UnguardedBody (Sequence [VariableAssignment "g" (MuNumber 2.0),If (MuBool False) (VariableDeclaration "resultado" (MuBool True)) (VariableDeclaration "resultado" (Variable "resultado")),Return (Variable "resultado")]))]]

    it "transform VariableAssignment to VariableDeclaration" $ do
      let gobstonesAst =  gbs "[\r\n  {\r\n    \"alias\": \"program\",\r\n    \"body\": [\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"x\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 2,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"y\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 3,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"x\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 1,\r\n          \"arity\": \"literal\"\r\n        }\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"value\": \"f\",\r\n    \"arity\": \"routine\",\r\n    \"reserved\": false,\r\n    \"led\": null,\r\n    \"lbp\": 0,\r\n    \"name\": \"f\",\r\n    \"alias\": \"functionDeclaration\",\r\n    \"parameters\": [],\r\n    \"body\": [\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"x\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 4,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"y\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 6,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"z\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 9,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"y\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": true,\r\n          \"arity\": \"literal\",\r\n          \"reserved\": true\r\n        }\r\n      }\r\n    ],\r\n    \"return\": {\r\n      \"value\": \"x\",\r\n      \"arity\": \"name\"\r\n    }\r\n  },\r\n  {\r\n    \"value\": \"P\",\r\n    \"arity\": \"routine\",\r\n    \"reserved\": false,\r\n    \"led\": null,\r\n    \"lbp\": 0,\r\n    \"name\": \"P\",\r\n    \"alias\": \"procedureDeclaration\",\r\n    \"parameters\": [],\r\n    \"body\": [\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"x\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 4,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"y\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 6,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"z\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": 9,\r\n          \"arity\": \"literal\"\r\n        }\r\n      },\r\n      {\r\n        \"alias\": \":=\",\r\n        \"arity\": \"binary\",\r\n        \"variable\": {\r\n          \"value\": \"y\",\r\n          \"arity\": \"name\"\r\n        },\r\n        \"expression\": {\r\n          \"value\": true,\r\n          \"arity\": \"literal\"\r\n        }\r\n      }\r\n    ]\r\n  }\r\n]"
      
      gobstonesAst `shouldBe`  Sequence [EntryPoint (Sequence [VariableAssignment "x" (MuNumber 2.0),VariableAssignment "y" (MuNumber 3.0),VariableAssignment "x" (MuNumber 1.0)]),FunctionDeclaration "f" [Equation [] (UnguardedBody (Sequence [VariableAssignment "x" (MuNumber 4.0),VariableAssignment "y" (MuNumber 6.0),VariableAssignment "z" (MuNumber 9.0),VariableAssignment "y" (MuBool True),Return (Variable "x")]))],ProcedureDeclaration "P" [Equation [] (UnguardedBody (Sequence [VariableAssignment "x" (MuNumber 4.0),VariableAssignment "y" (MuNumber 6.0),VariableAssignment "z" (MuNumber 9.0),VariableAssignment "y" (MuBool True)]))]]


   

    
