# Done Remastered
### iOS App written in Combine & SwiftUI with TDD

I decided to rebuild one of my App's called [Done](https://github.com/timmikelj/doneiOS). The legacy App is written in Objective-C, using Realm as a data persistence framework.
The legacy app only has a few tests; however, this is a fully test-driven rewrite.

All in all, it's a basic to-do app with an AI twist to it. The App analyses input string (To-Do item)  and extracts verbs/nouns from them, then search the web for accompanying image and attaches the image to a to-do item. 

The idea is to have a more intuitive experience when listing your items, i.e. when you input "buy bananas", the App will extract the noun bananas and search the web for an image of bananas and show it next to a given To-Do item.

I expanded the explanation of the below App architecture in [this article](https://timswift.dev/articles/swiftui%20&%20combine%20with%20tdd,%20building%20ai-powered%20to-do%20app%20-%20part%201/).

Here is the diagram of the App achitecture

<img src="/Done_Remastered_diagram.png"/>
