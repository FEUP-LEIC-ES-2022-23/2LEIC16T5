
## Architecture and Design
The architecture of a software system encompasses the set of key decisions about its overall organization. 

A well written architecture document is brief but reduces the amount of time it takes new programmers to a project to understand the code to feel able to make modifications and enhancements.

To document the architecture requires describing the decomposition of the system in their parts (high-level components) and the key behaviors and collaborations between them. 

In this section we briefly describe the overall components of our project and their interrelations.

### Logical architecture

Our Logical Architecture diagram shows the different layers and packages that compose our app.

The ***Fortuneko** System* contains the core functionality of our app. It is further divided into two other packages: ***Fortuneko** UI* and ***Fortuneko** Business Logic*. The first one handles the UI of our app and the second one, contains the logic that drives our app’s behaviour.

The *External Services* holds the dependencies of our app, namely the [*Google Maps API*](https://developers.google.com/maps), [*Firebase*](https://firebase.google.com) and the [*PORDATA database*](https://www.pordata.pt/db/portugal/ambiente+de+consulta/tabela). 

![LogicalArchitecture](https://github.com/SofiaViP/hero/assets/92641892/1fa022d2-d220-42a7-88c1-6f8fde7310b2)

### Physical architecture

Our Physical Architecture diagram shows our mobile app, connected to all the dependencies we have identified until now. [Firebase](https://firebase.google.com) is used for authentication, storage, and synchronisation of user data across multiple devices. [Google Maps API](https://developers.google.com/maps) is used for generating a geographical chart of expenses. [PORDATA database](https://www.pordata.pt/db/portugal/ambiente+de+consulta/tabela) provides the “National Comparison” feature.
Therefore, this diagram illustrates the communication and data flow between **Fortuneko** app and these external services.

![PhysicalArchitecture](https://user-images.githubusercontent.com/92641892/235796314-d5d13ff9-e637-4d98-86aa-e48c47b4fa7a.jpeg)

### Vertical prototype

For now, we have superficially implemented some of the [main features](./ProductVision.md/#Main-Features), such as the login, the transactions menu, and the settings. As a way of merging these all together, we also found it useful to create a prototype of the main menu, although some of its buttons are still functionless. We have also successfully configured [Firebase](https://firebase.google.com), despite the fact that we are still in the process of integrating it into our app.

