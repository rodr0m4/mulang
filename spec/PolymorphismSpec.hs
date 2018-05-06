{-# LANGUAGE QuasiQuotes, OverloadedStrings #-}

module PolymorphismSpec (spec) where

import           Test.Hspec
import           Language.Mulang
import           Language.Mulang.Inspector.ObjectOriented.Polymorphism
import qualified Language.Mulang.Parsers.Java as J (java)

import           Data.Text (Text, unpack)
import           NeatInterpolation (text)

java :: Text -> Expression
java = J.java . unpack

spec :: Spec
spec = do
  describe "usesDyamicPolymorphism" $ do
    it "is True when uses" $ do
      usesDyamicPolymorphism (java [text|
          class Bird { void sing() {} }
          class Performer { void sing() {} }
          class Festival { void run(Object o) { o.sing(); } }|]) `shouldBe` True

    it "is False when there is just one implementor" $ do
      usesDyamicPolymorphism (java [text|
          class Bird { void sing() {} }
          class Festival { void run(Object o) { o.sing(); } }|]) `shouldBe` False

    it "is False when there is no user" $ do
      usesDyamicPolymorphism (java [text|
        class Bird { void sing() {} }
        class Performer { void sing() {} }|]) `shouldBe` False

    it "is False when not uses" $ do
      usesDyamicPolymorphism (java [text|
        class Sample { void aMethod() { throw new Exception(); } }|]) `shouldBe` False

  describe "usesStaticPolymorphism" $ do
    it "is True when there is an usage of an interface implemented by two or more classes" $ do
      usesStaticPolymorphism (java [text|
            interface Singer {
              void sing();
            }
            class Bird implements Singer {
              void sing() {}
            }
            class Performer implements Singer {
              void sing() {}
            }
            class Festival {
              Singer o;
              void run() { o.sing(); }
            }|]) `shouldBe` True

    it "is False when there is an usage of an interface implemented by just one class" $ do
      usesStaticPolymorphism (java [text|
            interface Singer {
              void sing();
            }
            class Bird implements Singer {
              void sing() {}
            }
            class Festival {
              void run(Singer o) { o.sing(); }
            }|]) `shouldBe` False

    it "is False when there is no interace" $ do
      usesStaticPolymorphism (java [text|
            class Bird {
              void sing() {}
            }
            class Performer {
              void sing() {}
            }
            class Festival {
              void run(Singer o) { o.sing(); }
            }|]) `shouldBe` False

    it "is False when there is no polymorphic message send" $ do
      usesStaticPolymorphism (java [text|
            class Bird {
              void sing() {}
            }
            class Performer {
              void sing() {}
            }
            class Festival {
              void run(Singer o) { o.toString(); }
            }|]) `shouldBe` False

    it "is False when there is no message is sent" $ do
      usesStaticPolymorphism (java [text|
            class Bird {
              void sing() {}
            }
            class Performer {
              void sing() {}
            }
            class Festival {
              void run(Singer o) {}
            }|]) `shouldBe` False

    it "is False when there are no methods defined" $ do
      usesStaticPolymorphism (java [text|
            class Bird {
            }
            class Performer {
            }
            class Festival {
              void run(Singer o) {}
            }|]) `shouldBe` False

    it "is False when there is no usage" $ do
      usesStaticPolymorphism (java [text|
            interface Singer {
              void sing();
            }
            class Bird implements Singer {
              void sing() {}
            }
            class Performer implements Singer {
              void sing() {}
            }|]) `shouldBe` False
