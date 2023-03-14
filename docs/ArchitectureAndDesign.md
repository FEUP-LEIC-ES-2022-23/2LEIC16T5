
## Architecture and Design
The architecture of a software system encompasses the set of key decisions about its overall organization. 

A well written architecture document is brief but reduces the amount of time it takes new programmers to a project to understand the code to feel able to make modifications and enhancements.

To document the architecture requires describing the decomposition of the system in their parts (high-level components) and the key behaviors and collaborations between them. 

In this section you should start by briefly describing the overall components of the project and their interrelations. You should also describe how you solved typical problems you may have encountered, pointing to well-known architectural and design patterns, if applicable.

### Logical architecture

Our Logical Architecture diagram shows the different layers and packages that compose our app.

The ***Fortuneko** System* contains the core functionality of our app. It is further divided into three other packages: ***Fortuneko** UI*, ***Fortuneko** Business Logic* and ***Fortuneko** database*. The first one handles the UI of our app. The second one, contains the logic that drives our app’s behaviour. The third one, contains the data storage and retrieval logic of our app.

The *External Services* holds the dependencies of our app, namely the [*Google Maps API*](https://developers.google.com/maps), [*Firebase*](https://firebase.google.com) and the [*PORDATA database*](https://www.pordata.pt/db/portugal/ambiente+de+consulta/tabela). 

![LogicalArchitecture](https://user-images.githubusercontent.com/92641892/225074006-1127015a-5a66-4358-ade6-66dabd23e93f.jpeg)

### Physical architecture

Our Physical Architecture diagram shows our mobile app, connected to all the dependencies we have identified until now. [Firebase](https://firebase.google.com) is used for authentication, storage, and synchronisation of user data across multiple devices. [Google Maps API](https://developers.google.com/maps) is used for generating a geographical chart of expenses. [PORDATA database](https://www.pordata.pt/db/portugal/ambiente+de+consulta/tabela) provides the “National Comparison” feature.
Therefore, this diagram illustrates the communication and data flow between **Fortuneko** app and these external services.

![PhysicalArchitecture](https://user-images.githubusercontent.com/92641892/225074024-deae9f0c-1ce2-49b5-afd1-4426504eb021.jpeg)

### Vertical prototype

For now, we have superficially implemented some of the [main features](./ProductVision.md/#Main-Features), such as the login, the transactions menu, and the settings. As a way of merging these all together, we also found it useful to create a prototype of the main menu, although some of its buttons are still functionless. We have also successfully configured [Firebase](https://firebase.google.com), despite the fact that we are still in the process of integrating it into our app.

